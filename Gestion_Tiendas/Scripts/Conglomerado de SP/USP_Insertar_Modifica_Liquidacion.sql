-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 21/05/2018
-- Asunto			: Se agregó campos para nombres y telefonos de referencia en la tabla liquidación
-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 18/06/2018
-- Asunto			: Se modificó para poder guardar pagos en Documento_Transaccion
-- ====================================================================================================
/*
	Exec [USP_Insertar_Modifica_Liquidacion] 
*/

ALTER PROCEDURE [dbo].[USP_Insertar_Modifica_Liquidacion]
(
	--esta 1 insertar liquidacion
	--esta 2 modifica liquidacion
	@Estado                            integer,
	@LiqId                             varchar(12) output,  	 
	@Liq_BasId                         numeric,
	@Liq_ComisionP                     money,
	@Liq_PercepcionM                   Money,
	@Liq_Usu                           numeric,
	@Ped_Id                            varchar(12),	

	@Liq_Pst_Id                        numeric,
	@Liq_Pst_Ref                       varchar(30), 
	@liq_costoe                        money,
	@liq_fecha                         date,
	@liq_tot_cigv                      numeric(10,2),

	@liq_Ubigeo_ent                    varchar(20),
	@liq_dir_ent					   varchar(200),	
	@liq_dir_ref                       varchar(200),
	@liq_nom_ref                       varchar(200),
	@liq_tel_ref                       varchar(200),
	@liq_pes_tot                       numeric(10,2),
	/*VARIABLES PARA CLIENTE*/
		@bas_nombres                   varchar(100),
		@bas_apellidos                 varchar(100),
		@bas_email                     varchar(80),
		@bas_ubigeo                    varchar(10),
		@bas_direccion                 varchar(200),
		@bas_telf                      varchar(50),
		@bas_cel                       varchar(50),
		@bas_dni                       varchar(20),
	/**/

	/*VARIABLES DE PAGO*/
	@Detalle_Pago_ps Tmp_Detalle_Pago_ps READONLY,
		/*@pag_metodo                     varchar(30),
		@pag_nro_trans                  varchar(20),
		@pag_fecha                      date,
		@pag_monto                      money,*/
	/**/
	@Detalle_Pedido Tmp_Detalle_Pedido READONLY,
	--valida liquidacion directa
	@Liquidacion_Directa               integer=0,
	---************liquidacion del pago por pos
	@Pago_Pos                          integer=0, --este estaso es para el tema de pago directa por pos  
	@Pago_PosTarjeta                   varchar(16)='',
	@Pago_numconsigacion               varchar(55)='',
	@Pago_Total                        money=0  ,

	--pago directo de la liquidacion
	@DetallePago    Tmp_PagoLiq        READONLY,
	@Pago_Credito                      bit=0,
	@Ped_Por_Perc                      money=0, 
	/*PEDIDO ORIGINAL*/
	@pedido_original Tmp_Pedido_Real   READONLY  
)
AS
	declare @aplica_desc      numeric=1
	declare @Liq_Id           varchar(12)
	declare @Est_Id           varchar(5) 
	declare @Fecha_Expiracion date
	declare @valida_estado numeric=0;
	--declare @Ped_Por_Perc     money
	declare @IgvPorc          money
	if @Pago_Credito=1 begin		
		set @Est_Id='PC'		
	end
	else
	begin
		set @Est_Id='PS'	   
	end
	
	set @Fecha_Expiracion=cast(cast(getdate() as datetime) + 2 as date)
	select @Liq_Id=cast(max(Cast(Liq_Id as numeric)) + 1 as varchar(12)) from Liquidacion	

	if @Liq_Id is null begin set @Liq_Id=1 end

	if len(@LiqId)=0 begin 
	   set @LiqId=@Liq_Id 
	end
	else 
	begin
	   set @Liq_Id=@LiqId
	end
	--select @Ped_Por_Perc=Con_Fig_Percepcion from Configuracion
	select @IgvPorc=Con_Fig_Igv from Configuracion	

	--verificar si tiene porcentaje de percepcion

	--if (select count(*) from Basico_Dato where Bas_Id=@Liq_BasId and bas_percepcion=0)>0 begin
	--	set @Ped_Por_Perc=0
	--end 
	declare @error_cliente varchar(400)=''
	BEGIN TRY
		BEGIN TRAN Grabar_Liquidacion


			BEGIN --EN ESTA PARTE SE GRABA LOS DATOS DEL CLIENTE
					declare @dis_id numeric=(SELECT top 1 Dis_Id FROM Distrito WHERE Dis_Dep_Id + Dis_Prv_Cod + Dis_Cod=@bas_ubigeo)
					IF EXISTS(SELECT * FROM Basico_Dato WHERE LTRIM(RTRIM(Bas_Documento))=LTRIM(RTRIM(@bas_dni))) BEGIN
						SET @Liq_BasId=(SELECT Bas_Id FROM Basico_Dato WHERE LTRIM(RTRIM(Bas_Documento))=LTRIM(RTRIM(@bas_dni)))
						
						update Basico_Dato set Bas_Primer_Nombre=@bas_nombres,Bas_Primer_Apellido=@bas_apellidos,Bas_Direccion=@bas_direccion,
						       Bas_Telefono=@bas_telf,Bas_Celular=@bas_cel,Bas_Correo=@bas_email,Bas_Fecha_Mod=GETDATE(),Bas_Dis_Id=@dis_id
							   where Bas_Id=@Liq_BasId						
					END
					ELSE
					BEGIN
						/*SI NO EXISTE CREAMOS EL CLIENTE*/
						SELECT @Liq_BasId=MAX(BAS_ID) + 1 FROM Basico_Dato
						
					

						

						INSERT INTO Basico_Dato(Bas_Id,Bas_Primer_Nombre,Bas_Primer_Apellido,Bas_Documento,Bas_Doc_Tip_Id,Bas_Per_Tip_Id,
						                        Bas_Direccion,Bas_Telefono,Bas_Celular,Bas_Correo,Bas_Est_Id,Bas_Are_Id,Bas_Fecha_Cre,Bas_Cre_Usuario,Bas_Sex_Id,Bas_Dis_Id,
												Bas_Usu_TipId,Bas_Percepcion)
						 VALUES(@Liq_BasId,@bas_nombres,@bas_apellidos,@bas_dni,'1','1',@bas_direccion,@bas_telf,@bas_cel,@bas_email,'A','13',GETDATE(),@Liq_Usu,'M',@dis_id,
						        '02',0)
					END
			END
			--
			if @Liq_BasId=0 begin
				set @error_cliente='!ERROR DE CLIENTE COMERCIALES'
				declare @valor numeric=0/0
				
			end
			--borrar liquidacion pago
			 delete from Liquidacion_Pago where Liq_Pago_LiqId=@LiqId
			--*******************
		--en este caso vamos hacer la liquidacion directa
		
		   
		   
		   if @Liquidacion_Directa=0 begin
				if LEN(@Ped_Id)=0 begin
					execute [USP_Insertar_Modificar_Pedido] 1,@Ped_Id output,@Liq_BasId,@Liq_ComisionP,@Liq_PercepcionM,@Liq_Usu,@Ped_Por_Perc,@liq_costoe,@Detalle_Pedido
				end
				else
				begin
					execute [USP_Insertar_Modificar_Pedido] 2,@Ped_Id,@Liq_BasId,@Liq_ComisionP,@Liq_PercepcionM,@Liq_Usu,@Ped_Por_Perc,@liq_costoe,@Detalle_Pedido
				end
			end
			else
			begin
			    select @Liq_BasId=Ped_BasId,@Liq_ComisionP=Ped_Por_Com,@Liq_PercepcionM=Ped_Mto_Perc,@Ped_Por_Perc=Ped_Por_Perc from Pedido where Ped_Id=@Ped_Id
			end
			--nueva liquidacion
			if @Estado=1 begin
				
			   set @Est_Id='PF'

			   set @Liq_Id=cast(@Liq_Pst_Id as varchar(12))
			   	
			   insert into Liquidacion(Liq_Id,Liq_FechaIng,Liq_BasId,Liq_EstId,Liq_Fecha,Liq_Fecha_Expiracion,Liq_Igv,Liq_GruId,Liq_GuiaId,Liq_PedId,
			   Liq_ComisionP,Liq_PercepcionM,Liq_PercepcionP,Liq_FechaMod,Liq_Usu_Cre,Liq_Usu_Mod,Liq_Igv_Porc,liq_credito,Liq_Pst_Id,Liq_Pst_Ref,Liq_CostoE,Liq_Tot_CIgv,Liq_Ubigeo_Ent,Liq_Dir_Ent,Liq_Dir_Ref,Liq_Nombres_Ref,Liq_Telef_Ref,Liq_Pes_Tot)				   

			     select @Liq_Id,getdate(),@Liq_BasId,@Est_Id,cast(@liq_fecha as date),@Fecha_Expiracion,cast(@liq_tot_cigv -(sum((Ped_Det_Cantidad*Ped_Det_Precio) - (Ped_Det_ComisionM + isnull(Ped_Det_OfertaM,0)))) as numeric(10,2)),
					  null,null,@Ped_Id,@Liq_ComisionP,@Liq_PercepcionM,@Ped_Por_Perc,getdate(),@Liq_Usu,@Liq_Usu,@IgvPorc,@Pago_Credito,@Liq_Pst_Id,@Liq_Pst_Ref,@liq_costoe,@liq_tot_cigv,@liq_Ubigeo_ent,@liq_dir_ent,@liq_dir_ref,@liq_nom_ref,@liq_tel_ref,@liq_pes_tot from Pedido
			   inner join Pedido_Detalle on Ped_Id=Ped_Det_Id where Ped_Id=@Ped_Id


			   --select @Liq_Id,getdate(),@Liq_BasId,@Est_Id,cast(@liq_fecha as date),@Fecha_Expiracion,cast((sum((Ped_Det_Cantidad*Ped_Det_Precio) - (Ped_Det_ComisionM + isnull(Ped_Det_OfertaM,0))) + avg(Ped_CostoE)) * avg(Ped_Igv_Porc)/100 as numeric(10,1)),
					 -- null,null,@Ped_Id,@Liq_ComisionP,@Liq_PercepcionM,@Ped_Por_Perc,getdate(),@Liq_Usu,@Liq_Usu,@IgvPorc,@Pago_Credito,@Liq_Pst_Id,@Liq_Pst_Ref,@liq_costoe,@liq_tot_cigv from Pedido
			   --inner join Pedido_Detalle on Ped_Id=Ped_Det_Id where Ped_Id=@Ped_Id

			   insert into Liquidacion_Detalle(Liq_Det_Id,Liq_Det_Items,Liq_Det_ArtId,Liq_Det_TalId,Liq_Det_Cantidad,Liq_Det_Costo,Liq_Det_Precio,Liq_Det_Comision,Liq_Det_OfeID,Liq_Det_OfertaP,Liq_Det_OfertaM,Liq_Det_ArtDes,Liq_Det_peso)
			   select @Liq_Id,Ped_Det_Items,Ped_Det_ArtId,Ped_Det_TalId,Ped_Det_Cantidad,Ped_Det_Costo,Ped_Det_Precio,Ped_Det_ComisionM,isnull(Ped_Det_OfeID,0),isnull(Ped_Det_OfertaP,0),isnull(Ped_Det_OfertaM,0),Ped_Det_ArtDes,Ped_det_Peso from Pedido_Detalle	where Ped_Det_Id=@Ped_Id


			   /*en este caso grabamos la liquidacion original*/

			   insert into Liquidacion_Original(liq_idori,liq_ori_items,liq_ori_articulo,liq_ori_talla,liq_ori_cantidad)

			   select @Liq_Id,items,articulo,talla,cantidad from @pedido_original

			   update Pedido set Ped_EstId=@Est_Id,Ped_FechaMod=GETDATE(),Ped_Usu_Mod=@Liq_Usu where Ped_Id=@Ped_Id
			   --GRABAR EN MOVIMIENTO INGRESO Y SALIDA LA MERCADERIA SEPARADA
			   EXECUTE USP_Insertar_Modificar_Mov 1,'7','52',@Ped_Id
			   EXECUTE USP_Insertar_Modificar_Mov 1,'11','53',@Ped_Id


			   BEGIN /*CRUZAMOS EL METODO DE PAGO*/
				
				--// Modificado por	: Henry D. Morales Tasaico	-	18/06/2018
				--// Se agregó para insertar diferentes tipos de Pago (99)
				Declare @pago_metodo		Varchar(30),
						@pago_nro_trans		Varchar(20),
						@pago_nro_tarj		Varchar(20),
						@pago_fecha			Datetime,
						@pago_monto			Money;
				DECLARE tabla1_cursor CURSOR FOR
				Select	pag_metodo,
						pag_nro_tran,
						pag_nro_tarj,
						pag_fecha,
						pag_monto
				From @Detalle_Pago_ps
				Where pag_codigo = '99'; --Activador

				OPEN tabla1_cursor
		
				FETCH NEXT FROM tabla1_cursor
				INTO @pago_metodo, @pago_nro_trans, @pago_nro_tarj, @pago_fecha, @pago_monto

				WHILE @@FETCH_STATUS = 0
				BEGIN

					
					 DECLARE @PAG_ID VARCHAR(12)=(SELECT CAST(MAX(cast(Pag_Id as numeric)) + 1 AS VARCHAR(12)) FROM Pago)

				 
					 if @PAG_ID is null begin set @PAG_ID='1' end


					 INSERT INTO Pago(Pag_Id,Pag_BasId,Pag_BanId,Pag_Num_Consignacion,Pag_Num_ConsFecha,Pag_Fecha_Creacion,Pag_Monto,Pag_Comentario,Pag_EstId,Pag_Fecha_Evalua,Pag_ConId,Pag_Usu_Creacion,Pag_Pedido)
					 VALUES(@PAG_ID,@Liq_BasId,'1',CASE WHEN LEN(@pago_nro_trans)=0 THEN CAST(@PAG_ID AS VARCHAR(12)) ELSE CAST(@pago_nro_trans AS VARCHAR(12)) END,@pago_fecha,GETDATE(),@pago_monto,@pago_metodo,'PXV',GETDATE(),
																																					 '001',@Liq_Usu,'')
				 
					 UPDATE PAGO SET Pag_EstId='PCO' WHERE PAG_ID=@PAG_ID

					FETCH NEXT FROM tabla1_cursor
					INTO @pago_metodo, @pago_nro_trans, @pago_nro_tarj, @pago_fecha, @pago_monto
				END	-- tabla1_cursor (Pagos)

				 DECLARE @grupo_automatic varchar(12)=''--(select cast(max(cast(Gru_Id as numeric)) + 1 as varchar(12)) from Grupo)
				 exec [USP_Insertar_Grupo] @grupo_automatic output,@Liq_Usu
				 --if @grupo_automatic is null begin set @grupo_automatic=1 end

				    UPDATE LIQUIDACION SET Liq_GruId=@grupo_automatic WHERE Liq_Id=@Liq_Id
					
					UPDATE Documento_Transaccion SET Doc_Tra_GruId=@grupo_automatic WHERE Doc_Tra_Id=(SELECT Doc_Tra_Id FROM Documento_Transaccion WHERE Doc_Tra_ConId='9F' AND Doc_Tra_Doc=@PAG_ID)
				
					--// Modificado	por	: Henry D. Morales Tasaico	-	18/06/2018
					--// Asunto			: Se agergó el enlace entre NC y Transaccion
					Update c
						Set c.Doc_Tra_GruId = @grupo_automatic
					From @Detalle_Pago_ps a
						Inner Join Nota_Credito b
							On SUBSTRING(a.pag_nro_tran,3,12) = dbo.Devolver_Serie_Doc(b.Not_BasId,b.Not_Alm_Id) + right(replicate('0',8) + cast(b.not_numero as varchar(15)),8)
						Inner Join Documento_Transaccion c
							On c.Doc_Tra_Doc = b.Not_Id And c.Doc_Tra_ConId = a.pag_codigo
					Where a.pag_codigo = '98';

				 END

			   --modifcamos el pedido cabezera con mision cero
			   --en este caso si es que no tiene comision
			   --if (select count(*) from Pedido_Detalle where Ped_Det_Id=@Ped_Id and Ped_Det_ComisionP=0)>0 begin
				  --update Pedido set Ped_Por_Com=0,Ped_Mto_Perc=0 where Ped_Id=@Ped_Id				  
				  --update Liquidacion set Liq_ComisionP=0 where Liq_Id=@Liq_Id				  
			   --end


			   --select * from Liquidacion where Liq_Id='10464'
			   --select * from Pedido_Detalle where Ped_Det_Id='10756'
			   --select * from Liquidacion_Detalle where Liq_Det_Id='10464'

			end		
			
			--modifica liquidacion
			if @Estado=2 begin	
				
				--vamos a validar si es que ya esta cancelado
				
				IF (select count(*) from Liquidacion where Liq_Id=@Liq_Id AND NOT Liq_GruId IS NULL)>0 BEGIN
					set @valida_estado=1
				END
				--set @valida_estado=0
				if @valida_estado=0 begin			
				
						 select @Ped_Id=Liq_PedId from Liquidacion where Liq_Id=@LiqId 

						 update Liquidacion set Liq_Fecha=cast(Getdate() as date),Liq_Fecha_Expiracion=cast(GETDATE() + 2   as date),
						 Liq_Igv=cast(a.IgvM as numeric(10,2)),Liq_ComisionP=Ped_Por_Com,Liq_PercepcionM=Ped_Mto_Perc,
						 Liq_PercepcionP=@Ped_Por_Perc,Liq_FechaMod=getdate(),Liq_Usu_Mod=@Liq_Usu,liq_credito=@Pago_Credito,Liq_EstId=@Est_Id
						 from  Liquidacion inner join
						 Pedido on Liq_PedId=Ped_Id  
						 inner join 			
						 (select Ped_Det_Id,IgvM=sum((Ped_Det_Cantidad*Ped_Det_Precio) - (Ped_Det_ComisionM + isnull(Ped_Det_OfertaM,0))) * (@IgvPorc/100)
						 from Pedido_Detalle where Ped_Det_Id=@Ped_Id group by Ped_Det_Id) a
						 on a.Ped_Det_Id=Ped_Id
						 where Liq_Id=@LiqId

						 delete from Liquidacion_Detalle where Liq_Det_Id=@LiqId
						 insert into Liquidacion_Detalle(Liq_Det_Id,Liq_Det_Items,Liq_Det_ArtId,Liq_Det_TalId,Liq_Det_Cantidad,Liq_Det_Costo,
						 Liq_Det_Precio,Liq_Det_Comision,Liq_Det_OfeID,Liq_Det_OfertaP,Liq_Det_OfertaM)
						 select @LiqId,Ped_Det_Items,Ped_Det_ArtId,Ped_Det_TalId,Ped_Det_Cantidad,Ped_Det_Costo,Ped_Det_Precio,Ped_Det_ComisionM,isnull(Ped_Det_OfeID,0),
						 isnull(Ped_Det_OfertaP,0),
						 isnull(Ped_Det_OfertaM,0) from Pedido_Detalle where Ped_Det_Id=@Ped_Id

						 EXECUTE USP_Insertar_Modificar_Mov 1,'7','52',@Ped_Id,1
						 EXECUTE USP_Insertar_Modificar_Mov 1,'11','53',@Ped_Id

						 /*PEDIDO ORIGINAL*/

						 delete from Liquidacion_Original where liq_idori=@Liq_Id

						 insert into Liquidacion_Original(liq_idori,liq_ori_items,liq_ori_articulo,liq_ori_talla,liq_ori_cantidad)

						 select @Liq_Id,items,articulo,talla,cantidad from @pedido_original

							--modifcamos el pedido cabezera con mision cero
					   --en este caso si es que no tiene comision
					   if (select count(*) from Pedido_Detalle where Ped_Det_Id=@Ped_Id and Ped_Det_ComisionP=0)>0 begin
						  update Pedido set Ped_Por_Com=0,Ped_Mto_Perc=0 where Ped_Id=@Ped_Id				  
						  update Liquidacion set Liq_ComisionP=0 where Liq_Id=@Liq_Id				  
					   end

			   end
			end

			--pago con tarjeta visa unica
			if @Pago_Pos=1 begin
				if  len(@LiqId)>0 begin
				    set @Liq_Id=@LiqId
				end

				declare @Gru_Id  varchar(12)				
				execute USP_Insertar_Pago @Liq_BasId,@Pago_PosTarjeta,@Pago_numconsigacion,@Pago_Total,@Liq_Usu,@Gru_Id output,'9NE',0,@IgvPorc,0,0
				update Liquidacion set Liq_GruId=@Gru_Id,Liq_EstId='PM' where Liq_Id=@Liq_Id

				--select * from Estado
			end

			--FORMA DE PAGO DE LA LIQUIDACION PAGO DIRECTO			
			if @valida_estado=0 begin	
				if (select count(*) from @DetallePago)>0 begin
				   --select * from @DetallePago			 
				   if  len(ltrim(rtrim(@LiqId)))>0 begin
						set @Liq_Id=@LiqId
				   end 			 
				   ----borrando liquidacion detalle

				  
			   
				   ----
				   declare @importeq_liq   money
				   declare @importe_pago money
				   select @importeq_liq=sum(cast((Liq_Det_Cantidad * Liq_Det_Precio) - (Liq_Det_Comision + isnull(Liq_Det_OfertaM,0))  as numeric(10,2))) + avg(Liq_Igv) from Liquidacion inner join Liquidacion_Detalle on Liq_Id=Liq_Det_Id	where Liq_Id=@Liq_Id
				   select @importe_pago=sum(Monto)  from @DetallePago
				   declare @doc_tra_con_id varchar(5),@doc_tra_doc  varchar(12),@monto_item money,@grupo varchar(12)=''				
					
						if cast(@importeq_liq as numeric(10,2))<=cast(@importe_pago as numeric(10,2)) begin
							--el pago es mayor a la liquidacion						 							
								IF LEN(@grupo)=0 BEGIN
									EXECUTE [USP_Insertar_Grupo] @grupo OUTPUT,@Liq_BasId
								END             
								update Documento_Transaccion set Doc_Tra_GruId=@grupo  from @DetallePago c inner join Documento_Transaccion d on ltrim(rtrim(c.Doc_Tra_id))=ltrim(rtrim(d.Doc_Tra_Id))
								IF LEN(@GRUPO)>0 BEGIN
								   update Liquidacion set Liq_GruId=@grupo,Liq_EstId='PM' where Liq_Id=@Liq_Id							   
								END						
																		
						end
						else
						begin
						--	--queda un saldo en la liquidacion por pagar
								DECLARE @Doc_Tra_Id VARCHAR(12),@Monto_sf money
								DECLARE LIQ_PAGO CURSOR FOR select Doc_Tra_Id,Monto FROM  @DetallePago 
									OPEN LIQ_PAGO FETCH NEXT FROM LIQ_PAGO INTO @Doc_Tra_Id,@Monto_sf
										WHILE @@FETCH_STATUS = 0 BEGIN                       
											  EXECUTE USP_Insertar_Liquidacion_Pago  @Liq_Id,@Doc_Tra_Id,@Monto_sf
										FETCH NEXT FROM LIQ_PAGO INTO @Doc_Tra_Id,@Monto_sf
									END
								CLOSE LIQ_PAGO DEALLOCATE LIQ_PAGO
							
						  		
						end


				 --VERIFICAR EL CLIENTE QUE SEA DEL MISMO SIN COMBINAR
				 IF  @grupo IS NOT NULL OR LEN(@grupo)>0 BEGIN

				   declare @usu_verifica numeric,@usu_tmp numeric
				   select @usu_verifica=Liq_BasId from Liquidacion where Liq_Id=@Liq_Id				  	   
				   
					DECLARE VERI_CLI CURSOR FOR  select DISTINCT Doc_Tra_BasId from  Documento_Transaccion   where Doc_Tra_GruId=@grupo			
						OPEN VERI_CLI FETCH NEXT FROM VERI_CLI INTO @usu_tmp
							WHILE @@FETCH_STATUS = 0 BEGIN                       
								if @usu_tmp!=@usu_verifica begin
									declare @valida_saldo money =0/0
								end
							FETCH NEXT FROM VERI_CLI INTO @usu_tmp
						END
					CLOSE VERI_CLI DEALLOCATE VERI_CLI

			   END

				end
			


			delete from tmp_liq_correo where liq_id=@LiqId
			insert into tmp_liq_correo(liq_id)
			values(@Liq_Id)

			end
			--*********************
		--select * from Liquidacion
		
		COMMIT TRAN Grabar_Liquidacion
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN Grabar_Liquidacion
		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT; 		
		EXECUTE USP_ERRORES_SERVER @ErrorMessage OUTPUT,@ErrorSeverity OUTPUT ,@ErrorState OUTPUT	
		
		if len(@error_cliente)>0 begin
			SET @ErrorMessage=@error_cliente + '===>>' + @ErrorMessage;
		end
				
		RAISERROR (@ErrorMessage, -- Message text.
           @ErrorSeverity, -- Severity.
           @ErrorState	 -- State.
           ); 		
	END CATCH


	--select * from Estado


