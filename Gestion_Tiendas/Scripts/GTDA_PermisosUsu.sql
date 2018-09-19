USE [BDFinanzas]
GO

If Exists(Select * from sysobjects Where name = 'GTDA_PermisosUsu' And type = 'U')
	Drop Table GTDA_PermisosUsu
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 18/09/2018
-- Asunto			: Se creó tabla para  Gestión de Permisos
-- Tipo				: T - Todo
--					  L - Solo Lectura
-- ====================================================================================================

/****** Object:  Table [dbo].[GTDA_PermisosUsu]    Script Date: 18/09/2018 10:18:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[GTDA_PermisosUsu](
	[Perm_UsuId] [varchar](3) NOT NULL,
	[Perm_OpcId] [varchar](4) NOT NULL,
	[Perm_Tipo] [varchar](1) NOT NULL
) ON [PRIMARY]
GO


