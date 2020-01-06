if (exists (select * from sys.objects where name = 'proc_OutCheck'))
    drop proc proc_OutCheck
go
create proc proc_OutCheck
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
        @FMarketingStyle varchar(20),--����ҵ������
        @FExchangeRate float,
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
set @FBillNo = ''
 exec proc_GetICBillNo 21, @FBillNo out 
-----------------------------------------------------------�õ����
set @FCurrencyID=1 --�ұ�
set @FCheckDate=null --���ʱ��  
set @FExplanation='' --��ע
  declare @IsExist varchar(10), --�Ƿ����
            @value varchar(10)--����������
    select @value= Fvalue  from t_systemprofile where Fkey in ('UPSTOCKWHENSAVE') AND FCateGory='IC' 
INSERT INTO ICStockBill(FInterID,FBillNo,FBrNo,FTranType,FCancellation,FStatus,FUpStockWhenSave,FROB,FHookStatus,Fdate,
FSupplyID,FSaleStyle,FConfirmDate,FCheckDate,FFManagerID,FSManagerID,FBillerID,FConfirmer,FMultiCheckDate1,FMultiCheckDate2,
FMultiCheckDate3,FMultiCheckDate4,FMultiCheckDate5,FPOOrdBillNo,FMultiCheckDate6,FRelateBrID,FOrgBillInterID,
FMarketingStyle,FPrintCount,FSelTranType,FBrID,FFetchAdd,FConfirmMem,FExplanation,FDeptID,FEmpID,FManagerID,FVIPCardID,
FVIPScore,FReceiver,FHolisticDiscountRate,FPOSName,FWorkShiftId,FLSSrcInterID,FManageType,FPayCondition,FSettleDate,
FConsignee) 
SELECT @FInterID,@FBillNo,'0',21,0,0,@value,1,0,@Fdate,@FSupplyID,@FSaleStyle,Null,@FCheckDate,@FFManagerID,@FSManagerID,@FBillerID,0,Null,Null,Null,Null,Null,'',Null,0,0,12530,0,81,0,'','',@FExplanation,@FDeptID,@FEmpID,@FManagerID,0,0,'',0,'',0,0,0,0,@FSettleDate,0
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
        @FDCStockID varchar(20), --�ֿ�id
        @FDCSPID varchar(20),    --��λid
        @FBatchNo varchar(50),     --����
        @FCoefficient varchar(20),   --������
            @FSecCoefficient float, --������λ������
        @FSecQty decimal(28,10),   --������λ����
          @FSecUnitID  varchar(50), 
        @detailqty int,               --��ϸ�����ĸ���
        @detailcount int,             --��ϸÿ�����ݵĳ��� 
        @detailIndex int,            --��ϸÿ���±�
        @countindex int              --�ָ���|������
       set @detailqty=0        
       set @detailcount=9           
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
	set @FDCStockID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+5) --�ֿ�id
	set @FDCSPID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+6) --��λid
	set @FSourceEntryID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+7) --���Ƶ���ϸid
	set @FSourceInterId=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+8) --���Ƶ���FInterID
	set @FBatchNo=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+9) --���Ƶ���FInterID
	select  @FExchangeRate=isnull(FExchangeRate,1),@FSourceBillNo=FBillNo from SEOrder where FInterID=@FSourceInterId --���Ƶĵ��ݱ��
	set @FConsignPrice = @FConsignPrice * @FExchangeRate
	
	select @FAuxQtyMust = FAuxQty-FAuxCommitQty from SEOrderEntry where FInterID=@FSourceInterId and FEntryID=@FSourceEntryID
	select @FCoefficient=isnull(FCoefficient,1) from t_MeasureUnit where FMeasureUnitID=@FUnitID --��λ������
	set @FQtyMust=@FAuxQtyMust*@FCoefficient --������λ�����յ����� 
	select @FPlanPrice=isnull(FPlanPrice,0)*@FExchangeRate from t_ICItem where   FItemID=@FItemID 
	set @FQty=@Fauxqty*@FCoefficient                  --������λ���� 
	set @FAuxPlanPrice=@FPlanPrice*@FCoefficient   --��λ�ƻ�����
	set @FPlanAmount=@FAuxPlanPrice*@Fauxqty          --�ƻ����۽�� 
	set @FConsignAmount=@Fauxqty*@FConsignPrice
	set @detailIndex=@detailIndex+1
    set @FEntryID=@detailqty*50+@detailIndex 
    
    --���ϸ�����λ
       select @FSecUnitID=FSecUnitID,@FSecCoefficient=FSecCoefficient from t_ICItem where FItemID=@FItemID
      if(@FSecCoefficient<>0) --�����ж��ϴ����Ǹ�����λ���ǻ�����λ �������˵���ϴ����Ǹ�����λ
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
 FAuxPropID,FBatchNo,FQty,FUnitID,FAuxQtyMust,Fauxqty,FSecCoefficient,FSecQty,FAuxPlanPrice,
 FPlanAmount,Fauxprice,Famount,Fnote,FKFDate,FKFPeriod,FPeriodDate,FIsVMI,FEntrySupply,FDCStockID,
 FDCSPID,FConsignPrice,FDiscountRate,FConsignAmount,FDiscountAmount,FOrgBillEntryID,FSNListID,
 FSourceBillNo,FSourceTranType,FSourceInterId,FSourceEntryID,FContractBillNo,FContractInterID,
 FContractEntryID,FOrderBillNo,FOrderInterID,FOrderEntryID,FAllHookQTY,FCurrentHookQTY,FQtyMust,
 FSepcialSaleId,FPlanMode,FMTONo,FClientOrderNo,FConfirmMemEntry,FClientEntryID,FChkPassItem,
 FSEOutBillNo,FSEOutEntryID,FSEOutInterID)
  SELECT @FInterID,@FEntryID,'0','','',@FItemID,'',0,@FBatchNo,@FQty,@FUnitID,@FAuxQtyMust,@Fauxqty,
  @FSecCoefficient,@FSecQty,@FAuxPlanPrice,@FPlanAmount,0,0,'',Null,0,Null,0,0,@FDCStockID,@FDCSPID,@FConsignPrice,0,
  @FConsignAmount,0,0,0,@FSourceBillNo,81,@FSourceInterId,@FSourceEntryID,'',0,0,@FSourceBillNo,
  @FSourceInterId,@FSourceEntryID,0,0,@FQtyMust,0,14036,'','','','0',1058,'',0,0  
 
