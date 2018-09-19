USE [BDFinanzas]
GO

If Exists(Select * from sysobjects Where name = 'GTDA_Usuarios' And type = 'U')
	Drop Table GTDA_Usuarios
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 18/09/2018
-- Asunto			: Se creó tabla para Usuarios
-- ====================================================================================================
/****** Object:  Table [dbo].[GTDA_Usuarios]    Script Date: 18/09/2018 08:54:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[GTDA_Usuarios](
	[Usu_Id] [varchar](3) NOT NULL,
	[Usu_Nombres] [varchar](max) NULL,
	[Usu_Apellidos] [varchar](max) NULL,
	[Usu_Login] [varchar](10) NOT NULL,
	[Usu_Contraseña] [varbinary](8000) NOT NULL,
	[Usu_UsuCre] [varchar](max) NULL,
	[Usu_FecCre] [smalldatetime] NULL,
	[Usu_UsuMod] [varchar](max) NULL,
	[Usu_FecMod] [smalldatetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

