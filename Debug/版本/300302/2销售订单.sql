if (exists (select * from sys.objects where name = 'proc_SaleOrder'))
    drop proc proc_SaleOrder
go
create proc proc_SaleOrder
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
        @FAreaPS varchar(20),      --���۷�Χ
        @FTranType varchar(20),    --�������� 
        @Fdate varchar(50),       --���� 
        @FCustID varchar(20),     --������λid
        @FCurrencyID nvarchar(20),--�ұ�id
        @FSettleID nvarchar(20),  --���㷽ʽid
        @FSaleStyle varchar(20),  --���۷�ʽid
        @FFetchStyle varchar(20), --������ʽid
        @FFetchAdd varchar(100),  --�����ص���
        @FCheckDate varchar(50),  --�������
        @FMangerID varchar(20),   --����id
        @FDeptID varchar(20),     --����id
        @FEmpID varchar(20),      --ҵ��Աid
        @FBillerID varchar(20),   --�Ƶ���id
        @FExchangeRate varchar(50),--����
        @FSettleDate varchar(50), --��������
        @FExplanation varchar(200),--ժҪ 
        @FSelTranType varchar(20)   --Դ������ID
set @FBillerID = dbo.getString(@mainStr,'|',1) --����Ա
set @Fdate =dbo.getString(@mainStr,'|',2)      --����
set @FSettleDate=dbo.getString(@mainStr,'|',3) --��������
set @FSaleStyle =dbo.getString(@mainStr,'|',4) --���۷�ʽID
set @FFetchAdd =dbo.getString(@mainStr,'|',5)  --�����ص�
set @FDeptID =dbo.getString(@mainStr,'|',6)   --����id
set @FEmpID =dbo.getString(@mainStr,'|',7)    --ҵ��Աid
set @FMangerID =dbo.getString(@mainStr,'|',8) --����id
set @FCustID =dbo.getString(@mainStr,'|',9)   --������λID
set @FExplanation =dbo.getString(@mainStr,'|',10)--ժҪ
set @FAreaPS =dbo.getString(@mainStr,'|',11)    --���۷�ΧID 
set @FSettleID =dbo.getString(@mainStr,'|',12)  --���㷽ʽID
set @FFetchStyle =dbo.getString(@mainStr,'|',13)--������ʽID
set @FSelTranType=dbo.getString(@mainStr,'|',14)--Դ������ID
set @Fdate = convert(varchar(20),GETDATE(),23)
exec GetICMaxNum 'SEOrder',@FInterID output  --,1,@FBillerID --�õ�@FInterID
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
 where a.fbilltypeid = '81' and  a.FProjectID=3 order by a.FClassIndex
 --��ˮ�ų���
 select @FLength=a.FLength from t_billcoderule a
 left join t_option e on a.fprojectid=e.fprojectid and a.fformatindex=e.fid
 Left OUter join t_checkproject b on a.fbilltype=b.fbilltypeid and a.fprojectval=b.ffield
 where a.fbilltypeid = '81' and  a.FProjectID=3  order by a.FClassIndex
 set @Fnumber='0000000000000'+@Fnumber
 set @Fnumber=right(@Fnumber,@FLength) --��ˮ��
---������ˮ��
  update a set FProjectVal=FProjectVal+1 from t_billcoderule a
 left join t_option e on a.fprojectid=e.fprojectid and a.fformatindex=e.fid
 Left OUter join t_checkproject b on a.fbilltype=b.fbilltypeid and a.fprojectval=b.ffield
 where a.fbilltypeid = '81' and a.FProjectID=3  ---���µ���

