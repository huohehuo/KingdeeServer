if (exists (select * from sys.objects where name = 'proc_ProductPicking'))
    drop proc proc_ProductPicking
go
create proc proc_ProductPicking
(
 @mainStr nvarchar(1000),--主表参数
 @detailStr1 nvarchar(max),--明细参数
 @detailStr2 nvarchar(max),
 @detailStr3 nvarchar(max),
 @detailStr4 nvarchar(max),
 @detailStr5 nvarchar(max)
)
as 
--------------开启一个模式，也就是不再刷新多少行受影响的信息，可以提高性能
set nocount on
--------------开始存储过程
begin
--------------事务选项设置为出错全部回滚
set xact_abort on
--------------开启事务 
begin tran
declare @FInterID varchar(20),     --单号id
        @FBillNo varchar(50),      -- 编号   
        @FROB varchar(20),         --红蓝字标识
        @Fdate varchar(50),       --日期  
        @FSupplyID varchar(20),   --购货单位id
        @FCurrencyID nvarchar(20),--币别id 
        @FSaleStyle varchar(20),  --销售方式id 
        @FPOStyle varchar(20),    --采购方式
        @FFetchAdd varchar(100),  --交货地点名
        @FCheckDate varchar(50),  --审核日期 
        @FFManagerID varchar(20), --发货
        @FSManagerID varchar(20), --保管
        @FManagerID varchar(20),  --主管id
        @FDeptID varchar(20),     --部门id
        @FEmpID varchar(20),      --业务员id
        @FBillerID varchar(20),   --制单人id 
        @FSettleDate varchar(50), --付款日期
        @FExplanation varchar(200),--摘要 
        @FMarketingStyle varchar(20),--销售业务类型
        @FSelTranType varchar(20)  --源单类型
set @FBillerID = dbo.getString(@mainStr,'|',1) --操作员  
set @Fdate =dbo.getString(@mainStr,'|',2)      --日期  
set @FDeptID =dbo.getString(@mainStr,'|',4)   --交货单位id 
set @FPOStyle =dbo.getString(@mainStr,'|',5) --采购方式    
set @FEmpID =dbo.getString(@mainStr,'|',7)    --业务员id
set @FManagerID =dbo.getString(@mainStr,'|',8) --主管id
set @FFManagerID=dbo.getString(@mainStr,'|',9) --发货
set @FSManagerID=dbo.getString(@mainStr,'|',10) --保管  
set @Fdate = convert(varchar(20),GETDATE(),23) 
exec GetICMaxNum 'ICStockBill',@FInterID output,1,@FBillerID --得到@FInterID
------------------------------------------------------------得到编号
 set @FBillNo ='' 
 exec proc_GetICBillNo 24, @FBillNo out 
-----------------------------------------------------------得到编号
set @FCurrencyID=1 --币别
set @FCheckDate=null --审核时间  
set @FExplanation='' --备注
  declare @IsExist varchar(10), --是否存在
            @value varchar(10)--库存更新类型
    select @value= Fvalue  from t_systemprofile where Fkey in ('UPSTOCKWHENSAVE') AND FCateGory='IC' 
INSERT INTO ICStockBill(FInterID,FBillNo,FBrNo,FTranType,FCancellation,FStatus,FUpStockWhenSave,FROB,FHookStatus,Fdate,
FDeptID,Fuse,FCheckDate,FSManagerID,FFManagerID,FBillerID,FAcctID,FMultiCheckDate1,FMultiCheckDate2,FMultiCheckDate3,
FMultiCheckDate4,FMultiCheckDate5,FVchInterID,FMultiCheckDate6,FPurposeID,FWBINTERID,FSelTranType,FBackFlushed,FManageType,
FPrintCount) 
SELECT @FInterID,@FBillNo,'0',24,0,0,@value,1,0,@Fdate,@FDeptID,'',@FCheckDate,@FSManagerID,@FSManagerID,@FBillerID,0,Null,Null,
Null,Null,Null,0,Null,12000,0,85,0,0,0
 update ICStockBill set FUUID=newid() where FInterID=@FInterID

