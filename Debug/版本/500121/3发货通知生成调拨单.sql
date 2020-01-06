if (exists (select * from sys.objects where name = 'proc_PushDeliveryAllot'))
    drop proc proc_PushDeliveryAllot
go
create proc proc_PushDeliveryAllot
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
        @FCurrencyID nvarchar(20),--币别id 
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
        @FSettleDate varchar(50), --付款日期
        @FExplanation varchar(200),--摘要 
        @FExchangeRate float,
        
        @FMarketingStyle varchar(20),--销售业务类型
        @FSelTranType varchar(20)  --源单类型
set @FBillerID = dbo.getString(@mainStr,'|',1) --操作员  
set @Fdate =dbo.getString(@mainStr,'|',2)      --日期 
set @FSettleDate=dbo.getString(@mainStr,'|',3) --付款日期
set @FSupplyID =dbo.getString(@mainStr,'|',4)   --购货单位id 
set @FSaleStyle =dbo.getString(@mainStr,'|',5) --销售方式   
set @FDeptID =dbo.getString(@mainStr,'|',6)   --部门id
set @FEmpID =dbo.getString(@mainStr,'|',7)    --业务员id
set @FManagerID =dbo.getString(@mainStr,'|',8) --主管id
set @FFManagerID=dbo.getString(@mainStr,'|',9) --发货
set @FSManagerID=dbo.getString(@mainStr,'|',10) --保管   
set @Fdate = convert(varchar(20),GETDATE(),23)
exec GetICMaxNum 'ICStockBill',@FInterID output,1,@FBillerID --得到@FInterID
------------------------------------------------------------得到编号
 set @FBillNo ='' 
 exec proc_GetICBillNo 41, @FBillNo out 
-----------------------------------------------------------得到编号
set @FCurrencyID=1 --币别
set @FCheckDate=null --审核时间  
set @FExplanation='' --备注

  declare @IsExist varchar(10), --是否存在
            @value varchar(10)--库存更新类型
    select @value= Fvalue  from t_systemprofile where Fkey in ('UPSTOCKWHENSAVE') AND FCateGory='IC' 
INSERT INTO ICStockBill(FInterID,FBillNo,FBrNo,FTranType,FCancellation,FStatus,FUpStockWhenSave,FHookStatus,Fdate,
FCheckDate,FFManagerID,FSManagerID,FBillerID,FMultiCheckDate1,FMultiCheckDate2,FMultiCheckDate3,FMultiCheckDate4,
FMultiCheckDate5,FMultiCheckDate6,FSelTranType,FBrID,FDeptID,FEmpID,FPrintCount,FRefType,FPOOrdBillNo,FRelateBrID)
 VALUES (@FInterID,@FBillNo,'0',41,0,0,@value,0,@Fdate,@FCheckDate,@FFManagerID,@FSManagerID,@FBillerID,Null,Null,Null,
 Null,Null,Null,83,0,@FDeptID,@FEmpID,0,12561,'',0)
 update ICStockBill set FUUID=newid() where FInterID=@FInterID

