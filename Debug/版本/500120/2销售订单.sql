if (exists (select * from sys.objects where name = 'proc_SaleOrder'))
    drop proc proc_SaleOrder
go
create proc proc_SaleOrder
(
 @mainStr nvarchar(1000),--主表参数
 @detailStr1 varchar(max),--明细参数
 @detailStr2 varchar(max),
 @detailStr3 varchar(max),
 @detailStr4 varchar(max),
 @detailStr5 varchar(max)
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
        @FAreaPS varchar(20),      --销售范围
        @FTranType varchar(20),    --单据类型 
        @Fdate varchar(50),       --日期 
        @FCustID varchar(20),     --购货单位id
        @FCurrencyID nvarchar(20),--币别id
        @FSettleID nvarchar(20),  --结算方式id
        @FSaleStyle varchar(20),  --销售方式id
        @FFetchStyle varchar(20), --交货方式id
        @FFetchAdd varchar(100),  --交货地点名
        @FCheckDate varchar(50),  --审核日期
        @FMangerID varchar(20),   --主管id
        @FDeptID varchar(20),     --部门id
        @FEmpID varchar(20),      --业务员id
        @FBillerID varchar(20),   --制单人id
        @FExchangeRate varchar(50),--汇率
        @FSettleDate varchar(50), --结算日期
        @FExplanation varchar(200),--摘要 
        @FSelTranType varchar(20)   --源单类型ID
set @FBillerID = dbo.getString(@mainStr,'|',1) --操作员
set @Fdate =dbo.getString(@mainStr,'|',2)      --日期
set @FSettleDate=dbo.getString(@mainStr,'|',3) --结算日期
set @FSaleStyle =dbo.getString(@mainStr,'|',4) --销售方式ID
set @FFetchAdd =dbo.getString(@mainStr,'|',5)  --交货地点
set @FDeptID =dbo.getString(@mainStr,'|',6)   --部门id
set @FEmpID =dbo.getString(@mainStr,'|',7)    --业务员id
set @FMangerID =dbo.getString(@mainStr,'|',8) --主管id
set @FCustID =dbo.getString(@mainStr,'|',9)   --购货单位ID
set @FExplanation =dbo.getString(@mainStr,'|',10)--摘要
set @FAreaPS =dbo.getString(@mainStr,'|',11)    --销售范围ID 
set @FSettleID =dbo.getString(@mainStr,'|',12)  --结算方式ID
set @FFetchStyle =dbo.getString(@mainStr,'|',13)--交货方式ID
set @FSelTranType=dbo.getString(@mainStr,'|',14)--源单类型ID
set @Fdate = convert(varchar(20),GETDATE(),23)
exec GetICMaxNum 'SEOrder',@FInterID output,1,@FBillerID --得到@FInterID
------------------------------------------------------------得到编号
 set @FBillNo ='' 
 exec proc_GetICBillNo 81, @FBillNo out 
-----------------------------------------------------------得到编号
set @FCurrencyID=1 --币别
set @FCheckDate=null --审核时间
set @FExchangeRate=1 --换算率

INSERT INTO SEOrder(FInterID,FBillNo,FBrNo,FTranType,FCancellation,FStatus,FDiscountType,Fdate,FCustID,FSaleStyle,FFetchStyle,FCurrencyID,FFetchAdd,FCheckDate,FMangerID,FDeptID,FEmpID,FBillerID,FSettleID,FExchangeRate,FMultiCheckDate1,FMultiCheckDate2,FMultiCheckDate3,FMultiCheckDate4,FMultiCheckDate5,FMultiCheckDate6,FPOOrdBillNo,FRelateBrID,FTransitAheadTime,FImport,FSelTranType,FBrID,FSettleDate,FExplanation,FAreaPS,FManageType,FSysStatus,FValidaterName,FConsignee,FVersionNo,FChangeDate,FChangeUser,FChangeCauses,FChangeMark,FPrintCount) 
VALUES (@FInterID,@FBillNo,'0',81,0,0,0,@Fdate,@FCustID,@FSaleStyle,@FFetchStyle,@FCurrencyID,@FFetchAdd,@FCheckDate,@FMangerID,@FDeptID,@FEmpID,@FBillerID,@FSettleID,@FExchangeRate,Null,Null,Null,Null,Null,Null,'',0,'0',0,@FSelTranType,0,@FSettleDate,@FExplanation,@FAreaPS,0,2,'',0,'000',Null,0,'','',0)
update ICStockBill set FUUID=newid() where FInterID=@FInterID

declare @FEntryID varchar(20),       --明细序号
        @FItemID varchar(20),        --商品id
        @FQty float,                --换算数量
        @FUnitID varchar(20),       --单位id
        @Fauxqty float,            --基本单位数量
        @FStockQtyOnlyForShow float,--库存数量
        @Fauxprice float,      --单价
        @FAuxTaxPrice float,   --含税单价
        @Famount float,        --金额(单价*数量-单价*数量*折扣率)
        @FCess float,          --税率
        @FTaxRate float,       --折扣率
        @FTaxAmount float,     --折扣额(含税单价*数量*折扣率)             
        @FAuxPriceDiscount float,--实际含税单价(含税单价-折扣率*含税单价)
        @FTaxAmt float,        --销项税额(实际含税单价*数量-金额)
        @FAllAmount float,     --价税合计(数量*实际含税单价)
        
        @FDat varchar(50),           --交货日期@FDate由于存在所以定义为@FDat 
        @FAdviceConsignDate varchar(50), --建议交货日期
        @FCoefficient varchar(20),   --换算率
        
        @detailqty int,               --明细参数的个数
        @detailcount int,             --明细每行数据的长度 
        @detailIndex int,            --明细每行下标
        @countindex int              --分隔符|的数量
       set @detailqty=0        
       set @detailcount=6           
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
	set @FTaxRate=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+5)   --折扣率
    set @FDat=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+6)       --交货日期 	
    
	select @FCess = FTaxRate from t_ICItem where FItemID=@FItemID --税率
	select @FCoefficient=FCoefficient from t_MeasureUnit where FMeasureUnitID=@FUnitID --单位换算率
	set @FQty=@Fauxqty*@FCoefficient  --基本单位数量

	
	select @FAuxTaxPrice=isnull(FSalePrice,0) from t_ICItem where FItemID=@FItemID --含税单价
    if(@FAuxTaxPrice=0)
    begin
    set @FAuxTaxPrice= @Fauxprice *(1+ @FCess/100)   --含税单价
    end
    set @Famount=@Fauxqty*(@FAuxTaxPrice/(1+@FCess/100))-@Fauxqty*(@FAuxTaxPrice/(1+@FCess/100))*(@FTaxRate/100) --金额
	set @FTaxAmount= @FAuxTaxPrice*@Fauxqty*(@FTaxRate/100)--折扣额
	set @FAuxPriceDiscount= @FAuxTaxPrice-@FAuxTaxPrice*(@FTaxRate/100)--实际含税单价
	set @FTaxAmt=@FAuxPriceDiscount*@FQty-@Famount  --销项税额
	set @FAllAmount=@FQty*@FAuxPriceDiscount  --价税合计
	set @detailIndex=@detailIndex+1
    set @FEntryID=@detailqty*50+@detailIndex
    select @FStockQtyOnlyForShow=SUM(FQty) from ICInventory where FItemID=@FItemID --库存数量
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
--------------存在错误
if(0<>@@error)
	goto error1
--------------回滚事务	
error1:
	rollback tran;
--------------结束存储过程
end
 