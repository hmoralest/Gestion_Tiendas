USE [BDFinanzas]
GO

If Exists(Select * from sysobjects Where name = 'GTDA_Opciones' And type = 'U')
	Drop Table GTDA_Opciones
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 18/09/2018
-- Asunto			: Se creó tabla para  Obtener las Opciones del Sistema
-- ====================================================================================================

/****** Object:  Table [dbo].[GTDA_Opciones]    Script Date: 18/09/2018 10:18:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[GTDA_Opciones](
	[Opc_Id] [varchar](4) NOT NULL,
	[Opc_Descripcion] [varchar](max) NOT NULL,
	[Opc_Padre] [varchar](4) NULL,
	[Opc_UsuCre] [varchar](max) NULL,
	[Opc_FecCre] [smalldatetime] NULL,
	[Opc_UsuMod] [varchar](max) NULL,
	[OpcFecMod] [smalldatetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