declare @FEntryID varchar(20),       --新的明细序号
        @FSourceEntryID varchar(20), --下推单据的明细id
        @FSourceInterId varchar(20), --下推单据的FInterID
        @FSourceBillNo varchar(20),  --下推的单据的单据编号
        @FItemID varchar(20),        --商品id
        @FQty float,                --基本单位数量
        @FQtyMust float,            --基本单位可验数量
        @FAuxQtyMust float,        --单位可验收数量
        @FUnitID varchar(20),       --单位id
        @Fauxqty float,            --上传的数量 
        @FConsignPrice float,      -- 单价
        @FConsignAmount float,          --金额
        @FTaxAmount float,     -- 
        
        @FPlanPrice float,     --基本单位计划单价
        @FAuxPlanPrice float, --单位计划单价
        @FPlanAmount float,   --计划价金额     
        @FDiscountRate float,  --折扣率
        @FDiscountAmount float,--折扣额(含税单价*数量*折扣率)
        @FSCStockID varchar(20),--调出仓库id
        @FSCSPID  varchar(20),  --调出仓位id
        @FDCStockID varchar(20), --调入仓库id
        @FDCSPID varchar(20),    --调入仓位id
        @FBatchNo varchar(50),     --批号
        @FCoefficient varchar(20),   --换算率
        @FComplexQty varchar(50),  ---单位+数量
        @FUnitName varchar(50),   --单位名称
        @FOrderEntryID varchar(20),--订单序号id
        @FOrderInterID varchar(20),--订单finterID
        @FOrderBillNo varchar(50), --订单编号
        
        @detailqty int,               --明细参数的个数
        @detailcount int,             --明细每行数据的长度 
        @detailIndex int,            --明细每行下标
        @countindex int              --分隔符|的数量
       set @detailqty=0        
       set @detailcount=11           
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
	set @FConsignPrice=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+3)  --单价
	set @Fauxqty=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+4)    --数量   
	set @FSCStockID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+5) --下推的明FInterID
	set @FSCSPID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+6) --下推的明FInterID
	set @FSourceEntryID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+7) --下推的明细id
	set @FSourceInterId=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+8) --下推的明FInterID
	set @FBatchNo=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+9) --下推的明FInterID
	set @FDCStockID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+10) --仓库id
	set @FDCSPID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+11) --仓位id  
	
	select @FExchangeRate=isnull(FExchangeRate,1),@FSourceBillNo=FBillNo from SEOutStock where FInterID=@FSourceInterId --下推的单据编号
	set @FConsignPrice = @FConsignPrice*@FExchangeRate
	
	select @FAuxQtyMust = FAuxQty-FAuxCommitQty,@FOrderEntryID=FOrderEntryID,@FOrderInterID=FOrderInterID,@FOrderBillNo=FOrderBillNo from SEOutStockEntry where FInterID=@FSourceInterId and FEntryID=@FSourceEntryID
	select @FCoefficient=isnull(FCoefficient,1),@FUnitName=FName from t_MeasureUnit where FMeasureUnitID=@FUnitID --单位换算率
	set @FComplexQty=CONVERT( varchar(20),@Fauxqty)+@FUnitName 
	set @FQtyMust=@FAuxQtyMust*@FCoefficient --基本单位可验收的数量 
	select @FPlanPrice=isnull(FPlanPrice,0)*@FExchangeRate from t_ICItem where   FItemID=@FItemID 
	set @FQty=@Fauxqty*@FCoefficient                  --基本单位数量 
	set @FAuxPlanPrice=@FPlanPrice*@FCoefficient   --单位计划单价
	set @FPlanAmount=@FAuxPlanPrice*@Fauxqty          --计划单价金额 
	set @FConsignAmount=@Fauxqty*@FConsignPrice
	set @detailIndex=@detailIndex+1
    set @FEntryID=@detailqty*50+@detailIndex 
    
        if(@value=1)
    begin
    --入库
      select @IsExist=COUNT(1) from ICInventory where FStockID=@FDCStockID and FStockPlaceID=@FDCSPID and FBatchNo=@FBatchNo and FItemID=@FItemID
      if(@IsExist=0)
        begin
        INSERT INTO ICInventory(FBrNo,FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FQty,FSecQty)
        SELECT '',@FItemID,@FBatchNo,'',0,@FDCStockID,@FDCSPID,0,'',@FQty,0
        end
      else
        begin
        update ICInventory set FQty=FQty+@FQty where FStockID=@FDCStockID and FStockPlaceID=@FDCSPID and FBatchNo=@FBatchNo and FItemID=@FItemID 
      end   
      --出库
       select @IsExist=COUNT(1) from ICInventory where FStockID=@FSCStockID and FStockPlaceID=@FSCSPID and FBatchNo=@FBatchNo and FItemID=@FItemID
      if(@IsExist=0)
        begin
        INSERT INTO ICInventory(FBrNo,FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FQty,FSecQty)
        SELECT '',@FItemID,@FBatchNo,'',0,@FSCStockID,@FSCSPID,0,'',-@FQty,0
        end
      else
        begin
        update ICInventory set FQty=FQty-@FQty where FStockID=@FSCStockID and FStockPlaceID=@FSCSPID and FBatchNo=@FBatchNo and FItemID=@FItemID 
      end     
    end 
INSERT INTO ICStockBillEntry (FInterID,FEntryID,FBrNo,FItemID,FBarCode,FComCategoryID,FComBrandID,FAuxPropID,FBatchNo,FQty,
FUnitID,Fauxqty,FComplexQty,FSecCoefficient,FSecQty,FAuxPlanPrice,FPlanAmount,Fauxprice,Famount,FAuxPriceRef,FAmtRef,Fnote,
FKFDate,FKFPeriod,FPeriodDate,FSCStockID,FSCSPID,FDCStockID,FDCSPID,FSNListID,FSourceBillNo,FSourceTranType,FSourceInterId,
FSourceEntryID,FICMOBillNo,FICMOInterID,FPPBomEntryID,FOrderBillNo,FOrderInterID,FOrderEntryID,FPlanMode,FMTONo,FRecOK,
FNeedPickQTY,FInvStockQty) VALUES (@FInterID,@FEntryID,'0',@FItemID,'',0,0,0,@FBatchNo,@FQty,@FUnitID,@Fauxqty,@FComplexQty,
0,0,0,0,0,0,0,0,'',Null,0,Null,@FSCStockID,@FSCSPID,@FDCStockID,@FDCSPID,0,@FSourceBillNo,83,@FSourceInterId,@FSourceEntryID,
'',0,0,@FOrderBillNo,@FOrderInterID,@FOrderEntryID,14036,'','',0,0) --FOrderBillNo,FOrderInterID,FOrderEntryID= '',0,0
end
set @detailqty=@detailqty+1
end 
EXEC p_UpdateBillRelateData 41,@FInterID,'ICStockBill','ICStockBillEntry' 


