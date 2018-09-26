If Exists(Select * from sysobjects Where name = 'USP_Exportar_Ventas_Bata' And type = 'P')
	Drop Procedure USP_Exportar_Ventas_Bata
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 17/05/2018
-- Asunto			: Se agergó la lógica para que no traiga los datos ya marcados como "P - Procesado"
--					  Se quitó los parámetros de fechas, ya que se usará para distinguir el FLAG
-- ====================================================================================================
/*
	Exec USP_Exportar_Ventas_Bata 
*/
--Update venta set Ven_EstAct_Alm = NULL
CREATE PROCEDURE [dbo].[USP_Exportar_Ventas_Bata]/*
(
  @p_IHD_DATE_start   date,
  @p_IHD_DATE_end     date
)*/
   
AS    
BEGIN

   SELECT A.Comprobante,A.NUM_COMPROBANTE,A.PEDIDO,FECHA_FACTURA=convert(varchar(8),A.FECHA_FACTURA,112),A.CON_PAGO,Documento=case when len(A.DNI_CLIENTE)=11 then 'RUC'  else 'DNI' end --A.Documento
        ,A.DNI_CLIENTE,A.NOMBRE ,A.SEG_NOMBRE,A.APEPAT,A.APEMAT,A.Direccion,A.Ciudad, A.MONEDA,
        A.DNI_LIDER,A.nomLider,A.nom2Lider,A.ApepatLider,A.ApematLider,
        A.Ven_Det_ArtId IDV_ARTICLE,A.CALIDAD,A.talla,A.cantidad,A.Con_IGV, A.sin_IGV,
        A.VAL_TOT,A.DSCTO, A.Ven_Det_ComisionM IDN_COMMISSION,
        A.VAL_VENTA,IGV,fecRef=convert(varchar(8),A.fecRef,112),
		case when A.estadoNC='EFE' then 'C'
		     when A.estadoNC='F07' or A.estadoNC='1'  then ''			 
			 when A.estadoNC='2' then 'A'
			 when A.estadoNC='A' then 'A' END ,A.serie,A.documref,A.Ven_PercepcionP porc_percepcion,
			 case when A.Comprobante='NC' THEN 0 ELSE CASE WHEN [dbo].[Pago_Mayor_Nc](A.NUM_COMPROBANTE)=1 THEN 0 ELSE ((A.VAL_VENTA + IGV) - (case when A.Comprobante='BO' OR A.Comprobante='FA' or A.Comprobante='TI' 
			 then dbo.Pago_Nc_Venta(A.NUM_COMPROBANTE) else 0   end)) END END * (A.Ven_PercepcionP/100) "percepcion",A.GRUPO,a.cod_hash,a.motivo,a.igm_mc,a.Ven_Igv_Porc, A.Estado
        
   FROM(
        select  CASE WHEN left(Ven_Id,3)='668' then 'TI' ELSE CASE WHEN  left(ven_id,1)='B' THEN  'BO' ELSE 'FA'  END END  as Comprobante,ven_id as NUM_COMPROBANTE,
         Ven_LiqId AS PEDIDO,convert(varchar,ven_fecha,112) AS FECHA_FACTURA, 		 
         dbo.Condicion_Pago('TI',Ven_Id) AS CON_PAGO,
		 case when Doc_Tip_Id='1' or Doc_Tip_Id='3' then 'DNI'		          
		      when Doc_Tip_Id='2'   then 'RUC' end as Documento,
        bas_documento  AS DNI_CLIENTE,Bas_Primer_Nombre AS NOMBRE ,Bas_Segundo_Nombre AS SEG_NOMBRE,Bas_Primer_Apellido AS APEPAT,
        Bas_Segundo_Apellido AS APEMAT,Bas_Direccion as Direccion,'' as Ciudad, 'SOLES' MONEDA,
                (select top 1 lid.Bas_Documento from Basico_Dato lid where lid.Bas_Are_Id=Basico_Dato.Bas_Are_Id and (lid.Bas_Usu_TipId='01' or lid.Bas_Usu_TipId='03' )) as DNI_LIDER,				
                (select top 1 lid.Bas_Primer_Nombre from Basico_Dato lid where lid.Bas_Are_Id=Basico_Dato.Bas_Are_Id and (lid.Bas_Usu_TipId='01' or lid.Bas_Usu_TipId='03' )) as nomLider,
                (select top 1 lid.Bas_Segundo_Nombre from Basico_Dato lid where lid.Bas_Are_Id=Basico_Dato.Bas_Are_Id and (lid.Bas_Usu_TipId='01' or lid.Bas_Usu_TipId='03' )) as nom2Lider,
                (select top 1 lid.Bas_Primer_Apellido from Basico_Dato lid where lid.Bas_Are_Id=Basico_Dato.Bas_Are_Id and (lid.Bas_Usu_TipId='01' or lid.Bas_Usu_TipId='03' )) as ApepatLider,
                (select top 1 lid.Bas_Segundo_Apellido from Basico_Dato lid where lid.Bas_Are_Id=Basico_Dato.Bas_Are_Id and (lid.Bas_Usu_TipId='01' or lid.Bas_Usu_TipId='03' )) as ApematLider,
         Ven_Det_ArtId,isnull(Ven_Det_Calidad,'') AS CALIDAD,Ven_Det_TalId as talla,Ven_Det_Cantidad as cantidad, round((Ven_Det_Precio)* ((Ven_Igv_Porc/100) + 1),2) as Con_IGV, round((Ven_Det_Precio),2) as sin_IGV,
        round((Ven_Det_Precio)*Ven_Det_Cantidad,2) as VAL_TOT,case when Ven_Det_Precio=0 then 0 else round(Ven_Det_ComisionM/Ven_Det_Precio*100,2) end AS DSCTO, Ven_Det_ComisionM,
        ROUND((((Ven_Det_Precio)*Ven_Det_Cantidad)- (Ven_Det_ComisionM + isnull(Ven_Det_OfertaM,0))),2) VAL_VENTA,
        CAST((((Ven_Det_Precio)*Ven_Det_Cantidad)- (Ven_Det_ComisionM + isnull(Ven_Det_OfertaM,0)))*(Ven_Igv_Porc/100) AS numeric(10,4)) AS IGV
        ,'' as DocRef, '' as fecRef ,case when ven_est_id='FANUL' then 'A' ELSE dbo.Condicion_Pago('TI',Ven_Fecha) END as estadoNC,
		
        Con_Fig_SerieImpresora serie,'' documref,CASE WHEN Ven_ComisionP=0 and Ven_PercepcionP=0 then 0 else case when dbo.Aplica_Percepcion(Ven_Id)=0 then 0 else Ven_PercepcionP end end Ven_PercepcionP, 
         Alm_Novell    AS GRUPO,cod_hash=isnull(Ven_Cod_Hash,''),motivo='',igm_mc=Ven_Igv,Ven_Igv_Porc, case when ven_est_id='FANUL' then 'A' ELSE 'C' END as Estado
         from Basico_Dato
                inner join Usuario_Tipo on Bas_Usu_TipId=Usu_Tip_Id
                inner join Documento_Tipo  on Doc_Tip_Id=Bas_Doc_Tip_Id                
                inner join Venta  on  Ven_BasId=Bas_Id
				inner join Almacen on Alm_Id=Ven_Alm_Id
                left outer join Area on  Are_Id=Bas_Are_Id
				inner join Venta_Detalle on Ven_Id=Ven_Det_Id
				inner join Configuracion on Con_Fig_Id=1                
           WHERE /*dbo.Fecha(Ven_Fecha)  between  dbo.Fecha(@p_IHD_DATE_start)  and   dbo.Fecha(@p_IHD_DATE_end)
			 And*/ isnull(Ven_EstAct_Alm,'') = ''
                
        UNION ALL

         select  'NC' as Comprobante,dbo.[Devolver_Serie_Doc](Bas_Id,'11')   +  right(replicate('0',8) + cast(not_numero as varchar(15)),8) as NUM_COMPROBANTE,
         Ven_LiqId AS PEDIDO, 
         convert(varchar(8),Not_Fecha,112) AS FECHA_FACTURA, 
         dbo.Condicion_Pago('NC',Not_Id) AS CON_PAGO,
          case when Doc_Tip_Id='1' or Doc_Tip_Id='3' then 'DNI'		          
		      when Doc_Tip_Id='2'   then 'RUC' end as Documento,
         Bas_Documento AS DNI_CLIENTE,Bas_Primer_Nombre AS "NOMBRE" ,Bas_Segundo_Nombre AS SEG_NOMBRE,Bas_Primer_Apellido AS APEPAT,
         Bas_Segundo_Apellido AS APEMAT,Bas_Direccion as Direccion,'' as Ciudad, 'SOLES' MONEDA,
                (select  top 1 lid.Bas_Documento from Basico_Dato lid where lid.Bas_Are_Id=Basico_Dato.Bas_Are_Id and (lid.Bas_Usu_TipId='01' or lid.Bas_Usu_TipId='03' )) as DNI_LIDER,				
                (select top 1 lid.Bas_Primer_Nombre from Basico_Dato lid where lid.Bas_Are_Id=Basico_Dato.Bas_Are_Id and (lid.Bas_Usu_TipId='01' or lid.Bas_Usu_TipId='03' )) as nomLider,
                (select top 1 lid.Bas_Segundo_Nombre from Basico_Dato lid where lid.Bas_Are_Id=Basico_Dato.Bas_Are_Id and (lid.Bas_Usu_TipId='01' or lid.Bas_Usu_TipId='03' )) as nom2Lider,
                (select top 1 lid.Bas_Primer_Apellido from Basico_Dato lid where lid.Bas_Are_Id=Basico_Dato.Bas_Are_Id and (lid.Bas_Usu_TipId='01' or lid.Bas_Usu_TipId='03' )) as ApepatLider,
                (select top 1 lid.Bas_Segundo_Apellido from Basico_Dato lid where lid.Bas_Are_Id=Basico_Dato.Bas_Are_Id and (lid.Bas_Usu_TipId='01' or lid.Bas_Usu_TipId='03' )) as ApematLider,
         Not_Det_ArtId,isnull(case 
	       when not_det_calidad='0' or not_det_calidad='1' or not_det_calidad='4' or not_det_calidad='5' or not_det_calidad='7' or not_det_calidad='8' then '1'
		   when not_det_calidad='2' then '2'
		   when not_det_calidad='3' then '3'
		   when not_det_calidad='9' then '9'
		   when not_det_calidad='6' then '3' end,'')  AS CALIDAD,Not_Det_TalId as talla,Not_Det_Cantidad as cantidad, round((Not_Det_Precio)*((Ven_Igv_Porc/100) + 1),2) as Con_IGV, round((Not_Det_Precio),2) as sin_IGV,
         round((Not_Det_Precio)*Not_Det_Cantidad,2) as VAL_TOT,CASE WHEN Not_Det_Precio=0 THEN 0 ELSE round((Not_Det_ComisionM/Not_Det_Precio)*100,2) END AS DSCTO, Not_Det_ComisionM,
         ROUND((((Not_Det_Precio)*Not_Det_Cantidad)- Not_Det_ComisionM),2) VAL_VENTA,
         ROUND((((Not_Det_Precio)*Not_Det_Cantidad)- Not_Det_ComisionM)* (Ven_Igv_Porc/100),2) AS IGV
         ,Not_Det_VenId as DocRef, convert(varchar(8),Ven_Fecha,112) as fecRef ,
		 case when Not_EstId='1' then ''
		  when Not_EstId='2' then 'A' END  as estadoNC,Con_Fig_SerieImpresora as serie,
         Not_Det_VenId  documref,0 "porc_percepcion",Alm_Novell AS GRUPO,cod_hash=isnull(Not_Cod_Hash,''),motivo=isnull(not_estado_nc,'06'),igm_mc=ROUND((Select sum((((x.Not_Det_Precio)*x.Not_Det_Cantidad)- x.Not_Det_ComisionM)) From Nota_Credito_Detalle x  Where  Not_Id=x.Not_Det_Id)* (Ven_Igv_Porc/100),2)
		 /*igm_mc=ROUND((((x.Not_Det_Precio)*x.Not_Det_Cantidad)- x.Not_Det_ComisionM)* (Ven_Igv_Porc/100),2) */,Ven_Igv_Porc, case when Not_EstId='2' then 'A' ELSE 'C' END as Estado
         from Nota_Credito         
         inner join Nota_Credito_Detalle  on  Not_Id=Not_Det_Id
		 inner join Almacen on Alm_Id=Not_Alm_Id
         inner join Venta_Detalle on Ven_Det_Id=Not_Det_VenId  AND Ven_Det_ArtId=Not_Det_ArtId and Ven_Det_TalId=Not_Det_TalId
         inner join Venta  on Ven_Det_Id=Ven_Id 
         inner join Basico_Dato on  Ven_BasId=Bas_Id
         inner join Usuario_Tipo  on Bas_Usu_TipId=Usu_Tip_Id
         inner join Documento_Tipo on Doc_Tip_Id=Bas_Doc_Tip_Id        
         left outer join Area on Bas_Are_Id=Are_Id
		 inner join Configuracion on Con_Fig_Id=1
         WHERE /*dbo.Fecha(Not_Fecha)  between  dbo.Fecha(@p_IHD_DATE_start)  and   dbo.Fecha(@p_IHD_DATE_end)      
		   And */isnull(Not_EstAct_Alm,'') = ''
         
     )  A         
     order by Comprobante,NUM_COMPROBANTE;

END