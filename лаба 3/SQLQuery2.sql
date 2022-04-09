use Зм_TSQL_MyBase
CREATE table ТИПЫ_КРЕДИТОВ
( Название_вида_кредита nvarchar(50) primary key,
  Ставка real not null
);

CREATE table ФИРМЫ
( Название_фирмы nvarchar(50) primary key,
  Вид_собственности nvarchar(20) not null,
  Адрес nvarchar(50),
  Телефон nvarchar(12),
  Контактное_лицо nvarchar(20)
);

CREATE table ОФОРМЛЕННЫЕ_КРЕДИТЫ
( Номер_кредита int primary key,
  Вид_кредита nvarchar(50) foreign key references ТИПЫ_КРЕДИТОВ (Название_вида_кредита),
  Фирма_клиент nvarchar(50) foreign key references ФИРМЫ (Название_фирмы),
  Сумма real,
  Дата_выдачи date
);