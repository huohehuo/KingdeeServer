if (exists (select * from sys.objects where name = 'proc_Allot'))
    drop proc proc_Allot
go
create proc proc_Allot
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
        @Fdate varchar(50),       --����       
        @FCheckDate varchar(50),  --�������
        @FMangerID varchar(20),   --����id
        @FDeptID varchar(20),     --����id
        @FEmpID varchar(20),      --ҵ��Աid
        @FBillerID varchar(20),   --�Ƶ���id
        @FFManagerID varchar(20), --����
        @FSManagerID varchar(20)  --����  
set @FBillerID = dbo.getString(@mainStr,'|',1) --����Ա
set @Fdate =dbo.getString(@mainStr,'|',2)      --����  
set @FDeptID =dbo.getString(@mainStr,'|',3)   --����id
set @FEmpID =dbo.getString(@mainStr,'|',4)    --ҵ��Աid
set @FSManagerID =dbo.getString(@mainStr,'|',5) --����id   
set @FFManagerID =dbo.getString(@mainStr,'|',6) --����id
set @Fdate = convert(varchar(20),GETDATE(),23)
exec GetICMaxNum 'ICStockBill',@FInterID output --,1,@FBillerID --�õ�@FInterID
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
 where a.fbilltypeid = '41' and  a.FProjectID=3 order by a.FClassIndex
 --��ˮ�ų���
 select @FLength=a.FLength from t_billcoderule a
 left join t_option e on a.fprojectid=e.fprojectid and a.fformatindex=e.fid
 Left OUter join t_checkproject b on a.fbilltype=b.fbilltypeid and a.fprojectval=b.ffield
 where a.fbilltypeid = '41' and  a.FProjectID=3  order by a.FClassIndex
 set @Fnumber='0000000000000'+@Fnumber
 set @Fnumber=right(@Fnumber,@FLength) --��ˮ��
---������ˮ��
  update a set FProjectVal=FProjectVal+1 from t_billcoderule a
 left join t_option e on a.fprojectid=e.fprojectid and a.fformatindex=e.fid
 Left OUter join t_checkproject b on a.fbilltype=b.fbilltypeid and a.fprojectval=b.ffield
 where a.fbilltypeid = '41' and a.FProjectID=3  ---���µ���

select @FClassIndex= COUNT(1) from t_billcoderule a
 left join t_option b on a.fprojectid=b.fprojectid and a.fformatindex=b.fid
 left join t_checkproject c on a.fbilltype = c.fbilltypeid and a.fprojectval = c.ffield
 where a.fbilltypeid = '41'
 set @Index=1
 while(@Index<=@FClassIndex)
 begin
 select @FProjectID= a.FProjectID from t_billcoderule a
 left join t_option b on a.fprojectid=b.fprojectid and a.fformatindex=b.fid
 left join t_checkproject c on a.fbilltype = c.fbilltypeid and a.fprojectval = c.ffield
 where a.fbilltypeid = '41' and a.FClassIndex=@Index
 if(@FProjectID='1')
 begin
 --���ǰ׺    
select @Fprefix=a.FProjectVal from t_billcoderule a
 left join t_option e on a.fprojectid=e.fprojectid and a.fformatindex=e.fid
 Left OUter join t_checkproject b on a.fbilltype=b.fbilltypeid and a.fprojectval=b.ffield
 where a.fbilltypeid = '41' and  a.FProjectID=1 and a.FClassIndex=@Index order by a.FClassIndex
  set @FBillNo=isnull(@FBillNo,'')+isnull(@Fprefix,'')
 end
 if(@FProjectID='2')
 begin
  --�����ַ�
 select @FDateStr=a.FProjectVal from t_billcoderule a
 left join t_option e on a.fprojectid=e.fprojectid and a.fformatindex=e.fid
 Left OUter join t_checkproject b on a.fbilltype=b.fbilltypeid and a.fprojectval=b.ffield
 where a.fbilltypeid = '41' and  a.FProjectID=2 and a.FClassIndex=@Index order by a.FClassIndex
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
   declare @IsExist varchar(10), --�Ƿ����
            @value varchar(10)--����������
    select @value= Fvalue  from t_systemprofile where Fkey in ('UPSTOCKWHENSAVE') AND FCateGory='IC' 

set @FCheckDate=null --���ʱ�� 
INSERT INTO ICStockBill(FInterID,FBillNo,FBrNo,FTranType,FCancellation,FStatus,FUpStockWhenSave,FHookStatus,FVchInterID,
Fdate,FCurrencyID,FCheckDate,FDeptID,FFManagerID,FBillerID,FMultiCheckLevel1,FEmpID,FMultiCheckDate1,FSManagerID,
FMultiCheckLevel2,FRefType,FExplanation,FMultiCheckDate2,FMultiCheckLevel3,FMultiCheckDate3,FMultiCheckLevel4,
FMultiCheckDate4,FMultiCheckLevel5,FMultiCheckDate5,FMultiCheckLevel6,FMultiCheckDate6,FSelTranType,FBrID) 
VALUES (@FInterID,@FBillNo,'0',41,0,0,@value,0,0,@Fdate,1,@FCheckDate,@FDeptID,@FFManagerID,@FBillerID,Null,@FEmpID,Null,@FSManagerID,Null,12561,'',Null,Null,Null,Null,Null,Null,Null,Null,Null,0,0)
 UPDATE ICStockBill SET FUUID=NEWID() WHERE FInterID=@FInterID
