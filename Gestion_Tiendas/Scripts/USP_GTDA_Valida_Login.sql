If Exists(Select * from sysobjects Where name = 'USP_GTDA_Valida_Login' And type = 'P')
	Drop Procedure USP_GTDA_Valida_Login
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 24/09/2018
-- Asunto			: Se creó para Validar los Login de  Usuarios
-- ====================================================================================================
/*
	Exec USP_GTDA_Valida_Login '09993'
*/

CREATE PROCEDURE [dbo].[USP_GTDA_Valida_Login](
	@login			Varchar(10)
)
   
AS    
BEGIN

	Select *
	From GTDA_Usuarios
	Where Usu_Login = @login

END