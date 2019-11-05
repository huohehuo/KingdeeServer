if (exists (select * from sys.objects where name = 'proc_ProductPicking'))
    drop proc proc_ProductPicking
go
create proc proc_ProductPicking
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
              @FOrderID varchar(50),--PDA���ݱ��
        @FPDAID varchar(50),  --PDA���к� 
        @FSelTranType varchar(20)  --Դ������
set @FBillerID = dbo.getString(@mainStr,'|',1) --����Ա  
set @Fdate =dbo.getString(@mainStr,'|',2)      --����  
set @FDeptID =dbo.getString(@mainStr,'|',4)   --������λid 
set @FPOStyle =dbo.getString(@mainStr,'|',5) --�ɹ���ʽ    
set @FEmpID =dbo.getString(@mainStr,'|',7)    --ҵ��Աid
set @FManagerID =dbo.getString(@mainStr,'|',8) --����id
set @FFManagerID=dbo.getString(@mainStr,'|',9) --����
set @FSManagerID=dbo.getString(@mainStr,'|',10) --���� 
set @FExplanation =dbo.getString(@mainStr,'|',11) --������;  
set @Fdate = convert(varchar(20),GETDATE(),23)  
exec GetICMaxNum 'ICStockBill',@FInterID output --,1,@FBillerID --�õ�@FInterID
------------------------------------------------------------�õ����
if(@FROB='����')
set @FROB=-1
else
set @FROB=1
 set @FBillNo ='' 
declare @Fprefix varchar(50),--���ǰ׺
        @Fnumber varchar(20),--��ˮ��
        @FLength int,        --��ˮ�ŵĳ���
        @FDateStr varchar(20),--�����ַ�
        @FProjectID varchar(20),--��ʽ��ʶ�� 
        @FClassIndex int,  --����(����ѭ���ҳ�����)
        @Index int  --(ѭ����)
        set @FBillNo ='' 
 --��ˮ��
select @Fnumber=a.FProjectVal from t_billcoderule a
 left join t_option e on a.fprojectid=e.fprojectid and a.fformatindex=e.fid
 Left OUter join t_checkproject b on a.fbilltype=b.fbilltypeid and a.fprojectval=b.ffield
 where a.fbilltypeid = '24' and  a.FProjectID=3 order by a.FClassIndex
 --��ˮ�ų���
 select @FLength=a.FLength from t_billcoderule a
 left join t_option e on a.fprojectid=e.fprojectid and a.fformatindex=e.fid
 Left OUter join t_checkproject b on a.fbilltype=b.fbilltypeid and a.fprojectval=b.ffield
 where a.fbilltypeid = '24' and  a.FProjectID=3  order by a.FClassIndex
 set @Fnumber='0000000000000'+@Fnumber
 set @Fnumber=right(@Fnumber,@FLength) --��ˮ��
---������ˮ��
  update a set FProjectVal=FProjectVal+1 from t_billcoderule a
 left join t_option e on a.fprojectid=e.fprojectid and a.fformatindex=e.fid
 Left OUter join t_checkproject b on a.fbilltype=b.fbilltypeid and a.fprojectval=b.ffield
 where a.fbilltypeid = '24' and a.FProjectID=3  ---���µ���

select @FClassIndex= COUNT(1) from t_billcoderule a
 left join t_option b on a.fprojectid=b.fprojectid and a.fformatindex=b.fid
 left join t_checkproject c on a.fbilltype = c.fbilltypeid and a.fprojectval = c.ffield
 where a.fbilltypeid = 24
 set @Index=1
 while(@Index<=@FClassIndex)
 begin
 select @FProjectID= a.FProjectID from t_billcoderule a
 left join t_option b on a.fprojectid=b.fprojectid and a.fformatindex=b.fid
 left join t_checkproject c on a.fbilltype = c.fbilltypeid and a.fprojectval = c.ffield
 where a.fbilltypeid = 24 and a.FClassIndex=@Index
 if(@FProjectID='1')
 begin
 --���ǰ׺    
