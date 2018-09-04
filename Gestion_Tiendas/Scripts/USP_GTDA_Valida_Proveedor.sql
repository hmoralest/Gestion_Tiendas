If Exists(Select * from sysobjects Where name = 'USP_GTDA_Valida_Proveedor' And type = 'P')
	Drop Procedure USP_GTDA_Valida_Proveedor
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 08/08/2018
-- Asunto			: Obtiene el Contrato Actual, con los datos actualizados por Adendas
-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 03/09/2018
-- Asunto			: Se modificó para obtener los tipos de entidades correctos
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
		Inner Join [POSTGRES].[scomercial].[public].[tentidad_rela_tipo] tipos
			On ent.cod_entid = tipos.cod_entid And tipos.cod_tipent  IN ('PR','PP')
	--	Inner Join [POSTGRES].[scomercial].[public].[tentidad_proveedor] prov
	--		On ent.cod_entid = prov.cod_entid
	Where ltrim(rtrim(ent.nro_ruc)) = ltrim(rtrim(@RUC))

END
