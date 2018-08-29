USE [BDFinanzas]
GO

If Exists(Select * from sysobjects Where name = 'GTDA_Estado_Locales' And type = 'U')
	Drop Table GTDA_Estado_Locales
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 24/08/2018
-- Asunto			: Se creó tabla para  Almacenar Estados
-- Estados			:
--					  Sin Contrato
--					  Contrato Vigente
--					  Contrato por Vencer
--					  Contrato Vencido
-- ====================================================================================================

/****** Object:  Table [dbo].[GTDA_Estado_Locales]    Script Date: 24/08/2018 18:02:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[GTDA_Estado_Locales](
	[Est_LocId] [varchar](5) NOT NULL,
	[Est_LocTipo] [varchar](3) NOT NULL,
	[Est_ContId] [varchar](10) NULL,
	[Est_ContTipo] [varchar](1) NULL,
	[Est_FechaVig] [smalldatetime] NULL,
	[Est_Estado] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
