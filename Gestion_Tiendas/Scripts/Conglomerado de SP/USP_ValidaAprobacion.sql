If Exists(Select * from sysobjects Where name = 'USP_ValidaAprobacion' And type = 'P')
	Drop Procedure USP_ValidaAprobacion
GO

-- ==========================================================================================
-- Author		: Henry Morales
-- Create date	: 22/02/2018
-- Description	: Valida si ya ha realizado una aprobación / rechazo
-- @estado		: 0 = No existe registro
--				  1 = Existe Aprobación Previa
--				  2 = Existe Rechazo Previo
-- ==========================================================================================
-- tablas		: aprobaciones
-- ==========================================================================================
/*
	Exec USP_ValidaAprobacion 'prueba','001'
*/

CREATE Procedure USP_ValidaAprobacion(
	@id_promo		Varchar(8),
	@cod_user		Varchar(3)
)
AS 
BEGIN

	Declare @estado Int;

	IF Exists (	Select 1	From promociones_aprob	Where iduser = @cod_user And idpromo = @id_promo)
	BEGIN
		Select @estado =	CASE estado	WHEN 'A' THEN 1
										WHEN 'R' THEN 2
							END
		From promociones_aprob	
		Where iduser = @cod_user And idpromo = @id_promo
	END
	ELSE
		Set @estado = 0;

	Select @estado as estado;

END