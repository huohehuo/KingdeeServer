if (exists (select * from sys.objects where name = 'proc_InOrder'))
    drop proc proc_InOrder
go
create proc proc_InOrder
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
        @FAreaPS varchar(20),      --�ɹ���Χ
        @Fdate varchar(50),       --���� 
        @FSupplyID varchar(20),   --��Ӧ��id
        @FCurrencyID nvarchar(20),--�ұ�id
        @FSettleID varchar(20),  --���㷽ʽid 
        @FPOStyle varchar(20),   --�ɹ���ʽ
        @FSelTranType varchar(20),--Դ������
        @FFetchAdd varchar(100),  --�����ص���
        @FCheckDate varchar(50),  --�������
        @FMangerID varchar(20),   --����id
        @FDeptID varchar(20),     --����id
        @FEmpID varchar(20),      --ҵ��Աid
        @FBillerID varchar(20),   --�Ƶ���id
        @FExchangeRate varchar(50),--����
        @FSettleDate varchar(50), --��������
        @FExplanation varchar(200)--ժҪ 
set @FBillerID = dbo.getString(@mainStr,'|',1) --����Ա
set @Fdate =dbo.getString(@mainStr,'|',2)      --����
set @FSettleDate=dbo.getString(@mainStr,'|',3) --��������
set @FPOStyle =dbo.getString(@mainStr,'|',4) --�ɹ���ʽ
set @FFetchAdd =dbo.getString(@mainStr,'|',5)  --�����ص�
set @FDeptID =dbo.getString(@mainStr,'|',6)   --����id
set @FEmpID =dbo.getString(@mainStr,'|',7)    --ҵ��Աid
set @FMangerID =dbo.getString(@mainStr,'|',8) --����id
set @FSupplyID =dbo.getString(@mainStr,'|',9)   --��Ӧ��id
set @FExplanation =dbo.getString(@mainStr,'|',10)--ժҪ 
set @FAreaPS =dbo.getString(@mainStr,'|',11)    --�ɹ���ΧID 
set @FSettleID =dbo.getString(@mainStr,'|',12)  --���㷽ʽID 
set @FSelTranType=dbo.getString(@mainStr,'|',13)  --Դ������ID
set @Fdate = convert(varchar(20),GETDATE(),23)
exec GetICMaxNum 'ICStockBill',@FInterID output,1,@FBillerID --�õ�@FInterID
------------------------------------------------------------�õ����
set @FBillNo = ''
 exec proc_GetICBillNo 71, @FBillNo out 
-----------------------------------------------------------�õ����
set @FCurrencyID=1 --�ұ�
set @FCheckDate=null --���ʱ��
set @FExchangeRate=1 --������

