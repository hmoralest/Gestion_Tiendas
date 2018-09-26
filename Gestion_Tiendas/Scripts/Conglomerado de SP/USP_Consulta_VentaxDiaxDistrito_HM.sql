If Exists(Select * from sysobjects Where name = 'USP_Consulta_VentaxDiaxDistrito_HM' And type = 'P')
	Drop Procedure USP_Consulta_VentaxDiaxDistrito_HM
GO

-- =====================================================================
-- Author		: Henry Morales
-- Create date	: 30/04/2018
-- Description	: Envía correo de Ventas por Día por Distrito
-- =====================================================================
/*
	exec [dbo].[USP_Consulta_VentaxDiaxDistrito_HM]  '20180430','BA','20170501','201818','201719','20180430','20180506','20170501','20170507','1'
	exec [dbo].[USP_Consulta_VentaxDiaxDistrito]  '20180430','BA','20170501','201818','201719','20180430','20180506','20170501','20170507','1'
*/

CREATE procedure [dbo].[USP_Consulta_VentaxDiaxDistrito_HM](
	@fecproc	Date,
	@cod_cadena	Varchar(2),
	@fecly		Date,
	@semproc	Char(6),
	@semly		Char(6),
	@fisemproc	Date,
	@ffsemproc	Date,
	@fisemly	Date,
	@ffsemly	Date,
	@dw			Int
)
AS

