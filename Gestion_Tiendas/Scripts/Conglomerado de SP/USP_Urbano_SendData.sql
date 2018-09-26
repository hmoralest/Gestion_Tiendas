If Exists(Select * from sysobjects Where name = 'USP_Urbano_SendData' And type = 'P')
	Drop Procedure USP_Urbano_SendData
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 17/05/2018
-- Asunto			: Se agergó la lógica para que no traiga los datos ya marcados como "P - Procesado"
--					  Se quitó los parámetros de fechas, ya que se usará para distinguir el FLAG
-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 21/05/2018
-- Asunto			: Se agergó campos de referencia en nombre y telefono para la dirección de entrega
-- ====================================================================================================
/*
	Exec [USP_Urbano_SendData] 'B09500000001'
*/

CREATE PROCEDURE [dbo].[USP_Urbano_SendData]
	@ven_id varchar(12)='-1'
AS
BEGIN

	Select 
			cod_rastreo=Ven_Pst_Ref,
			fech_emi_vent=convert(varchar(20),Ven_Fecha,103),
			nro_guia_trans=Tra_Gui_No,
			nro_factura=Ven_Id,
			cod_empresa=Emp_Ruc,
			nom_empresa=Emp_Razon,
			cod_cliente=Bas_Documento,
			nom_cliente=dbo.ConvertMayMin(isnull(Bas_Primer_Nombre,'') + ' ' + isnull(Bas_Segundo_Nombre,'') + ' '+ isnull(Bas_Primer_Apellido,'') + ' '+ isnull(Bas_Segundo_Apellido,'')),
			nro_telf=Bas_Telefono,
			nro_telf_mobil=Bas_Celular,
			correo_elec=Bas_Correo,
			dir_entrega=Ven_Dir_Ent,
			ubi_direc=Ven_Ubigeo_Ent,
			ref_direc=Ven_Dir_Ref,
			ref_nombre=IsNull(Liq_Nombres_Ref,''),
			ref_telef=IsNull(Liq_Telef_Ref,'/'),
			peso_total=Ven_Pes_Tot,
			cod_sku=Ven_Det_ArtId + '-' + Ven_Det_TalId,
			descr_sku=Ven_Det_ArtDes,
			modelo_sku=Ven_Det_ArtId,
			marca_sku=Mar_Descripcion,
			peso_sku=ven_det_peso,

			tot_cant=(Select SUM(IIF(a.Ven_Det_ArtId='9999997',0,a.Ven_Det_Cantidad)) From Venta_Detalle a with(nolock) Where vta.Ven_Det_Id = a.Ven_Det_Id ),
			cantidad_sku=Ven_Det_Cantidad

	From Venta ven with(nolock)
		Inner Join Venta_Detalle vta with(nolock) 
			On Ven_Id=Ven_Det_Id
		Inner Join Articulo art with(nolock) 
			On Art_Id=Ven_Det_ArtId
		Inner Join Marca marc with(nolock)
			On Mar_Id=Art_Mar_Id 
		Inner Join Liquidacion liq with(nolock)
			On Liq_Id=Ven_LiqId
		Inner Join Basico_Dato bas with(nolock)
			On Bas_Id=Ven_BasId
		Inner Join Guia_Remision guia with(nolock)
			On Gui_Rem_VenId=Ven_Id
		Inner Join Transporte_Guia trans with(nolock)
			On Tra_Gui_Id=Liq_GuiaId 
		Inner Join Empresa	emp with(nolock)
			On Emp_Id=1
	Where Ven_Guia_Urbano Is Null
	  And Art_Sin_Stk=0
	  And (Ven_Id=@ven_id Or '-1'=@ven_id)
	  And Ven_Det_ArtId <> '9999997'

END