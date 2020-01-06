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
exec GetICMaxNum 'SEOrder',@FInterID output,1,@FBillerID --�õ�@FInterID
------------------------------------------------------------�õ����
 set @FBillNo ='' 
 exec proc_GetICBillNo 81, @FBillNo out 
-----------------------------------------------------------�õ����
set @FCurrencyID=1 --�ұ�
set @FCheckDate=null --���ʱ��
set @FExchangeRate=1 --������

INSERT INTO SEOrder(FInterID,FBillNo,FBrNo,FTranType,FCancellation,FStatus,FDiscountType,Fdate,FCustID,FSaleStyle,FFetchStyle,FCurrencyID,FFetchAdd,FCheckDate,FMangerID,FDeptID,FEmpID,FBillerID,FSettleID,FExchangeRate,FMultiCheckDate1,FMultiCheckDate2,FMultiCheckDate3,FMultiCheckDate4,FMultiCheckDate5,FMultiCheckDate6,FPOOrdBillNo,FRelateBrID,FTransitAheadTime,FImport,FSelTranType,FBrID,FSettleDate,FExplanation,FAreaPS,FManageType,FSysStatus,FValidaterName,FConsignee,FVersionNo,FChangeDate,FChangeUser,FChangeCauses,FChangeMark,FPrintCount) 
VALUES (@FInterID,@FBillNo,'0',81,0,0,0,@Fdate,@FCustID,@FSaleStyle,@FFetchStyle,@FCurrencyID,@FFetchAdd,@FCheckDate,@FMangerID,@FDeptID,@FEmpID,@FBillerID,@FSettleID,@FExchangeRate,Null,Null,Null,Null,Null,Null,'',0,'0',0,@FSelTranType,0,@FSettleDate,@FExplanation,@FAreaPS,0,2,'',0,'000',Null,0,'','',0)
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
    
INSERT INTO SEOrderEntry (FInterID,FEntryID,FBrNo,FMapNumber,FMapName,FItemID,FAuxPropID,FQty,
FUnitID,Fauxqty,FStockQtyOnlyForShow,FSecCoefficient,FSecQty,FICPrcPly_FName,Fauxprice,FAuxTaxPrice,
Famount,FCess,FTaxRate,FUniDiscount,FTaxAmount,FAuxPriceDiscount,FTaxAmt,FAllAmount,FTranLeadTime,
FInForecast,FDate,Fnote,FPlanMode,FMTONo,FBomInterID,FCostObjectID,FAdviceConsignDate,FATPDeduct,
FLockFlag,FSourceBillNo,FSourceTranType,FSourceInterId,FSourceEntryID,FMrpTime,FContractBillNo,
FContractInterID,FContractEntryID,FAuxQtyInvoice,FQtyInvoice,FSecInvoiceQty,FSecCommitInstall,
FCommitInstall,FAuxCommitInstall,FAllStdAmount,FMrpLockFlag,FHaveMrp,FReceiveAmountFor_Commit,
FOrderBillNo,FOrderEntryID) VALUES 
(@FInterID,@FEntryID,'0','','',@FItemID,0,@FQty,@FUnitID,@Fauxqty,@FStockQtyOnlyForShow,0,0,'',
@Fauxprice,@FAuxTaxPrice,@Famount,@FCess,@FTaxRate,0,@FTaxAmount,@FAuxPriceDiscount,@FTaxAmt,
@FAllAmount,'',0,@FDat,'',14036,'',0,'0',@FAdviceConsignDate,0,0,'',0,0,0,Null,'',0,0,0,0,0,0,0,0,@FAllAmount,0,0,0,'','') 
end
set @detailqty=@detailqty+1
end
EXEC p_UpdateBillRelateData 81,@FInterID,'SEOrder','SEOrderEntry' 
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
 