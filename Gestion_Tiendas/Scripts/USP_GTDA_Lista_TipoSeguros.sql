If Exists(Select * from sysobjects Where name = 'USP_GTDA_Lista_TipoSeguros' And type = 'P')
	Drop Procedure USP_GTDA_Lista_TipoSeguros
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 04/09/2018
-- Asunto			: Obtiene el Listado de los Tipos de Seguros Activos (A)
-- ====================================================================================================
/*
	Exec USP_GTDA_Lista_TipoSeguros
*/

CREATE PROCEDURE [dbo].[USP_GTDA_Lista_TipoSeguros]
   
AS    
BEGIN 
	
	Select 
		TSeg_Id				As Id,
		TSeg_Descripcion	AS descripcion
	From GTDA_Tipo_Seguro
	Where TSeg_Estado = 'A'

END