set nocount on
declare @fcheck_fail int
declare @fsrccommitfield_prevalue decimal(28,13)
declare @fsrccommitfield_endvalue decimal(28,13)
declare @maxorder int 
update src set @fsrccommitfield_prevalue= isnull(src.fcommitqty,0),
     @fsrccommitfield_endvalue=@fsrccommitfield_prevalue+dest.fqty,
     @fcheck_fail=case isnull(@maxorder,0) when 1 then 0 else (case when (1=1) then @fcheck_fail else -1 end) end,
     src.fcommitqty=@fsrccommitfield_endvalue,
     src.fauxcommitqty=@fsrccommitfield_endvalue/cast(t1.fcoefficient as float)
 from seoutstockentry src 
     inner join 
 (select u1.fsourceinterid as fsourceinterid,u1.fsourceentryid,u1.fitemid,sum(u1.fqty) as fqty
 from  icstockbillentry u1 
 where u1.finterid=@FInterID
 group by u1.fsourceinterid,u1.fsourceentryid,u1.fitemid) dest 
 on dest.fsourceinterid = src.finterid
 and dest.fitemid = src.fitemid
 and src.fentryid = dest.fsourceentryid
 inner join t_measureunit t1 on src.funitid=t1.fitemid
 if (isnull(@fcheck_fail,0)=-1) 
 begin
   raiserror('可能的原因是：
 1、所选单据已被其他单据关联
 2、所选单据已被反审核
 3、当前单据和所选单据的关联数量超过了所选单据的数量
 4、所选单据已经关闭',18,18)
 goto error1
 end
 
UPDATE T1 SET T1.FStatus=
CASE WHEN NOT EXISTS(SELECT 1 FROM SEOutStockEntry WHERE FInterID=T1.FInterID AND FCommitQty<>0) THEN 1 
WHEN NOT EXISTS (SELECT 1 FROM SEOutStockEntry WHERE FInterID=T1.FInterID AND FQty>FCommitQty) THEN 3 
ELSE 2 END,
T1.FCLOSED=CASE WHEN NOT EXISTS (SELECT 1 FROM SEOutStockEntry WHERE FInterID=T1.FInterID AND FQty>FCommitQty) THEN 1 ELSE 0 END 
FROM SEOutStock T1, ICStockBillEntry T2 
WHERE T1.FInterID = T2.FSourceInterID
 AND T2.FInterID=@FInterID 
 
 
 IF EXISTS (SELECT 1 FROM ICBillRelations_Sale WHERE FBillType = 41 AND FBillID=@FInterID)
BEGIN
    UPDATE t1 SET t1.FChildren=t1.FChildren+1
    FROM SEOutStock t1 INNER JOIN SEOutStockEntry t2 ON     t1.FInterID=t2.FInterID
    INNER JOIN ICBillRelations_Sale t3 ON t3.FMultiEntryID=t2.FEntryID AND t3.FMultiInterID=t2.FInterID
    WHERE t3.FBillType=41 AND t3.FBillID=@FInterID
END
ELSE
BEGIN
    UPDATE t3 SET t3.FChildren=t3.FChildren+1
    FROM ICStockBill t1 INNER JOIN ICStockBillEntry     t2 ON t1.FInterID=t2.FInterID
    INNER JOIN SEOutStock t3 ON t3.FTranType=t2.FSourceTranType AND t3.FInterID=t2.FSourceInterID
    WHERE t1.FTranType=41 AND t1.FInterID=@FInterID AND t2.FSourceInterID>0
END
   if exists( 
   select 1 from ICStockBillEntry enty 
   inner join ICStockBill bill on enty.FinterID=bill.FinterID
   inner join t_PDASNTemp  temp on temp.FBillNo=bill.FBillNo and enty.FEntryID=temp.FEntryID
   where enty.FinterID=@FInterID  )
   begin
   Update enty
   Set enty.FPDASn = temp.FPDASn
   from ICStockBillEntry enty
   inner join ICStockBill bill
   on enty.FinterID=bill.FinterID
   inner join t_PDASNTemp  temp
   on temp.FBillNo=bill.FBillNo and enty.FEntryID=temp.FEntryID
   Where enty.FinterID = @FInterID  and len(temp.FPDASn)>0  and  temp.FPDASn is not null  
   End
   Delete temp
   from ICStockBillEntry enty
   inner join ICStockBill bill
   on enty.FinterID=bill.FinterID
   inner join t_PDASNTemp  temp
   on temp.FBillNo=bill.FBillNo and enty.FEntryID=temp.FEntryID
   Where enty.FinterID = @FInterID   


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
