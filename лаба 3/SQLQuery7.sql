USE master
GO

CREATE DATABASE [??_TSQL_MyBase]
 ON  PRIMARY 
( NAME = N'??_TSQL_MyBase', FILENAME = N'C:\Users\diana\Desktop\??\MSSQL15.MSSQLSERVER\MSSQL\DATA\??_TSQL_MyBase.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB ),
 filegroup FG1
( NAME = N'??_TSQL_MyBase_fg1', FILENAME = N'C:\Users\diana\Desktop\??\MSSQL15.MSSQLSERVER\MSSQL\DATA\??_TSQL_MyBase_fg1.ndf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'??_TSQL_MyBase_log', FILENAME = N'C:\Users\diana\Desktop\??\MSSQL15.MSSQLSERVER\MSSQL\DATA\??_TSQL_MyBase_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO