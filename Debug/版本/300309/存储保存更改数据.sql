if (exists (select * from sys.objects where name = 'proc_UpdateQtyInStore'))
    drop proc proc_UpdateQtyInStore
go
create proc proc_UpdateQtyInStore
(
 @detailStr1 varchar(max),--��ϸ����
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
--------------��ʼ�洢����
begin
--------------����ѡ������Ϊ����ȫ���ع�
set xact_abort on
--------------��������
begin tran 
declare  
        @FQtyInStore float,         --PDAɨ������� 
        @FInterID varchar(50),      --Դ��id
        @FItemID varchar(50),       --��Ʒid
        @FRemark varchar(50),       --��ע 
        @IsExist float,             --0Ϊ������ ����1����   
        @detailqty int,             --��ϸ�����ĸ���
        @detailcount int,           --��ϸÿ�����ݵĳ��� 
        @detailIndex int,           --��ϸÿ���±�
        @countindex int             --�ָ���|������
       set @detailqty=0        
       set @detailcount=3   
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
	set @FInterID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+2)   --Դ��id
    set @FQtyInStore =dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+3)      --��װ������
    set @detailIndex=@detailIndex+1 
     update t_PCPrintBarCode set FQtyInStore=@FQtyInStore  where FInterID=@FInterID and FItemID=@FItemID   
    end
    set @detailqty=@detailqty+1
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
