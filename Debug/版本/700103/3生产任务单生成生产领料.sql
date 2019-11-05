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
        @FSelTranType varchar(20)  --Դ������
set @FBillerID = dbo.getString(@mainStr,'|',1) --����Ա  
set @Fdate =dbo.getString(@mainStr,'|',2)      --����  
set @FDeptID =dbo.getString(@mainStr,'|',4)   --������λid 
set @FPOStyle =dbo.getString(@mainStr,'|',5) --�ɹ���ʽ    
set @FEmpID =dbo.getString(@mainStr,'|',7)    --ҵ��Աid
set @FManagerID =dbo.getString(@mainStr,'|',8) --����id
set @FFManagerID=dbo.getString(@mainStr,'|',9) --����
set @FSManagerID=dbo.getString(@mainStr,'|',10) --����  
set @Fdate = convert(varchar(20),GETDATE(),23) 
exec GetICMaxNum 'ICStockBill',@FInterID output,1,@FBillerID --�õ�@FInterID
------------------------------------------------------------�õ����
 set @FBillNo ='' 
 exec proc_GetICBillNo 24, @FBillNo out 
-----------------------------------------------------------�õ����
set @FCurrencyID=1 --�ұ�
set @FCheckDate=null --���ʱ��  
set @FExplanation='' --��ע
  declare @IsExist varchar(10), --�Ƿ����
            @value varchar(10)--����������
    select @value= Fvalue  from t_systemprofile where Fkey in ('UPSTOCKWHENSAVE') AND FCateGory='IC' 
INSERT INTO ICStockBill(FInterID,FBillNo,FBrNo,FTranType,FCancellation,FStatus,FUpStockWhenSave,FROB,FHookStatus,Fdate,
FDeptID,Fuse,FCheckDate,FSManagerID,FFManagerID,FBillerID,FAcctID,FMultiCheckDate1,FMultiCheckDate2,FMultiCheckDate3,
FMultiCheckDate4,FMultiCheckDate5,FVchInterID,FMultiCheckDate6,FPurposeID,FWBINTERID,FSelTranType,FBackFlushed,FManageType,
FPrintCount) 
SELECT @FInterID,@FBillNo,'0',24,0,0,@value,1,0,@Fdate,@FDeptID,'',@FCheckDate,@FSManagerID,@FSManagerID,@FBillerID,0,Null,Null,
Null,Null,Null,0,Null,12000,0,85,0,0,0
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
	if(@FDCSPID is null or @FDCSPID='')
	set @FDCSPID=0
	--select @FSourceBillNo=FBillNo from POOrder where FInterID=@FSourceInterId --���Ƶĵ��ݱ��
	select @FAuxQtyMust = FAuxQtyMust+FAuxQtySupply-FAuxQty from PPBOMEntry where FICMOInterID=@FSourceInterId and FEntryID=@FSourceEntryID
	select @FSourceBillNo=FBillNo,@FCostOBJID=FCostOBJID from ICMO where FInterID=@FSourceInterId
	if(@FCostOBJID is null or @FCostOBJID='') set @FCostOBJID=0
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
INSERT INTO ICStockBillEntry (FInterID,FEntryID,FBrNo,FSCStockID,FItemID,FAuxPropID,FBatchNo,FQtyMust,FQty,FReProduceType,
FCostOBJID,FCostObjGroupID,FUnitID,FAuxQtyMust,Fauxqty,FSecCoefficient,FSecQty,FAuxPlanPrice,FPlanAmount,Fauxprice,Famount,
FBomInterID,Fnote,FKFDate,FKFPeriod,FPeriodDate,FDCSPID,FOperSN,FOperID,FSNListID,FSourceBillNo,
FSourceTranType,FSourceInterId,FSourceEntryID,FICMOBillNo,FICMOInterID,FPPBomEntryID,FInStockID,FCostCenterID,FPlanMode,
FMTONo,FPositionNo,FItemSize,FItemSuite) 
 SELECT @FInterID,@FEntryID,'0',@FDCStockID,@FItemID,0,@FBatchNo,@FQtyMust,@FQty,1059,@FCostOBJID,0,@FUnitID,@FAuxQtyMust,@Fauxqty,
