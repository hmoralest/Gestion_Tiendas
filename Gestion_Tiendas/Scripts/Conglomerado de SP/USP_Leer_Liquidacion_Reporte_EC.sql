If Exists(Select * from sysobjects Where name = 'USP_Leer_Liquidacion_Reporte_EC' And type = 'P')
	Drop Procedure USP_Leer_Liquidacion_Reporte_EC
GO

-- ==========================================================================================
-- Author			: Henry Morales
-- Create date		: 22/05/2018
-- Description		: Obtiene datos para reporte
-- ==========================================================================================
/*
	Exec [USP_Leer_Liquidacion_Reporte_EC] '4'
*/

CREATE PROCEDURE USP_Leer_Liquidacion_Reporte_EC
(
	@liq_id varchar(12)		
)
  as
  --CABEZERA DE LA LIQUIDACIONB
  SELECT       Liq_Id,
               Bas_Id,
               Bas_Documento,               
               Bas_Direccion=dbo.ConvertMayMin(Bas_Direccion),
               Bas_Telefono ,
               Bas_Fax,
               Bas_Celular,
			   Bas_Correo=dbo.ConvertMayMin(Bas_Correo),               
			   nombres=dbo.ConvertMayMin(isnull(Bas_Primer_Nombre,'') + ' ' +
			   isnull(Bas_Segundo_Nombre,'') + ' ' +
			   isnull(Bas_Primer_Apellido,'') + ' ' +
			   isnull(Bas_Segundo_Apellido,'')),
			   ubicacion=dbo.ConvertMayMin(isnull(cc.Dep_Descripcion,'') + ', ' + isnull(dc.Prv_Descripcion,'') + ', ' + isnull(aa.Dis_Descripcion,'')) ,
               almacen=dbo.ConvertMayMin(al.Alm_Descripcion),
			   alm_direccion=dbo.ConvertMayMin(al.Alm_Direccion),
			   al.Alm_Telefono,
               liq_est=Liq_Id + ' - ' + Liq_EstId,
               fecha_Desc=convert(varchar(100),Liq_FechaIng,100),
               Liq_FechaIng,
			   Liq_Fecha_Expiracion,			  
               Liq_EstId,
               estado=dbo.ConvertMayMin(Est_Descripcion),
               igvmonto=cast(Liq_Igv as numeric(10,2)),
               igvporc=cast(Liq_Igv_Porc  as numeric(10,0)),            
               cantidad_total=sum(IIF(Liq_Det_ArtId='9999997',0,Liq_Det_Cantidad)),
			   ganancia=sum(Liq_Det_Comision),
			   subtotal=cast(sum((Liq_Det_Cantidad * Liq_Det_Precio) - (Liq_Det_Comision + isnull(Liq_Det_OfertaM,0))) as numeric(10,2)),
               total=cast(sum((Liq_Det_Cantidad * Liq_Det_Precio) - (Liq_Det_Comision + isnull(Liq_Det_OfertaM,0))) + Liq_Igv as numeric(10,2)),
			   descuento=sum(isnull(Liq_Det_OfertaM,0)),
               Percepcionm=isnull(Liq_PercepcionM,0),
			   Percepcionp=isnull(Liq_PercepcionP,0),              
               ncredito=CASE 
                    WHEN 
                        (select COUNT(*) from Liquidacion_Pago  where Liq_Pago_LiqId=@liq_id)>0 then 
                        isnull((select sum(Liq_Pago_Monto)  from Liquidacion_Pago where Liq_Pago_LiqId=@liq_id),0)
                    WHEN 
                       (select COUNT(*) from Liquidacion_Pago  where Liq_Pago_LiqId=@liq_id)=0 AND
                       isnull(avg(Liquidacion.Liq_PercepcionM),0)<>dbo.PercepcionLV('L',@liq_id) then
                       isnull((select sum(Doc_Tra_SubTotal) + sum(Doc_Tra_Igv) + SUM(isnull(doc_tra_percepcionm,0)) from  Documento_Transaccion  where ((Doc_Tra_ConId='98' or (Doc_Tra_ConId='90' and Doc_Tra_Comentario='NC'))  OR (Doc_Tra_ConId='90' AND Doc_Tra_PercepcionP>0 )) and Doc_Tra_GruId=Liquidacion.Liq_GruId),0)
                   else
                       0  
                   end,                   
                  totalop=DBO.TotalOp(LIQ_GRUID),
			  lider=dbo.[devolver_lider](Liq_BasId)
          FROM Liquidacion                              
               INNER JOIN Liquidacion_Detalle 
                  ON  Liq_Id=Liq_Det_Id
               INNER JOIN Basico_Dato 
                  ON  Bas_Id=Liq_BasId    
			   INNER JOIN Almacen al
				  ON alm_id=9	            
                LEFT JOIN Distrito aa
                  ON  aa.Dis_Id=Bas_Dis_Id
               LEFT JOIN Provincia dc
                  ON dc.Prv_Id=aa.Dis_Prv_Id
               LEFT JOIN Departamento cc
                  ON cc.Dep_Id=dc.Prv_Dep_Id                                            
               INNER JOIN Estado 
                  ON  Est_Id=Liq_EstId
               
         WHERE Liq_Id= @liq_id
         GROUP BY Liq_Id,
				  Bas_Id,
				  Bas_Documento,
				  Bas_Direccion,
				  Bas_Telefono,
				  Bas_Fax,
				  Bas_Celular,
				  Bas_Correo,
				  Bas_Primer_Nombre,
				  Bas_Segundo_Nombre,
				  Bas_Primer_Apellido,
				  Bas_Segundo_Apellido,
				  cc.Dep_Descripcion,
				  dc.Prv_Descripcion,
				  aa.Dis_Descripcion,
				  al.Alm_Descripcion,
				  al.Alm_Direccion,
				  al.Alm_Telefono,
				  Liq_Id,
				  Liq_EstId,
				  Liq_FechaIng,
				  Liq_Fecha_Expiracion,
				  Est_Descripcion,
				  Liq_Igv,
				  Liq_Igv_Porc,
				  Liq_PercepcionM,
				  Liq_PercepcionP,
				  Liq_GruId,
				  Liq_BasId
				  order by Liq_FechaIng desc

  
  --detalle

   SELECT      Liq_Det_Id,
			   Art_Id,
			   art_descripcion=dbo.ConvertMayMin(art_descripcion) ,
               Mar_Descripcion=dbo.ConvertMayMin(Mar_Descripcion),
               Col_Descripcion=dbo.ConvertMayMin(Col_Descripcion),
               Liq_Det_TalId,
               Liq_Det_Cantidad,
               Liq_Det_Precio,
               Liq_Det_Comision,
			   Liq_Det_OfertaM=isnull(Liq_Det_OfertaM,0)
          FROM Liquidacion_Detalle
		       inner join Articulo on Art_Id=Liq_Det_ArtId
			   inner join Marca on Mar_Id=Art_Mar_Id
			   inner join Color on Col_Id=Art_Col_Id
          where Liq_Det_Id=@liq_id 
		    And Liq_Det_ArtId <> '9999997'
          order by Art_Id     
               
         
	--****PAGOS DE LA LIAQUIDACION NOTA DE CREDITO


		declare @var_existe                 numeric=0
		declare @var_validapercepcion       money
		declare @var_clear                  varchar(12)='xxxxxx'

  
		select @var_existe=count(*)   from Liquidacion_Pago 
		inner join Liquidacion  on Liq_Id=Liq_Pago_LiqId where Liq_Id=@liq_id and Liq_GruId  is not null;
  
		if @var_existe>0 begin
			select @var_clear=Liq_GruId  from Liquidacion  where Liq_Id=@liq_id --and lhv_clear is not null
			GROUP BY Liq_GruId       
		end
		else  
		begin
			select @var_existe=count(*) 
			from Liquidacion  where Liq_GruId  is not null and Liq_Id=@liq_id and Liq_PercepcionM<>dbo.PercepcionLV('L',@liq_id)
			and Liq_PercepcionP>0;
      
			if @var_existe=1 begin
				select @var_clear=Liq_GruId
				from Liquidacion where /*lhv_clear is not null and*/ Liq_Id=@liq_id /*and percepcion<>LOGISTICA.Fuc_PercepcionLV('L',var_idliquidacion)
				and porc_percepcion>0;*/
			end
			else
			begin
			select @var_existe=count(*) 
			from Liquidacion  where Liq_GruId  is not null and Liq_Id=@liq_id 
			and Liq_PercepcionP=0;

			if @var_existe=1 begin
				select @var_clear=Liq_GruId
				from Liquidacion where /*lhv_clear is not null and*/ Liq_Id=@liq_id /*and percepcion<>LOGISTICA.Fuc_PercepcionLV('L',var_idliquidacion)
				and porc_percepcion>0;*/
			end  
			end
		end
     
		select ncredito=CASE WHEN Not_Numero IS NULL THEN 'Saldo a F.' ELSE  '668' +  right(replicate('0',7) + cast(not_numero as varchar(15)),7)  END ,  fecha=Doc_Tra_Fecha,Total=isnull(Doc_Tra_SubTotal,0) + isnull(Doc_Tra_Igv,0) + isnull(Doc_Tra_PercepcionM,0
)  from Documento_Transaccion 
		LEFT join Nota_Credito  on Doc_Tra_Doc=Not_Id where Doc_Tra_GruId=@var_clear AND ((Doc_Tra_ConId='98' or (Doc_Tra_ConId='90' and Doc_Tra_Comentario='NC')) OR (Doc_Tra_ConId='90' AND Doc_Tra_PercepcionP>0 )) ;
   


		--***************************************************************************
		--*****VALIDA FORMA DE PAGO LIQUIDACION
		declare @var_existef numeric=0
		declare @var_nc      numeric=0
		declare @var_validapercepcionf money
		declare @var_clearf   varchar(12)='xxxxxx'; 
		
  
		select @var_existef=count(*)  from Liquidacion  where Liq_Id=@liq_id and Liq_GruId  is not null;
  
		if  @var_existef>0 begin
			select @var_clearf=Liq_GruId from  
			Liquidacion   where Liq_Id=@liq_id
		end
  
		select @var_nc=count(*)  
		from Liquidacion where Liq_GruId is not null and Liq_Id=@liq_id and Liq_PercepcionM=dbo.PercepcionLV('L',@liq_id)
		and Liq_PercepcionP>0;
  
		IF @var_nc=0 begin
			select pago=dbo.ConvertMayMin(Con_Descripcion),
					Documento=CASE WHEN LEN(Not_Numero)>0 THEN '668' + right(replicate('0',7) + cast(not_numero as varchar(15)),7) 
						WHEN len(Pag_Num_Consignacion)>0 THEN  Pag_Num_Consignacion ELSE '' END ,
					fecha=CASE WHEN len(Pag_Num_Consignacion)>0 THEN Pag_Fecha_Creacion ELSE Doc_Tra_Fecha END ,Total=isnull(Doc_Tra_SubTotal,0) + isnull(Doc_Tra_Igv,0)   from Documento_Transaccion
			inner join Concepto on Con_Id=Doc_Tra_ConId
			left join Pago on Pag_Id=Doc_Tra_Doc
			left join Nota_Credito on Doc_Tra_Doc=Not_Id where (Doc_Tra_ConId='9F' or  Doc_Tra_ConId='9BBVA' OR
											      Doc_Tra_ConId='9INT' OR
											      Doc_Tra_ConId='BN' OR Doc_Tra_ConId='007' /*OR cov_conceptid='98'*/ OR (Doc_Tra_ConId='90' and Doc_Tra_Comentario<>'NC' and (Doc_Tra_PercepcionM IS NULL OR  Doc_Tra_PercepcionM=0)) OR (Doc_Tra_ConId='90' AND (Doc_Tra_PercepcionP IS NULL OR Doc_Tra_PercepcionP=0)) OR Doc_Tra_ConId='9NE') AND Doc_Tra_GruId=@var_clearf
    
		--select * from maestros.concepts
		end
		ELSE
	    begin
		select  pago=dbo.ConvertMayMin(Con_Descripcion),
				Documento=CASE WHEN len(Not_Numero)>0 THEN '668' + right(replicate('0',7) + cast(not_numero as varchar(15)),7) 
					WHEN len(Pag_Num_Consignacion)>0 THEN Pag_Num_Consignacion ELSE '' END ,
				fecha=CASE WHEN Con_Id='9F' or  Con_Id='9BBVA' OR
											      Con_Id='9INT' OR
											      Con_Id='BN' /*WHEN LENGTH(PAV_NUM_CONSIGNACION)>0*/ THEN Pag_Fecha_Creacion ELSE Doc_Tra_Fecha END ,Total=isnull(Doc_Tra_SubTotal,0) + isnull(Doc_Tra_Igv,0)   from Documento_Transaccion
		inner join Concepto on Con_Id=Doc_Tra_ConId
		left join Pago on Pag_Id=Doc_Tra_Doc
		left join Nota_Credito on Doc_Tra_Doc=Not_Id where (Con_Id='9F' or  Con_Id='9BBVA' OR
											      Con_Id='9INT' OR
											      Con_Id='BN' OR Con_Id='007' OR Con_Id='98' OR (Con_Id='90' AND (Doc_Tra_PercepcionM IS NULL OR Doc_Tra_PercepcionM=0))   OR Con_Id='9NE') AND Doc_Tra_GruId=@var_clearf ;
		end

