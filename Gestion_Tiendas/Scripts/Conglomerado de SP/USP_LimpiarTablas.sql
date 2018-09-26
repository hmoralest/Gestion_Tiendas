If Exists(Select * from sysobjects Where name = 'USP_LimpiarTablas' And type = 'P')
	Drop Procedure USP_LimpiarTablas
GO

-- =====================================================================
-- Author		: Henry Morales
-- Create date	: 12-03-2018
-- Description	: Limpia las tablas que se usan para PrestaShop
-- =====================================================================
/*
	Exec USP_LimpiarTablas 'BD_ECOMMERCE'
*/

CREATE Procedure USP_LimpiarTablas	(
	@nombre_BD		Varchar(max)
)
AS 
BEGIN

	If(@nombre_BD = 'BD_ECOMMERCE')
	Begin

		delete from Movimiento
		delete from Movimiento_Detalle
		delete from Pago
		delete from Documento_Transaccion

		delete from Liquidacion
		delete from Pedido

		delete from Validar_Banco

		delete from Venta
		delete from Nota_Credito
		delete from Transporte_Guia
		delete from Paquete
		delete from Venta_Liq_Ped
		delete from Transporte_Guia
		delete from Guia_Remision

		--select * from Liquidacion

		delete FROM Movimiento_Bata_Documento

		delete from Tmp_Movimiento_Bata
		delete from Tmp_Art_Mov_NExiste
		delete from Articulo_Stock
		
		delete from ECOM_Control_Proceso
		delete from Log_ProcesoVentas
	End
END