select @Fprefix=a.FProjectVal from t_billcoderule a
 left join t_option e on a.fprojectid=e.fprojectid and a.fformatindex=e.fid
 Left OUter join t_checkproject b on a.fbilltype=b.fbilltypeid and a.fprojectval=b.ffield
 where a.fbilltypeid = '24' and  a.FProjectID=1 and a.FClassIndex=@Index order by a.FClassIndex
  set @FBillNo=isnull(@FBillNo,'')+isnull(@Fprefix,'')
 end
 if(@FProjectID='2')
 begin
  --�����ַ�
 select @FDateStr=a.FProjectVal from t_billcoderule a
 left join t_option e on a.fprojectid=e.fprojectid and a.fformatindex=e.fid
 Left OUter join t_checkproject b on a.fbilltype=b.fbilltypeid and a.fprojectval=b.ffield
 where a.fbilltypeid = '24' and  a.FProjectID=2 and a.FClassIndex=@Index order by a.FClassIndex
 if(@FDateStr='mm/dd/yy')
 begin
 Select @FDateStr=CONVERT(varchar(50), GETDATE(), 1)
 end
 else if(@FDateStr='yy/mm/dd')
 begin
 Select @FDateStr=CONVERT(varchar(50), GETDATE(), 11)
 end
 else if(@FDateStr='yyyy/mm/dd')
 begin
 Select @FDateStr=CONVERT(varchar(50), GETDATE(), 111)
 end
  else if(@FDateStr='yy-mm-dd')
 begin
 Select @FDateStr=substring(convert(char(10),getdate(),25) ,3,8)
 end
 else if(@FDateStr='mm-dd-yy')
 begin
 Select @FDateStr=CONVERT(varchar(100), GETDATE(), 10)
 end
 else if(@FDateStr='yyyy-mm-dd')
 begin
 Select @FDateStr=CONVERT(varchar(100), GETDATE(), 23)
 end
 else if(@FDateStr='yymm')
 begin
 Select @FDateStr=substring(CONVERT(varchar(100), GETDATE(), 12),0,5)
 end
  else if(@FDateStr='mmyy')
 begin
 Select @FDateStr=REPLACE(SUBSTRING( CONVERT(varchar(100), GETDATE(), 6),4,7),' ','')
 end
 else if(@FDateStr='yy-mm')
 begin
 Select @FDateStr=replace(substring(CONVERT(varchar(100), GETDATE(), 11),0,6),'/','-')
 end
 else if(@FDateStr='mm-yy')
 begin
 Select @FDateStr=  substring(CONVERT(varchar(6) , getdate(), 112 ) ,5,2)+  '-'+ substring(CONVERT(varchar(6) , getdate(), 112 ) ,3,2)
 end
 else if(@FDateStr='yyyymmdd')
 begin
 Select @FDateStr=    Convert(varchar(10),Getdate(),112) 
 end 
 set @FBillNo=isnull(@FBillNo,'')+isnull(@FDateStr,'')
 end
 if(@FProjectID='3')
 begin
 set @FBillNo=isnull(@FBillNo,'')+isnull(@Fnumber,'')
 end
 set @Index=@Index+1
 end
-----------------------------------------------------------�õ����
set @FCurrencyID=1 --�ұ�
set @FCheckDate=null --���ʱ��  
set @FExplanation='' --��ע
  declare @IsExist varchar(10), --�Ƿ����
            @value varchar(10)--����������
    select @value= Fvalue  from t_systemprofile where Fkey in ('UPSTOCKWHENSAVE') AND FCateGory='IC' 
