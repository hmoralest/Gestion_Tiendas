If Exists(Select * from sysobjects Where name = 'USP_EcommerceImpEtiqueta' And type = 'P')
	Drop Procedure USP_EcommerceImpEtiqueta
GO

-- =======================================================================
-- Author		: Henry Morales
-- Mod. date	: 17/05/2018
-- Description	: Cambia el código de PS, por la Referencia de PS (pedido)
-- =======================================================================
/*
	exec [dbo].[USP_EcommerceImpEtiqueta]  'F09500000001'
*/

CREATE PROCEDURE [dbo].[USP_EcommerceImpEtiqueta]
	@ven_id varchar(30)
AS
BEGIN
	SELECT	nroguia=Ven_Guia_Urbano,
			cliente=isnull(Bas_Primer_Nombre,'') + ' ' + isnull(Bas_Segundo_Nombre,'') + ' ' +isnull(Bas_Primer_Apellido,'') + ' ' + isnull(Bas_Segundo_Apellido,''),
			Emp_Comercial,
			nro_pedido=Ven_LiqId,
			direccion=Ven_Dir_Ent,
			Ven_Dir_Ref,
			Ven_Ubigeo_Ent,
			Ven_Pst_Ref
	FROM Venta WITH(NOLOCK)
		--INNER JOIN Liquidacion on Ven_LiqId=Liq_Id
		INNER JOIN Basico_Dato WITH(NOLOCK) 
			ON Ven_BasId=Bas_Id
		INNER JOIN Empresa  WITH(NOLOCK) 
			ON Emp_Id='1'
	WHERE Ven_Id=@ven_id	


--select * from Venta

END