declare @FEntryID varchar(20),       --��ϸ���
        @FItemID varchar(20),        --��Ʒid
        @FQty float,                --������λ����
        @FUnitID varchar(20),       --��λid
        @Fauxqty float,             --�ϴ���λ���� 
        @FSCStockID varchar(20),    --����ֿ�id
        @FSCSPID varchar(20),       --�����λid
        @FDCStockID varchar(20),    --���ֿ�id
        @FDCSPID  varchar(20),      --����λid
        @FBatchNo varchar(50),    --����
        @FCoefficient float(50),  --��λ����
        @FPlanPrice float(50),    --�����ƻ�����
        @FAuxPlanPrice float(50), --��λ�ƻ�����
        @FPlanAmount float(50),   --�ƻ����۽��
        @detailqty int,               --��ϸ�����ĸ���
        @detailcount int,             --��ϸÿ�����ݵĳ��� 
        @detailIndex int,            --��ϸÿ���±�
        @countindex int              --�ָ���|������
       set @detailqty=0        
       set @detailcount=8          
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
	set @Fauxqty=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+3)    --����
	set @FDCStockID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+4) --���id
	set @FSCStockID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+5) --����id
	set @FDCSPID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+6) --����λ
	set @FSCSPID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+7) --�����λ
	set @FBatchNo=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+8) --����
	 	select @FCoefficient=FCoefficient from t_MeasureUnit where FMeasureUnitID=@FUnitID --��λ������
	select @FPlanPrice=isnull(FPlanPrice,0) from t_ICItem where   FItemID=@FItemID 
	set @FQty=@Fauxqty*@FCoefficient  
	set @FAuxPlanPrice = @FPlanPrice*@FCoefficient
	set @FPlanAmount = @FAuxPlanPrice*@Fauxqty
 
	set @detailIndex=@detailIndex+1
    set @FEntryID=@detailqty*50+@detailIndex
    
        if(@value=1)
    begin
    --���
      select @IsExist=COUNT(1) from ICInventory where FStockID=@FDCStockID and FStockPlaceID=@FDCSPID and FBatchNo=@FBatchNo and FItemID=@FItemID
      if(@IsExist=0)
        begin
        INSERT INTO ICInventory(FBrNo,FItemID,FBatchNo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FQty,FSecQty)
        SELECT '',@FItemID,@FBatchNo,0,@FDCStockID,@FDCSPID,0,'',@FQty,0
        end
      else
        begin
        update ICInventory set FQty=FQty+@FQty where FStockID=@FDCStockID and FStockPlaceID=@FDCSPID and FBatchNo=@FBatchNo and FItemID=@FItemID 
      end   
      --����
       select @IsExist=COUNT(1) from ICInventory where FStockID=@FSCStockID and FStockPlaceID=@FSCSPID and FBatchNo=@FBatchNo and FItemID=@FItemID
      if(@IsExist=0)
        begin
        INSERT INTO ICInventory(FBrNo,FItemID,FBatchNo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FQty,FSecQty)
        SELECT '',@FItemID,@FBatchNo,0,@FSCStockID,@FSCSPID,0,'',-@FQty,0
        end
      else
        begin
        update ICInventory set FQty=FQty-@FQty where FStockID=@FSCStockID and FStockPlaceID=@FSCSPID and FBatchNo=@FBatchNo and FItemID=@FItemID 
      end     
    end 
INSERT INTO ICStockBillEntry (FInterID,FEntryID,FBrNo,FItemID,FSCStockID,FDCStockID,FAuxPropID,FBatchNo,FQty,FUnitID,
Fauxqty,Fauxprice,Famount,FSecCoefficient,FAuxPriceRef,FAmtRef,FSecQty,Fnote,FAuxPlanPrice,FPlanAmount,FKFDate,FKFPeriod,
FPeriodDate,FSourceBillNo,FSourceTranType,FSourceInterId,FSourceEntryID,FOrderBillNo,FOrderInterID,FOrderEntryID,FSCSPID,
FDCSPID,FSNListID,FICMOBillNo,FICMOInterID,FPPBomEntryID) 
VALUES (@FInterID,@FEntryID,'0',@FItemID,@FSCStockID,@FDCStockID,0,@FBatchNo,@FQty,@FUnitID,@Fauxqty,0,0,0,0,0,0,'',0,0,
Null,0,Null,'',0,0,0,'',0,0,@FSCSPID,@FDCSPID,0,'',0,0) 
end
set @detailqty=@detailqty+1
end
EXEC p_UpdateBillRelateData 41,@FInterID --,'ICStockBill','ICStockBillEntry' 
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
