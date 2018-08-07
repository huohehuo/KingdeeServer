if (exists (select * from sys.objects where name = 'proc_ProductPicking1'))
    drop proc proc_ProductPicking1
go
create proc proc_ProductPicking1
(
 @mainStr nvarchar(1000),--主表参数
 @detailStr1 nvarchar(max),--明细参数
 @detailStr2 nvarchar(max),
 @detailStr3 nvarchar(max),
 @detailStr4 nvarchar(max),
 @detailStr5 nvarchar(max)
)
as 
--------------开启一个模式，也就是不再刷新多少行受影响的信息，可以提高性能
set nocount on
--------------开始存储过程
begin
--------------事务选项设置为出错全部回滚
set xact_abort on
--------------开启事务
begin tran
declare @FInterID varchar(20),     --单号id
        @FBillNo varchar(50),      -- 编号   
        @FROB varchar(20),         --红蓝字标识
        @Fdate varchar(50),       --日期  
        @FSupplyID varchar(20),   --购货单位id
        @FCurrencyID varchar(20),--币别id 
        @FSaleStyle varchar(20),  --销售方式id 
        @FPOStyle varchar(20),    --采购方式
        @FFetchAdd varchar(100),  --交货地点名
        @FCheckDate varchar(50),  --审核日期 
        @FFManagerID varchar(20), --发货
        @FSManagerID varchar(20), --保管
        @FManagerID varchar(20),  --主管id
        @FDeptID varchar(20),     --部门id
        @FEmpID varchar(20),      --业务员id
        @FBillerID varchar(20),   --制单人id 
        @FSettleDate varchar(50), --结算日期
        @FExplanation varchar(200),--摘要 
        @FMarketingStyle varchar(20),--销售业务类型
        @FCussentAcctID varchar(20), --往来科目ID
        @FPurposeID varchar(20), --委外类型
        @FSelTranType varchar(20)  --源单类型
set @FBillerID = dbo.getString(@mainStr,'|',1) --操作员  
set @Fdate =dbo.getString(@mainStr,'|',2)      --日期 
set @FDeptID =dbo.getString(@mainStr,'|',3)   --领料部门
--set @FExplanation =dbo.getString(@mainStr,'|',10)--摘要
set @FFManagerID=dbo.getString(@mainStr,'|',4) --验收
set @FSManagerID=dbo.getString(@mainStr,'|',5) --保管
set @FROB=dbo.getString(@mainStr,'|',6)         --蓝字红字
set @FPurposeID=dbo.getString(@mainStr,'|',7)  --委外类型id  
set @FExplanation =dbo.getString(@mainStr,'|',8)--摘要
set @Fdate = convert(varchar(20),GETDATE(),23)
exec GetICMaxNum 'ICStockBill',@FInterID output,1,@FBillerID --得到@FInterID
------------------------------------------------------------得到编号
if(@FROB='红字')
set @FROB=-1
else
set @FROB=1
 set @FBillNo ='' 
 exec proc_GetICBillNo 24, @FBillNo out 
-----------------------------------------------------------得到编号
set @FCurrencyID=1 --币别
set @FCheckDate=null --审核时间  
  declare @IsExist varchar(10), --是否存在
            @value varchar(10)--库存更新类型
    select @value= Fvalue  from t_systemprofile where Fkey in ('UPSTOCKWHENSAVE') AND FCateGory='IC' 
INSERT INTO ICStockBill(FInterID,FBillNo,FBrNo,FTranType,FCancellation,FStatus,FUpStockWhenSave,FROB,FHookStatus,Fdate,
FDeptID,Fuse,FCheckDate,FSManagerID,FFManagerID,FBillerID,FAcctID,FMultiCheckDate1,FMultiCheckDate2,FMultiCheckDate3,
FMultiCheckDate4,FMultiCheckDate5,FVchInterID,FMultiCheckDate6,FPurposeID,FWBINTERID,FSelTranType,FBackFlushed,FManageType,
FPrintCount) 
VALUES (@FInterID,@FBillNo,'0',24,0,0,@value,@FROB,0,@Fdate,@FDeptID,@FExplanation,@FCheckDate,@FSManagerID,@FFManagerID,@FBillerID,
0,Null,Null,Null,Null,Null,0,Null,12000,0,0,0,0,0)
update ICStockBill set FUUID=newid() where FInterID=@FInterID

