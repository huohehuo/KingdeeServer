if (exists (select * from sys.objects where name = 'proc_PushDeliveryAllot'))
    drop proc proc_PushDeliveryAllot
go
create proc proc_PushDeliveryAllot
(
 @mainStr nvarchar(1000),--�������
 @detailStr1 nvarchar(max),--��ϸ����
 @detailStr2 nvarchar(max),
 @detailStr3 nvarchar(max),
 @detailStr4 nvarchar(max),
 @detailStr5 nvarchar(max)
)
as 
--------------����һ��ģʽ��Ҳ���ǲ���ˢ�¶�������Ӱ�����Ϣ�������������
set nocount on
--------------��ʼ�洢����
begin
--------------����ѡ������Ϊ����ȫ���ع�
set xact_abort on
--------------��������
begin tran

declare @FInterID varchar(20),     --����id
        @FBillNo varchar(50),      -- ���   
        @FROB varchar(20),         --�����ֱ�ʶ
        @Fdate varchar(50),       --����  
        @FSupplyID varchar(20),   --������λid
        @FCurrencyID nvarchar(20),--�ұ�id 
        @FSaleStyle varchar(20),  --���۷�ʽid 
        @FPOStyle varchar(20),    --�ɹ���ʽ
        @FFetchAdd varchar(100),  --�����ص���
        @FCheckDate varchar(50),  --������� 
        @FFManagerID varchar(20), --����
        @FSManagerID varchar(20), --����
        @FManagerID varchar(20),  --����id
        @FDeptID varchar(20),     --����id
        @FEmpID varchar(20),      --ҵ��Աid
        @FBillerID varchar(20),   --�Ƶ���id 
        @FSettleDate varchar(50), --��������
        @FExplanation varchar(200),--ժҪ 
        @FExchangeRate float,
        
        @FMarketingStyle varchar(20),--����ҵ������
        @FSelTranType varchar(20)  --Դ������
set @FBillerID = dbo.getString(@mainStr,'|',1) --����Ա  
set @Fdate =dbo.getString(@mainStr,'|',2)      --���� 
set @FSettleDate=dbo.getString(@mainStr,'|',3) --��������
set @FSupplyID =dbo.getString(@mainStr,'|',4)   --������λid 
set @FSaleStyle =dbo.getString(@mainStr,'|',5) --���۷�ʽ   
set @FDeptID =dbo.getString(@mainStr,'|',6)   --����id
set @FEmpID =dbo.getString(@mainStr,'|',7)    --ҵ��Աid
set @FManagerID =dbo.getString(@mainStr,'|',8) --����id
set @FFManagerID=dbo.getString(@mainStr,'|',9) --����
set @FSManagerID=dbo.getString(@mainStr,'|',10) --����   
set @Fdate = convert(varchar(20),GETDATE(),23)
exec GetICMaxNum 'ICStockBill',@FInterID output,1,@FBillerID --�õ�@FInterID
------------------------------------------------------------�õ����
 set @FBillNo ='' 
 exec proc_GetICBillNo 41, @FBillNo out 
-----------------------------------------------------------�õ����
set @FCurrencyID=1 --�ұ�
set @FCheckDate=null --���ʱ��  
set @FExplanation='' --��ע

  declare @IsExist varchar(10), --�Ƿ����
            @value varchar(10)--����������
    select @value= Fvalue  from t_systemprofile where Fkey in ('UPSTOCKWHENSAVE') AND FCateGory='IC' 
INSERT INTO ICStockBill(FInterID,FBillNo,FBrNo,FTranType,FCancellation,FStatus,FUpStockWhenSave,FHookStatus,Fdate,
FCheckDate,FFManagerID,FSManagerID,FBillerID,FMultiCheckDate1,FMultiCheckDate2,FMultiCheckDate3,FMultiCheckDate4,
FMultiCheckDate5,FMultiCheckDate6,FSelTranType,FBrID,FDeptID,FEmpID,FPrintCount,FRefType,FPOOrdBillNo,FRelateBrID)
 VALUES (@FInterID,@FBillNo,'0',41,0,0,@value,0,@Fdate,@FCheckDate,@FFManagerID,@FSManagerID,@FBillerID,Null,Null,Null,
 Null,Null,Null,83,0,@FDeptID,@FEmpID,0,12561,'',0)
 update ICStockBill set FUUID=newid() where FInterID=@FInterID