INSERT INTO ICStockBill(FInterID,FBillNo,FBrNo,FTranType,FCancellation,FStatus,FUpStockWhenSave,FROB,FHookStatus,Fdate,
FDeptID,Fuse,FCheckDate,FSManagerID,FFManagerID,FBillerID,FAcctID,FMultiCheckDate1,FMultiCheckDate2,FMultiCheckDate3,
FMultiCheckDate4,FMultiCheckDate5,FVchInterID,FMultiCheckDate6,FPurposeID,FWBINTERID,FSelTranType,FBackFlushed) 
SELECT @FInterID,@FBillNo,'0',24,0,0,@value,1,0,@Fdate,@FDeptID,@FExplanation,@FCheckDate,@FSManagerID,@FSManagerID,@FBillerID,0,Null,Null,
Null,Null,Null,0,Null,12000,0,85,0
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
        @Fauxprice float,          -- ����
        @Famount float,          --���
        @FTaxAmount float,     -- 
            @FKFDate varchar(50),    --�������� 
        @FKFPeriod int,       --������
        @FPeriodDate varchar(50),--��Ч��
        @FPlanPrice float,     --������λ�ƻ�����
        @FAuxPlanPrice float, --��λ�ƻ�����
        @FPlanAmount float,   --�ƻ��۽��     
        @FDiscountRate float,  --�ۿ���
        @FDiscountAmount float,--�ۿ۶�(��˰����*����*�ۿ���)   
        @FDCStockID varchar(20), --�ֿ�id
        @FDCSPID varchar(20), --��λid
        @FBatchNo varchar(50),--����
        @FCoefficient varchar(20),   --������
        @FCostOBJID varchar(20),     --�ɱ�����
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
	set @Fauxprice=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+3)  --����
	set @Fauxqty=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+4)    --����  
	set @FDCStockID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+5) --�ֿ�id
	set @FDCSPID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+6) --��λid
	set @FSourceEntryID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+7) --���Ƶ���ϸid
	set @FSourceInterId=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+8) --���Ƶ���FInterID
	set @FBatchNo=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+9)
	 	 set @FKFDate= '' --dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+10)  
	set @FKFPeriod= 0--dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+11)
		if(@FKFDate is null or @FKFDate='')
	set @FPeriodDate=null
	else
	begin
	select @FPeriodDate = DATEADD(day,@FKFPeriod,@FKFDate) 
	end 
	if(@FDCSPID is null or @FDCSPID='')
	set @FDCSPID=0
 set @FCostOBJID=0
	--select @FAuxQtyMust = FAuxQtyMust+FAuxQtySupply-FAuxQty from PPBOMEntry where FICMOInterID=@FSourceInterId and FEntryID=@FSourceEntryID
	select @FAuxQtyMust = FAuxPlanQty-FDiscountQty from ICMOEntry where FInterID=@FSourceInterId and FEntryID=@FSourceEntryID
	select @FSourceBillNo=FBillNo from ICMO where FInterID=@FSourceInterId

	select @FCoefficient=FCoefficient from t_MeasureUnit where FMeasureUnitID=@FUnitID --��λ������ 
	set @FQtyMust=@FAuxQtyMust*@FCoefficient --������λ�����յ����� 
	select @FPlanPrice=isnull(FPlanPrice,0) from t_ICItem where   FItemID=@FItemID 
	set @FQty=@Fauxqty*@FCoefficient                  --������λ���� 
	set @FAuxPlanPrice=@FPlanPrice*@FCoefficient   --��λ�ƻ�����
	set @FPlanAmount=@FAuxPlanPrice*@Fauxqty          --�ƻ����۽�� 
	set @Famount=@Fauxqty*@Fauxprice
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
		  select @IsExist=COUNT(1) from ICInventory where FStockID=@FDCStockID and FStockPlaceID=@FDCSPID and FBatchNo=@FBatchNo and FItemID=@FItemID and FKFPeriod=@FKFPeriod and FKFDate=@FKFDate
		  if(@IsExist=0)
			begin
			INSERT INTO ICInventory(FBrNo,FItemID,FBatchNo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FQty,FSecQty)
			SELECT '0',@FItemID,@FBatchNo,0,@FDCStockID,@FDCSPID,@FKFPeriod,@FKFDate,-@FQty,-@FSecQty
			end
		  else
			begin
			update ICInventory set FQty=FQty-@FQty,FSecQty=FSecQty-@FSecQty where FStockID=@FDCStockID and FStockPlaceID=@FDCSPID and FBatchNo=@FBatchNo and FItemID=@FItemID and FKFPeriod=@FKFPeriod and FKFDate=@FKFDate
		  end    
		end
			if(@FKFDate is null or @FKFDate='')
		 begin
            set @FKFDate = null
         end
