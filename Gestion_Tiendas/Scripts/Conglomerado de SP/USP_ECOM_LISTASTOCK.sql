If Exists(Select * from sysobjects Where name = 'USP_ECOM_LISTASTOCK' And type = 'P')
	Drop Procedure USP_ECOM_LISTASTOCK
GO

-- =====================================================================
-- Author			: Henry Morales
-- Create date		: 12-02-2018
-- Description		: Lista Movimientos de Stock para enviarlos a PrestaShop
-- =====================================================================
-- Modificado por	: Henry Morales
-- Create date		: 18-04-2018
-- Description		: Se realiza actualizaci�n y control por Detalle
-- =====================================================================
/*
	Exec USP_ECOM_LISTASTOCK '11'
*/
CREATE Procedure USP_ECOM_LISTASTOCK(
	@tienda		Varchar(50)
)
AS 
BEGIN

	/*Select	Cast(Stk_ArtId As Int)				As product_id,
			Stk_Cantidad						As cantidad
	From Articulo_Stock
	Where Stk_AlmId = @tienda;*/

	Select	det.Mov_Det_ArtId+det.Mov_Det_TalId			As product_id,
	--Select	Substring(det.Mov_Det_ArtId,1,3)+'-'+Substring(det.Mov_Det_ArtId,4,9)+'-'+det.Mov_Det_TalId			As product_id,
			Case Mov_ConId	When '30'	Then det.Mov_Det_Cantidad
							When '31'	Then det.Mov_Det_Cantidad * (0-1)
							Else			 0
			END																	As cantidad,
			mov.Mov_Fecha														As fecha,
			mov.Mov_Id															As mov_id,
			det.Mov_Det_Items													As det_mov_id
	From Movimiento mov
		Inner Join Movimiento_Detalle det
			On mov.Mov_Id = det.Mov_Det_Id
	Where mov.Mov_AlmId = @tienda
	  And mov.Mov_EstId = 'A'
	  --And isnull(mov.Mov_EstPS,'') <> 'P'
	  And isnull(det.Mov_Det_EstId,'') <> 'P'
	  And Mov_ConId IN ('30','31');

END
GO