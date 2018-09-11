USE [BDFinanzas]
GO

If Exists(Select * from sysobjects Where name = 'GTDA_Tipo_Seguro' And type = 'U')
	Drop Table GTDA_Tipo_Seguro
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 04/09/2018
-- Asunto			: Se creó tabla para Almacenar los diferentes tipos de Seguros
-- ====================================================================================================
/****** Object:  Table [dbo].[GTDA_Tipo_Seguro]    Script Date: 4/09/2018 09:13:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[GTDA_Tipo_Seguro](
	[TSeg_Id] [varchar](3) NULL,
	[TSeg_Descripcion] [varchar](max) NULL,
	[TSeg_Estado] [varchar](1) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


