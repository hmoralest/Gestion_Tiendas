USE [BdTienda]
GO

/****** Object:  Table [dbo].[Ffactc_ecom]    Script Date: 26/03/2018 11:07:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TkActivC](
	[TIENDA] [varchar](5) NOT NULL,
	[SERIE] [varchar](4) NOT NULL,
	[NUMERO] [varchar](8) NOT NULL,
	[FECHA] [datetime] NULL,
	[TIDE] [varchar](1) NULL,
	[DIDE] [varchar](15) NULL,
	[NOMCLI] [varchar](200) NULL,
	[APEPAT] [varchar](200) NULL,
	[APEMAT] [varchar](200) NULL,
	[FORPAG] [varchar](1) NULL,
	[TARJET] [varchar](2) NULL,
	[NROTAR] [varchar](16) NULL,
	[EstDBF] [varchar](1) NULL
 CONSTRAINT [PK_TkActivC] PRIMARY KEY CLUSTERED 
(
	[TIENDA] ASC,
	[SERIE] ASC,
	[NUMERO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
