USE [Змитревич ПРОДАЖИ]
GO

/****** Object:  Table [dbo].[ЗАКАЗЧИКИ]    Script Date: 11.02.2022 18:09:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ЗАКАЗЧИКИ](
	[Наименование_фирмы] [nvarchar](20) NOT NULL,
	[Адрес] [nvarchar](50) NULL,
	[Расчетный_счет] [nvarchar](15) NULL,
 CONSTRAINT [IX_ЗАКАЗЧИКИ] UNIQUE NONCLUSTERED 
(
	[Наименование_фирмы] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


