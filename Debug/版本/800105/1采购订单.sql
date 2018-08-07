if (exists (select * from sys.objects where name = 'proc_InOrder'))
    drop proc proc_InOrder
go
create proc proc_InOrder
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
        @FAreaPS varchar(20),      --采购范围
        @Fdate varchar(50),       --日期 
        @FSupplyID varchar(20),   --供应商id
        @FCurrencyID nvarchar(20),--币别id
        @FSettleID varchar(20),  --结算方式id 
        @FPOStyle varchar(20),   --采购方式
        @FSelTranType varchar(20),--源单类型
        @FFetchAdd varchar(100),  --交货地点名
        @FCheckDate varchar(50),  --审核日期
        @FMangerID varchar(20),   --主管id
        @FDeptID varchar(20),     --部门id
        @FEmpID varchar(20),      --业务员id
        @FBillerID varchar(20),   --制单人id
        @FExchangeRate varchar(50),--汇率
        @FSettleDate varchar(50), --结算日期
        @FExplanation varchar(200)--摘要 
set @FBillerID = dbo.getString(@mainStr,'|',1) --操作员
set @Fdate =dbo.getString(@mainStr,'|',2)      --日期
set @FSettleDate=dbo.getString(@mainStr,'|',3) --结算日期
set @FPOStyle =dbo.getString(@mainStr,'|',4) --采购方式
set @FFetchAdd =dbo.getString(@mainStr,'|',5)  --交货地点
set @FDeptID =dbo.getString(@mainStr,'|',6)   --部门id
set @FEmpID =dbo.getString(@mainStr,'|',7)    --业务员id
set @FMangerID =dbo.getString(@mainStr,'|',8) --主管id
set @FSupplyID =dbo.getString(@mainStr,'|',9)   --供应商id
set @FExplanation =dbo.getString(@mainStr,'|',10)--摘要 
set @FAreaPS =dbo.getString(@mainStr,'|',11)    --采购范围ID 
set @FSettleID =dbo.getString(@mainStr,'|',12)  --结算方式ID 
set @FSelTranType=dbo.getString(@mainStr,'|',13)  --源单类型ID
set @Fdate = convert(varchar(20),GETDATE(),23)
exec GetICMaxNum 'ICStockBill',@FInterID output,1,@FBillerID --得到@FInterID
------------------------------------------------------------得到编号
set @FBillNo = ''
 exec proc_GetICBillNo 71, @FBillNo out 
-----------------------------------------------------------得到编号
set @FCurrencyID=1 --币别
set @FCheckDate=null --审核时间
set @FExchangeRate=1 --换算率

INSERT INTO POOrder(FInterID,FBillNo,FBrNo,FTranType,FCancellation,FStatus,FSupplyID,Fdate,FCurrencyID,FCheckDate,FMangerID,FDeptID,FEmpID,FBillerID,FExchangeRateType,FExchangeRate,FPOStyle,FRelateBrID,FMultiCheckDate1,FMultiCheckDate2,FMultiCheckDate3,FMultiCheckDate4,FMultiCheckDate5,FMultiCheckDate6,FSelTranType,FBrID,FExplanation,FSettleID,FSettleDate,FAreaPS,FPOOrdBillNo,FManageType,FSysStatus,FValidaterName,FConsignee,FVersionNo,FChangeDate,FChangeUser,FChangeCauses,FChangeMark,FPrintCount,FDeliveryPlace,FPOMode,FAccessoryCount,FLastAlterBillNo,FPlanCategory) SELECT @FInterID,@FBillNo,'0',71,0,0,@FSupplyID,@Fdate,@FCurrencyID,@FCheckDate,@FMangerID,@FDeptID,@FEmpID,@FBillerID,1,@FExchangeRate,@FPOStyle,0,Null,Null,Null,Null,Null,Null,@FSelTranType,0,@FExplanation,0,@FSettleDate,@FAreaPS,'',0,0,'',0,'000',Null,0,'','',0,'',36680,0,'','1'
declare @FEntryID varchar(20),       --明细序号
        @FItemID varchar(20),        --商品id
        @FQty float,                --基本单位数量
        @FUnitID varchar(20),       --单位id
        @Fauxqty float,             --上传单位数量 
        @Fauxprice float,           --上传单价
        @FAuxTaxPrice float,        --含税单价
        @Famount float,        --金额(单价*数量-单价*数量*折扣率)
        @FCess float,          --税率
        @FTaxRate float,       --折扣率
        @FDescount float,      --折扣额(数量*含税单价*折扣率)        
        @FAuxPriceDiscount float,--实际含税单价(含税单价-折扣率*含税单价) 
        @FTaxAmount float,     --税额(实际含税单价*数量-金额)  
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
	
	select @FCess = isnull(FTaxRate,0) from t_ICItem where FItemID=@FItemID --税率
	select @FCoefficient=isnull(FCoefficient,1) from t_MeasureUnit where FMeasureUnitID=@FUnitID --单位换算率
	set @FAuxTaxPrice= round(@Fauxprice *(1+ @FCess/100)+0.001,2)    --含税单价
	set @FQty=@Fauxqty*@FCoefficient  --基本单位数量
	set @Famount=round(@Fauxqty*(@FAuxTaxPrice/(1+@FCess/100))-@Fauxqty*(@FAuxTaxPrice/(1+@FCess/100))*(@FTaxRate/100)+0.001,2) --金额	
	set @FDescount= round(@FAuxTaxPrice*@Fauxqty*(@FTaxRate/100)+0.001,2)--折扣额
	set @FAuxPriceDiscount= round(@FAuxTaxPrice-(@FTaxRate/100)*@FAuxTaxPrice+0.001,2)--实际含税单价
	set @FTaxAmount=round((@FAuxTaxPrice-(@FTaxRate/100)*@FAuxTaxPrice)*@Fauxqty-@Famount+0.001,2)  --税额
	set @FAllAmount=round(@FQty*(@FAuxTaxPrice-(@FTaxRate/100)*@FAuxTaxPrice)+0.001,2)  --价税合计
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
--------------存在错误
if(0<>@@error)
	goto error1
--------------回滚事务	
error1:
	rollback tran;
--------------结束存储过程
end