BEGIN

	-- Se trabaja con una tabla temporal para que todos los reportes tengan el mismo resultado (este es el primer reporte)
	-- Borrar y añadir registros a la tabla temporal
	--TRUNCATE TABLE tventasxdia_aux
	/*DELETE FROM tventasxdia_aux WHERE COD_CADENA=@cod_cadena
	DELETE FROM tventasxdia_aux WHERE COD_CADENA=@cod_cadena*/

	IF OBJECT_ID('tempdb..#VtaxDiaxDist') IS NOT NULL  
	BEGIN  
		Drop table #VtaxDiaxDist;
	END  

	Create table #VtaxDiaxDist(
		cod_cadena	Varchar(5), 
		fecha		Date, 
		distrito	Varchar(5),
		tienda		Varchar(10),
		pares		Decimal(18,4), 
		costo		Decimal(18,4), 
		soles		Decimal(18,4), 
		qfac		Decimal(18,4)
	)

	--// Se obtiene información a usar
	Insert Into #VtaxDiaxDist (cod_cadena, fecha, distrito, tienda, pares, costo, soles, qfac)
	Select	 td.cod_cadena
			,c.FC_FFAC
			,td.cod_distri
			,td.COD_ENTID
			,sum(isnull(case when @cod_cadena='BA' then case when left(d.FD_ARTI,1)!='9' THEN d.FD_QFAC else 0 end else d.FD_QFAC end * case when c.fc_suna='07' then -1 else 1 end,0.00))
			,sum(isnull(dbo.fcosto(d.FD_ARTI,d.ID_CALIDAD,c.FC_FFAC)*d.fd_qfac*case when c.fc_suna='07' then -1 else 1 end,0))
			,sum(isnull(d.FD_VVTA*case when c.fc_suna='07' then -1 else 1 end,0.00))
			,sum(isnull(d.fd_qfac*case when c.fc_suna='07' then -1 else 1 end,0.00))
	From FFACTC c with(nolock)
		Inner join FFACTD d with(nolock) 
			on c.COD_ENTID=d.COD_ENTID AND c.FC_NINT=d.FD_NINT And d.FD_ARTI!='9998888' And d.COD_SECCI='5'
			And not (c.cod_entid>='50850' and c.cod_entid<='50899')
		Inner join POSTGRES.scomercial.[public].tentidad_tienda td with(nolock) 
			on td.cod_entid=c.COD_ENTID And td.cod_distri <> '521' 
	where ((c.FC_FFAC>=@fisemproc and c.FC_FFAC<=@ffsemproc) OR (c.FC_FFAC>=@fisemly and c.FC_FFAC<=@ffsemly))
	  And c.FC_ESTA IS NULL 
	  And (rtrim(ltrim(@cod_cadena))='' Or (td.cod_cadena=@cod_cadena))
	Group by td.cod_cadena, c.FC_FFAC, td.cod_distri, td.COD_ENTID

	--// Se da formato a la información
	Select 
			distrito     = 'Distrito ' +fec_actual.distrito,
			nrotdas      = (select count(distinct tienda) from #VtaxDiaxDist where fecha=@fecproc and distrito=fec_actual.distrito),

			paresac      = isnull(paresac,0.00),
			solesac      = isnull(solesac,0.00),
			costoac      = isnull(costoac,0.00),
			margac       = case when solesac<>0 then convert(decimal(16,2),((solesac-costoac)/solesac)*100) else 0.00 end,   

			paresly      = isnull(paresly,0.00),
			solesly      = isnull(solesly,0.00),
			costoly      = isnull(costoly,0.00),
			margly       = case when solesly<>0 then convert(decimal(16,2),((solesly-costoly)/solesly)*100) else 0.00 end,

			margest      = 0.00, --case when e.soles>0 then convert(decimal(16,2), (a.soles/e.soles)*100) else 0.00 end

			sest         = case when solesest<>0 then convert(decimal(16,2),(solesac/solesest)*100) else 0.00 end,  -- ventas dia actual / ventas dia presupuesto
			saly         = case when solesly<>0  then convert(decimal(16,2),(solesac/solesly)*100)  else 0.00 end,  -- ventas dia actual / ventas dia año pasado

			paressemproc = isnull(paressemproc,0.00),
			solessemproc = isnull(solessemproc,0.00),
			costosemproc = isnull(costosemproc,0.00),
			margsemproc  = case when solessemproc<>0 then convert(decimal(16,2),((solessemproc-costosemproc)/solessemproc)*100) else 0.00 end,

			paressemly   = isnull(paressemly,0.00),
			solessemly   = isnull(solessemly,0.00),
			costosemly   = isnull(costosemly,0.00),		
			margsemly    = case when solessemly<>0 then convert(decimal(16,2),((solessemly-costosemly)/solessemly)*100) else 0.00 end,

			margseest    = 0.00, --case when f.soles>0 then convert(decimal(16,2), (c.soles/f.soles)*100) else 0.00 end

			test         = case when solessemest<>0 then convert(decimal(16,2),(solessemproc/solessemest)*100) else 0.00 end,
			taly         = case when solessemly<>0  then convert(decimal(16,2),(solessemproc/solessemly)*100)  else 0.00 end

	From	
	-- Venta Fecha Actual
		(	Select distrito, sum(isnull(pares,0.00)) As paresac, sum(isnull(soles,0.00)) As solesac, sum(isnull(costo,0.00)) As costoac
			From #VtaxDiaxDist
			Where fecha=@fecproc
			Group by distrito	) fec_actual
		-- venta fecha año pasado
		Full Join 
			(	Select distrito, sum(isnull(pares,0.00)) As paresly, sum(isnull(soles,0.00)) As solesly, sum(isnull(costo,0.00)) As costoly
				From #VtaxDiaxDist
				Where fecha=@fecly 
				Group by distrito	) fec_anterior
			On fec_actual.distrito = fec_anterior.distrito
		-- venta semana actual (avance hasta el dia actual)
		Full Join
			(	Select distrito, sum(isnull(pares,0.00)) As paressemproc, sum(isnull(soles,0.00)) As solessemproc, sum(isnull(costo,0.00)) As costosemproc
				From #VtaxDiaxDist
				Where (fecha>=@fisemproc and fecha<=DATEADD(day,@dw-1,@fisemproc)) 
				Group by distrito	) sem_actual 
			On fec_anterior.distrito = sem_actual.distrito
		-- venta semana año pasado (avance hasta el dia actual)
		Full Join
			(	Select distrito, sum(isnull(pares,0.00)) As paressemly, sum(isnull(soles,0.00)) As solessemly, sum(isnull(costo,0.00)) As costosemly
				From #VtaxDiaxDist
				Where (fecha>=@fisemly and fecha<=dateadd(day,@dw-1,@fisemly)) 
				Group by distrito	) fsem_anterior
			On sem_actual.distrito= fsem_anterior.distrito
		-- presupuesto dia actual
		Left Join 
			(	Select	distrito, sum(isnull(importe*
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
			On fsem_anterior.distrito = pres_dia_act.distrito	
		-- presupuesto semana actual (avance hasta el dia actual)
		Left Join 
			(	Select distrito, sum(isnull(
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
			On pres_dia_act.distrito = pres_sem_act.distrito		

	UNION ALL
	
	select 
		distrito    = 'TOTAL',
		nrotdas     = (select count(distinct tienda) from #VtaxDiaxDist where fecha=@fecproc),
	
		paresac, 
		solesac,
		costoac,
		margac      = case when solesac<>0 then convert(decimal(16,2),((solesac-costoac)/solesac)*100) else 0.00 end,

		paresly, 
		solesly,
		costoly,
		margly      = case when solesly<>0 then convert(decimal(16,2),((solesly-costoly)/solesly)*100) else 0.00 end,

		margest     = 0.00,

		sest        = case when soleses<>0 then convert(decimal(16,2),(solesac/soleses)*100) else 0.00 end, 
		saly        = case when solesly<>0 then convert(decimal(16,2),(solesac/solesly)*100) else 0.00 end,   

		paressemproc,
		solessemproc,
		costosemproc,
		margsemproc = case when solessemproc<>0 then convert(decimal(16,2),((solessemproc-costosemproc)/solessemproc)*100) else 0.00 end,

		paressemly,
		solessemly,
		costosemly,
		margsemly   = case when solessemly<>0 then convert(decimal(16,2),((solessemly-costosemly)/solessemly)*100) else 0.00 end,

		margseest   = 0.00,
		test        = case when solessemes<>0 then convert(decimal(16,2),(solessemproc/solessemes)*100) else 0.00 end, 
		taly        = case when solessemly<>0 then convert(decimal(16,2),(solessemproc/solessemly)*100) else 0.00 end		

	From	
	-- Venta Fecha Actual
		(	Select sum(isnull(pares,0.00)) As paresac, sum(isnull(soles,0.00)) As solesac, sum(isnull(costo,0.00)) As costoac
			From #VtaxDiaxDist
			Where fecha=@fecproc) fec_actual,
	-- venta fecha año pasado
		(	Select sum(isnull(pares,0.00)) As paresly, sum(isnull(soles,0.00)) As solesly, sum(isnull(costo,0.00)) As costoly
			From #VtaxDiaxDist
			Where fecha=@fecly 	) fec_anterior,
	-- venta semana actual (avance hasta el dia actual)
		(	Select sum(isnull(pares,0.00)) As paressemproc, sum(isnull(soles,0.00)) As solessemproc, sum(isnull(costo,0.00)) As costosemproc
			From #VtaxDiaxDist
			Where (fecha>=@fisemproc and fecha<=DATEADD(day,@dw-1,@fisemproc)) ) sem_actual,
	-- venta semana año pasado (avance hasta el dia actual)
		(	Select sum(isnull(pares,0.00)) As paressemly, sum(isnull(soles,0.00)) As solessemly, sum(isnull(costo,0.00)) As costosemly
			From #VtaxDiaxDist
			Where (fecha>=@fisemly and fecha<=dateadd(day,@dw-1,@fisemly)) ) fsem_anterior,
	-- presupuesto dia actual
	(	Select sum(isnull(
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
	(	Select sum(isnull(
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

END

