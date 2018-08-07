if (exists (select * from sys.objects where name = 'proc_UpdateQtyInStore'))
    drop proc proc_UpdateQtyInStore
go
create proc proc_UpdateQtyInStore
(
 @detailStr1 varchar(max),--明细参数
 @detailStr2 varchar(max),
 @detailStr3 varchar(max),
 @detailStr4 varchar(max),
 @detailStr5 varchar(max),
 @detailStr6 varchar(max),
 @detailStr7 varchar(max),
 @detailStr8 varchar(max),
 @detailStr9 varchar(max),
 @detailStr10 varchar(max) 
)
as
set nocount on
--------------开始存储过程
begin
--------------事务选项设置为出错全部回滚
set xact_abort on
--------------开启事务
begin tran 
declare  
        @FQtyInStore float,         --PDA扫描的数量 
        @FInterID varchar(50),      --源单id
        @FItemID varchar(50),       --商品id
        @FRemark varchar(50),       --备注 
        @IsExist float,             --0为不存在 大于1存在   
        @detailqty int,             --明细参数的个数
        @detailcount int,           --明细每行数据的长度 
        @detailIndex int,           --明细每行下标
        @countindex int             --分隔符|的数量
       set @detailqty=0        
       set @detailcount=3   
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
	set @FInterID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+2)   --源单id
    set @FQtyInStore =dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+3)      --已装箱数量
    set @detailIndex=@detailIndex+1 
     update t_PCPrintBarCode set FQtyInStore=@FQtyInStore  where FInterID=@FInterID and FItemID=@FItemID   
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