INSERT INTO ICStockBillEntry (FInterID,FEntryID,FBrNo,FSCStockID,FItemID,FAuxPropID,FBatchNo,FQtyMust,FQty,FReProduceType,
FCostOBJID,FCostObjGroupID,FUnitID,FAuxQtyMust,Fauxqty,FSecCoefficient,FSecQty,FAuxPlanPrice,FPlanAmount,Fauxprice,Famount,
FBomInterID,Fnote,FKFDate,FKFPeriod,FPeriodDate,FDCSPID,FOperSN,FOperID,FSNListID,FSourceBillNo,
FSourceTranType,FSourceInterId,FSourceEntryID,FICMOBillNo,FICMOInterID,FPPBomEntryID,FMOBillNo,FMOInterID,FMOEntryID) 
 SELECT @FInterID,@FEntryID,'0',@FDCStockID,@FItemID,0,@FBatchNo,@FQtyMust,@FQty,1059,@FCostOBJID,0,@FUnitID,@FAuxQtyMust,@Fauxqty,
 @FSecCoefficient,@FSecQty,0,0,0,0,0,'',Null,0,Null,@FDCSPID,0,'0',0,@FSourceBillNo,85,@FSourceInterId,@FSourceEntryID,'',
 0,0,@FSourceBillNo, @FSourceInterId,@FSourceEntryID

end
set @detailqty=@detailqty+1
end
EXEC p_UpdateBillRelateData 24,@FInterID --,'ICStockBill','ICStockBillEntry' 
 declare @FHeadSelfB0422 varchar(128),  --������
         @FMOItemID int,
         @FMOUnitID int,
         @FMOAuxQty decimal(20,5),
         @FMOBaseUnitID int,
         @FBillSource int,
         @FMOQty decimal(20,5) 
 	select  @FMOItemID=FItemID,@FMOUnitID=FUnitID,@FMOAuxQty=FAuxQty  from ICMO where FInterID=@FSourceInterId
 	set @FMOBaseUnitID=@FMOUnitID
 	set @FMOQty=@FMOAuxQty
 update ICStockBill set  FMOItemID=@FMOItemID,FMOUnitID=@FMOUnitID,FMOAuxQty=@FMOAuxQty,FMOBaseUnitID=@FMOBaseUnitID,FMOQty=@FMOQty where FInterID=@FInterID
Update src Set src.FDiscountQty = src.FDiscountQty+dest.FQty
,src.FAuxDiscountQty = Cast((src.FDiscountQty+dest.FQty)as Decimal(23,10))/CAST(t1.FCoefficient as Decimal(23,10))
 From icmoentry src INNER JOIN 
 (Select u1.FMOInterID as FSourceInterID,u1.FMOEntryID,u1.FItemID,SUM(u1.FQty) as FQty,u1.FAuxPropID 
 From  ICStockBillEntry u1 
 Where u1.FInterID=@FInterID
 GROUP BY u1.FMOInterID,u1.FMOEntryID,u1.FItemID,u1.FAuxPropID) dest 
 ON dest.FSourceInterID = src.FInterID
 AND dest.FItemID = src.FItemID

 And src.FEntryID = dest.FMOEntryID

 And src.FAuxPropID  = dest.FAuxPropID 

 INNER JOIN t_MeasureUnit t1 ON src.FUnitID=t1.FItemID
 UPDATE t3 SET t3.FChildren=t3.FChildren+1
FROM ICStockBill t1 INNER JOIN ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
INNER JOIN ICMO t3 ON t3.FTranType=t2.FSourceTranType AND t3.FInterID=t2.FSourceInterID
WHERE t1.FTranType=24 AND t1.FInterID=@FInterID AND t2.FSourceInterID>0
IF EXISTS(SELECT FMOInterID FROM ICStockBillEntry WHERE FMOInterID>0 AND FInterID=@FInterID)
 UPDATE u1
 SET u1.FStockQty=u1.FStockQty+Cast(1*u2.FStockQty as Decimal(23,10))
     ,u1.FAuxStockQty=(u1.FStockQty+Cast(1*u2.FStockQty as Decimal(23,10)))/t3.FCoefficient
 FROM ICMoEntry u1 
 INNER JOIN 
 (SELECT FMOInterID,FMOEntryID,FItemID,SUM(FQty)AS FStockQty,SUM(FAuxQty) AS FAuxStockQty
  FROM ICStockBillEntry WHERE FInterID=@FInterID
  GROUP BY FMOInterID,FMOEntryID,FItemID) u2
 ON u1.FInterID=u2.FMOInterID AND u1.FEntryID=u2.FMOEntryID AND u1.FItemID=u2.FItemID
 INNER JOIN t_ICItem t1 ON u1.FItemID=t1.FItemID INNER JOIN t_MeasureUnit t3 ON u1.FUnitID=t3.FItemID
 
if not exists(  select   1  from ICStockBillEntry where FInterID=@FInterID)
begin
    delete from ICStockBill where FInterID=@FInterID
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
