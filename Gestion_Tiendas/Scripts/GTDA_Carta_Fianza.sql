USE [BDFinanzas]
GO

If Exists(Select * from sysobjects Where name = 'GTDA_Carta_Fianza' And type = 'U')
	Drop Table GTDA_Carta_Fianza
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 28/08/2018
-- Asunto			: Se creó tabla para Carta Fianza
-- ====================================================================================================

/****** Object:  Table [dbo].[GTDA_Carta_Fianza]    Script Date: 28/08/2018 12:15:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[GTDA_Carta_Fianza](
	[CarF_ContId] [varchar](10) NULL,
	[CarF_ContTipo] [varchar](1) NULL,
	[CarF_Id] [varchar](3) NULL,
	[CarF_FecIni] [smalldatetime] NULL,
	[CarF_FecFin] [smalldatetime] NULL,
	[CarF_BanId] [varchar](3) NULL,
	[CarF_BanDes] [varchar](max) NULL,
	[CarF_NroDoc] [varchar](max) NULL,
	[CarF_BenefRUC] [varchar](15) NULL,
	[CarF_BenefDesc] [varchar](max) NULL,
	[CarF_Monto] [decimal](18, 2) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


