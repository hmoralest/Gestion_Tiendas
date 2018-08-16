If Exists(Select * from sysobjects Where name = 'USP_GTDA_Valida_Proveedor' And type = 'P')
	Drop Procedure USP_GTDA_Valida_Proveedor
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 08/08/2018
-- Asunto			: Obtiene el Contrato Actual, con los datos actualizados por Adendas
-- ====================================================================================================
/*
	Exec USP_GTDA_Valida_Proveedor '20514714828'
*/

CREATE PROCEDURE [dbo].[USP_GTDA_Valida_Proveedor](
	@RUC		Varchar(15)
)
   
AS    
BEGIN 

	Select 
		ent.des_entid			As razon_social
	From [POSTGRES].[scomercial].[public].[tentidad] ent
		Inner Join [POSTGRES].[scomercial].[public].[tentidad_proveedor] prov
			On ent.cod_entid = prov.cod_entid
	Where ltrim(rtrim(ent.nro_ruc)) = ltrim(rtrim(@RUC))

END
