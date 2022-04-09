USE [Змитревич ПРОДАЖИ]
GO

/****** Object:  Table [dbo].[ЗАКАЗЫ]    Script Date: 11.02.2022 18:09:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ЗАКАЗЫ](
	[Номер_заказа] [nvarchar](10) NOT NULL,
	[Наименование_товара] [nvarchar](20) NOT NULL,
	[Цена_продажи] [real] NULL,
	[Количество] [int] NULL,
	[Дата_поставки] [date] NULL,
	[Заказчик] [nvarchar](20) NULL,
 CONSTRAINT [IX_ЗАКАЗЫ] UNIQUE NONCLUSTERED 
(
	[Номер_заказа] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ЗАКАЗЫ]  WITH CHECK ADD  CONSTRAINT [FK_ЗАКАЗЫ_ЗАКАЗЧИКИ] FOREIGN KEY([Заказчик])
REFERENCES [dbo].[ЗАКАЗЧИКИ] ([Наименование_фирмы])
GO

ALTER TABLE [dbo].[ЗАКАЗЫ] CHECK CONSTRAINT [FK_ЗАКАЗЫ_ЗАКАЗЧИКИ]
GO

ALTER TABLE [dbo].[ЗАКАЗЫ]  WITH CHECK ADD  CONSTRAINT [FK_ЗАКАЗЫ_ТОВАРЫ] FOREIGN KEY([Наименование_товара])
REFERENCES [dbo].[ТОВАРЫ] ([Наименование])
GO

ALTER TABLE [dbo].[ЗАКАЗЫ] CHECK CONSTRAINT [FK_ЗАКАЗЫ_ТОВАРЫ]
GO


