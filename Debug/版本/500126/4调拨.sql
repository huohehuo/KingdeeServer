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
exec GetICMaxNum 'ICStockBill',@FInterID output,1,@FBillerID --�õ�@FInterID
set @Fdate = convert(varchar(20),GETDATE(),23)
------------------------------------------------------------�õ����
 set @FBillNo ='' 
 exec proc_GetICBillNo 41, @FBillNo out 
-----------------------------------------------------------�õ���� 
 
  declare @IsExist varchar(10), --�Ƿ����
            @value varchar(10)--����������
    select @value= Fvalue  from t_systemprofile where Fkey in ('UPSTOCKWHENSAVE') AND FCateGory='IC' 
set @FCheckDate=null --���ʱ�� 
INSERT INTO ICStockBill(FInterID,FBillNo,FBrNo,FTranType,FCancellation,FStatus,FUpStockWhenSave,FHookStatus,Fdate,
FCheckDate,FFManagerID,FSManagerID,FBillerID,FMultiCheckDate1,FMultiCheckDate2,FMultiCheckDate3,FMultiCheckDate4,
FMultiCheckDate5,FMultiCheckDate6,FSelTranType,FBrID,FDeptID,FEmpID,FPrintCount,FRefType) 
VALUES (@FInterID,@FBillNo,'0',41,0,0,@value,0,@Fdate,@FCheckDate,@FFManagerID,@FSManagerID,@FBillerID,Null,Null,Null,Null,Null,Null,0,0,@FDeptID,@FEmpID,0,12561)
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
        @FBatchNo varchar(50),   --����
        @FCoefficient float(50),  --��λ����
        @FPlanPrice float(50),    --�����ƻ�����
        @FAuxPlanPrice float(50), --��λ�ƻ�����
        @FPlanAmount float(50),   --�ƻ����۽��
           @FSecCoefficient float, --������λ������
        @FSecQty decimal(28,10),   --������λ����
          @FSecUnitID  varchar(50), 
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
    --���
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
      --����
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
--------------���ڴ���
if(0<>@@error)
	goto error1
--------------�ع�����	
error1:
	rollback tran;
--------------�����洢����
end
