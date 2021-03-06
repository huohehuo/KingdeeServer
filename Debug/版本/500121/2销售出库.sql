if (exists (select * from sys.objects where name = 'proc_SaleStore'))
    drop proc proc_SaleStore
go
create proc proc_SaleStore
(
 @mainStr nvarchar(1000),--主表参数
 @detailStr1 varchar(max),--明细参数
 @detailStr2 varchar(max),
 @detailStr3 varchar(max),
 @detailStr4 varchar(max),
 @detailStr5 varchar(max)
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
        @FCurrencyID nvarchar(20),--币别id 
        @FSaleStyle varchar(20),  --销售方式id 
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
        @FSelTranType varchar(20)  --源单类型
set @FBillerID = dbo.getString(@mainStr,'|',1) --操作员  
set @Fdate =dbo.getString(@mainStr,'|',2)      --日期
set @FSettleDate=dbo.getString(@mainStr,'|',3) --结算日期
set @FSaleStyle =dbo.getString(@mainStr,'|',4) --销售方式  
set @FFetchAdd =dbo.getString(@mainStr,'|',5)  --交货地点
set @FDeptID =dbo.getString(@mainStr,'|',6)   --部门id
set @FEmpID =dbo.getString(@mainStr,'|',7)    --业务员id
set @FManagerID =dbo.getString(@mainStr,'|',8) --主管id
set @FSupplyID =dbo.getString(@mainStr,'|',9)   --购货单位
set @FExplanation =dbo.getString(@mainStr,'|',10)--摘要
set @FFManagerID=dbo.getString(@mainStr,'|',11) --发货
set @FSManagerID=dbo.getString(@mainStr,'|',12) --保管
set @FROB=dbo.getString(@mainStr,'|',13)         --蓝字红字
set @FMarketingStyle=dbo.getString(@mainStr,'|',14)--销售业务类型
set @FSelTranType=dbo.getString(@mainStr,'|',15)  --源单类型
set @Fdate = convert(varchar(20),GETDATE(),23)
exec GetICMaxNum 'ICStockBill',@FInterID output,1,@FBillerID --得到@FInterID
------------------------------------------------------------得到编号
if(@FROB='红字')
set @FROB=-1
else
set @FROB=1
 set @FBillNo ='' 
 exec proc_GetICBillNo 21, @FBillNo out 
-----------------------------------------------------------得到编号
set @FCurrencyID=1 --币别
set @FCheckDate=null --审核时间  
  declare @IsExist varchar(10), --是否存在
            @value varchar(10)--库存更新类型
    select @value= Fvalue  from t_systemprofile where Fkey in ('UPSTOCKWHENSAVE') AND FCateGory='IC' 
INSERT INTO ICStockBill(FInterID,FBillNo,FBrNo,FTranType,FCancellation,FStatus,FDiscountType,
FUpStockWhenSave,FVchInterID,FROB,FHookStatus,Fdate,FSupplyID,FSaleStyle,FCheckDate,FFManagerID,
FSManagerID,FBillerID,FMultiCheckDate1,FMultiCheckDate2,FMultiCheckDate3,FMultiCheckDate4,FMultiCheckDate5,
FPOOrdBillNo,FMultiCheckDate6,FRelateBrID,FOrgBillInterID,FMarketingStyle,FSelTranType,FPrintCount,FBrID,
FFetchAdd,FExplanation,FDeptID,FEmpID,FManagerID,FVIPCardID,FVIPScore,FHolisticDiscountRate,FPOSName,
FWorkShiftId,FLSSrcInterID,FManageType,FSettleDate,FSellerMessage,FTelephone,FMobile,FReceiver,
FDeliveryAddress,FDeliveryCity,FDeliveryDistrict,FDeliveryProvince,FBuyerMessage,FBuyerNick,FConsignee,FOrderAffirm) 
VALUES (@FInterID,@FBillNo,'0',21,0,0,0,@value,0,@FROB,0,@Fdate,@FSupplyID,@FSaleStyle,@FCheckDate,@FFManagerID,@FSManagerID,@FBillerID,Null,Null,Null,Null,Null,'',Null,0,0,12530,@FSelTranType,0,0,@FFetchAdd,@FExplanation,@FDeptID,@FEmpID,@FManagerID,0,0,0,'',0,0,0,@FSettleDate,'','','','','','','','','','',0,0)
update ICStockBill set FUUID=newid() where FInterID=@FInterID

declare @FEntryID varchar(20),       --明细序号
        @FItemID varchar(20),        --商品id
        @FQty float,                --基本单位数量
        @FUnitID varchar(20),       --单位id
        @Fauxqty float,            --上传的数量 
        @Fauxprice float,      -- 单位成本单价
        @Famount float,        --成本金额
        @FPrice float,
        @FTaxAmount float,     --
        @FConsignPrice float,   --销售单价
        @FConsignAmount float, --销售金额(销售单价*数量-折扣额)
        @FPlanPrice float,     --基本单位计划单价
        @FAuxPlanPrice float, --单位计划单价
        @FPlanAmount float,   --计划价金额     
        @FDiscountRate float,  --折扣率
        @FDiscountAmount float,--折扣额(含税单价*数量*折扣率)  
        @FBatchNo varchar(50),   --批号 
        @FDCStockID varchar(20), --仓库id
        @FDCSPID varchar(20),    --仓位
        @FCoefficient varchar(20),   --换算率
        @FBarCode_EntrySelfA0156 varchar(50),--条形码
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
	set @FConsignPrice=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+3)  --销售单价
	set @Fauxqty=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+4)       --数量
	set @FDiscountRate=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+5)   --折扣率
	set @FDCStockID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+6)     --仓库id
	set @FBatchNo=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+7)       --批号
	set @FDCSPID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+8)        --仓位ID
	
	set @FPrice=0
	set @FAuxPrice=@FPrice
    set @FAmount=@FPrice*@Fauxqty
    select @FBarCode_EntrySelfA0156=FBarcode from t_ICItem where FItemID=@FItemID
	select @FCoefficient=FCoefficient from t_MeasureUnit where FMeasureUnitID=@FUnitID --单位换算率
	select @FPlanPrice=isnull(FPlanPrice,0) from t_ICItem where   FItemID=@FItemID 
	set @FQty=@Fauxqty*@FCoefficient                  --基本单位数量 
	set @FAuxPlanPrice=@FPlanPrice*@FCoefficient   --单位计划单价
	set @FPlanAmount=@FAuxPlanPrice*@Fauxqty          --计划单价金额
	set @FDiscountAmount=@Fauxqty*@FConsignPrice*(@FDiscountRate/100) --折扣额
	set @FConsignAmount=@Fauxqty*@FConsignPrice-@FDiscountAmount --金额
	
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
    INSERT INTO ICStockBillEntry (FInterID,FEntryID,FBrNo,FMapNumber,FMapName,FItemID,FOLOrderBillNo,
    FAuxPropID,FBatchNo,FQty,FUnitID,FAuxQtyMust,Fauxqty,FSecCoefficient,FSecQty,FAuxPlanPrice,FPlanAmount,
    Fauxprice,Famount,Fnote,FKFDate,FKFPeriod,FPeriodDate,FDCStockID,FDCSPID,FConsignPrice,FDiscountRate,
    FUniDiscount,FDiscountAmount,FConsignAmount,FOrgBillEntryID,FSNListID,FBuyerFreight,FSourceBillNo,
    FSourceTranType,FSourceInterId,FSourceEntryID,FContractBillNo,FContractInterID,FContractEntryID,
    FOrderBillNo,FOrderInterID,FOrderEntryID,FAllHookQTY,FCurrentHookQTY,FQtyMust,FSepcialSaleId,FSecInvoiceQty,FAuxQtyInvoice,FQtyInvoice,FPlanMode,FMTONo,FClientEntryID,FClientOrderNo,FBarCode_EntrySelfA0156) 
    VALUES (@FInterID,@FEntryID,'0','','',@FItemID,'',0,@FBatchNo,@FQty,@FUnitID,0,@Fauxqty,@FSecCoefficient,@FSecQty,@FAuxPlanPrice,@FPlanAmount,@Fauxprice,@Famount,'',Null,0,Null,@FDCStockID,@FDCSPID,@FConsignPrice,@FDiscountRate,0,@FDiscountAmount,@FConsignAmount,
    0,0,0,'',0,0,0,'',0,0,'',0,0,0,0,0,0,0,0,0,14036,'','','',@FBarCode_EntrySelfA0156) 
end
set @detailqty=@detailqty+1
end
EXEC p_UpdateBillRelateData 21,@FInterID,'ICStockBill','ICStockBillEntry' 
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
