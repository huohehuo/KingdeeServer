if (exists (select * from sys.objects where name = 'proc_Check'))
    drop proc proc_Check
go
create proc proc_Check
( 
 @detailStr1 varchar(8000),--明细参数
 @detailStr2 varchar(8000),
 @detailStr3 varchar(8000),
 @detailStr4 varchar(8000),
 @detailStr5 varchar(8000),
 @detailStr6 varchar(8000),--明细参数
 @detailStr7 varchar(8000),
 @detailStr8 varchar(8000),
 @detailStr9 varchar(8000),
 @detailStr10 varchar(8000),
 @detailStr11 varchar(8000),--明细参数
 @detailStr12 varchar(8000),
 @detailStr13 varchar(8000),
 @detailStr14 varchar(8000),
 @detailStr15 varchar(8000),
 @detailStr16 varchar(8000),--明细参数
 @detailStr17 varchar(8000),
 @detailStr18 varchar(8000),
 @detailStr19 varchar(8000),
 @detailStr20 varchar(8000),
 @detailStr21 varchar(8000),--明细参数
 @detailStr22 varchar(8000),
 @detailStr23 varchar(8000),
 @detailStr24 varchar(8000),
 @detailStr25 varchar(8000),
 @detailStr26 varchar(8000),--明细参数
 @detailStr27 varchar(8000),
 @detailStr28 varchar(8000),
 @detailStr29 varchar(8000),
 @detailStr30 varchar(8000),
 @detailStr31 varchar(8000),--明细参数
 @detailStr32 varchar(8000),
 @detailStr33 varchar(8000),
 @detailStr34 varchar(8000),
 @detailStr35 varchar(8000),
 @detailStr36 varchar(8000),--明细参数
 @detailStr37 varchar(8000),
 @detailStr38 varchar(8000),
 @detailStr39 varchar(8000),
 @detailStr40 varchar(8000)
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

declare @FCheckQty float,  --基本单位盘点数量
        @FQtyAct float,    --基本单位实存数量
        @FQty float,       --基本单位账存数量
        @FAdjQty float,    --基本单位调整数量
        @FAuxCheckQty float,--单位盘点数量 
        @FAuxQtyAct float, --单位实存数量
        @FAuxQty float,    --单位账存数量
        @FInterID varchar(20),--盘点方案id
        @FStockID varchar(20),--仓库id
        @FStockPlaceID varchar(20),--仓位id
        @FBatchNo varchar(50),--批次
        @FItemID varchar(20),--商品id
        @FUnitID varchar(20),--单位id
        @FUnitGroupID varchar(20), --单位组id
        @FDateBackup varchar(50),
        @FMinus float,
        @FMaxBillInterID varchar(20),
        @FCoefficient float,--换算率
        
        @detailqty int,               --明细参数的个数
        @detailcount int,             --明细每行数据的长度 
        @detailIndex int,            --明细每行下标
        @countindex int              --分隔符|的数量
       set @detailqty=0        
       set @detailcount=8           
     while(@detailqty<40)--判断是明细的哪个参数
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
	if(@detailqty=5)
	begin
	set @detailStr1=@detailStr6
	end 
	if(@detailqty=6)
	begin
	set @detailStr1=@detailStr7
	end 
	if(@detailqty=7)
	begin
	set @detailStr1=@detailStr8
	end 
	if(@detailqty=8)
	begin
	set @detailStr1=@detailStr9
	end 
	if(@detailqty=9)
	begin
	set @detailStr1=@detailStr10
	end 
	if(@detailqty=10)
	begin
	set @detailStr1=@detailStr11
	end 
	if(@detailqty=11)
	begin
	set @detailStr1=@detailStr12
	end  
	if(@detailqty=12)
	begin
	set @detailStr1=@detailStr13
	end 
	if(@detailqty=13)
	begin
	set @detailStr1=@detailStr14
	end 
	if(@detailqty=14)
	begin
	set @detailStr1=@detailStr15
	end 
	if(@detailqty=15)
	begin
	set @detailStr1=@detailStr16
	end 
	if(@detailqty=16)
	begin
	set @detailStr1=@detailStr17
	end 
	if(@detailqty=17)
	begin
	set @detailStr1=@detailStr18
	end 
	if(@detailqty=18)
	begin
	set @detailStr1=@detailStr19
	end 
	if(@detailqty=19)
	begin
	set @detailStr1=@detailStr20
	end  
	
	if(@detailqty=20)
	begin
	set @detailStr1=@detailStr21
	end  
	if(@detailqty=21)
	begin
	set @detailStr1=@detailStr22
	end 
	if(@detailqty=22)
	begin
	set @detailStr1=@detailStr23
	end 
	if(@detailqty=23)
	begin
	set @detailStr1=@detailStr24
	end 
	if(@detailqty=24)
	begin
	set @detailStr1=@detailStr25
	end 
	if(@detailqty=25)
	begin
	set @detailStr1=@detailStr26
	end 
	if(@detailqty=26)
	begin
	set @detailStr1=@detailStr27
	end 
	if(@detailqty=27)
	begin
	set @detailStr1=@detailStr28
	end 
	if(@detailqty=28)
	begin
	set @detailStr1=@detailStr29
	end 
	if(@detailqty=29)
	begin
	set @detailStr1=@detailStr30
	end 
	if(@detailqty=30)
	begin
	set @detailStr1=@detailStr31
	end  
	if(@detailqty=31)
	begin
	set @detailStr1=@detailStr32
	end 
	if(@detailqty=32)
	begin
	set @detailStr1=@detailStr33
	end 
	if(@detailqty=33)
	begin
	set @detailStr1=@detailStr34
	end 
	if(@detailqty=34)
	begin
	set @detailStr1=@detailStr35
	end 
	if(@detailqty=35)
	begin
	set @detailStr1=@detailStr36
	end 
	if(@detailqty=36)
	begin
	set @detailStr1=@detailStr37
	end 
	if(@detailqty=37)
	begin
	set @detailStr1=@detailStr38
	end 
	if(@detailqty=38)
	begin
	set @detailStr1=@detailStr39
	end  
	if(@detailqty=39)
	begin
	set @detailStr1=@detailStr40
	end  
	if(@detailStr1='' or @detailStr1=null)
	begin
	break;
	end
	set @detailIndex=0 
	select @countindex=len(@detailStr1)-len(replace(@detailStr1, '|', ''))
	while(@countindex>@detailIndex*@detailcount)
	begin
set @FInterID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+1)--盘点 
set @FItemID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+2) --商品
set @FUnitID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+3) --单位
set @FStockID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+4) --仓库
set @FStockPlaceID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+5)--
set @FCheckQty=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+6)--
set @FAdjQty=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+7)--数量 
set @FBatchNo=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+8)--批次 
set @FAuxCheckQty=isnull(@FCheckQty,0)
set @FQtyAct =isnull(@FCheckQty,0)
set @FAuxQtyAct=isnull(@FCheckQty,0)
set @detailIndex=@detailIndex+1

