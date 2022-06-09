-- 1
use UNIVER;
set nocount on;

go
SELECT * from TEACHER
where PULPIT = 'ИСиТ'
FOR xml PATH('TEACHER'), root('Преподаватели_ИСиТ'), elements;

-- 2
use UNIVER;
set nocount on;

go
SELECT
	AUDITORIUM.AUDITORIUM_NAME,
	AUDITORIUM.AUDITORIUM_TYPE,
	AUDITORIUM.AUDITORIUM_CAPACITY
FROM AUDITORIUM_TYPE
JOIN AUDITORIUM ON AUDITORIUM_TYPE.AUDITORIUM_TYPE = AUDITORIUM.AUDITORIUM_TYPE
WHERE AUDITORIUM.AUDITORIUM_TYPE like 'ЛК%'
for xml AUTO, root('Лекционные_аудитории'), elements;

-- 3
use UNIVER;
set nocount on;

go
declare @h int = 0,
    @x varchar(2000) =
		'<?xml version="1.0" encoding="windows-1251" ?>
		<SUBJECTS> 
			<SUBJECT SUBJECT="subj1" SUBJECT_NAME="subj1" PULPIT="ИСиТ" />
			<SUBJECT SUBJECT="subj2" SUBJECT_NAME="subj2" PULPIT="ИСиТ" />
			<SUBJECT SUBJECT="subj3" SUBJECT_NAME="subj3" PULPIT="ИСиТ" />
		</SUBJECTS>';

exec sp_xml_preparedocument @h output, @x;
insert SUBJECT select [SUBJECT], [SUBJECT_NAME], [PULPIT]
	from openxml(@h, '/SUBJECTS/SUBJECT', 0)
	with([SUBJECT] nvarchar(10), [SUBJECT_NAME] nvarchar(100), [PULPIT] nvarchar(20))
exec sp_xml_removedocument @h;

-- 4
use UNIVER
-- delete STUDENT where STUDENT.NAME = 'ТЕСТ'
INSERT INTO STUDENT(IDGROUP, NAME, BDAY, INFO) values
	(9, 'ТЕСТ', '2000-01-01', 
		'<паспорт>
			<серия>1</серия>
			<номер>123456</номер>
			<дата_выдачи>2000-01-01</дата_выдачи>
			<адрес>Свердлова 13а</адрес>
		</паспорт>');

select * from STUDENT where NAME = 'ТЕСТ';

update STUDENT set INFO =
		'<паспорт>
			<серия>2</серия>
			<номер>654321</номер>
			<дата_выдачи>2001-01-01</дата_выдачи>
			<адрес>Свердлова 13а</адрес>
		</паспорт>'
where STUDENT.INFO.value('(/паспорт/серия)[1]','int') = 1;

select * from STUDENT where NAME = 'ТЕСТ';

select NAME, 
	INFO.value('(/паспорт/дата_выдачи)[1]', 'date') [дата_выдачи],
	INFO.value('(/паспорт/адрес)[1]', 'varchar(100)') [адрес],
	INFO.query('/паспорт') [паспорт]
from STUDENT where NAME = 'ТЕСТ';

-- 5
use UNIVER;
create xml schema collection Student_info as 
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified" 
           elementFormDefault="qualified"
           xmlns:xs="http://www.w3.org/2001/XMLSchema">
       <xs:element name="студент">  
       <xs:complexType><xs:sequence>
       <xs:element name="паспорт" maxOccurs="1" minOccurs="1">
       <xs:complexType>
       <xs:attribute name="серия" type="xs:string" use="required" />
       <xs:attribute name="номер" type="xs:unsignedInt" use="required"/>
       <xs:attribute name="дата"  use="required" >  
       <xs:simpleType>  <xs:restriction base ="xs:string">
   <xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
   </xs:restriction> 	</xs:simpleType>
   </xs:attribute> </xs:complexType> 
   </xs:element>
   <xs:element maxOccurs="3" name="телефон" type="xs:unsignedInt"/>
   <xs:element name="адрес">   <xs:complexType><xs:sequence>
   <xs:element name="страна" type="xs:string" />
   <xs:element name="город" type="xs:string" />
   <xs:element name="улица" type="xs:string" />
   <xs:element name="дом" type="xs:string" />
   <xs:element name="квартира" type="xs:string" />
   </xs:sequence></xs:complexType>  </xs:element>
   </xs:sequence></xs:complexType>
   </xs:element>
</xs:schema>';

alter table STUDENT alter column INFO xml(Student_info);
drop XML SCHEMA COLLECTION Student_info;