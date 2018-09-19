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
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 12/09/2018
-- Asunto			: Se agregaron campos de Monitoreo por Usuarios
-- ====================================================================================================

/****** Object:  Table [dbo].[GTDA_Carta_Fianza]    Script Date: 28/08/2018 12:15:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[GTDA_Carta_Fianza](
	[CarF_EntCod] [varchar](5) NULL,
	[CarF_EntTip] [varchar](3) NULL,
	[CarF_Id] [varchar](4) NULL,
	[CarF_FecIni] [smalldatetime] NULL,
	[CarF_FecFin] [smalldatetime] NULL,
	[CarF_BanId] [varchar](4) NULL,
	[CarF_BanDes] [varchar](max) NULL,
	[CarF_NroDoc] [varchar](max) NULL,
	[CarF_BenefRUC] [varchar](15) NULL,
	[CarF_BenefDesc] [varchar](max) NULL,
	[CarF_Monto] [decimal](18, 2) NULL,
	[CarF_RutaDoc] [varchar](max) NULL,
	/*Se agregó control de Usuario*/
	[CarF_UsuCre] [varchar](max) NULL,
	[CarF_FecCre] [smalldatetime] NULL,
	[CarF_UsuMod] [varchar](max) NULL,
	[CarF_FecMod] [smalldatetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


