-- Создание + заполнение таблиц

create table Containers
(
	ID uniqueidentifier primary key default newid(),
	Number int not null,
	Type varchar(50) not null,
	Length int not null,
	Width int not null,
	Height int not null,
	Weight int not null,
	IsEmpty bit not null,
	ReceiptDate datetime not null
);


insert into Containers (ID, Number, Type, Length, Width, Height, Weight, IsEmpty, ReceiptDate)
values ('5EE8A124-1D4C-4470-A692-080A4C1016E6', 156, '40', 400, 200, 200, 100, 0, '2020/05/15 14:13:00'),
('6314D380-9E9D-4F45-8644-25E22EC66366', 100, '40', 400, 200, 200, 100, 0, '2020/05/15 12:10:00')


create table Operations
(
	ID uniqueidentifier primary key default newid(),
	ContainerID uniqueidentifier not null,
	StartDate datetime not null,
	EndDate datetime not null,
	Type varchar(50) not null,
	FIO varchar(150) not null,
	InspectLocation varchar(150) not null,
	foreign key (ContainerID) references Containers (ID)
);


insert into Operations (ContainerID, StartDate, EndDate, Type, FIO, InspectLocation)
values ('5EE8A124-1D4C-4470-A692-080A4C1016E6', '2024-02-09 10:55', '2024-02-09 11:55', 'Погрузка', 'Васильев В.В.', 'Какой-то адрес'),
('5EE8A124-1D4C-4470-A692-080A4C1016E6', '2024-02-09 11:55', '2024-02-09 11:55', 'Отправка', 'Петров В.В.', 'Какой-то адрес'),
('6314D380-9E9D-4F45-8644-25E22EC66366', '2024-02-09 11:55', '2024-02-09 11:55', 'Отправка', 'Петров В.В.', 'Какой-то адрес')


-- Контейнеры
-- формирование json встроенными средствами 
select ID, Number, Type, Length, Width, Height, Weight, IsEmpty, ReceiptDate
from Containers
for json path


declare @ID uniqueidentifier, @Number int, @Type varchar(50), @Length int, @Width int, @Height int, @Weight int, @IsEmpty int, @ReceiptDate datetime, @json varchar(max) = ''

-- формирование json с использованием курсора
declare containers_cursor cursor for 
	select ID, Number, Type, Length, Width, Height, Weight, IsEmpty, ReceiptDate
	from Containers

open containers_cursor

fetch next from containers_cursor
into @ID, @Number, @Type, @Length, @Width, @Height, @Weight, @IsEmpty, @ReceiptDate
  
while @@FETCH_STATUS = 0  
begin
	set @json = @json + concat('{'
			, '"ID": "', @ID, '", '
			, '"Number": ', @Number, ', '
			, '"Type": "', @Type, '", '
			, '"Length": ', @Length, ', '
			, '"Width": ', @Width, ', '
			, '"Height": ', @Height, ', '
			, '"Weight": ', @Weight, ', '
			, '"IsEmpty": ', case when @IsEmpty = 1 then 'true' else 'false' end, ', '
			, '"ReceiptDate": "', format(@ReceiptDate, 'yyyy-MM-dd hh:mm:ss'), '"'
			, '},')

	fetch next from containers_cursor
	into @ID, @Number, @Type, @Length, @Width, @Height, @Weight, @IsEmpty, @ReceiptDate
end

deallocate containers_cursor

-- Результат
select case when len(@json) > 0 then '[' + substring(@json, 1, len(@json) - 1) + ']' end



-- Операции
-- формирование json встроенными средствами 
select ID, ContainerID, StartDate, EndDate, Type, FIO, InspectLocation
from Operations
where ContainerID = '5EE8A124-1D4C-4470-A692-080A4C1016E6'
for json path

declare @ContainerID uniqueidentifier, @StartDate datetime, @EndDate datetime, @FIO varchar(150), @InspectLocation varchar(150)
set @json = ''

-- формирование json с использованием курсора
declare operations_cursor cursor for
	select ID, ContainerID, StartDate, EndDate, Type, FIO, InspectLocation
	from Operations
	where ContainerID = '5EE8A124-1D4C-4470-A692-080A4C1016E6'

open operations_cursor

fetch next from operations_cursor
into @ID, @ContainerID, @StartDate, @EndDate, @Type, @FIO, @InspectLocation
  
while @@FETCH_STATUS = 0  
begin
	set @json = @json + concat('{'
			, '"ID": "', @ID, '", '
			, '"ContainerID": "', @ContainerID, '", '
			, '"StartDate": "', format(@StartDate, 'yyyy-MM-dd hh:mm:ss'), '", '
			, '"EndDate": "', format(@EndDate, 'yyyy-MM-dd hh:mm:ss'), '", '
			, '"Type": "', @Type, '", '
			, '"FIO": "', @FIO, '", '
			, '"InspectLocation": "', @InspectLocation, '"'
			, '},')

	fetch next from operations_cursor
	into @ID, @ContainerID, @StartDate, @EndDate, @Type, @FIO, @InspectLocation
end

deallocate operations_cursor

-- Результат
select case when len(@json) > 0 then '[' + substring(@json, 1, len(@json) - 1) + ']' end
