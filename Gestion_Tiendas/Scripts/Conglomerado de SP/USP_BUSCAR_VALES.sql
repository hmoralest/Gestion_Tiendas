/*
	USP_BUSCAR_VALES '','0Q2N895YF8C32','50336'
*/

ALTER PROCEDURE [dbo].[USP_BUSCAR_VALES]
(
	@correlativo varchar(8),
	@code        varchar(15),
	@tda		 varchar(5)
)
as

	declare @estado varchar(5)--,@estado_inactivo varchar(5)='CA',@estado_consumido varchar(5)='CO'

/*VERIFICA SI EL CUPON EXISTE*/
	IF (SELECT COUNT(*) FROM Cupones with(nolock) WHERE Cup_Barra=@code)>0 BEGIN
		declare @fecha_expiracion varchar(20),@por_desc_str varchar(5),@promo_des varchar(100),@por_des_int int,@par_max int,@prom_id varchar(5),@monto_vale money
		select @estado=Cup_EstID,@fecha_expiracion=convert(varchar,Cup_Fecha_Fin,106),@por_desc_str=cast(cast(Cup_PorcDesc as int) as varchar) + '%',
		@promo_des=dbo.ConvertMayMin(Prom_Des),@por_des_int=Cup_PorcDesc,@par_max=Cup_MaxPares,@prom_id=Cup_PromID,@monto_vale=isnull(Cup_Val_Monto,0) from Cupones with(nolock)
		inner join Promocion with(nolock) on Prom_ID=Cup_PromID where Cup_Barra=@code
		/*verifica si esta caducado el cupon ya se vencio se fecha de expiracion*/
		if @estado='CA' BEGIN
			SELECT descripcion='!El N° de cupon: ' +  @code + ' se expiro el ' + @fecha_expiracion
			goto salir
		END
		-- Modificado por	: Henry Morales - 11/04/2018
		/*Se agregó para el estado de las Gift Cards, Emitido (aún no es posible consumirlo)*/
		if @estado='EM' BEGIN
			SELECT descripcion='!El N° de cupon: ' +  @code + ' NO se encuentra Activo'
			goto salir
		END
		/*cuando el cupon esta disponible para su uso*/
		if @estado='DS' BEGIN
			
			/*verificar si la tienda esta habilitada con filtro*/
			declare @verifica_tienda_filtro numeric=(select count(*) from Promocion_Tienda with(nolock) where PromTda_PromID=@prom_id)
			declare @verifica_tienda_existe numeric=(select count(*) from Promocion_Tienda with(nolock) where PromTda_PromID=@prom_id and PromTda_CodTda=@tda)
			declare @permiso_tda numeric=0
			
			if @verifica_tienda_filtro=0 begin
				set @permiso_tda=1 
			end
			else
			begin
				if @verifica_tienda_existe>0 begin set @permiso_tda=1 end
			end
				
				if @permiso_tda=1 begin
					if @monto_vale=0 begin
						SELECT estado='1',descripcion='!El N° de cupon: ' +  @code + ' se encuentra disponible con el ' + @por_desc_str + ' dscto.' + CASE WHEN @fecha_expiracion is NULL THEN '' ELSE ' hasta el ' + @fecha_expiracion END
						--SELECT estado='1',descripcion='!El N° de cupon: ' +  @code + ' se encuentra disponible con el ' + @por_desc_str + ' dscto. hasta el ' + @fecha_expiracion
						+ ', Promocion: {' + @promo_des + '}'
					end
					else
					begin 
						SELECT estado='1',descripcion='!El N° de Vale: ' +  @code + ' se encuentra disponible con S/.' + cast(@monto_vale as varchar) + '.' + CASE WHEN @fecha_expiracion is NULL THEN '' ELSE ' hasta el ' + @fecha_expiracion END
						--SELECT estado='1',descripcion='!El N° de Vale: ' +  @code + ' se encuentra disponible con S/.' + cast(@monto_vale as varchar) + '. hasta el ' + @fecha_expiracion
						+ ', {' + @promo_des + '}'
					end

					select serie=Cup_Serie,correlativo=Cup_Numero,Porc_Descuento=Cup_PorcDesc,pares_max=Cup_MaxPares,
					tipo_des=CASE WHEN LEFT(@promo_des,6)='CUMPLE' then 'C' else '' end,val_tipcupid=Cup_PromID,
					empruc=ISNULL(VCOM_RUC,''),empraz=ISNULL(VCOM_RAZON,''),MONTOVALE=isnull(Cup_Val_Monto,0),DNI='',nombres='',fecha_emi='',tienda_ven='',cliente_venta='',
					fecha_venta='',docu_venta='' from Cupones with(nolock)
					LEFT JOIN Vales_Compra with(nolock) ON VCOM_ID=CUP_VAL_COMP where Cup_Barra=@code

					

					goto salir
			   end
			   else
			   begin
					SELECT descripcion='!El N° de cupon: ' +  @code + ' no esta disponible para esta tienda'
					goto salir
			   end



		end
		/*verifica si el cupon ha sido usado*/
		if @estado='CO' begin
			SELECT estado='3',descripcion='!El N° de cupon: ' +  @code + ', YA FUE CONSUMIDO '

			select serie=Cup_Serie,correlativo=Cup_Numero,Porc_Descuento=Cup_PorcDesc,pares_max=Cup_MaxPares,
			tipo_des=CASE WHEN LEFT(@promo_des,6)='CUMPLE' then 'C' else '' end,val_tipcupid=Cup_PromID,
			empruc='',empraz='',MONTOVALE=0,DNI=Cup_Dni_Ven,nombres=Cup_Nom_Ven,fecha_emi=[dbo].[Fecha_Str]([Cup_FecDoc_Ven]),tienda_ven=CAST(Cup_Tda_Ven AS VARCHAR) + '==>' + des_entid,cliente_venta=Cup_Nom_Ven,
			fecha_venta=[dbo].[Fecha_Str]([Cup_FecDoc_Ven]),docu_venta=IsNull(LTRIM(Rtrim(Cup_SerieDoc_Ven))+'-'+LTRIM(Rtrim(Cup_NumDoc_Ven)),'')  from Cupones with(nolock)
			INNER JOIN tentidad_tienda with(nolock) ON cod_entid=Cup_Tda_Ven  where Cup_Barra=@code
	
			goto salir
		end
	END
	ELSE
	BEGIN
		SELECT descripcion='!El ° de cupon: ' +  @code + ' no existe en la base de datos'
	END
salir:
	--SELECT * FROM Cupones WHERE Cup_Barra='0002696ABF1DB7D'

	--UPDATE Cupones SET Cup_EstID='CA' WHERE Cup_Barra='0002696ABF1DB7D'

	--SELECT * FROM Estado_Cupon