select @FClassIndex= COUNT(1) from t_billcoderule a
 left join t_option b on a.fprojectid=b.fprojectid and a.fformatindex=b.fid
 left join t_checkproject c on a.fbilltype = c.fbilltypeid and a.fprojectval = c.ffield
 where a.fbilltypeid = 81
 set @Index=1
 while(@Index<=@FClassIndex)
 begin
 select @FProjectID= a.FProjectID from t_billcoderule a
 left join t_option b on a.fprojectid=b.fprojectid and a.fformatindex=b.fid
 left join t_checkproject c on a.fbilltype = c.fbilltypeid and a.fprojectval = c.ffield
 where a.fbilltypeid = 81 and a.FClassIndex=@Index
 if(@FProjectID='1')
 begin
 --���ǰ׺    
select @Fprefix=a.FProjectVal from t_billcoderule a
 left join t_option e on a.fprojectid=e.fprojectid and a.fformatindex=e.fid
 Left OUter join t_checkproject b on a.fbilltype=b.fbilltypeid and a.fprojectval=b.ffield
 where a.fbilltypeid = '81' and  a.FProjectID=1 and a.FClassIndex=@Index order by a.FClassIndex
  set @FBillNo=isnull(@FBillNo,'')+isnull(@Fprefix,'')
 end
 if(@FProjectID='2')
 begin
  --�����ַ�
 select @FDateStr=a.FProjectVal from t_billcoderule a
 left join t_option e on a.fprojectid=e.fprojectid and a.fformatindex=e.fid
 Left OUter join t_checkproject b on a.fbilltype=b.fbilltypeid and a.fprojectval=b.ffield
 where a.fbilltypeid = '81' and  a.FProjectID=2 and a.FClassIndex=@Index order by a.FClassIndex
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
set @FExchangeRate=1 --������
INSERT INTO SEOrder(FInterID,FBillNo,FBrNo,FTranType,FCancellation,FStatus,FDiscountType,Fdate,FCustID,FSaleStyle,FFetchStyle,FCurrencyID,FFetchAdd,FCheckDate,FAlterDate,FMangerID,FDeptID,FEmpID,FBillerID,FSettleID,FExchangeRate,FSelTranType,FSettleDate,FMultiCheckLevel1,FExplanation,FMultiCheckDate1,FMultiCheckLevel2,FMultiCheckDate2,FMultiCheckLevel3,FMultiCheckDate3,FMultiCheckLevel4,FMultiCheckDate4,FMultiCheckLevel5,FMultiCheckDate5,FMultiCheckLevel6,FMultiCheckDate6,FPOOrdBillNo,FRelateBrID,FTransitAheadTime,FImport,FBrID,FAreaPS) VALUES (@FInterID,@FBillNo,'0',81,0,0,0,@Fdate,@FCustID,@FSaleStyle,@FFetchStyle,@FCurrencyID,@FFetchAdd,@FCheckDate,Null,@FMangerID,@FDeptID,@FEmpID,@FBillerID,@FSettleID,@FExchangeRate,0,@FSettleDate,Null,'',Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,'',0,'0',0,0,20302)
update ICStockBill set FUUID=newid() where FInterID=@FInterID