end
set @detailqty=@detailqty+1
end 
EXEC p_UpdateBillRelateData 21,@FInterID,'ICStockBill','ICStockBillEntry' 
set nocount on
declare @fcheck_fail int
declare @fsrccommitfield_prevalue decimal(28,13)
declare @fsrccommitfield_endvalue decimal(28,10)
declare @maxorder int 
update src set @fsrccommitfield_prevalue= isnull(src.fcommitqty,0),
     @fsrccommitfield_endvalue=@fsrccommitfield_prevalue+dest.fqty,
@maxorder=(select fvalue from t_systemprofile where fcategory='ic' and fkey='cqtylargerseqty'),
     @fcheck_fail=case isnull(@maxorder,0) when 1 then 0 else (case when (abs(src.fqty)>abs(@fsrccommitfield_prevalue) or abs(src.fqty)>abs(@fsrccommitfield_endvalue)) then @fcheck_fail else -1 end) end,
     src.fcommitqty=@fsrccommitfield_endvalue,
     src.fauxcommitqty=@fsrccommitfield_endvalue/cast(t1.fcoefficient as float)
 from seorderentry src 
     inner join seorder srchead on src.finterid=srchead.finterid
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
else
if exists (select 1 from seorder src right join  (select u1.fsourceinterid as fsourceinterid,u1.fsourceentryid,u1.fitemid,sum(u1.fqty) as fqty
 from  icstockbillentry u1 
 where u1.finterid=@FInterID
 group by u1.fsourceinterid,u1.fsourceentryid,u1.fitemid) dest on dest.fsourceinterid = src.finterid where dest.fsourceinterid>0 and src.finterid is null)
begin
raiserror('��ѡ�����ѱ�ɾ��',18,18)
goto error1
end

Update t
Set t.FStatus =Case When (SELECT COUNT(1) FROM SEOrderEntry WHERE (FCommitQty>0 OR (ISNULL(FMRPClosed,0)=1 AND ISNULL(FMRPAutoClosed,1)=0)) AND FInterID IN(@FSourceInterId))=0 Then 1 When (SELECT COUNT(1) FROM SEOrderEntry te WHERE (ISNULL(FMRPClosed,0)=1 OR  FCommitQty >= FQty ) AND FInterID IN(@FSourceInterId))<(SELECT COUNT(1) FROM SEOrderEntry WHERE FInterID IN(@FSourceInterId)) Then 2 Else 3 End
,t.FClosed =Case WHEN (SELECT COUNT(1) FROM SEOrderEntry te WHERE ( FCommitQty >= FQty  OR (ISNULL(te.FMRPAutoClosed,1)=0 AND ISNULL(FMRPClosed,0)=1)) AND te.FInterID IN(@FSourceInterId))=(SELECT COUNT(1) FROM SEOrderEntry te WHERE te.FInterID IN(@FSourceInterId)) Then 1 Else 0 End
From SEOrder t
WHERE t.FInterID IN(@FSourceInterId)

