if (exists (select * from sys.objects where name = 'proc_InCheck'))
    drop proc proc_InCheck
go
create proc proc_InCheck
(
 @mainStr nvarchar(1000),--�������
 @detailStr1 varchar(max),--��ϸ����
 @detailStr2 varchar(max),
 @detailStr3 varchar(max),
 @detailStr4 varchar(max),
 @detailStr5 varchar(max)
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
set @FPOStyle =dbo.getString(@mainStr,'|',5) --�ɹ���ʽ   
set @FDeptID =dbo.getString(@mainStr,'|',6)   --����id
set @FEmpID =dbo.getString(@mainStr,'|',7)    --ҵ��Աid
set @FManagerID =dbo.getString(@mainStr,'|',8) --����id
set @FFManagerID=dbo.getString(@mainStr,'|',9) --����
set @FSManagerID=dbo.getString(@mainStr,'|',10) --����   
set @Fdate = convert(varchar(20),GETDATE(),23)
exec GetICMaxNum 'ICStockBill',@FInterID output  --,1,@FBillerID --�õ�@FInterID
------------------------------------------------------------�õ����
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
 where a.fbilltypeid = '1' and  a.FProjectID=3 order by a.FClassIndex
 --��ˮ�ų���
 select @FLength=a.FLength from t_billcoderule a
 left join t_option e on a.fprojectid=e.fprojectid and a.fformatindex=e.fid
 Left OUter join t_checkproject b on a.fbilltype=b.fbilltypeid and a.fprojectval=b.ffield
 where a.fbilltypeid = '1' and  a.FProjectID=3  order by a.FClassIndex
 set @Fnumber='0000000000000'+@Fnumber
 set @Fnumber=right(@Fnumber,@FLength) --��ˮ��
---������ˮ��
  update a set FProjectVal=FProjectVal+1 from t_billcoderule a
 left join t_option e on a.fprojectid=e.fprojectid and a.fformatindex=e.fid
 Left OUter join t_checkproject b on a.fbilltype=b.fbilltypeid and a.fprojectval=b.ffield
 where a.fbilltypeid = '1' and a.FProjectID=3  ---���µ���

select @FClassIndex= COUNT(1) from t_billcoderule a
 left join t_option b on a.fprojectid=b.fprojectid and a.fformatindex=b.fid
 left join t_checkproject c on a.fbilltype = c.fbilltypeid and a.fprojectval = c.ffield
 where a.fbilltypeid = 1
 set @Index=1
 while(@Index<=@FClassIndex)
 begin
 select @FProjectID= a.FProjectID from t_billcoderule a
 left join t_option b on a.fprojectid=b.fprojectid and a.fformatindex=b.fid
 left join t_checkproject c on a.fbilltype = c.fbilltypeid and a.fprojectval = c.ffield
 where a.fbilltypeid = 1 and a.FClassIndex=@Index
 if(@FProjectID='1')
 begin
 --���ǰ׺    
select @Fprefix=a.FProjectVal from t_billcoderule a
 left join t_option e on a.fprojectid=e.fprojectid and a.fformatindex=e.fid
 Left OUter join t_checkproject b on a.fbilltype=b.fbilltypeid and a.fprojectval=b.ffield
 where a.fbilltypeid = '1' and  a.FProjectID=1 and a.FClassIndex=@Index order by a.FClassIndex
  set @FBillNo=isnull(@FBillNo,'')+isnull(@Fprefix,'')
 end
 if(@FProjectID='2')
 begin
  --�����ַ�
 select @FDateStr=a.FProjectVal from t_billcoderule a
 left join t_option e on a.fprojectid=e.fprojectid and a.fformatindex=e.fid
 Left OUter join t_checkproject b on a.fbilltype=b.fbilltypeid and a.fprojectval=b.ffield
 where a.fbilltypeid = '1' and  a.FProjectID=2 and a.FClassIndex=@Index order by a.FClassIndex
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
INSERT INTO ICStockBill(FInterID,FBillNo,FBrNo,FTranType,FCancellation,FStatus,FUpStockWhenSave,FVchInterID,FROB,FHookStatus,
Fdate,FSupplyID,FCheckDate,FSManagerID,FBillerID,FPOStyle,FOrgBillInterID,FSelTranType,FExplanation,FManagerID,FDeptID,
FFManagerID,FMultiCheckLevel1,FEmpID,FMultiCheckDate1,FMultiCheckLevel2,FMultiCheckDate2,FMultiCheckLevel3,FMultiCheckDate3,
FMultiCheckLevel4,FMultiCheckDate4,FMultiCheckLevel5,FMultiCheckDate5,FMultiCheckLevel6,FMultiCheckDate6,FRelateBrID,FBrID,
FCussentAcctID) 
VALUES (@FInterID,@FBillNo,'0',1,0,0,@value,0,1,0,@Fdate,@FSupplyID,@FCheckDate,@FSManagerID,@FBillerID,@FPOStyle,0,71,@FExplanation,@FManagerID,@FDeptID,@FFManagerID,Null,@FEmpID,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,0,0,0)
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
        
        @FPlanPrice float,     --������λ�ƻ�����
        @FAuxPlanPrice float, --��λ�ƻ�����
        @FPlanAmount float,   --�ƻ��۽��     
        @FDiscountRate float,  --�ۿ���
        @FDiscountAmount float,--�ۿ۶�(��˰����*����*�ۿ���)   
        @FDCStockID varchar(20), --�ֿ�id
        @FDCSPID varchar(20), --��λid
        @FBatchNo varchar(50),--����
        @FCoefficient varchar(20),   --������
        
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
	select @FExchangeRate=isnull(FExchangeRate,1),@FSourceBillNo=FBillNo from POOrder where FInterID=@FSourceInterId --���Ƶĵ��ݱ��
		set @Fauxprice = @Fauxprice*@FExchangeRate
		
	select @FAuxQtyMust = FAuxQty-FAuxCommitQty from POOrderEntry where FInterID=@FSourceInterId and FEntryID=@FSourceEntryID
	select @FCoefficient=FCoefficient from t_MeasureUnit where FMeasureUnitID=@FUnitID --��λ������
	set @FQtyMust=@FAuxQtyMust*@FCoefficient --������λ�����յ����� 
	select @FPlanPrice=isnull(FPlanPrice,0)*@FExchangeRate from t_ICItem where   FItemID=@FItemID 
	set @FQty=@Fauxqty*@FCoefficient                  --������λ���� 
	set @FAuxPlanPrice=@FPlanPrice*@FCoefficient   --��λ�ƻ�����
	set @FPlanAmount=@FAuxPlanPrice*@Fauxqty          --�ƻ����۽�� 
	set @Famount=@Fauxqty*@Fauxprice
	set @detailIndex=@detailIndex+1
    set @FEntryID=@detailqty*50+@detailIndex 
     if(@value=1)
		begin
		  select @IsExist=COUNT(1) from ICInventory where FStockID=@FDCStockID and FStockPlaceID=@FDCSPID and FBatchNo=@FBatchNo and FItemID=@FItemID
		  if(@IsExist=0)
			begin
			INSERT INTO ICInventory(FBrNo,FItemID,FBatchNo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FQty,FSecQty)
			SELECT '0',@FItemID,@FBatchNo,0,@FDCStockID,@FDCSPID,0,'',@FQty,0
			end
		  else
			begin
			update ICInventory set FQty=FQty+@FQty where FStockID=@FDCStockID and FStockPlaceID=@FDCSPID and FBatchNo=@FBatchNo and FItemID=@FItemID 
		  end    
		end
 INSERT INTO ICStockBillEntry (FInterID,FEntryID,FBrNo,FItemID,FMapNumber,FMapName,FDCStockID,FAuxPropID,FBatchNo,FQtyMust,FQty,FUnitID,FAuxQtyMust,Fauxqty,Fauxprice,Famount,Fnote,FKFDate,FSecCoefficient,FSecQty,FKFPeriod,FAuxPlanPrice,FPeriodDate,FOrgBillEntryID,FPlanAmount,FSourceBillNo,FSourceTranType,FSourceInterId,FSourceEntryID,FOrderBillNo,FOrderInterID,FOrderEntryID,FAuxQtyInvoice,FQtyInvoice,FDVStockID,FDCSPID,FSNListID,FContractBillNo,FContractInterID,FContractEntryID,FAllHookQTY,FAllHookAmount,FCurrentHookQTY,FCurrentHookAmount) VALUES (@FInterID,@FEntryID,'0',@FItemID,'','',@FDCStockID,0,@FBatchNo,@FQtyMust,@FQty,@FUnitID,@FAuxQtyMust,@Fauxqty,@Fauxprice,@Famount,'',Null,0,0,0,@FAuxPlanPrice,Null,0,@FPlanAmount,@FSourceBillNo,71,@FSourceInterId,@FSourceEntryID,@FSourceBillNo,@FSourceInterId,@FSourceEntryID,0,0,0,0,0,'',0,0,0,0,0,0)

end
set @detailqty=@detailqty+1
end
EXEC p_UpdateBillRelateData 1,@FInterID  --,'ICStockBill','ICStockBillEntry' 

set nocount on
declare @fcheck_fail int
declare @fsrccommitfield_prevalue decimal(28,13)
declare @fsrccommitfield_endvalue decimal(28,13)
declare @maxorder int 
update src set @fsrccommitfield_prevalue= isnull(src.fcommitqty,0),
     @fsrccommitfield_endvalue=@fsrccommitfield_prevalue+dest.fqty,
@maxorder=(select fvalue from t_systemprofile where fcategory='ic' and fkey='cqtylargerpoqty'),
     @fcheck_fail=case isnull(@maxorder,0) when 1 then 0 else (case when ((src.fqty > @fsrccommitfield_prevalue and isnull(srcHead.fstatus, 0)>0) or (src.fqty <= @fsrccommitfield_prevalue and isnull(srcHead.fstatus, 0) in (1,2)) or (src.fqty > @fsrccommitfield_endvalue and isnull(srcHead.fstatus, 0)>0)) then @fcheck_fail else -1 end) end,
     src.fcommitqty=@fsrccommitfield_endvalue,
     src.fauxcommitqty=@fsrccommitfield_endvalue/cast(t1.fcoefficient as float)
 from poorderentry src 
     inner join poorder srchead on src.finterid=srchead.finterid
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
if exists (select 1 from poorder src right join  (select u1.fsourceinterid as fsourceinterid,u1.fsourceentryid,u1.fitemid,sum(u1.fqty) as fqty
 from  icstockbillentry u1 
 where u1.finterid=@FInterID
 group by u1.fsourceinterid,u1.fsourceentryid,u1.fitemid) dest on dest.fsourceinterid = src.finterid where dest.fsourceinterid>0 and src.finterid is null)
begin
raiserror('��ѡ�����ѱ�ɾ��',18,18)
goto error1
end
Update t1 SET t1.FStatus=
Case when (select count(*) from POOrderEntry M inner join t_Icitem T on M.FItemID=T.FItemID  where M.FInterID=t1.FInterID and Round(FCommitQty,T.FQtyDecimal)<>0)=0 then 1 
when (select count(*) from POOrderEntry M inner join t_Icitem T on M.FItemID=T.FItemID  where M.FInterID=t1.FInterID and Round(abs(FQty),T.FQtyDecimal)>Round(abs(FCommitQty),T.FQtyDecimal))>0 then 2 
else 3 End 
From POOrder t1, ICStockBillEntry t2 
Where t1.FInterID = t2.FSourceInterID
AND t2.FInterID=@FSourceInterId


Update v1 SET v1.FStatus= (CASE WHEN u1.sumqty>0 THEN (CASE WHEN u1.qty <= u1.sumqty THEN 3 ELSE 1 END) ELSE v1.FStatus END),FChildren=(CASE WHEN u1.sumqty>0 THEN 1 ELSE 0 END)
From POInStock v1
inner join (select t2.FInterID,SUM(t2.fqty) AS qty, SUM(t2.fconcommitqty + t2.fcommitqty+t2.FSampleBreakQty) AS sumqty from POInStockEntry t2
    inner join ICStockBillEntry t3 on t2.FInterID = t3.fsourceinterid
    where t3.fsourcetrantype=702 AND t3.FInterID = @FInterID group by t2.FInterID) u1
on v1.FInterID = u1.FInterID

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