declare @FEntryID varchar(20),       --新的明细序号
        @FSourceEntryID varchar(20), --下推单据的明细id
        @FSourceInterId varchar(20), --下推单据的FInterID
        @FSourceBillNo varchar(20),  --下推的单据的单据编号
        @FItemID varchar(20),        --商品id
        @FQty float,                --基本单位数量
        @FQtyMust float,            --基本单位可验数量
        @FAuxQtyMust float,        --单位可验收数量
        @FUnitID varchar(20),       --单位id
        @Fauxqty float,            --上传的数量 
        @Fauxprice float,          -- 单价
        @Famount float,          --金额
        @FTaxAmount float,     -- 
        
        @FPlanPrice float,     --基本单位计划单价
        @FAuxPlanPrice float, --单位计划单价
        @FPlanAmount float,   --计划价金额     
        @FDiscountRate float,  --折扣率
        @FDiscountAmount float,--折扣额(含税单价*数量*折扣率)   
        @FDCStockID varchar(20), --仓库id
        @FDCSPID varchar(20), --仓位id
        @FBatchNo varchar(50),--批号
        @FCoefficient varchar(20),   --换算率
        @FCostOBJID varchar(20),     --成本对象
           @FSecCoefficient float, --辅助单位换算率
        @FSecQty decimal(28,10),   --辅助单位数量
          @FSecUnitID  varchar(50), 
        @detailqty int,               --明细参数的个数
        @detailcount int,             --明细每行数据的长度 
        @detailIndex int,            --明细每行下标
        @countindex int              --分隔符|的数量
       set @detailqty=0        
       set @detailcount=9           
    while(@detailqty<5)--判断是明细的哪个参数
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
	set @FItemID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+1)    --商品id
	set @FUnitID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+2)    --单位id 
	set @Fauxprice=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+3)  --单价
	set @Fauxqty=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+4)    --数量  
	set @FDCStockID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+5) --仓库id
	set @FDCSPID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+6) --仓位id
	set @FSourceEntryID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+7) --下推的明细id
	set @FSourceInterId=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+8) --下推的明FInterID
	set @FBatchNo=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+9)
	if(@FDCSPID is null or @FDCSPID='')
	set @FDCSPID=0
	--select @FSourceBillNo=FBillNo from POOrder where FInterID=@FSourceInterId --下推的单据编号
	select @FAuxQtyMust = FAuxQtyMust+FAuxQtySupply-FAuxQty from PPBOMEntry where FICMOInterID=@FSourceInterId and FEntryID=@FSourceEntryID
	select @FSourceBillNo=FBillNo,@FCostOBJID=FCostOBJID from ICMO where FInterID=@FSourceInterId
	if(@FCostOBJID is null or @FCostOBJID='') set @FCostOBJID=0
	select @FCoefficient=FCoefficient from t_MeasureUnit where FMeasureUnitID=@FUnitID --单位换算率 
	set @FQtyMust=@FAuxQtyMust*@FCoefficient --基本单位可验收的数量 
	select @FPlanPrice=isnull(FPlanPrice,0) from t_ICItem where   FItemID=@FItemID 
	set @FQty=@Fauxqty*@FCoefficient                  --基本单位数量 
	set @FAuxPlanPrice=@FPlanPrice*@FCoefficient   --单位计划单价
	set @FPlanAmount=@FAuxPlanPrice*@Fauxqty          --计划单价金额 
	set @Famount=@Fauxqty*@Fauxprice
	set @detailIndex=@detailIndex+1
    set @FEntryID=@detailqty*50+@detailIndex
     --物料辅助单位
       select @FSecUnitID=FSecUnitID,@FSecCoefficient=FSecCoefficient from t_ICItem where FItemID=@FItemID
      if(@FSecCoefficient<>0) --这里判断上传的是辅助单位还是基本单位 如果成立说明上传的是辅助单位
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
   raiserror('领料单的退料数不能大于对应投料单子项物料的已领数与报废数之差。',18,18)
   goto error1
 end
else
if exists (select 1 from ppbom src right join  (select u1.ficmointerid as fsourceinterid,u1.fppbomentryid,u1.fitemid,sum(u1.fqty) as fqty
 from  icstockbillentry u1 
 where u1.finterid=@FInterID
 and u1.ficmointerid> 0 
 group by u1.ficmointerid,u1.fppbomentryid,u1.fitemid) dest on dest.fsourceinterid = src.ficmointerid where dest.fsourceinterid>0 and src.ficmointerid is null)
begin
raiserror('所选单据已被删除',18,18)
goto error1
end
 
 
if not exists(  select   1  from ICStockBillEntry where FInterID=@FInterID)
begin
    delete from ICStockBill where FInterID=@FInterID
	goto error1
end 

commit tran 
return;
--------------存在错误
if(0<>@@error)
	goto error1
--------------回滚事务	
error1:
	rollback tran;
--------------结束存储过程
end