IF EXISTS (SELECT 1 FROM ICBillRelations_Sale WHERE FBillType = 21 AND FBillID=@FInterID)
BEGIN
    UPDATE t1 SET t1.FChildren=t1.FChildren+1
    FROM SEOrder t1 INNER JOIN SEOrderEntry t2 ON     t1.FInterID=t2.FInterID
    INNER JOIN ICBillRelations_Sale t3 ON t3.FMultiEntryID=t2.FEntryID AND t3.FMultiInterID=t2.FInterID
    WHERE t3.FBillType=21 AND t3.FBillID=@FInterID
END
ELSE
BEGIN
    UPDATE t3 SET t3.FChildren=t3.FChildren+1
    FROM ICStockBill t1 INNER JOIN ICStockBillEntry     t2 ON t1.FInterID=t2.FInterID
    INNER JOIN SEOrder t3 ON t3.FTranType=t2.FSourceTranType AND t3.FInterID=t2.FSourceInterID
    WHERE t1.FTranType=21 AND t1.FInterID=@FInterID AND t2.FSourceInterID>0
END
UPDATE P1 SET P1.FLockFlag=(CASE WHEN ISNULL(t1.FQty,0)<=0 THEN 0 ELSE 1 END)
FROM SEOrderEntry P1 
INNER JOIN ICStockBillEntry u1 ON u1.FOrderInterID=P1.FInterID AND u1.FOrderEntryID=P1.FEntryID AND u1.FItemID=P1.FItemID
INNER JOIN (SELECT FInterID,FEntryID,SUM(FQty) AS FQty FROM t_LockStock WHERE FTranType=81 GROUP BY FInterID,FEntryID) t1 ON P1.FInterID=t1.FInterID AND P1.FEntryID=t1.FEntryID
WHERE u1.FInterID=@FInterID
  if(@value=1)
		begin
 IF EXISTS(SELECT FOrderInterID FROM ICStockBillEntry WHERE FOrderInterID>0 AND FInterID=@FInterID)