@FSecCoefficient,@FSecQty,0,0,0,0,0,'',Null,0,Null,@FDCSPID,0,'0',0,@FSourceBillNo,85,@FSourceInterId,@FSourceEntryID,@FSourceBillNo,
 @FSourceInterId,@FSourceEntryID,0,0,14036,'','','',''

end
set @detailqty=@detailqty+1
end
EXEC p_UpdateBillRelateData 24,@FInterID,'ICStockBill','ICStockBillEntry' 

set nocount on
declare @fcheck_fail int
declare @fsrccommitfield_prevalue decimal(28,13)
declare @fsrccommitfield_endvalue decimal(28,13)
declare @maxorder int 
update src set @fsrccommitfield_prevalue= isnull(src.fqty,0),
     @fsrccommitfield_endvalue=@fsrccommitfield_prevalue+(case src.fmaterieltype when 376 then dest.fqty*cast(-1 as float) else dest.fqty end),
     @fcheck_fail=case isnull(@maxorder,0) when 1 then 0 else (case when (src.fstockqty+dest.fqty>=src.fdiscardqty) then @fcheck_fail else -1 end) end,
     src.fqty=@fsrccommitfield_endvalue,
     src.fauxqty=@fsrccommitfield_endvalue/cast(t1.fcoefficient as float)
 from ppbomentry src 
     inner join ppbom srchead on src.ficmointerid=srchead.ficmointerid
     inner join 
 (select u1.ficmointerid as fsourceinterid,u1.fppbomentryid,u1.fitemid,sum(u1.fqty) as fqty
 from  icstockbillentry u1 
 where u1.finterid=@FInterID
 and u1.ficmointerid> 0 
 group by u1.ficmointerid,u1.fppbomentryid,u1.fitemid) dest 
 on dest.fsourceinterid = src.ficmointerid
 and dest.fitemid = src.fitemid
 and src.fentryid = dest.fppbomentryid
 inner join t_measureunit t1 on src.funitid=t1.fitemid
select @fcheck_fail=0
select @fcheck_fail=-1 from ppbomentry src
inner join (select u1.ficmointerid as fsourceinterid,u1.fppbomentryid,u1.fitemid,sum(u1.fqty) as fqty from icstockbillentry u1  where u1.finterid=@FInterID and u1.ficmointerid> 0 group by u1.ficmointerid,u1.fppbomentryid,u1.fitemid) dest
on dest.fsourceinterid = src.ficmointerid and dest.fitemid = src.fitemid and src.fentryid = dest.fppbomentryid 
where src.fstockqty +dest.fqty -src.fdiscardqty<0 and src.fmaterieltype<>376
if @@rowcount>0 select @fcheck_fail=-1

if (select cast(isnull(fvalue,0) as int) from t_systemprofile where fcategory='sh' and fkey='itemscrap_controlqty')=1 
if (isnull(@fcheck_fail,0)=-1) 
begin
   raiserror('���ϵ������������ܴ��ڶ�ӦͶ�ϵ��������ϵ��������뱨����֮�',18,18)
   goto error1
 end
else
if exists (select 1 from ppbom src right join  (select u1.ficmointerid as fsourceinterid,u1.fppbomentryid,u1.fitemid,sum(u1.fqty) as fqty
 from  icstockbillentry u1 
 where u1.finterid=@FInterID
 and u1.ficmointerid> 0 
 group by u1.ficmointerid,u1.fppbomentryid,u1.fitemid) dest on dest.fsourceinterid = src.ficmointerid where dest.fsourceinterid>0 and src.ficmointerid is null)
begin
raiserror('��ѡ�����ѱ�ɾ��',18,18)
goto error1
end
 
 
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
