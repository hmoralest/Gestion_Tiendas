USE [BDFinanzas]
GO

If Exists(Select * from sysobjects Where name = 'GTDA_Pago_Terceros' And type = 'U')
	Drop Table GTDA_Pago_Terceros
GO

-- =========================================================================================
-- Author			: Henry Morales
-- Create date		: 22/08/2018
-- Description		: Almacena el detalle de Pago a Terceros (de existir)
-- =========================================================================================
-- Author			: Henry Morales
-- Create date		: 05/09/2018
-- Description		: Se modifica para relacionar directamente el Pago a 3eros al Local
-- =========================================================================================

/****** Object:  Table [dbo].[GTDA_Pago_Terceros]    Script Date: 22/08/2018 09:37:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[GTDA_Pago_Terceros](
	[Pag_CodLoc] [varchar](5) NULL,
	[Pag_TipLoc] [varchar](3) NULL,
	--[Pag_ContID] [varchar](10) NULL,
	--[Pag_ContTipo] [varchar](1) NULL,
	[Pag_Id] [varchar](2) NULL,
	[Pag_RUC] [varchar](15) NULL,
	[Pag_RazSoc] [varchar](max) NOT NULL,
	[Pag_Porc] [decimal](18, 2) NULL,
	[Pag_BanId] [varchar](3) NULL,
	[Pag_BanDes] [varchar](max) NULL,
	[Pag_BanCta] [varchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


