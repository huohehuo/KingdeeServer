if (exists (select * from sys.objects where name = 'proc_Allot'))
    drop proc proc_Allot
go
create proc proc_Allot
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
        @Fdate varchar(50),       --日期       
        @FCheckDate varchar(50),  --审核日期
        @FMangerID varchar(20),   --主管id
        @FDeptID varchar(20),     --部门id
        @FEmpID varchar(20),      --业务员id
        @FBillerID varchar(20),   --制单人id
        @FFManagerID varchar(20), --验收
        @FSManagerID varchar(20)  --保管  
set @FBillerID = dbo.getString(@mainStr,'|',1) --操作员
set @Fdate =dbo.getString(@mainStr,'|',2)      --日期  
set @FDeptID =dbo.getString(@mainStr,'|',3)   --部门id
set @FEmpID =dbo.getString(@mainStr,'|',4)    --业务员id
set @FSManagerID =dbo.getString(@mainStr,'|',5) --保管id   
set @FFManagerID =dbo.getString(@mainStr,'|',6) --验收id
exec GetICMaxNum 'ICStockBill',@FInterID output,1,@FBillerID --得到@FInterID
set @Fdate = convert(varchar(20),GETDATE(),23)
------------------------------------------------------------得到编号
 set @FBillNo ='' 
 exec proc_GetICBillNo 41, @FBillNo out 
-----------------------------------------------------------得到编号 
 
  declare @IsExist varchar(10), --是否存在
            @value varchar(10)--库存更新类型
    select @value= Fvalue  from t_systemprofile where Fkey in ('UPSTOCKWHENSAVE') AND FCateGory='IC' 
set @FCheckDate=null --审核时间 
INSERT INTO ICStockBill(FInterID,FBillNo,FBrNo,FTranType,FCancellation,FStatus,FUpStockWhenSave,FHookStatus,Fdate,
FCheckDate,FFManagerID,FSManagerID,FBillerID,FMultiCheckDate1,FMultiCheckDate2,FMultiCheckDate3,FMultiCheckDate4,
FMultiCheckDate5,FMultiCheckDate6,FSelTranType,FBrID,FDeptID,FEmpID,FPrintCount,FRefType) 
VALUES (@FInterID,@FBillNo,'0',41,0,0,@value,0,@Fdate,@FCheckDate,@FFManagerID,@FSManagerID,@FBillerID,Null,Null,Null,Null,Null,Null,0,0,@FDeptID,@FEmpID,0,12561)
 UPDATE ICStockBill SET FUUID=NEWID() WHERE FInterID=@FInterID
declare @FEntryID varchar(20),       --明细序号
        @FItemID varchar(20),        --商品id
        @FQty float,                --基本单位数量
        @FUnitID varchar(20),       --单位id
        @Fauxqty float,             --上传单位数量 
        @FSCStockID varchar(20),    --出库仓库id
        @FSCSPID varchar(20),       --出库仓位id
        @FDCStockID varchar(20),    --入库仓库id
        @FDCSPID  varchar(20),      --入库仓位id
        @FBatchNo varchar(50),   --批次
        @FCoefficient float(50),  --单位换算
        @FPlanPrice float(50),    --基本计划单价
        @FAuxPlanPrice float(50), --单位计划单价
        @FPlanAmount float(50),   --计划单价金额
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
	set @Fauxqty=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+3)    --数量
	set @FDCStockID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+4) --入库id
	set @FSCStockID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+5) --出库id
	set @FDCSPID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+6) --入库仓位
	set @FSCSPID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+7) --出库仓位
	set @FBatchNo=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+8) --批次
	 	select @FCoefficient=FCoefficient from t_MeasureUnit where FMeasureUnitID=@FUnitID --单位换算率
	select @FPlanPrice=isnull(FPlanPrice,0) from t_ICItem where   FItemID=@FItemID 
	set @FQty=@Fauxqty*@FCoefficient  
	set @FAuxPlanPrice = @FPlanPrice*@FCoefficient
	set @FPlanAmount = @FAuxPlanPrice*@Fauxqty
 
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
    --入库
      select @IsExist=COUNT(1) from ICInventory where FStockID=@FDCStockID and FStockPlaceID=@FDCSPID and FBatchNo=@FBatchNo and FItemID=@FItemID
      if(@IsExist=0)
        begin
        INSERT INTO ICInventory(FBrNo,FItemID,FBatchNo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FQty,FSecQty)
        SELECT '',@FItemID,@FBatchNo,0,@FDCStockID,@FDCSPID,0,'',@FQty,@FSecQty
        end
      else
        begin
        update ICInventory set FQty=FQty+@FQty,FSecQty=FSecQty+@FSecQty where FStockID=@FDCStockID and FStockPlaceID=@FDCSPID and FBatchNo=@FBatchNo and FItemID=@FItemID 
      end   
      --出库
       select @IsExist=COUNT(1) from ICInventory where FStockID=@FSCStockID and FStockPlaceID=@FSCSPID and FBatchNo=@FBatchNo and FItemID=@FItemID
      if(@IsExist=0)
        begin
        INSERT INTO ICInventory(FBrNo,FItemID,FBatchNo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FQty,FSecQty)
        SELECT '',@FItemID,@FBatchNo,0,@FSCStockID,@FSCSPID,0,'',-@FQty,-@FSecQty
        end
      else
        begin
        update ICInventory set FQty=FQty-@FQty,FSecQty=FSecQty-@FSecQty where FStockID=@FSCStockID and FStockPlaceID=@FSCSPID and FBatchNo=@FBatchNo and FItemID=@FItemID 
      end     
    end 
    INSERT INTO ICStockBillEntry (FInterID,FEntryID,FBrNo,FItemID,FAuxPropID,FBatchNo,FQty,FUnitID,Fauxqty,FSecCoefficient,FSecQty,FAuxPlanPrice,FPlanAmount,
    Fauxprice,Famount,FAuxPriceRef,FAmtRef,Fnote,FKFDate,FKFPeriod,FPeriodDate,FSCStockID,FSCSPID,FDCStockID,FDCSPID,FSNListID,FSourceBillNo,FSourceTranType,
    FSourceInterId,FSourceEntryID,FICMOBillNo,FICMOInterID,FPPBomEntryID,FOrderBillNo,FOrderInterID,FOrderEntryID,FPlanMode,FMTONo,FNeedPickQTY,FInvStockQty) 
    VALUES (@FInterID,@FEntryID,'0',@FItemID,0,@FBatchNo,@FQty,@FUnitID,@Fauxqty,@FSecCoefficient,@FSecQty,@FAuxPlanPrice,@FPlanAmount,0,0,0,0,'',Null,0,Null,@FSCStockID,@FSCSPID,@FDCStockID,@FDCSPID,0,'',0,0,0,'',0,0,'',0,0,14036,'',0,0) 
end
set @detailqty=@detailqty+1
end
EXEC p_UpdateBillRelateData 41,@FInterID,'ICStockBill','ICStockBillEntry' 
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
