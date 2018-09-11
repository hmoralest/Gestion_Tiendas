If Exists(Select * from sysobjects Where name = 'USP_GTDA_Obten_Datos_Locales' And type = 'P')
	Drop Procedure USP_GTDA_Obten_Datos_Locales
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 09/08/2018
-- Asunto			: Obtiene Datos del Contrato Actual
-- ====================================================================================================
/*
	Exec USP_GTDA_Obten_Datos_Locales '50102','TDA'
*/

CREATE PROCEDURE [dbo].[USP_GTDA_Obten_Datos_Locales](
	@cod_ent	Varchar(5),
	@tipo		Varchar(3)
)
   
AS    
BEGIN 

	Select
		ent.cod_entid					As Id,
		ent.des_entid					As nombre,
		ubigeo.descripcion				As dist,
		ent.des_direc1					As direc,
		@tipo							As tipo,
		isnull(est.Est_CodInt,'')		As cod_int
	From [POSTGRES].[scomercial].[public].[tentidad] ent
		Left Join 
		(
			Select 
				u1.cod_dpto + u1.cod_prov + u1.cod_dist						As codigo,
				u3.des_ubigeo + ' / ' + u2.des_ubigeo + ' / ' + u1.des_ubigeo	As descripcion
			From [POSTGRES].[scomercial].[public].[tubigeo] u1
				Inner Join [POSTGRES].[scomercial].[public].[tubigeo] u2
					On u1.cod_dpto = u2.cod_dpto And u1.cod_prov = u2.cod_prov And u2.cod_dist='00'
				Inner Join [POSTGRES].[scomercial].[public].[tubigeo] u3
					On u1.cod_dpto = u3.cod_dpto And u3.cod_prov = '00' And u3.cod_dist='00'
			Where u1.cod_prov <> '00' And u1.cod_dist <> '00'									)	ubigeo
			On ent.cod_ubige1 = ubigeo.codigo
		Left Join GTDA_Estado_Locales est
			On ent.cod_entid = est.Est_LocId And est.Est_LocTipo = @tipo
	Where ent.cod_entid = @cod_ent


END