set @FDateBackup=GETDATE()
set @FMinus = isnull(@FQtyAct,0) - isnull(@FQty,0) - isnull(@FAdjQty,0) * 1
SELECT DISTINCT @FMaxBillInterID=FMaxBillInterID FROM ICInvBackup WHERE FInterID=@FInterID 
select @FUnitGroupID = FUnitGroupID  from t_MeasureUnit where FMeasureUnitID=@FUnitID --查找单位组id
--如果该盘点方案不存在该商品
set @FCoefficient=''
select @FCoefficient = b.FCoefficient from ICInvBackUp a LEFT JOIN t_MeasureUnit b on a.FUnitID=b.FMeasureUnitID where a.FItemID=@FItemID And a.FInterID = @FInterID AND a.FAuxPropID='0' and b.FUnitGroupID=@FUnitGroupID and a.FBatchNo=@FBatchNo AND Datediff(DD,a.FKFDate,'')=0 and a.FKFPeriod='0' and a.FStockID=@FStockID  AND a.FStockPlaceID=@FStockPlaceID 
--if not Exists(@FCoefficient)
 
if(@FCoefficient is null or @FCoefficient='')
begin 
  Insert ICInvBackup
  (FInterID,FBrNo,FItemID,FAuxPropID,FUnitID,FBatchNo,FStockID,FQty,FSelect,FAdj,FAdjQty,
  FDateBackup,FMaxBillInterID,FCheckQty,FQtyAct,FAuxCheckQty,FAuxQtyAct,FAuxQty,FMinus,FNote,FStockPlaceID,FKFDate,FKFPeriod,FSecUnitID,FSecQty)
  Values(@FInterID,'0',@FItemID,0,@FUnitID,@FBatchNo
  ,@FStockID,0,0,0,0,@FDateBackup,@FMaxBillInterID
  ,@FCheckQty,@FQtyAct,@FAuxCheckQty,@FAuxQtyAct,@FAuxQty,@FMinus,''
  ,@FStockPlaceID,'',0,0,0)
end
else
begin
set @FAuxCheckQty=isnull(@FCheckQty,0)/@FCoefficient
set @FQtyAct =isnull(@FCheckQty,0)
set @FAuxQtyAct=isnull(@FCheckQty,0)/@FCoefficient
 UPDATE ICInvBackUp
  SET FCheckQty=@FCheckQty + FCheckQty,FAuxCheckQty=@FAuxCheckQty + FAuxCheckQty,
  FQtyAct=@FCheckQty + FQtyAct,FAuxQtyAct=@FAuxCheckQty + FAuxQtyAct,
      FAdjQty=@FAdjQty + FAdjQty,FSecQty=FSecQty + 0
  Where FItemID=@FItemID and FAuxPropID='0' and FUnitID IN (select FMeasureUnitID FROM t_MeasureUnit WHERE FUnitGroupID=@FUnitGroupID)
  AND FBatchNo=@FBatchNo and Datediff(DD,FKFDate,'')=0 and FKFPeriod='0' 
  AND FStockID=@FStockID and FStockPlaceID=@FStockPlaceID and FInterID = @FInterID
  UPDATE ICInvBackUp
  SET FMinus = FQtyAct - FQty - FAdjQty * 1
   Where FItemID=@FItemID and FAuxPropID='0' and FUnitID IN (select FMeasureUnitID FROM t_MeasureUnit WHERE FUnitGroupID=@FUnitGroupID)
  AND FBatchNo=@FBatchNo and Datediff(DD,FKFDate,'')=0 and FKFPeriod='0' 
  AND FStockID=@FStockID and FStockPlaceID=@FStockPlaceID and FInterID = @FInterID
end 
end
set @detailqty=@detailqty+1
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

 