declare @FEntryID varchar(20),       --明细序号
        @FItemID varchar(20),        --商品id
        @FQty float,                --基本单位数量
        @FUnitID varchar(20),       --单位id
        @Fauxqty float,            --上传的数量 
        @Fauxprice float,          -- 单价
        @Famount float,          --金额
        @FTaxRate float,        --税率
        @FTaxAmount float,     -- 税额
        @FProcessPrice float, --单位成本
        @FProcessCost float,  --单位成本金额
        
        @FPlanPrice float,     --基本单位计划单价
        @FAuxPlanPrice float, --单位计划单价
        @FPlanAmount float,   --计划价金额     
        @FDiscountRate float,  --折扣率
        @FDiscountAmount float,--折扣额(含税单价*数量*折扣率)   
        @FDCStockID varchar(20), --仓库id
        @FCoefficient float,   --换算率
        @FBatchNo varchar(50),     --批号
        @FDCSPID varchar (20),     --仓位ID
           @FSecCoefficient float, --辅助单位换算率
        @FSecQty decimal(28,10),   --辅助单位数量
          @FSecUnitID  varchar(50), 
        @detailqty int,               --明细参数的个数
        @detailcount int,             --明细每行数据的长度 
        @detailIndex int,            --明细每行下标
        @countindex int              --分隔符|的数量
       set @detailqty=0        
       set @detailcount=8           
    while(@detailqty<5)--判断是明细的哪个参数
    begin
    if(@detailqty=1)
	begin
	set @detailStr1=@detailStr2
	end  
	if(@detailqty=2)
	begin
	set @detailStr1=@detailStr3
	end 
	if(@detailqty=3)
	begin
	set @detailStr1=@detailStr4
	end 
	if(@detailqty=4)
	begin
	set @detailStr1=@detailStr5
	end 
	if(@detailStr1='' or @detailStr1=null)
	begin
	break;
	end
	set @detailIndex=0 
	select @countindex=len(@detailStr1)-len(replace(@detailStr1, '|', ''))
	while(@countindex>@detailIndex*@detailcount)
	begin
	set @FItemID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+1)    --商品id
	set @FUnitID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+2)    --单位id 
	set @Fauxprice=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+3)  --单价
	set @Fauxqty=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+4)       --数量
	set @FDiscountRate=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+5)  --折扣率 
	set @FDCStockID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+6)     --仓库id
	set @FBatchNo=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+7)       --批号
	set @FDCSPID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+8)        --仓位ID 
	select @FCoefficient=isnull(FCoefficient,1) from t_MeasureUnit where FMeasureUnitID=@FUnitID --单位换算率
	select @FPlanPrice=isnull(FPlanPrice,0),@FTaxRate=isnull(FTaxRate,0) from t_ICItem where   FItemID=@FItemID  
	
	 set   @FProcessPrice = @Fauxprice*@FCoefficient
	 set  @FProcessCost = @FProcessPrice*@Fauxqty
	set @FQty=@Fauxqty*@FCoefficient                  --基本单位数量 
	set @FAuxPlanPrice=@FPlanPrice*@FCoefficient   --单位计划单价
	set @FPlanAmount=@FAuxPlanPrice*@Fauxqty          --计划单价金额 
	set @Famount=@Fauxqty*@Fauxprice 
	set @FTaxAmount = @Famount*(1+@FTaxRate)
	
	set @detailIndex=@detailIndex+1
    set @FEntryID=@detailqty*50+@detailIndex 
    
        --物料辅助单位
       select @FSecUnitID=FSecUnitID,@FSecCoefficient=FSecCoefficient from t_ICItem where FItemID=@FItemID
      if(@FSecCoefficient<>0) --这里判断上传的是辅助单位还是基本单位 如果成立说明上传的是辅助单位
      begin
      set @FSecQty = @FQty/@FSecCoefficient
      end
      else
      begin
      set @FSecQty = 0
      end
      if(@value=1)
		begin
		  select @IsExist=COUNT(1) from ICInventory where FStockID=@FDCStockID and FStockPlaceID=@FDCSPID and FBatchNo=@FBatchNo and FItemID=@FItemID
		  if(@IsExist=0)
			begin
			INSERT INTO ICInventory(FBrNo,FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FQty,FSecQty)
			SELECT '0',@FItemID,@FBatchNo,'',0,@FDCStockID,@FDCSPID,0,'',-@FQty,-@FSecQty
			end
		  else
			begin
			update ICInventory set FQty=FQty-@FQty,FSecQty=FSecQty-@FSecQty where FStockID=@FDCStockID and FStockPlaceID=@FDCSPID and FBatchNo=@FBatchNo and FItemID=@FItemID 
		  end    
		end
INSERT INTO ICStockBillEntry (FInterID,FEntryID,FBrNo,FItemID,FAuxPropID,FBatchNo,FQtyMust,FQty,FReProduceType,FCostOBJID,
FCostObjGroupID,FUnitID,FAuxQtyMust,Fauxqty,FSecCoefficient,FSecQty,FAuxPlanPrice,FPlanAmount,Fauxprice,Famount,FBomInterID,
Fnote,FKFDate,FKFPeriod,FPeriodDate,FSCStockID,FDCSPID,FOperSN,FOperID,FSNListID,FSourceBillNo,
FSourceTranType,FSourceInterId,FSourceEntryID,FICMOBillNo,FICMOInterID,FPPBomEntryID,FInStockID,FCostCenterID,FPlanMode,
FMTONo) 
VALUES (@FInterID,@FEntryID,'0',@FItemID,0,@FBatchNo,0,@FQty,1059,0,0,@FUnitID,0,@Fauxqty,@FSecCoefficient,@FSecQty,@FAuxPlanPrice,@FPlanAmount,
@Fauxprice,@Famount,0,'',Null,0,Null,@FDCStockID,@FDCSPID,0,'0',0,'',0,0,0,'',0,0,0,0,14036,'')
end
set @detailqty=@detailqty+1
end
EXEC p_UpdateBillRelateData 24,@FInterID,'ICStockBill','ICStockBillEntry' 
if not exists(  select   1  from ICStockBillEntry where FInterID=@FInterID)
begin
    delete  ICStockBill where FInterID=@FInterID
	goto error1
end 

commit tran 
return;
--------------存在错误
if(0<>@@error)
	goto error1
--------------回滚事务	
error1:
	rollback tran;
--------------结束存储过程
end

