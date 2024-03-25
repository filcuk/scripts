/* Replace existing table with a new one */

declare @table_act as varchar(max) = 'TABLE_NAME';
declare @table_old as varchar(max) = @table_act + '_old';
declare @table_new as varchar(max) = @table_act + '_new';

begin transaction
exec sp_rename @table_act, @table_old
exec sp_rename @table_new, @table_act
commit transaction
go
