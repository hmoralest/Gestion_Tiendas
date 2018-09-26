If Exists(Select * from sysobjects Where name = 'USP_DatosPromocion_Gral' And type = 'P')
	Drop Procedure USP_DatosPromocion_Gral
GO

-- ==========================================================================================
-- Author		: Henry Morales
-- Create date	: 21/02/2018
-- Description	: Obtiene datos de cabecera de la Promocion
-- ==========================================================================================
-- tablas		: promociones_cab
-- ==========================================================================================
/*
	Exec USP_DatosPromocion_Gral
*/

CREATE Procedure USP_DatosPromocion_Gral(
	@id_promo	Varchar(8)
)
AS 
BEGIN

	Select	*
	From promociones_cab
	Where idpromo = @id_promo;

END