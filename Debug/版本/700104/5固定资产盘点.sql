if (exists (select * from sys.objects where name = 'proc_CheckAsset'))
    drop proc proc_CheckAsset
go
create proc proc_CheckAsset
( 
 @detailStr1 nvarchar(max),--明细参数
 @detailStr2 nvarchar(max),
 @detailStr3 nvarchar(max),
 @detailStr4 nvarchar(max),
 @detailStr5 nvarchar(max),
 @IsCurOrReCur nvarchar(10) --判断是否启动复盘数量
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

declare @FCurNum float,              --初盘数量
        @FReCurNum float,            --复盘数量
        @FCurUserID varchar(20),     --初盘人
        @FReCurUserID varchar(20),   --复盘人
        @FCurDate varchar(30),       --初盘日期
        @FReCurDate varchar(30),     --复盘日前
        @FProjectID varchar(20),     --盘点方案ID
        @FAssetNumber varchar(50),   --资产编码 
        
        @detailqty int,              --明细参数的个数
        @detailcount int,            --明细每行数据的长度 
        @detailIndex int,            --明细每行下标
        @countindex int              --分隔符|的数量
       set @detailqty=0        
       set @detailcount=2           
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
set @FCurNum=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+1)   --初盘数量
set @FReCurNum=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+2) --复盘数量
set @FProjectID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+3)--盘点方案id
set @FAssetNumber=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+4)--编码
set @FCurDate=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+5)  --盘点日期
set @FCurUserID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+6)--盘点人
set @FCurDate=convert(varchar(10),getdate(),120)
set @FReCurDate=convert(varchar(10),getdate(),120)
set @FReCurUserID=@FCurUserID
if(@IsCurOrReCur='Cur')--初盘
begin
update t_AssetInvEntry set FCurNum=@FCurNum ,FCurUserID=@FCurUserID,FCurDate=@FCurDate where FProjectID=@FProjectID and FAssetNumber=@FAssetNumber
end
else 
begin
update t_AssetInvEntry set FReCurNum=@FReCurNum ,FReCurUserID=@FReCurUserID,FReCurDate=@FReCurDate where FProjectID=@FProjectID and FAssetNumber=@FAssetNumber
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