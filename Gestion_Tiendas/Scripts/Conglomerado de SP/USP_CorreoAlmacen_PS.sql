If Exists(Select * from sysobjects Where name = 'USP_CorreoAlmacen_PS' And type = 'P')
	Drop Procedure USP_CorreoAlmacen_PS
GO

-- =====================================================================
-- Author		: Henry Morales
-- Create date	: 07-03-2018
-- Description	: Env�a correo al �rea de almac�n para rehacer Saldos
-- =====================================================================
/*
	Exec USP_CorreoAlmacen_PS 
*/

CREATE Procedure USP_CorreoAlmacen_PS
AS 
BEGIN

	DECLARE	@email		varchar(max),
			@asunto		varchar(max),
			@cuerpo		varchar(max)

	SET		@email	= 'henry.morales@tawa.com.pe';
	
	SET		@asunto = '[Almacen E-Commerce] Diferencia en Saldos de Stock';
		
	SET		@cuerpo	 =	'Estimados Srs. de Almacen,<br><br>';
	SET		@cuerpo +=	'El sistema de la tienda virtual le informa que debido a una Excepci�n los saldos del almac�n correspondiente a E-Commerce ';
	SET		@cuerpo +=	'posiblemente no esten cuadrando, por lo cual se les solicita que realicen el re-c�lculo de saldos para este almac�n.<br><br>';
	SET		@cuerpo +=	'Atte: Tienda Virtual.';

	Exec USP_EnviarCorreos @email,@asunto,@cuerpo,null
END