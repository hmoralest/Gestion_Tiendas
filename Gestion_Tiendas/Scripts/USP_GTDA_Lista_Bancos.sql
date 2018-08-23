If Exists(Select * from sysobjects Where name = 'USP_GTDA_Lista_Bancos' And type = 'P')
	Drop Procedure USP_GTDA_Lista_Bancos
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 08/08/2018
-- Asunto			: Obtiene el Listado de todos los Bancos
-- ====================================================================================================
/*
	Exec USP_GTDA_Lista_Bancos 
*/

CREATE PROCEDURE [dbo].[USP_GTDA_Lista_Bancos]
   
AS    
BEGIN 
	
	Select 
		cod_banco			As id,
		des_razons			As razon_soc
	From [POSTGRES].[scomercial].[public].[tbanco]
	Order by razon_soc

END