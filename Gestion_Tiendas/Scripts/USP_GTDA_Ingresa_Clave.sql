If Exists(Select * from sysobjects Where name = 'USP_GTDA_Ingresa_Clave' And type = 'FN')
	Drop Function USP_GTDA_Ingresa_Clave
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 18/09/2018
-- Asunto			: Encripta Contraseña para Usuarios
-- ====================================================================================================
/*
	Select dbo.USP_GTDA_Ingresa_Clave('Bata2018')
*/

CREATE FUNCTION [dbo].[USP_GTDA_Ingresa_Clave] 
(
    @clave VARCHAR(max)
)
RETURNS VarBinary(8000)
AS
BEGIN
    
    
    DECLARE @pass AS VarBinary(8000)
    ------------------------------------
    ------------------------------------
    SET @pass = ENCRYPTBYPASSPHRASE('GTDA_Clave',@clave)--dbCurso09 es la llave para cifrar el campo.
    ------------------------------------
    ------------------------------------    
    RETURN @pass

END