If Exists(Select * from sysobjects Where name = 'USP_GTDA_Lista_Documentos_TDA' And type = 'P')
	Drop Procedure USP_GTDA_Lista_Documentos_TDA
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 08/08/2018
-- Asunto			: Obtiene el Listado de todos los documentos que tiene la tienda:
-- ====================================================================================================
/*
	Exec USP_GTDA_Lista_Documentos_TDA '',''
*/

CREATE PROCEDURE [dbo].[USP_GTDA_Lista_Documentos_TDA](
	@cod_ent	Varchar(5),
	@tipo_ent	Varchar(3)
)
   
AS    
BEGIN 
	
	Select 
		Cont_Id			As Id,
		Cont_TipoCont	As Tipo,
		Cont_PadreID	As padre,
		Cont_FecIni		As fec_ini,
		Cont_FecFin		As fec_fin,
		'desde: '+CONVERT(varchar,Cont_FecIni,103)+' hasta: '+CONVERT(varchar,Cont_FecFin,103)	As vigencia
	From GTDA_Contratos
	Where (Cont_EntidId = @cod_ent or @cod_ent = '')
	  And (Cont_TipEnt = @tipo_ent or @tipo_ent = '')
	Order by isnull(Cont_PadreID,Cont_Id) ASC, Id Asc

END