USE [BDFinanzas]
GO

If Exists(Select * from sysobjects Where name = 'GTDA_Seguros' And type = 'U')
	Drop Table GTDA_Seguros
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 04/09/2018
-- Asunto			: Se creó tabla para Almacenar los Seguros
-- ====================================================================================================
/****** Object:  Table [dbo].[GTDA_Seguros]    Script Date: 4/09/2018 10:19:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[GTDA_Seguros](
	[Seg_EntId] [varchar](5) NULL,
	[Seg_EntTip] [varchar](3) NULL,
	[Seg_Id] [varchar](5) NULL,
	[Seg_Tipo] [varchar](3) NULL,
	[Seg_FecIni] [smalldatetime] NULL,
	[Seg_FecFin] [smalldatetime] NULL,
	[Seg_AsegRUC] [varchar](15) NOT NULL,
	[Seg_AsegRazSoc] [varchar](max) NOT NULL,
	[Seg_NroDoc] [varchar](max) NOT NULL,
	[Seg_BenefRUC] [varchar](15) NOT NULL,
	[Seg_BenefRazSoc] [varchar](max) NOT NULL,
	[Seg_Cant] [decimal](18, 2) NOT NULL,
	[Seg_Unidad] [varchar](30) NOT NULL,
	[Seg_Valor] [decimal](18, 2) NOT NULL,
	[Seg_RutaDoc] [varchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


