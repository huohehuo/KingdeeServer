if (exists (select * from sys.objects where name = 'proc_Allot'))
    drop proc proc_Allot
go
create proc proc_Allot
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
        @Fdate varchar(50),       --日期       
        @FCheckDate varchar(50),  --审核日期
        @FMangerID varchar(20),   --主管id
        @FDeptID varchar(20),     --部门id
        @FEmpID varchar(20),      --业务员id
        @FBillerID varchar(20),   --制单人id
        @FFManagerID varchar(20), --验收
        @FSManagerID varchar(20)  --保管  
set @FBillerID = dbo.getString(@mainStr,'|',1) --操作员
set @Fdate =dbo.getString(@mainStr,'|',2)      --日期  
set @FDeptID =dbo.getString(@mainStr,'|',3)   --部门id
set @FEmpID =dbo.getString(@mainStr,'|',4)    --业务员id
set @FSManagerID =dbo.getString(@mainStr,'|',5) --保管id   
set @FFManagerID =dbo.getString(@mainStr,'|',6) --验收id
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
 where a.fbilltypeid = '41' and  a.FProjectID=3 order by a.FClassIndex
 --流水号长度
 select @FLength=a.FLength from t_billcoderule a
 left join t_option e on a.fprojectid=e.fprojectid and a.fformatindex=e.fid
 Left OUter join t_checkproject b on a.fbilltype=b.fbilltypeid and a.fprojectval=b.ffield
 where a.fbilltypeid = '41' and  a.FProjectID=3  order by a.FClassIndex
 set @Fnumber='0000000000000'+@Fnumber
 set @Fnumber=right(@Fnumber,@FLength) --流水号
---更新流水号
  update a set FProjectVal=FProjectVal+1 from t_billcoderule a
 left join t_option e on a.fprojectid=e.fprojectid and a.fformatindex=e.fid
 Left OUter join t_checkproject b on a.fbilltype=b.fbilltypeid and a.fprojectval=b.ffield
 where a.fbilltypeid = '41' and a.FProjectID=3  ---更新单号

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
 --编号前缀    
select @Fprefix=a.FProjectVal from t_billcoderule a
 left join t_option e on a.fprojectid=e.fprojectid and a.fformatindex=e.fid
 Left OUter join t_checkproject b on a.fbilltype=b.fbilltypeid and a.fprojectval=b.ffield
 where a.fbilltypeid = '41' and  a.FProjectID=1 and a.FClassIndex=@Index order by a.FClassIndex
  set @FBillNo=isnull(@FBillNo,'')+isnull(@Fprefix,'')
 end
 if(@FProjectID='2')
 begin
  --日期字符
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
-----------------------------------------------------------得到编号 
   declare @IsExist varchar(10), --是否存在
            @value varchar(10)--库存更新类型
    select @value= Fvalue  from t_systemprofile where Fkey in ('UPSTOCKWHENSAVE') AND FCateGory='IC' 

set @FCheckDate=null --审核时间 
INSERT INTO ICStockBill(FInterID,FBillNo,FBrNo,FTranType,FCancellation,FStatus,FUpStockWhenSave,FHookStatus,FVchInterID,
Fdate,FCurrencyID,FCheckDate,FDeptID,FFManagerID,FBillerID,FMultiCheckLevel1,FEmpID,FMultiCheckDate1,FSManagerID,
FMultiCheckLevel2,FRefType,FExplanation,FMultiCheckDate2,FMultiCheckLevel3,FMultiCheckDate3,FMultiCheckLevel4,
FMultiCheckDate4,FMultiCheckLevel5,FMultiCheckDate5,FMultiCheckLevel6,FMultiCheckDate6,FSelTranType,FBrID) 
VALUES (@FInterID,@FBillNo,'0',41,0,0,@value,0,0,@Fdate,1,@FCheckDate,@FDeptID,@FFManagerID,@FBillerID,Null,@FEmpID,Null,@FSManagerID,Null,12561,'',Null,Null,Null,Null,Null,Null,Null,Null,Null,0,0)
 UPDATE ICStockBill SET FUUID=NEWID() WHERE FInterID=@FInterID
declare @FEntryID varchar(20),       --明细序号
        @FItemID varchar(20),        --商品id
        @FQty float,                --基本单位数量
        @FUnitID varchar(20),       --单位id
        @Fauxqty float,             --上传单位数量 
        @FSCStockID varchar(20),    --出库仓库id
        @FSCSPID varchar(20),       --出库仓位id
        @FDCStockID varchar(20),    --入库仓库id
        @FDCSPID  varchar(20),      --入库仓位id
        @FBatchNo varchar(50),    --批次
        @FCoefficient float(50),  --单位换算
        @FPlanPrice float(50),    --基本计划单价
        @FAuxPlanPrice float(50), --单位计划单价
        @FPlanAmount float(50),   --计划单价金额
        @detailqty int,               --明细参数的个数
        @detailcount int,             --明细每行数据的长度 
        @detailIndex int,            --明细每行下标
        @countindex int              --分隔符|的数量
       set @detailqty=0        
       set @detailcount=8          
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
	set @Fauxqty=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+3)    --数量
	set @FDCStockID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+4) --入库id
	set @FSCStockID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+5) --出库id
	set @FDCSPID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+6) --入库仓位
	set @FSCSPID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+7) --出库仓位
	set @FBatchNo=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+8) --批次
	 	select @FCoefficient=FCoefficient from t_MeasureUnit where FMeasureUnitID=@FUnitID --单位换算率
	select @FPlanPrice=isnull(FPlanPrice,0) from t_ICItem where   FItemID=@FItemID 
	set @FQty=@Fauxqty*@FCoefficient  
	set @FAuxPlanPrice = @FPlanPrice*@FCoefficient
	set @FPlanAmount = @FAuxPlanPrice*@Fauxqty
 
	set @detailIndex=@detailIndex+1
    set @FEntryID=@detailqty*50+@detailIndex
    
        if(@value=1)
    begin
    --入库
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
      --出库
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
--------------存在错误
if(0<>@@error)
	goto error1
--------------回滚事务	
error1:
	rollback tran;
--------------结束存储过程
end
