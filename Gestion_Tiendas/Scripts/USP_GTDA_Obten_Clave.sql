If Exists(Select * from sysobjects Where name = 'USP_GTDA_Obten_Clave' And type = 'FN')
	Drop Function USP_GTDA_Obten_Clave
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 18/09/2018
-- Asunto			: DesEncripta Contraseña para Usuarios
-- ====================================================================================================
/*
	Select dbo.USP_GTDA_Obten_Clave('Bata2018')
*/

CREATE FUNCTION USP_GTDA_Obten_Clave 
(
    @clave VARBINARY(8000)
)
RETURNS VARCHAR(max)
AS
BEGIN
    
    
    DECLARE @pass AS VARCHAR(max)
    ------------------------------------
    ------------------------------------
    --Se descifra el campo aplicandole la misma llave con la que se cifro GTDA_Clave
    SET @pass = DECRYPTBYPASSPHRASE('GTDA_Clave',@clave)
    ------------------------------------
    ------------------------------------    
    RETURN @pass

END
GO