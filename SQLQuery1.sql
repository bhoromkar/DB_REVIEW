
create database store
use  store
go


create table orders(
orderid int primary key  identity(1,1) not null,
orderstatus varchar(255),
customerID int,
orderdate date
);
 insert into orders (orderstatus,customerID,orderdate)values('order purchased',1,'2023-06-05')

 select * from orders
 select * from orderlogs

create table orderlogs(
logid int primary key identity(1,1),
logmessage varchar(255),
logtimestamp datetime,
orderid int foreign key references orders(orderid)
);

--If the order does not exist, the stored procedure should throw an exception with the message "Order not found".
--If any other error occurs, the stored procedure should insert an error log entry into the OrderLogs table with the message "Error: {err

GO

create procedure spupdatethestatusoforder
@OrderId int,
@orderstatus varchar(255)
AS
BEGIN try 
begin transaction;
begin try
IF not existS(SELECT * FROM ORDERS WHERE OrderId =@OrderId )
UPDATE ORDERS SET orderstatus= @orderstatus WHERE orderid= @orderid;

insert into orderlogs(orderid,logmessage,logtimestamp)
values(@orderid,'order updated'+@orderstatus,getdate())
end try
BEGIN  catch
THROW 51001, 'Order not found',1;
END catch
commit transaction
end try
begin catch
declare @errormessage varchar(255) = error_message();
insert into orderlogs(orderid,logmessage,logtimestamp)
values(@orderid,'error: '+@orderstatus,getdate());
rollback transaction ;
end catch
go

exec spupdatethestatusoforder 1 , orderexists