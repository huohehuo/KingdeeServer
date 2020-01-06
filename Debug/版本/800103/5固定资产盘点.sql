if (exists (select * from sys.objects where name = 'proc_CheckAsset'))
    drop proc proc_CheckAsset
go
create proc proc_CheckAsset
( 
 @detailStr1 nvarchar(max),--��ϸ����
 @detailStr2 nvarchar(max),
 @detailStr3 nvarchar(max),
 @detailStr4 nvarchar(max),
 @detailStr5 nvarchar(max),
 @IsCurOrReCur nvarchar(10) --�ж��Ƿ�������������
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

declare @FCurNum float,              --��������
        @FReCurNum float,            --��������
        @FCurUserID varchar(20),     --������
        @FReCurUserID varchar(20),   --������
        @FCurDate varchar(30),       --��������
        @FReCurDate varchar(30),     --������ǰ
        @FProjectID varchar(20),     --�̵㷽��ID
        @FAssetNumber varchar(50),   --�ʲ����� 
        
        @detailqty int,              --��ϸ�����ĸ���
        @detailcount int,            --��ϸÿ�����ݵĳ��� 
        @detailIndex int,            --��ϸÿ���±�
        @countindex int              --�ָ���|������
       set @detailqty=0        
       set @detailcount=2           
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
set @FCurNum=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+1)   --��������
set @FReCurNum=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+2) --��������
set @FProjectID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+3)--�̵㷽��id
set @FAssetNumber=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+4)--����
set @FCurDate=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+5)  --�̵�����
set @FCurUserID=dbo.getString(@detailStr1,'|',@detailcount*@detailIndex+6)--�̵���
set @FCurDate=convert(varchar(10),getdate(),120)
set @FReCurDate=convert(varchar(10),getdate(),120)
set @FReCurUserID=@FCurUserID
if(@IsCurOrReCur='Cur')--����
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
--------------���ڴ���
if(0<>@@error)
	goto error1
--------------�ع�����	
error1:
	rollback tran;
--------------�����洢����
end 