declare @FEntryID varchar(20),       --�µ���ϸ���
        @FSourceEntryID varchar(20), --���Ƶ��ݵ���ϸid
        @FSourceInterId varchar(20), --���Ƶ��ݵ�FInterID
        @FSourceBillNo varchar(20),  --���Ƶĵ��ݵĵ��ݱ��
        @FItemID varchar(20),        --��Ʒid
        @FQty float,                --������λ����
        @FQtyMust float,            --������λ��������
        @FAuxQtyMust float,        --��λ����������
        @FUnitID varchar(20),       --��λid
        @Fauxqty float,            --�ϴ������� 
        @FConsignPrice float,      -- ����
        @FConsignAmount float,          --���
        @FTaxAmount float,     -- 
        
        @FPlanPrice float,     --������λ�ƻ�����
        @FAuxPlanPrice float, --��λ�ƻ�����
        @FPlanAmount float,   --�ƻ��۽��     
        @FDiscountRate float,  --�ۿ���
        @FDiscountAmount float,--�ۿ۶�(��˰����*����*�ۿ���)
        @FSCStockID varchar(20),--�����ֿ�id
        @FSCSPID  varchar(20),  --������λid
        @FDCStockID varchar(20), --����ֿ�id
        @FDCSPID varchar(20),    --�����λid
        @FBatchNo varchar(50),     --����
        @FCoefficient varchar(20),   --������
        @FComplexQty varchar(50),  ---��λ+����
        @FUnitName varchar(50),   --��λ����
        @FOrderEntryID varchar(20),--�������id
        @FOrderInterID varchar(20),--����finterID
        @FOrderBillNo varchar(50), --�������
        
        @detailqty int,               --��ϸ�����ĸ���
        @detailcount int,             --��ϸÿ�����ݵĳ��� 
        @detailIndex int,            --��ϸÿ���±�
        @countindex int              --�ָ���|������
       set @detailqty=0        
       set @detailcount=11           
    while(@detailqty<5)--�ж�����ϸ���ĸ�����
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
	set @FItemID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+1)    --��Ʒid
	set @FUnitID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+2)    --��λid 
	set @FConsignPrice=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+3)  --����
	set @Fauxqty=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+4)    --����   
	set @FSCStockID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+5) --���Ƶ���FInterID
	set @FSCSPID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+6) --���Ƶ���FInterID
	set @FSourceEntryID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+7) --���Ƶ���ϸid
	set @FSourceInterId=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+8) --���Ƶ���FInterID
	set @FBatchNo=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+9) --���Ƶ���FInterID
	set @FDCStockID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+10) --�ֿ�id
	set @FDCSPID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+11) --��λid  
	
	select @FExchangeRate=isnull(FExchangeRate,1),@FSourceBillNo=FBillNo from SEOutStock where FInterID=@FSourceInterId --���Ƶĵ��ݱ��
	set @FConsignPrice = @FConsignPrice*@FExchangeRate
	
	select @FAuxQtyMust = FAuxQty-FAuxCommitQty,@FOrderEntryID=FOrderEntryID,@FOrderInterID=FOrderInterID,@FOrderBillNo=FOrderBillNo from SEOutStockEntry where FInterID=@FSourceInterId and FEntryID=@FSourceEntryID
	select @FCoefficient=isnull(FCoefficient,1),@FUnitName=FName from t_MeasureUnit where FMeasureUnitID=@FUnitID --��λ������
	set @FComplexQty=CONVERT( varchar(20),@Fauxqty)+@FUnitName 
	set @FQtyMust=@FAuxQtyMust*@FCoefficient --������λ�����յ����� 
	select @FPlanPrice=isnull(FPlanPrice,0)*@FExchangeRate from t_ICItem where   FItemID=@FItemID 
	set @FQty=@Fauxqty*@FCoefficient                  --������λ���� 
	set @FAuxPlanPrice=@FPlanPrice*@FCoefficient   --��λ�ƻ�����
	set @FPlanAmount=@FAuxPlanPrice*@Fauxqty          --�ƻ����۽�� 
	set @FConsignAmount=@Fauxqty*@FConsignPrice
	set @detailIndex=@detailIndex+1
    set @FEntryID=@detailqty*50+@detailIndex 
    
        if(@value=1)
    begin
    --���
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
      --����
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
   raiserror('���ܵ�ԭ���ǣ�
 1����ѡ�����ѱ��������ݹ���
 2����ѡ�����ѱ������
 3����ǰ���ݺ���ѡ���ݵĹ���������������ѡ���ݵ�����
 4����ѡ�����Ѿ��ر�',18,18)
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
--------------���ڴ���
if(0<>@@error)
	goto error1
--------------�ع�����	
error1:
	rollback tran;
--------------�����洢����
end
