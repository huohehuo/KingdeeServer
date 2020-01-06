if (exists (select * from sys.objects where name = 'proc_InOrder'))
    drop proc proc_InOrder
go
create proc proc_InOrder
(
 @mainStr varchar(1000),--主表参数
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
exec GetICMaxNum 'ICStockBill',@FInterID output --,1,@FBillerID --得到@FInterID
------------------------------------------------------------得到编号
declare @Fprefix varchar(50),--编号前缀
        @Fnumber varchar(20),--流水号
        @FLength int,        --流水号的长度
        @FDateStr varchar(20),--日期字符
        @FProjectID varchar(20),--格式标识符 
        @FClassIndex int,  --排序(用于循环找出类型)
        @Index int  --(循环标)
        set @FBillNo ='' 
 --流水号
select @Fnumber=a.FProjectVal from t_billcoderule a
 left join t_option e on a.fprojectid=e.fprojectid and a.fformatindex=e.fid
 Left OUter join t_checkproject b on a.fbilltype=b.fbilltypeid and a.fprojectval=b.ffield
 where a.fbilltypeid = '71' and  a.FProjectID=3 order by a.FClassIndex
 --流水号长度
 select @FLength=a.FLength from t_billcoderule a
 left join t_option e on a.fprojectid=e.fprojectid and a.fformatindex=e.fid
 Left OUter join t_checkproject b on a.fbilltype=b.fbilltypeid and a.fprojectval=b.ffield
 where a.fbilltypeid = '71' and  a.FProjectID=3  order by a.FClassIndex
 set @Fnumber='0000000000000'+@Fnumber
 set @Fnumber=right(@Fnumber,@FLength) --流水号
---更新流水号
  update a set FProjectVal=FProjectVal+1 from t_billcoderule a
 left join t_option e on a.fprojectid=e.fprojectid and a.fformatindex=e.fid
 Left OUter join t_checkproject b on a.fbilltype=b.fbilltypeid and a.fprojectval=b.ffield
 where a.fbilltypeid = '71' and a.FProjectID=3  ---更新单号

select @FClassIndex= COUNT(1) from t_billcoderule a
 left join t_option b on a.fprojectid=b.fprojectid and a.fformatindex=b.fid
 left join t_checkproject c on a.fbilltype = c.fbilltypeid and a.fprojectval = c.ffield
 where a.fbilltypeid = 71
 set @Index=1
 while(@Index<=@FClassIndex)
 begin
 select @FProjectID= a.FProjectID from t_billcoderule a
 left join t_option b on a.fprojectid=b.fprojectid and a.fformatindex=b.fid
 left join t_checkproject c on a.fbilltype = c.fbilltypeid and a.fprojectval = c.ffield
 where a.fbilltypeid = 71 and a.FClassIndex=@Index
 if(@FProjectID='1')
 begin
 --编号前缀    
select @Fprefix=a.FProjectVal from t_billcoderule a
 left join t_option e on a.fprojectid=e.fprojectid and a.fformatindex=e.fid
 Left OUter join t_checkproject b on a.fbilltype=b.fbilltypeid and a.fprojectval=b.ffield
 where a.fbilltypeid = '71' and  a.FProjectID=1 and a.FClassIndex=@Index order by a.FClassIndex
  set @FBillNo=isnull(@FBillNo,'')+isnull(@Fprefix,'')
 end
 if(@FProjectID='2')
 begin
  --日期字符
 select @FDateStr=a.FProjectVal from t_billcoderule a
 left join t_option e on a.fprojectid=e.fprojectid and a.fformatindex=e.fid
 Left OUter join t_checkproject b on a.fbilltype=b.fbilltypeid and a.fprojectval=b.ffield
 where a.fbilltypeid = '71' and  a.FProjectID=2 and a.FClassIndex=@Index order by a.FClassIndex
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
-----------------------------------------------------------得到编号
set @FCurrencyID=1 --币别
set @FCheckDate=null --审核时间
set @FExchangeRate=1 --换算率

INSERT INTO POOrder(FInterID,FBillNo,FBrNo,FTranType,FCancellation,FStatus,FSupplyID,Fdate,FCurrencyID,FCheckDate,FAlterDate,FMangerID,FDeptID,FEmpID,FBillerID,FExchangeRate,FPOStyle,FExplanation,FSettleID,FSettleDate,FRelateBrID,FMultiCheckLevel1,FMultiCheckDate1,FMultiCheckLevel2,FMultiCheckDate2,FMultiCheckLevel3,FMultiCheckDate3,FMultiCheckLevel4,FMultiCheckDate4,FMultiCheckLevel5,FMultiCheckDate5,FMultiCheckLevel6,FMultiCheckDate6,FSelTranType,FBrID,FAreaPS,FPOOrdBillNo) VALUES (@FInterID,@FBillNo,'0',71,0,0,@FSupplyID,@Fdate,@FCurrencyID,@FCheckDate,Null,@FMangerID,@FDeptID,@FEmpID,@FBillerID,@FExchangeRate,@FPOStyle,@FExplanation,@FSettleID,@FSettleDate,0,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,0,0,20302,'')
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
INSERT INTO POOrderEntry (FInterID,FEntryID,FBrNo,FItemID,FMapNumber,FMapName,FAuxPropID,FQty,FUnitID,FAuxQty,Fauxprice,FAuxTaxPrice,FAmount,FTaxRate,FSecCoefficient,FAuxPriceDiscount,FSecQty,FDescount,FCess,FTaxAmount,FAllAmount,Fdate,Fnote,FAuxQtyInvoice,FQtyInvoice,FMrpLockFlag,FSourceBillNo,FPurchasePlanBillNo,FPurchasePlanKey,FSourceTranType,FSourceInterId,FSourceEntryID,FContractBillNo,FContractInterID,FContractEntryID) VALUES (@FInterID,@FEntryID,'0',@FItemID,'','',0,@FQty,@FUnitID,@FAuxQty,@Fauxprice,@FAuxTaxPrice,@FAmount,@FTaxRate,0,@FAuxPriceDiscount,0,0,@FCess,@FTaxAmount,@FAllAmount,@Fdat,'',0,0,0,'','','',0,0,0,'',0,0) 
end
set @detailqty=@detailqty+1
end
EXEC p_UpdateBillRelateData 71,@FInterID  --,'POOrder','POOrderEntry' 
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
