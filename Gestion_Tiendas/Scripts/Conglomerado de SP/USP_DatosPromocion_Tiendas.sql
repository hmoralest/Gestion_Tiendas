If Exists(Select * from sysobjects Where name = 'USP_DatosPromocion_Tiendas' And type = 'P')
	Drop Procedure USP_DatosPromocion_Tiendas
GO

-- ==========================================================================================
-- Author		: Henry Morales
-- Create date	: 21/02/2018
-- Description	: Obtiene datos de la Promocion, de las tiendas en las que estan vigentes
-- ==========================================================================================
-- tablas		: promociones_det2
--				  [BdTienda].[dbo].[tentidad_tienda]
--				  [BdTienda].[dbo].[Tienda]
-- ==========================================================================================
/*
	Exec USP_DatosPromocion_Tiendas
*/

CREATE Procedure USP_DatosPromocion_Tiendas(
	@id_promo	Varchar(8)
)
AS 
BEGIN

	Select	*
	From promociones_det2 tda
		Inner Join [BdTienda].[dbo].[tentidad_tienda] ent
			On tda.tienda = ent.cod_entid
		Inner Join [BdTienda].[dbo].[Tienda] tien 
			On tien.Cod_Tienda = ent.cod_entid
	Where tda.idpromo = @id_promo;

END