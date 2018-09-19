USE [BDFinanzas]
GO
If Exists(Select * from sysobjects Where name = 'GTDA_Cronograma_Pagos' And type = 'U')
	Drop Table GTDA_Cronograma_Pagos
GO

-- =====================================================================
-- Author			: Henry Morales
-- Create date		: 07/08/2018
-- Description		: Almacena las cuotas grabadas en detalle 
-- =====================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 12/09/2018
-- Asunto			: Se agregaron campos para gestión de Cambios
-- ====================================================================================================

/****** Object:  Table [dbo].[GTDA_Cronograma_Pagos]    Script Date: 20/08/2018 17:20:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[GTDA_Cronograma_Pagos](
	[Cron_ContId] [varchar](10) NULL,
	[Cron_ContTipo] [varchar](1) NULL,
	[Cron_Nro] [varchar](2) NULL,
	[Cron_RenFija] [decimal](18, 2) NOT NULL,
	[Cron_RenVar] [decimal](18, 2) NOT NULL,
	[Cron_FecIni] [smalldatetime] NULL,
	[Cron_FecFin] [smalldatetime] NULL,
	[Cron_DesVigencia] [varchar](max) NOT NULL,
	[Cron_UsuCre] [varchar](max) NULL,
	[Cron_FecCre] [smalldatetime] NULL,
	[Cron_UsuMod] [varchar](max) NULL,
	[Cron_FecMod] [smalldatetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


