If Exists(Select * from sysobjects Where name = 'USP_GTDA_Lista_Contratos_TDA' And type = 'P')
	Drop Procedure USP_GTDA_Lista_Contratos_TDA
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 14/08/2018
-- Asunto			: Obtiene el Listado de Contratos
-- ====================================================================================================
/*
	Exec USP_GTDA_Lista_Contratos_TDA '20514714828'
*/

CREATE PROCEDURE [dbo].[USP_GTDA_Lista_Contratos_TDA](
	@cod_ent	Varchar(5),
	@tipo_ent	Varchar(3)
)
   
AS    
BEGIN 

	Select
		Cont_Id										As Id,
		Convert(Varchar, Cont_FecIni, 103)			As Fecha_Ini,
		Convert(Varchar, Cont_FecFin, 103)			As Fecha_Fin,
		'desde ' + Convert(Varchar, Cont_FecIni, 103) + ' hasta ' +Convert(Varchar, Cont_FecFin, 103)	As descripcion
	From GTDA_Contratos
	Where Cont_EntidId = @cod_ent
	  And Cont_TipEnt = @tipo_ent
	  And Cont_TipoCont = 'C'
	Order by Fecha_Ini DESC

END
