If Exists(Select * from sysobjects Where name = 'USP_Leer_Empaque_EC' And type = 'P')
	Drop Procedure USP_Leer_Empaque_EC
GO

-- ==========================================================================================
-- Author			: Henry Morales
-- Create date		: 22/05/2018
-- Description		: Obtiene datos para reporte
-- ==========================================================================================
/*
	Exec [USP_Leer_Empaque_EC] '4'
*/

CREATE PROCEDURE USP_Leer_Empaque_EC
(
   @liq_id   varchar(12)
)
AS
        SELECT 
               liq_id + ' - ' + Liq_EstId as lhv_liquidation_no,
               dbo.ConvertMayMin(Alm_Descripcion) stv_descriptions,
               Liq_Det_ArtId tdv_article,
               dbo.ConvertMayMin(Art_Descripcion)  arv_name,
               Liq_Det_TalId tdv_size,
               Liq_Det_Cantidad tdn_qty,
               Liq_Det_Costo odn_odv,
               Liq_Det_Precio prn_public_price,
               dbo.ConvertMayMin(Mar_Descripcion) brv_description,
               '-' instrucciones,
               null po
          FROM Liquidacion inner join
		  Liquidacion_Detalle on Liq_Id=Liq_Det_Id
		  inner join Articulo on Liq_Det_ArtId=Art_Id
		  inner join Marca on Mar_Id=Art_Mar_Id
		  inner join Almacen on Alm_Id=11		  
         WHERE liq_id =@liq_id
		   AND Liq_Det_ArtId <> '9999997'
      ORDER BY brv_description, tdv_article;

