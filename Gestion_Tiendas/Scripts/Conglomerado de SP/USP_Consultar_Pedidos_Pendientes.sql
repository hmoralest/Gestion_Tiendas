If Exists(Select * from sysobjects Where name = 'USP_Consultar_Pedidos_Pendientes' And type = 'P')
	Drop Procedure USP_Consultar_Pedidos_Pendientes
GO

-- ==========================================================================================
-- Author			: Henry Morales
-- Create date		: 21/05/2018
-- Description		: Listado de Pedidos Pendientes por Facturar
-- ==========================================================================================
/*
	Exec USP_Consultar_Pedidos_Pendientes '1','', '',''
*/

CREATE PROCEDURE [dbo].[USP_Consultar_Pedidos_Pendientes]
(
	--si tipo es 0 entonces busca por fecha si es 1 entonces busca por documento
	@tipo      bit,	
	@fechaini  date,
	@fechafin  date,
	@doc       varchar(10)
)
As
	
	if @tipo=0 begin

		Select 
			Liq.Liq_Id As id,
			convert(varchar(30),liq.Liq_Fecha,113) As fecha_ped,
			liq.Liq_Fecha As fecha,
			liq.Liq_Pst_Ref As ped_ref,
			isnull(bas.Bas_Primer_Nombre,'')+ ' '+isnull(bas.Bas_Segundo_Nombre,'')+ ' '+isnull(bas.Bas_Primer_Apellido,'')+ ' '+isnull(bas.Bas_Segundo_Apellido,'')   as cliente,
			SUM(IIF(det.Liq_Det_ArtId= '9999997',0,det.Liq_Det_Cantidad)) As cant_total
		From Liquidacion liq
			Inner Join Liquidacion_Detalle det
				On liq.Liq_Id = det.Liq_Det_Id
			Inner Join Basico_Dato bas
				On liq.Liq_BasId = bas.Bas_Id
		Where /*liq.Liq_EstId = 'PF'
		  And*/ (dbo.Fecha(liq.Liq_Fecha)>=@fechaini and dbo.Fecha(liq.Liq_Fecha)<=@fechafin) 
		Group by Liq.Liq_Id, liq.Liq_Fecha, Liq_Pst_Ref, liq.Liq_Nombres_Ref, bas.Bas_Primer_Nombre, bas.Bas_Segundo_Nombre, bas.Bas_Primer_Apellido, bas.Bas_Segundo_Apellido
		Order by liq.Liq_Fecha Desc;

	end

	if @tipo=1 begin

		Select 
			Liq.Liq_Id As id,
			convert(varchar(30),liq.Liq_Fecha,113) As fecha_ped,
			liq.Liq_Fecha As fecha,
			liq.Liq_Pst_Ref As ped_ref,
			isnull(bas.Bas_Primer_Nombre,'')+ ' '+isnull(bas.Bas_Segundo_Nombre,'')+ ' '+isnull(bas.Bas_Primer_Apellido,'')+ ' '+isnull(bas.Bas_Segundo_Apellido,'')   as cliente,
			SUM(IIF(det.Liq_Det_ArtId= '9999997',0,det.Liq_Det_Cantidad)) As cant_total
		From Liquidacion liq
			Inner Join Liquidacion_Detalle det
				On liq.Liq_Id = det.Liq_Det_Id
			Inner Join Basico_Dato bas
				On liq.Liq_BasId = bas.Bas_Id
		Where /*liq.Liq_EstId = 'PF' 
		  And*/ Liq.Liq_Id like '%' +  @doc + '%'
		Group by Liq.Liq_Id, liq.Liq_Fecha, Liq_Pst_Ref, liq.Liq_Nombres_Ref, bas.Bas_Primer_Nombre, bas.Bas_Segundo_Nombre, bas.Bas_Primer_Apellido, bas.Bas_Segundo_Apellido
		Order by liq.Liq_Fecha Desc;

	end
	