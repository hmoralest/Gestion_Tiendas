If Exists(Select * from sysobjects Where name = 'USP_Leer_Liquidacion' And type = 'P')
	Drop Procedure USP_Leer_Liquidacion
GO

-- ==========================================================================================
-- Author			: Henry Morales
-- Create date		: 22/05/2018
-- Description		: Obtiene datos para reporte
-- ==========================================================================================
/*
	Exec [USP_Leer_Liquidacion] 'B09500000002'
*/

CREATE PROCEDURE [dbo].[USP_Leer_Liquidacion]
(
	@ven_id varchar(12)	
)
as

	select distinct 
		Ven_Id,
		Ven_Fecha,
		nombres=dbo.ConvertMayMin(isnull(Bas_Primer_Nombre,'') + ' ' + isnull(Bas_Segundo_Nombre,'') + ' ' + isnull(Bas_Primer_Apellido,'')	 + ' ' + isnull(Bas_Segundo_Apellido,'')) + SPACE(5) + Bas_Documento,
		Bas_Id,direccion=Liq_Dir_Ent /*dbo.ConvertMayMin(Bas_Direccion)*/,
		Bas_Telefono=isnull(Bas_Telefono,''),
		Bas_Celular=isnull(Bas_Celular,''),
		Tra_Descripcion=dbo.ConvertMayMin(Tra_Descripcion),
		Tra_Gui_No,
		ubicalugar=dbo.ConvertMayMin(isnull(Dep_Descripcion,'') + ' ' + isnull(Prv_Descripcion,'') + ' ' + isnull(Dis_Descripcion,''))/*lider=dbo.ConvertMayMin(Are_Descripcion)*/,
	lider='',--(select top 1 dbo.ConvertMayMin(isnull(lid.Bas_Primer_Nombre,'') + ' '  + isnull(lid.Bas_Segundo_Nombre,'') + ' ' + isnull(lid.Bas_Primer_Apellido,'') + ' '  + isnull(lid.Bas_Segundo_Apellido,'')) + ' (' + lid.Bas_Documento  +')' from Basico_Dato lid where lid.Bas_Are_Id=Basico_Dato.Bas_Are_Id and Bas_Est_Id='A' and (lid.Bas_Usu_TipId='01' or lid.Bas_Usu_TipId='03')),
	direccion_lider='',--(select top 1 dbo.ConvertMayMin(isnull(lid.Bas_Direccion,''))  from Basico_Dato lid where lid.Bas_Are_Id=Basico_Dato.Bas_Are_Id and Bas_Est_Id='A' and (lid.Bas_Usu_TipId='01' or lid.Bas_Usu_TipId='03')),
	agencia=''/*UPPER(isnull(Bas_Agencia,''))*/,agencia_ruc=''/*ISNULL(Bas_Agencia_ruc,'')*/	
--	select * from Usuario_Tipo
	 from Venta
    inner join Liquidacion on Liq_Id=Ven_LiqId
	inner join Basico_Dato on Bas_Id=Ven_BasId
	left join Distrito on Dis_Dep_Id + Dis_Prv_Cod + Dis_Cod=Liq_Ubigeo_Ent
	left join Provincia on Prv_Id=Dis_Prv_Id
	left join Departamento on Dep_Id=Prv_Dep_Id
	inner join Guia_Remision on Gui_Rem_VenId=Ven_Id
	inner join Transporte_Guia on Tra_Gui_Id=Liq_GuiaId
	inner join Transporte on Tra_id=Tra_Gui_TraId
	--inner join Area on Are_Id=Bas_Are_Id
	 where Ven_Id=@ven_id

	 
	 select Ven_Det_Id,Ven_Det_ArtId=Ven_Det_ArtId + isnull(Ven_Det_Calidad,''),Art_Descripcion=dbo.ConvertMayMin(Art_Descripcion),Mar_Descripcion=dbo.ConvertMayMin(Mar_Descripcion),
	 Ven_Det_Cantidad,Ven_Det_TalId,Col_Descripcion=dbo.ConvertMayMin(Col_Descripcion) from Venta_Detalle
	 inner join Articulo on Ven_Det_ArtId=Art_Id
	 inner join Marca on Mar_Id=Art_Mar_Id
	 inner join Color on Col_Id=Art_Col_Id
	 where Ven_Det_Id=@ven_id and Art_Sin_Stk=0
	 order by Art_Id,Ven_Det_TalId


	 select Paq_Id,Paq_No,cantidad=sum(Paq_Cantidad) from Paquete_Detalle inner join Liquidacion_Detalle
	 on Paq_ArtId=Liq_Det_ArtId
	 and Paq_TalId=Liq_Det_TalId
	 inner join Liquidacion on Liq_Id=Liq_Det_Id
	 inner join venta on Ven_LiqId=Liq_Id
	 inner join Articulo on Art_Id=Paq_ArtId
	 inner join Paquete on Paq_Id=Paq_Det_Id and Paq_LiqId=Liq_Id
	 where Ven_Id=@ven_id

	 group by Paq_Id,Paq_No
	 order by Paq_No
	 --select * from Paquete


	 --select 






--	select * from Basico_Dato