INSERT INTO POOrder(FInterID,FBillNo,FBrNo,FTranType,FCancellation,FStatus,FSupplyID,Fdate,FCurrencyID,FCheckDate,FMangerID,FDeptID,FEmpID,FBillerID,FExchangeRateType,FExchangeRate,FPOStyle,FRelateBrID,FMultiCheckDate1,FMultiCheckDate2,FMultiCheckDate3,FMultiCheckDate4,FMultiCheckDate5,FMultiCheckDate6,FSelTranType,FBrID,FExplanation,FSettleID,FSettleDate,FAreaPS,FPOOrdBillNo,FManageType,FSysStatus,FValidaterName,FConsignee,FVersionNo,FChangeDate,FChangeUser,FChangeCauses,FChangeMark,FPrintCount,FDeliveryPlace,FPOMode,FAccessoryCount,FLastAlterBillNo,FPlanCategory) SELECT @FInterID,@FBillNo,'0',71,0,0,@FSupplyID,@Fdate,@FCurrencyID,@FCheckDate,@FMangerID,@FDeptID,@FEmpID,@FBillerID,1,@FExchangeRate,@FPOStyle,0,Null,Null,Null,Null,Null,Null,@FSelTranType,0,@FExplanation,0,@FSettleDate,@FAreaPS,'',0,0,'',0,'000',Null,0,'','',0,'',36680,0,'','1'
declare @FEntryID varchar(20),       --��ϸ���
        @FItemID varchar(20),        --��Ʒid
        @FQty float,                --������λ����
        @FUnitID varchar(20),       --��λid
        @Fauxqty float,             --�ϴ���λ���� 
        @Fauxprice float,           --�ϴ�����
        @FAuxTaxPrice float,        --��˰����
        @Famount float,        --���(����*����-����*����*�ۿ���)
        @FCess float,          --˰��
        @FTaxRate float,       --�ۿ���
        @FDescount float,      --�ۿ۶�(����*��˰����*�ۿ���)        
        @FAuxPriceDiscount float,--ʵ�ʺ�˰����(��˰����-�ۿ���*��˰����) 
        @FTaxAmount float,     --˰��(ʵ�ʺ�˰����*����-���)  
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
	
	select @FCess = isnull(FTaxRate,0) from t_ICItem where FItemID=@FItemID --˰��
	select @FCoefficient=isnull(FCoefficient,1) from t_MeasureUnit where FMeasureUnitID=@FUnitID --��λ������
	set @FAuxTaxPrice= round(@Fauxprice *(1+ @FCess/100)+0.001,2)    --��˰����
	set @FQty=@Fauxqty*@FCoefficient  --������λ����
	set @Famount=round(@Fauxqty*(@FAuxTaxPrice/(1+@FCess/100))-@Fauxqty*(@FAuxTaxPrice/(1+@FCess/100))*(@FTaxRate/100)+0.001,2) --���	
	set @FDescount= round(@FAuxTaxPrice*@Fauxqty*(@FTaxRate/100)+0.001,2)--�ۿ۶�
	set @FAuxPriceDiscount= round(@FAuxTaxPrice-(@FTaxRate/100)*@FAuxTaxPrice+0.001,2)--ʵ�ʺ�˰����
	set @FTaxAmount=round((@FAuxTaxPrice-(@FTaxRate/100)*@FAuxTaxPrice)*@Fauxqty-@Famount+0.001,2)  --˰��
	set @FAllAmount=round(@FQty*(@FAuxTaxPrice-(@FTaxRate/100)*@FAuxTaxPrice)+0.001,2)  --��˰�ϼ�
	set @detailIndex=@detailIndex+1
    set @FEntryID=@detailqty*50+@detailIndex
INSERT INTO POOrderEntry (FInterID,FEntryID,FBrNo,FMapNumber,FMapName,FItemID,FAuxPropID,FQty,FUnitID,FAuxQty,FSecCoefficient,FSecQty,Fauxprice,FAuxTaxPrice,FAmount,FTaxRate,FAuxPriceDiscount,FDescount,FCess,FTaxAmount,FAllAmount,Fdate,Fnote,FSourceBillNo,FSourceTranType,FSourceInterId,FSourceEntryID,FContractBillNo,FContractInterID,FContractEntryID,FMrpLockFlag,FReceiveAmountFor_Commit,FPlanMode,FMTONo,FSupConfirm,FSupConDate,FSupConMem,FSupConQty,FSupConFetchDate,FSupConfirmor,FPRInterID,FPREntryID,FEntryAccessoryCount,FCheckMethod,FIsCheck)  SELECT @FInterID,@FEntryID,'0','','',@FItemID,0,@FQty,@FUnitID,@FAuxQty,0,0,@Fauxprice,@FAuxTaxPrice,@FAmount,@FTaxRate,@FAuxPriceDiscount,@FDescount,@FCess,@FTaxAmount,@FAllAmount,@FDat,'','',0,0,0,'',0,0,0,0,14036,'','',Null,'',0,Null,0,0,0,0,352,'0' 
end
set @detailqty=@detailqty+1
end
EXEC p_UpdateBillRelateData 71,@FInterID,'POOrder','POOrderEntry' 
if not exists(  select   1  from POOrderEntry where FInterID=@FInterID)
begin
    delete  POOrder where FInterID=@FInterID
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
