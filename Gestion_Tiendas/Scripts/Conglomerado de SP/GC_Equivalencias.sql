USE [BdTiendaReplica]
GO

/****** Object:  Table [dbo].[GC_Equivalencias]    Script Date: 11/04/2018 16:37:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[GC_Equivalencias](
	[GC_PrefijoTarj] [varchar](5) NOT NULL,
	[GC_ArtId] [varchar](7) NOT NULL,
	[GC_ArtSecci] [varchar](1) NOT NULL,
	[GC_MontoTarj] [decimal](18, 2) NULL,
 CONSTRAINT [PK_GC_Equivalencias] PRIMARY KEY CLUSTERED 
(
	[GC_PrefijoTarj] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


