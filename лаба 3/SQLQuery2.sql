use ��_TSQL_MyBase
CREATE table ����_��������
( ��������_����_������� nvarchar(50) primary key,
  ������ real not null
);

CREATE table �����
( ��������_����� nvarchar(50) primary key,
  ���_������������� nvarchar(20) not null,
  ����� nvarchar(50),
  ������� nvarchar(12),
  ����������_���� nvarchar(20)
);

CREATE table �����������_�������
( �����_������� int primary key,
  ���_������� nvarchar(50) foreign key references ����_�������� (��������_����_�������),
  �����_������ nvarchar(50) foreign key references ����� (��������_�����),
  ����� real,
  ����_������ date
);