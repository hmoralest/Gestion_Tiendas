If Exists(Select * from sysobjects Where name = 'USP_GTDA_Obtener_Usuario' And type = 'P')
	Drop Procedure USP_GTDA_Obtener_Usuario
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 24/09/2018
-- Asunto			: Se creó para Obtener Usuarios
-- ====================================================================================================
/*
	Exec USP_GTDA_Obtener_Usuario '09993','ALM','','20180101','20181231','0012','Banco de la Nacion','123123123','1110','D:\Conglomerado de SP\QuitaEsp.txt' 
*/

CREATE PROCEDURE [dbo].[USP_GTDA_Obtener_Usuario](
	@login			Varchar(10),
	@contra			varchar(max)
)
   
AS    
BEGIN

	Select	Usu_Id			As ID,
			Usu_Nombres		As Nombres,
			Usu_Apellidos	As Apellidos
	From GTDA_Usuarios
	Where Usu_Login = @login
	  And dbo.USP_GTDA_Obten_Clave(Usu_Login) = @contra

END