USE [BDFinanzas]
GO

If Exists(Select * from sysobjects Where name = 'GTDA_Contratos' And type = 'U')
	Drop Table GTDA_Contratos
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 08/08/2018
-- Asunto			: Se creó tabla para  Documentos (Contratos y Adendas)
-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 03/09/2018
-- Asunto			: Se agrego Cont_Reten para guardar indicador de Retención 1ra Categ
-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 06/09/2018
-- Asunto			: Se comentó los flag de obligatorio Carta Fianza, seguro y Pago a Terceros
--					  Se traslado a dependencia directa a locales
-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 12/09/2018
-- Asunto			: Se agregaron campos para gestión de Cambios
-- ====================================================================================================

/****** Object:  Table [dbo].[GTDA_Contratos]    Script Date: 08/08/2018 14:07:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[GTDA_Contratos](
	[Cont_Id] [varchar](10) NOT NULL,
	[Cont_TipoCont] [varchar](1) NOT NULL,
	[Cont_PadreID] [varchar](10) NULL,
	[Cont_EntidId] [varchar](5) NOT NULL,
	[Cont_TipEnt] [varchar](3) NOT NULL,
	[Cont_CodInt] [varchar](max) NULL,
	[Cont_Area] [decimal](18, 2) NULL,
	[Cont_FecIni] [smalldatetime] NULL,
	[Cont_FecFin] [smalldatetime] NULL,
	[Cont_Moneda] [varchar](3) NULL,
	[Cont_Arrenda] [varchar](max) NULL,
	[Cont_Adminis] [varchar](max) NULL,
	[Cont_RentFija] [decimal](18, 2) NULL,
	[Cont_RentVar] [decimal](18, 2) NULL,
	[Cont_Adela] [decimal](18, 2) NULL,
	[Cont_Garantia] [decimal](18, 2) NULL,
	[Cont_Ingreso] [decimal](18, 2) NULL,
	[Cont_RevProy] [decimal](18, 2) NULL,
	[Cont_FondProm] [decimal](18, 2) NULL,
	[Cont_FondPromVar] [decimal](18, 2) NULL,
	[Cont_GComunFijo] [decimal](18, 2) NULL,
	[Cont_GComunFijo_P] [bit] NULL,
	[Cont_GComunVar] [decimal](18, 2) NULL,
	[Cont_Reten] [bit] NULL,
	[Cont_DbJul] [bit] NULL,
	[Cont_DbDic] [bit] NULL,
	[Cont_ServPub] [bit] NULL,
	[Cont_ArbMunic] [bit] NULL,
	[Cont_IPC_RentFija] [bit] NULL,
	[Cont_IPC_FondProm] [bit] NULL,
	[Cont_IPC_GComun] [bit] NULL,
	[Cont_IPC_Frecue] [smallint] NULL,
	[Cont_IPC_Fec] [smalldatetime] NULL,
	--[Cont_PagoTercer] [bit] NULL,
	--[Cont_CartFianza] [bit] NULL,
	--[Cont_OblSegur] [bit] NULL,
	[Cont_RutaPlano] [varchar](max) NULL,
	[Cont_RutaCont] [varchar](max) NULL,
	[Cont_UsuCre] [varchar](max) NULL,
	[Cont_FecCre] [smalldatetime] NULL,
	[Cont_UsuMod] [varchar](max) NULL,
	[Cont_FecMod] [smalldatetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
