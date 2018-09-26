USE [BdAquarella]
GO

/****** Object:  Table [dbo].[promociones_aprob]    Script Date: 27/02/2018 11:19:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[promociones_user_aprob](
	[iduser] [varchar](3) NOT NULL,
	[nombres] [varchar](100) NOT NULL,
	[apellidos] [varchar](100) NOT NULL,
	[email] [varchar](100) NOT NULL,
	[estado] [char](1) NOT NULL,
	[fecreg] [datetime] NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[promociones_user_aprob] ADD  CONSTRAINT [DF_promociones_user_aprob_fecreg]  DEFAULT (getdate()) FOR [fecreg]
GO


