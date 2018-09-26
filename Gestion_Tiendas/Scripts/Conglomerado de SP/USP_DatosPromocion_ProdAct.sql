If Exists(Select * from sysobjects Where name = 'USP_DatosPromocion_ProdAct' And type = 'P')
	Drop Procedure USP_DatosPromocion_ProdAct
GO

-- ==========================================================================================
-- Author		: Henry Morales
-- Create date	: 21/02/2018
-- Description	: Obtiene datos de la Promocion, de los productos que la activan
-- ==========================================================================================
-- tablas		: promociones_det1
--				  [BdTienda].[dbo].[tarticulo]
-- ==========================================================================================
/*
	Exec USP_DatosPromocion_ProdAct
*/

CREATE Procedure USP_DatosPromocion_ProdAct(
	@id_promo	Varchar(8)
)
AS 
BEGIN

	Declare @seccion	Varchar(1);

	Set @seccion = '5';

	Select	*
	From promociones_det1 act
		Inner Join [BdTienda].[dbo].[tarticulo] art
			On act.artic = art.cod_artic And art.cod_secci = @seccion
		Where act.idpromo = @id_promo
		  And act.activadorpromo = 1; -- Activador

END