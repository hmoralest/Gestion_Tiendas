If Exists(Select * from sysobjects Where name = 'USP_Correo_VentasxDia_Aqua' And type = 'P')
	Drop Procedure USP_Correo_VentasxDia_Aqua
GO

-- =====================================================================
-- Author		: Henry Morales
-- Create date	: 30/04/2018
-- Description	: Envía correo de Ventas por Día por Cadena (o todas)
-- =====================================================================
/*
	exec [dbo].[USP_Correo_VentasxDia_Aqua]  '','DIA ANTERIOR', 1
	exec [dbo].[USP_Correo_VentasxDia_2]  'BA','DIA ACTUAL', 0
*/

CREATE PROCEDURE USP_Correo_VentasxDia_Aqua(
	@cod_cadena Varchar(2),
	@tipo		Varchar(20),	-- SEMANA ANTERIOR, DIA ANTERIOR, DIA ACTUAL
	@sendmail	Int				-- 1=Envia Email  0=No Envia
)
AS	
 
BEGIN

	-- INICIO: VENTAS X DISTRITO
	DECLARE @titulo1	Varchar(100),
			@titulo2	Varchar(100),
			@titulo3	Varchar(100),
			@semac		Varchar(6),
			@NRegs		INT;

	DECLARE @html_formato nvarchar(max)=(select Html from tFormato_Html where Codigo= CASE @cod_cadena WHEN '' THEN 'BA' ELSE @cod_cadena END);	
	DECLARE @agrega_html  nvarchar(max)='';
	
	Declare	@fecproc	Date,
			@semproc	Char(6),
			@fisemproc	Date,
			@ffsemproc	Date;

	Declare @fecly		Date,
			@fisemly	Date,
			@ffsemly	Date,
			@semly		Char(6) 

	Declare	@fechoy		Date,
			@semhoy		Char(6),
			@fisemhoy	Date,
			@ffsemhoy	Date,
			@dw			Int;

	Set @fechoy = GETDATE()

 	IF @tipo='SEMANA ANTERIOR'
    BEGIN	  
	  Set		@semhoy		= (select cod_semana from tsemana where @fechoy>=fec_inicio and @fechoy<=fec_final)
      Select	@fisemhoy	= fec_inicio, @ffsemhoy=fec_final from tsemana where cod_semana=@semhoy
	  Set		@fecproc	= DATEADD(day, -1, @fisemhoy) 
	END
    IF @tipo='DIA ANTERIOR'
	BEGIN
	  Set		@fecproc	= DATEADD(day, -1, @fechoy) -- '2017-08-06' -- OJO 
	END
	IF @tipo='DIA ACTUAL'
	BEGIN
	  Set		@fecproc	= @fechoy
    END	

	--Set @fecproc = '20180207'

	--// Se obtienen los datos de semanas, para poder obtener el rango de Fechas
    Set		@dw			= (select DATEPART(dw, @fecproc));	-- Dia de la semana
    Select	@semproc = cod_semana,	@semly = cod_semref from POSTGRES.scomercial.[public].tsemana where @fecproc>=fec_inicio and @fecproc<=fec_final;	-- Semana actual
	--Set	@semproc	= (select cod_semana from tsemana where @fecproc>=fec_inicio and @fecproc<=fec_final);
    Set		@fecly		= (select DATEADD(day, @dw-1, fec_inicio) from tsemana where cod_semana=@semly);
    Select	@fisemproc	= fec_inicio,	@ffsemproc	= fec_final	From tsemana Where cod_semana=@semproc;
    Select	@fisemly	= fec_inicio,	@ffsemly	= fec_final	From tsemana where cod_semana=@semly;

	
	DECLARE @cadena VARCHAR(20)
	SET @cadena = CASE @cod_cadena
	                WHEN 'BA' THEN 'BATA'
	                WHEN 'WB' THEN 'WEINBRENNER'
	                WHEN 'BG' THEN 'BUBBLE GUMMERS'
					ELSE 'BA, WB y BG'
	              END

	SET @titulo1 = 'El servidor Retail informa sobre las Ventas del dia por distrito Tiendas '+@cadena
	SET @titulo2 = 'Ventas del dia '  + Convert(char(2),day(@fecproc)) + ' ' + DATENAME(month,@fecproc) + ' ' + Convert(char(4),year(@fecproc))	
	--SET @semac   = (select cod_semana from tsemana where @fecha>=fec_inicio and @fecha<=fec_final)
	SET @titulo3 = 'Ventas de la semana ' + substring(@semproc,5,2)

	
		-- Obtener venta desde tabla tventasxdia
		DECLARE @tabla table(
			distrito varchar(20), 
			nrotdas int, 
			paresac money,
			solesac money, 
			costoac money, 
			margac numeric(8,2), 
			paresly money,
			solesly money,
			costoly money,
			margly numeric(8,2),
			mrgest numeric(8,2),
			sest numeric(8,2),
			saly numeric(8,2),
			paresseac money,
			solesseac money, 
			costoseac money, 
			margseac numeric(8,2),
			paressely money, 
			solessely money, 
			costosely money, 
			margsely numeric(8,2),
			margseest numeric(8,2), 
			test numeric(10,2), 
			taly numeric(10,2) 
		)

		IF OBJECT_ID('tempdb..#Vta_Aqua') Is Not Null  
		BEGIN  
			Drop table #Vta_Aqua;
		END  

		Create table #Vta_Aqua(
			fecha		Date, 
			articulo	Varchar(12),
			pares		Money, 
			costo		Money, 
			soles		Money, 
			qfac		Money
		)

		Insert Into #Vta_Aqua (fecha, articulo, pares, costo, soles, qfac)
		Select
			cab.Ven_Fecha,
			det.Ven_Det_ArtId,
			sum(IsNull(case when left(det.Ven_Det_ArtId,1)!='9' THEN det.Ven_Det_Cantidad else 0 end,0)),
			sum(IsNull(det.Ven_Det_Costo,0)),
			sum(IsNull(det.Ven_Det_Precio - det.Ven_Det_ComisionM,0.00)),
			sum(IsNull(det.Ven_Det_Cantidad,0.00))
		From Venta cab
		Inner Join Venta_Detalle det
			ON cab.Ven_Id = det.Ven_Det_Id
		Group by cab.Ven_Fecha, det.Ven_Det_ArtId
		Union
		Select 
			cab.Not_Fecha,
			det.Not_Det_ArtId,
			sum(IsNull(case when left(det.Not_Det_ArtId,1)!='9' THEN det.Not_Det_Cantidad else 0 end,0))*(0-1),
			sum(IsNull(csto.Art_Costo,0))*(0-1),
			sum(IsNull(det.Not_Det_Precio - det.Not_Det_ComisionM,0.00))*(0-1),
			sum(IsNull(det.Not_Det_Cantidad,0.00))*(0-1)
		From Nota_Credito cab
			Inner Join Nota_Credito_Detalle det
				On cab.Not_Id = det.Not_Det_Id
			Left Join Articulo_Costo csto
				On det.Not_Det_ArtId = csto.Art_Costo_Id
		Group by cab.Not_Fecha, det.Not_Det_ArtId

		--Order by cab.Ven_Fecha DESC

		
	/**************************************************************************************************************************/


		Insert Into	@tabla
		--// Se da formato a la información
		Select 
				distrito     = 'Distrito ' +distri.cod_distri,
				nrotdas      = (select count(distinct tienda) from #VtaxDiax where fecha=@fecproc and distrito=distri.cod_distri),

				paresac      = IsNull(paresac,0.00),
				solesac      = IsNull(solesac,0.00),
				costoac      = IsNull(costoac,0.00),
				margac       = case when solesac<>0 then Convert(decimal(16,2),IsNUll(((solesac-costoac)/solesac),0)*100) else 0.00 end,   

				paresly      = IsNull(paresly,0.00),
				solesly      = IsNull(solesly,0.00),
				costoly      = IsNull(costoly,0.00),
				margly       = case when solesly<>0 then Convert(decimal(16,2),IsNUll(((solesly-costoly)/solesly),0)*100) else 0.00 end,

				margest      = 0.00, --case when e.soles>0 then Convert(decimal(16,2), (a.soles/e.soles)*100) else 0.00 end

				sest         = case when solesest<>0 then Convert(decimal(16,2),IsNUll((solesac/solesest),0)*100) else 0.00 end,  -- ventas dia actual / ventas dia presupuesto
				saly         = case when solesly<>0  then Convert(decimal(16,2),IsNUll((solesac/solesly),0)*100)  else 0.00 end,  -- ventas dia actual / ventas dia año pasado

				paressemproc = IsNull(paressemproc,0.00),
				solessemproc = IsNull(solessemproc,0.00),
				costosemproc = IsNull(costosemproc,0.00),
				margsemproc  = case when solessemproc<>0 then Convert(decimal(16,2),IsNUll(((solessemproc-costosemproc)/solessemproc),0)*100) else 0.00 end,

				paressemly   = IsNull(paressemly,0.00),
				solessemly   = IsNull(solessemly,0.00),
				costosemly   = IsNull(costosemly,0.00),		
				margsemly    = case when solessemly<>0 then Convert(decimal(16,2),IsNUll(((solessemly-costosemly)/solessemly),0)*100) else 0.00 end,

				margseest    = 0.00, --case when f.soles>0 then Convert(decimal(16,2), (c.soles/f.soles)*100) else 0.00 end

				test         = case when solessemest<>0 then Convert(decimal(16,2),IsNUll((solessemproc/solessemest),0)*100) else 0.00 end,
				taly         = case when solessemly<>0  then Convert(decimal(16,2),IsNUll((solessemproc/solessemly),0)*100)  else 0.00 end

		From	
			(	Select distinct cod_distri
				From tentidad_tienda) distri
			-- Venta Fecha Actual
			Full Join
				(	Select distrito, sum(IsNull(pares,0.00)) As paresac, sum(IsNull(soles,0.00)) As solesac, sum(IsNull(costo,0.00)) As costoac
					From #VtaxDiax
					Where fecha=@fecproc
					Group by distrito	) fec_actual
				On distri.cod_distri = fec_actual.distrito
			-- venta fecha año pasado
			Full Join 
				(	Select distrito, sum(IsNull(pares,0.00)) As paresly, sum(IsNull(soles,0.00)) As solesly, sum(IsNull(costo,0.00)) As costoly
					From #VtaxDiax
					Where fecha=@fecly 
					Group by distrito	) fec_anterior
				On distri.cod_distri = fec_anterior.distrito
			-- venta semana actual (avance hasta el dia actual)
			Full Join
				(	Select distrito, sum(IsNull(pares,0.00)) As paressemproc, sum(IsNull(soles,0.00)) As solessemproc, sum(IsNull(costo,0.00)) As costosemproc
					From #VtaxDiax
					Where (fecha>=@fisemproc and fecha<=DATEADD(day,@dw-1,@fisemproc)) 
					Group by distrito	) sem_actual 
				On distri.cod_distri = sem_actual.distrito
			-- venta semana año pasado (avance hasta el dia actual)
			Full Join
				(	Select distrito, sum(IsNull(pares,0.00)) As paressemly, sum(IsNull(soles,0.00)) As solessemly, sum(IsNull(costo,0.00)) As costosemly
					From #VtaxDiax
					Where (fecha>=@fisemly and fecha<=dateadd(day,@dw-1,@fisemly)) 
					Group by distrito	) sem_anterior
				On distri.cod_distri= sem_anterior.distrito
			-- presupuesto dia actual
			Left Join 
				(	Select	distrito, sum(IsNull(importe*
							case when @dw=1 then d1/100 else
							case when @dw=2 then d2/100 else
							case when @dw=3 then d3/100 else
							case when @dw=4 then d4/100 else
							case when @dw=5 then d5/100 else
							case when @dw=6 then d6/100 else
							case when @dw=7 then d7/100 end end end end end end end, 0.00))	As solesest
					From presutda WITH(NOLOCK) 
						Inner Join POSTGRES.scomercial.[public].tentidad_tienda tt 
							On presutda.tda = tt.cod_entid And (@cod_cadena='' Or (tt.cod_cadena = @cod_cadena))
					Where sem=@semproc And distrito<>'521'  
					Group by distrito	) pres_dia_act
				On distri.cod_distri = pres_dia_act.distrito	
			-- presupuesto semana actual (avance hasta el dia actual)
			Left Join 
				(	Select distrito, sum(IsNull(
						case when @dw=1 then d1/100*importe else
						case when @dw=2 then d1/100*importe + d2/100*importe else
						case when @dw=3 then d1/100*importe + d2/100*importe + d3/100*importe else
						case when @dw=4 then d1/100*importe + d2/100*importe + d3/100*importe + d4/100*importe else
						case when @dw=5 then d1/100*importe + d2/100*importe + d3/100*importe + d4/100*importe + d5/100*importe else
						case when @dw=6 then d1/100*importe + d2/100*importe + d3/100*importe + d4/100*importe + d5/100*importe + d6/100*importe else
						case when @dw=7 then d1/100*importe + d2/100*importe + d3/100*importe + d4/100*importe + d5/100*importe + d6/100*importe + d7/100*importe  end end end end end end end, 0.00)) As solessemest
					From presutda WITH(NOLOCK) 
						Inner Join POSTGRES.scomercial.[public].tentidad_tienda tt 
							On presutda.tda = tt.cod_entid And (@cod_cadena='' Or (tt.cod_cadena = @cod_cadena))
					Where sem=@semproc And distrito<>'521'
					Group by distrito	) pres_sem_act
				On distri.cod_distri = pres_sem_act.distrito
		WHERE fec_actual.distrito Is Not Null Or fec_anterior.distrito Is Not Null Or sem_actual.distrito Is Not Null Or sem_anterior.distrito Is Not Null Or IsNull(pres_dia_act.solesest,0) <> 0 Or IsNull(pres_sem_act.solessemest,0) <> 0

		UNION ALL
	
		select 
			distrito    = 'TOTAL',
			nrotdas     = (select count(distinct tienda) from #VtaxDiax where fecha=@fecproc),
	
			paresac, 
			solesac,
			costoac,
			margac      = case when solesac<>0 then Convert(decimal(16,2),((solesac-costoac)/solesac)*100) else 0.00 end,

			paresly, 
			solesly,
			costoly,
			margly      = case when solesly<>0 then Convert(decimal(16,2),((solesly-costoly)/solesly)*100) else 0.00 end,

			margest     = 0.00,

			sest        = case when soleses<>0 then Convert(decimal(16,2),(solesac/soleses)*100) else 0.00 end, 
			saly        = case when solesly<>0 then Convert(decimal(16,2),(solesac/solesly)*100) else 0.00 end,   

			paressemproc,
			solessemproc,
			costosemproc,
			margsemproc = case when solessemproc<>0 then Convert(decimal(16,2),((solessemproc-costosemproc)/solessemproc)*100) else 0.00 end,

			paressemly,
			solessemly,
			costosemly,
			margsemly   = case when solessemly<>0 then Convert(decimal(16,2),((solessemly-costosemly)/solessemly)*100) else 0.00 end,

			margseest   = 0.00,
			test        = case when solessemes<>0 then Convert(decimal(16,2),(solessemproc/solessemes)*100) else 0.00 end, 
			taly        = case when solessemly<>0 then Convert(decimal(16,2),(solessemproc/solessemly)*100) else 0.00 end		

		From	
		-- Venta Fecha Actual
			(	Select sum(IsNull(pares,0.00)) As paresac, sum(IsNull(soles,0.00)) As solesac, sum(IsNull(costo,0.00)) As costoac
				From #VtaxDiax
				Where fecha=@fecproc) fec_actual,
		-- venta fecha año pasado
			(	Select sum(IsNull(pares,0.00)) As paresly, sum(IsNull(soles,0.00)) As solesly, sum(IsNull(costo,0.00)) As costoly
				From #VtaxDiax
				Where fecha=@fecly 	) fec_anterior,
		-- venta semana actual (avance hasta el dia actual)
			(	Select sum(IsNull(pares,0.00)) As paressemproc, sum(IsNull(soles,0.00)) As solessemproc, sum(IsNull(costo,0.00)) As costosemproc
				From #VtaxDiax
				Where (fecha>=@fisemproc and fecha<=DATEADD(day,@dw-1,@fisemproc)) ) sem_actual,
		-- venta semana año pasado (avance hasta el dia actual)
			(	Select sum(IsNull(pares,0.00)) As paressemly, sum(IsNull(soles,0.00)) As solessemly, sum(IsNull(costo,0.00)) As costosemly
				From #VtaxDiax
				Where (fecha>=@fisemly and fecha<=dateadd(day,@dw-1,@fisemly)) ) fsem_anterior,
		-- presupuesto dia actual
		(	Select sum(IsNull(
					importe*case when @dw=1 then d1/100 else
							case when @dw=2 then d2/100 else
							case when @dw=3 then d3/100 else
							case when @dw=4 then d4/100 else
							case when @dw=5 then d5/100 else
							case when @dw=6 then d6/100 else
							case when @dw=7 then d7/100 end end end end end end end, 0.00))	As soleses
			From presutda WITH(NOLOCK)
				Inner Join POSTGRES.scomercial.[public].tentidad_tienda tt 
					On presutda.tda = tt.cod_entid And (@cod_cadena='' Or (tt.cod_cadena = @cod_cadena))
			Where sem=@semproc
			  And distrito<>'521'	) pres_dia_act,
		-- presupuesto semana actual (avance hasta el dia actual)		
		(	Select sum(IsNull(
					case when @dw=1 then d1/100*importe else
					case when @dw=2 then d1/100*importe + d2/100*importe else
					case when @dw=3 then d1/100*importe + d2/100*importe + d3/100*importe else
					case when @dw=4 then d1/100*importe + d2/100*importe + d3/100*importe + d4/100*importe else
					case when @dw=5 then d1/100*importe + d2/100*importe + d3/100*importe + d4/100*importe + d5/100*importe else
					case when @dw=6 then d1/100*importe + d2/100*importe + d3/100*importe + d4/100*importe + d5/100*importe + d6/100*importe else
					case when @dw=7 then d1/100*importe + d2/100*importe + d3/100*importe + d4/100*importe + d5/100*importe + d6/100*importe + d7/100*importe end end end end end end end, 0.00)) As solessemes
			From presutda WITH(NOLOCK)
				Inner Join POSTGRES.scomercial.[public].tentidad_tienda tt 
					On presutda.tda = tt.cod_entid And (@cod_cadena='' Or (tt.cod_cadena = @cod_cadena))
			Where sem=@semproc
			  And distrito<>'521'	) pres_sem_act

		Order by 1