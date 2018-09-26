USE [BdAquarella]
GO

/****** Object:  Table [dbo].[promociones_aprob]    Script Date: 26/02/2018 17:15:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[promociones_aprob](
	[idpromo] [varchar](8) NOT NULL,
	[iduser] [varchar](3) NOT NULL,
	[complemento] [varchar](100) NOT NULL,
	[estado] [char](1) NOT NULL,
	[fecreg] [datetime] NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[promociones_aprob] ADD  CONSTRAINT [DF_promociones_aprob_fecreg]  DEFAULT (getdate()) FOR [fecreg]
GO