declare @FEntryID varchar(20),       --��ϸ���
        @FItemID varchar(20),        --��Ʒid
        @FQty float,                --��������
        @FUnitID varchar(20),       --��λid
        @Fauxqty float,            --������λ����
        @FStockQtyOnlyForShow float,--�������
        @Fauxprice float,      --����
        @FAuxTaxPrice float,   --��˰����
        @Famount float,        --���(����*����-����*����*�ۿ���)
        @FCess float,          --˰��
        @FTaxRate float,       --�ۿ���
        @FTaxAmount float,     --�ۿ۶�(��˰����*����*�ۿ���)             
        @FAuxPriceDiscount float,--ʵ�ʺ�˰����(��˰����-�ۿ���*��˰����)
        @FTaxAmt float,        --����˰��(ʵ�ʺ�˰����*����-���)
        @FAllAmount float,     --��˰�ϼ�(����*ʵ�ʺ�˰����)
        
        @FDat varchar(50),           --��������@FDate���ڴ������Զ���Ϊ@FDat 
        @FAdviceConsignDate varchar(50), --���齻������
        @FCoefficient varchar(20),   --������
        
        @detailqty int,               --��ϸ�����ĸ���
        @detailcount int,             --��ϸÿ�����ݵĳ��� 
        @detailIndex int,            --��ϸÿ���±�
        @countindex int              --�ָ���|������
       set @detailqty=0        
       set @detailcount=6           
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
	set @FTaxRate=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+5)   --�ۿ���
    set @FDat=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+6)       --�������� 	
    
	select @FCess = FTaxRate from t_ICItem where FItemID=@FItemID --˰��
	select @FCoefficient=FCoefficient from t_MeasureUnit where FMeasureUnitID=@FUnitID --��λ������
	set @FQty=@Fauxqty*@FCoefficient  --������λ����

	
	select @FAuxTaxPrice=isnull(FSalePrice,0) from t_ICItem where FItemID=@FItemID --��˰����
    if(@FAuxTaxPrice=0)
    begin
    set @FAuxTaxPrice= @Fauxprice *(1+ @FCess/100)   --��˰����
    end
    set @Famount=@Fauxqty*(@FAuxTaxPrice/(1+@FCess/100))-@Fauxqty*(@FAuxTaxPrice/(1+@FCess/100))*(@FTaxRate/100) --���
	set @FTaxAmount= @FAuxTaxPrice*@Fauxqty*(@FTaxRate/100)--�ۿ۶�
	set @FAuxPriceDiscount= @FAuxTaxPrice-@FAuxTaxPrice*(@FTaxRate/100)--ʵ�ʺ�˰����
	set @FTaxAmt=@FAuxPriceDiscount*@FQty-@Famount  --����˰��
	set @FAllAmount=@FQty*@FAuxPriceDiscount  --��˰�ϼ�
	set @detailIndex=@detailIndex+1
    set @FEntryID=@detailqty*50+@detailIndex
    select @FStockQtyOnlyForShow=SUM(FQty) from ICInventory where FItemID=@FItemID --�������
	   if(@FStockQtyOnlyForShow is null or @FStockQtyOnlyForShow='')
    begin
    set @FStockQtyOnlyForShow=0
    end
	  set @FAdviceConsignDate=@FDat
INSERT INTO SEOrderEntry (FInterID,FEntryID,FBrNo,FItemID,FMapNumber,FMapName,FAuxPropID,FQty,FUnitID,Fauxqty,Fauxprice,
FAuxTaxPrice,Famount,FCess,FSecCoefficient,FTaxRate,FUniDiscount,FSecQty,FTaxAmount,FAuxPriceDiscount,FTaxAmt,FAllAmount,
FTranLeadTime,FInForecast,FDate,Fnote,FAuxQtyInvoice,FQtyInvoice,FCommitInstall,FAuxCommitInstall,
FAllStdAmount,FMrpLockFlag,FBomInterID,FCostObjectID,FAdviceConsignDate,FATPDeduct,FLockFlag,FSourceBillNo,FSourceTranType,
FSourceInterId,FSourceEntryID,FContractBillNo,FOrderCommitQty,FContractInterID,FContractEntryID)
 VALUES (@FInterID,@FEntryID,'0',@FItemID,'','',0,@FQty,@FUnitID,@Fauxqty,@Fauxprice,@FAuxTaxPrice,@Famount,@FCess,
 0,0,0,0,@FTaxAmount,@FAuxPriceDiscount,@FTaxAmt,@FAllAmount,'',0,@FDat,'',0,0,0,0,@FAllAmount,0,0,'0',
 @FAdviceConsignDate,0,0,'',0,0,0,'',0,0,0) 
end
set @detailqty=@detailqty+1
end
EXEC p_UpdateBillRelateData 81,@FInterID  --,'SEOrder','SEOrderEntry' 
if not exists(  select   1  from SEOrderEntry where FInterID=@FInterID)
begin
    delete  SEOrder where FInterID=@FInterID
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
 