If Exists(Select * from sysobjects Where name = 'USP_GTDA_Obten_Relacion_Locales' And type = 'P')
	Drop Procedure USP_GTDA_Obten_Relacion_Locales
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 09/08/2018
-- Asunto			: Obtiene Relaciones del local
-- ====================================================================================================
/*
	Exec USP_GTDA_Obten_Relacion_Locales '50102','TDA'
	Exec USP_GTDA_Obten_Relacion_Locales '22368','ALM'
*/

CREATE PROCEDURE [dbo].[USP_GTDA_Obten_Relacion_Locales](
	@cod_ent	Varchar(5),
	@tipo		Varchar(3)
)
   
AS    
BEGIN 

	IF (@tipo = 'TDA')
	BEGIN
		SElect 
			ent.cod_entid	As id, 
            ent.des_entid	As descripcion, 
            'ALM'			As tipo,
			ent.des_direc1	As direc
		From [POSTGRES].[scomercial].[public].[tentidad] ent
			Inner Join [POSTGRES].[scomercial].[public].[tentidad_almacen] alm 
				On ent.cod_entid = alm.cod_entid 
		Where ent.cod_entidp = @cod_ent
	END
	
	IF (@tipo = 'ALM')
	BEGIN
		SElect 
			ent.cod_entid	As id, 
            ent.des_entid	As descripcion, 
            'TDA'			As tipo,
			ent.des_direc1	As direc
		From [POSTGRES].[scomercial].[public].[tentidad] ent
            Inner Join [POSTGRES].[scomercial].[public].[tentidad_tienda] tda 
				On ent.cod_entid = tda.cod_entid 
		Where ent.cod_entid = (	Select cod_entidp
								From [POSTGRES].[scomercial].[public].[tentidad]
								Where cod_entid = @cod_ent)
	END

END