BEGIN 
  UPDATE u1
  SET u1.FStockQty=u1.FStockQty+1*Cast(u2.FStockQty as Float)
       ,u1.FSecStockQty=u1.FSecStockQty+1*Cast(u2.FSecStockQty as Float)
       ,u1.FAuxStockQty=ROUND((u1.FStockQty+1*Cast(u2.FStockQty as Float))/Cast(t3.FCoefficient as Float),t1.FQtyDecimal)
  FROM SEOrderEntry u1 
  INNER JOIN 
  (SELECT FOrderInterID,FOrderEntryID,FItemID,SUM(FQty)AS FStockQty,SUM(FAuxQty) AS FAuxStockQty,SUM(FSecQty) AS FSecStockQty
   FROM ICStockBillEntry WHERE FInterID=@FInterID
   GROUP BY FOrderInterID,FOrderEntryID,FItemID) u2
  ON u1.FInterID=u2.FOrderInterID AND u1.FEntryID=u2.FOrderEntryID AND u1.FItemID=u2.FItemID
   INNER JOIN t_ICItemBase t1 ON u1.FItemID=t1.FItemID
   INNER JOIN t_MeasureUnit t3 ON u1.FUnitID=t3.FItemID
 
  IF OBJECT_ID('tempdb..#tmpPMCIndex','U') IS NOT NULL 
    DROP TABLE #tmpPMCIndex
  SELECT u0.FIndex
    INTO #tmpPMCIndex
  FROM ICPlan_PMCdetail u0
  INNER JOIN SEOrderEntry u1 ON u0.FRelTranType=81 AND u0.FRelInterID=u1.FInterID AND u0.FRelEntryID=u1.FEntryID AND  u0.FBillType In(22,25)
  INNER JOIN 
  ( SELECT DISTINCT FOrderInterID,FOrderEntryID,FItemID
    FROM ICStockBillEntry WHERE  FOrderInterID>0 AND FInterID=@FInterID
   ) u2 ON u1.FInterID=u2.FOrderInterID AND u1.FEntryID=u2.FOrderEntryID AND u1.FItemID=u2.FItemID 
  CREATE CLUSTERED INDEX PK_#tmpPMCIndex ON #tmpPMCIndex(FIndex) 
 
  UPDATE u0
    SET u0.FWillOutQty=CASE WHEN u1.FQty>u1.FStockQty THEN u1.FQty-u1.FStockQty ELSE 0 END 
  FROM ICPlan_PMCdetail u0
  INNER JOIN SEOrderEntry u1 ON u0.FRelTranType=81 AND u0.FRelInterID=u1.FInterID AND u0.FRelEntryID=u1.FEntryID AND  u0.FBillType In(22,25)
  WHERE exists(select 1 from  #tmpPMCIndex where FIndex=u0.FIndex)
  DROP TABLE #tmpPMCIndex
 
END 

 UPDATE p1 
SET p1.FMrpClosed=CASE WHEN ISNULL(p1.FMRPAutoClosed,1)=1 THEN (CASE WHEN p1.FStockQty<p1.FQty THEN 0 ELSE 1 END) ELSE p1.FMrpClosed END
FROM SEOrderEntry p1 INNER JOIN ICStockBillEntry u1 ON u1.FOrderInterID=p1.FInterID AND u1.FOrderEntryID=p1.FEntryID
WHERE u1.FInterID=@FInterID
IF EXISTS(SELECT FOrderInterID FROM ICStockBillEntry WHERE FSEOutInterID>0 AND FInterID=@FInterID)
 UPDATE u1
 SET u1.FStockQty=u1.FStockQty+1*Cast(u2.FStockQty as Float)
     ,u1.FSecStockQty=u1.FSecStockQty+1*Cast(u2.FSecStockQty as Float)
     ,u1.FAuxStockQty=ROUND((u1.FStockQty+1*Cast(u2.FStockQty as Float))/Cast(t3.FCoefficient as Float),t1.FQtyDecimal)
 FROM SEOutStockEntry u1 
 INNER JOIN 
 (SELECT FSEOutInterID,FSEOutEntryID,FItemID,SUM(FQty)AS FStockQty,SUM(FAuxQty) AS FAuxStockQty,SUM(FSecQty) AS FSecStockQty
  FROM ICStockBillEntry WHERE FInterID=@FInterID
  GROUP BY FSEOutInterID,FSEOutEntryID,FItemID) u2
 ON u1.FInterID=u2.FSEOutInterID AND u1.FEntryID=u2.FSEOutEntryID AND u1.FItemID=u2.FItemID
 INNER JOIN t_ICItemBase t1 ON u1.FItemID=t1.FItemID INNER JOIN t_MeasureUnit t3 ON u1.FUnitID=t3.FItemID
end
Update t
Set t.FStatus =Case When (SELECT COUNT(1) FROM SEOrderEntry WHERE (FCommitQty>0 OR (ISNULL(FMRPClosed,0)=1 AND ISNULL(FMRPAutoClosed,1)=0)) AND FInterID IN(@FSourceInterId))=0 Then 1 When (SELECT COUNT(1) FROM SEOrderEntry te WHERE (ISNULL(FMRPClosed,0)=1 OR  FCommitQty >= FQty ) AND FInterID IN(@FSourceInterId))<(SELECT COUNT(1) FROM SEOrderEntry WHERE FInterID IN(@FSourceInterId)) Then 2 Else 3 End
,t.FClosed =Case WHEN (SELECT COUNT(1) FROM SEOrderEntry te WHERE ( FCommitQty >= FQty  OR (ISNULL(te.FMRPAutoClosed,1)=0 AND ISNULL(FMRPClosed,0)=1)) AND te.FInterID IN(@FSourceInterId))=(SELECT COUNT(1) FROM SEOrderEntry te WHERE te.FInterID IN(@FSourceInterId)) Then 1 Else 0 End
From SEOrder t
WHERE t.FInterID IN(@FSourceInterId)



update t1 set FcmtQty_O=FcmtQty_O from ExpOutReqEntry t1  inner join (  select sum(t1.FQty) FQty,t3.fdetailid  from ICStockBillEntry t1  inner join ExpOutReqEntry t2 on t2.fdetailid=t1.fsourceEntryid  inner join ExpOutReqEntry t3 on t3.fdetailid=t2.fentryid_src  where fsourceinterid>0 and fsourcebillno<>'' and fsourcetrantype=1007131 and t1.finterid=@FInterID group by t3.fdetailid) t2  on t1.fdetailid=t2.fdetailid

    UPDATE A SET A.FCommitQty=A.FCommitQty-D.FQty,A.FAuxCommitQty=A.FAuxCommitQty-(D.FQty/T.FCoefficient),
    A.FSecCommitQty=A.FSecCommitQty -D.FSecQty 
    FROM ICStockBillEntry A
    INNER JOIN ICWebReturnEntry B ON B.FID_SRC=A.FInterID AND B.FEntryID_SRC=A.FDetailID AND B.FClassID_SRC=1007572
    INNER JOIN SEOutStockEntry C ON C.FSourceInterId=B.FID AND C.FSourceEntryID=B.FEntryID 
    INNER JOIN ICStockBillEntry D ON D.FSourceInterId =C.FInterID AND D.FSourceEntryID =C.FEntryID AND D.FSourceTranType =82
    LEFT JOIN t_MeasureUnit T ON A.FUnitID=T.FMeasureUnitID 
    WHERE D.FInterID=@FInterID


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
