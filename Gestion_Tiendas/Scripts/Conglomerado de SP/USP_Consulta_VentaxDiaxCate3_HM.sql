If Exists(Select * from sysobjects Where name = 'USP_Consulta_VentaxDiaxCate3_HM' And type = 'P')
	Drop Procedure USP_Consulta_VentaxDiaxCate3_HM
GO

-- =====================================================================
-- Author		: Henry Morales
-- Create date	: 01/05/2018
-- Description	: Envía correo de Ventas por Día por Categoría
-- =====================================================================
/*
	exec [dbo].[USP_Consulta_VentaxDiaxCate3_HM]  '20180430','BA','20170501','201818','201719','20180430','20180506','20170501','20170507','1'
	exec [dbo].[USP_Consulta_VentaxDiaxCate3]  '20180430','BA','20170501','201818','201719','20180430','20180506','20170501','20170507','1'
*/

CREATE procedure [dbo].[USP_Consulta_VentaxDiaxCate3_HM](
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

	/*Declare	@impte_presu_dia_proc	Numeric(18,2),
			@impte_presu_dia1		Numeric(18,2),
			@impte_presu_dia2		Numeric(18,2),
			@impte_presu_dia3		Numeric(18,2),
			@impte_presu_dia4		Numeric(18,2),
			@impte_presu_dia5		Numeric(18,2),
			@impte_presu_dia6		Numeric(18,2),
			@impte_presu_dia7		Numeric(18,2)

	-- presupuesto total dia actual
	set	@impte_presu_dia_proc = (	Select solesest=sum(isnull(importe*
															case when @dw=1 then d1/100 else
															case when @dw=2 then d2/100 else
															case when @dw=3 then d3/100 else
															case when @dw=4 then d4/100 else
															case when @dw=5 then d5/100 else
															case when @dw=6 then d6/100 else
															case when @dw=7 then d7/100 end end end end end end end, 0.00)) 	
									From presutda WITH(NOLOCK) 
										Inner Join POSTGRES.scomercial.[public].tentidad_tienda tt 
											On presutda.tda = tt.cod_entid
									where sem=@semproc 
									  And ( rtrim(ltrim(@cod_cadena)) = '' Or tt.cod_cadena = @cod_cadena )
									  And distrito<>'521') --and exists

	-- presupuesto total x dia
	Select	@impte_presu_dia1 = sum(isnull(importe*d1/100,0.00)),
			@impte_presu_dia2 = sum(isnull(importe*d2/100,0.00)),
			@impte_presu_dia3 = sum(isnull(importe*d3/100,0.00)),
			@impte_presu_dia4 = sum(isnull(importe*d4/100,0.00)),
			@impte_presu_dia5 = sum(isnull(importe*d5/100,0.00)),
			@impte_presu_dia6 = sum(isnull(importe*d6/100,0.00)),
			@impte_presu_dia7 = sum(isnull(importe*d7/100,0.00))
	From presutda WITH(NOLOCK)
		Inner Join POSTGRES.scomercial.[public].tentidad_tienda tt
			On presutda.tda=tt.cod_entid
	Where sem=@semproc 
	  And ( rtrim(ltrim(@cod_cadena)) = '' Or tt.cod_cadena = @cod_cadena )
	  And distrito<>'521'  */

	--print @impte_presu_dia1+@impte_presu_dia2+@impte_presu_dia3+@impte_presu_dia4+@impte_presu_dia5+@impte_presu_dia6+@impte_presu_dia7

	--// Se elimina tabla temporal
	IF OBJECT_ID('tempdb..#VentaxDiaxCate3') IS NOT NULL  
	BEGIN  
		Drop table #VentaxDiaxCate3;
	END  
	
	--// Se crea tabla temporal
	Create table #VentaxDiaxCate3(
		cod_cadena	Varchar(5), 
		fecha		Date,
		cod_line3	Varchar(2),
		pares		Decimal(18,4), 
		costo		Decimal(18,4), 
		soles		Decimal(18,4), 
		qfac		Decimal(18,4)
	)

	--// Se obtiene información a usar
	Insert Into #VentaxDiaxCate3 (cod_cadena,fecha,cod_line3,pares,costo,soles,qfac)
	Select	 td.cod_cadena
			,c.FC_FFAC
			,tc.cod_line3
			,sum(isnull(case when @cod_cadena='BA' then case when left(d.FD_ARTI,1)!='9' THEN d.FD_QFAC else 0 end else d.FD_QFAC end * case when c.fc_suna='07' then -1 else 1 end,0.00))
			,sum(isnull(dbo.fcosto(d.FD_ARTI,d.ID_CALIDAD,c.FC_FFAC)*d.fd_qfac*case when c.fc_suna='07' then -1 else 1 end,0))
			,sum(isnull(d.FD_VVTA*case when c.fc_suna='07' then -1 else 1 end,0.00))
			,sum(isnull(d.fd_qfac*case when c.fc_suna='07' then -1 else 1 end,0.00))
	From FFACTC c with(nolock)
		Inner join FFACTD d with(nolock) 
			On c.COD_ENTID=d.COD_ENTID AND c.FC_NINT=d.FD_NINT 
			And not (c.cod_entid>='50850' and c.cod_entid<='50899')
		Inner Join tarticulo t with(nolock)
			On t.cod_artic = d.FD_ARTI And t.cod_secci = d.COD_SECCI And t.COD_SECCI='5' And t.cod_artic!='9998888'
		Inner Join tcategori3 tc with(nolock)  
			On tc.cod_cate3 = t.cod_cate3
		Inner Join POSTGRES.scomercial.[public].tentidad_tienda td with(nolock) 
			on td.cod_entid=c.COD_ENTID And td.cod_distri <> '521' 
	where ((c.FC_FFAC>=@fisemproc and c.FC_FFAC<=@ffsemproc) OR (c.FC_FFAC>=@fisemly and c.FC_FFAC<=@ffsemly))
	  And c.FC_ESTA IS NULL 
	  And (rtrim(ltrim(@cod_cadena))='' Or (td.cod_cadena=@cod_cadena))
	Group by td.cod_cadena, c.FC_FFAC, tc.cod_line3

	--// Final de datos
	select 
		linea        = isnull((select des_line3 from POSTGRES.scomercial.[public].tline3 ttl3 where ttl3.cod_line3 = sem_anterior.cod_line3),''),

		paresac      = isnull(paresac,0.00),
		solesac      = isnull(solesac,0.00),
		costoac      = isnull(costoac,0.00),
		margac       = case when solesac<>0 then convert(decimal(16,2),((solesac-costoac)/solesac)*100) else 0.00 end,   

		paresly      = isnull(paresly,0.00),
		solesly      = isnull(solesly,0.00),
		costoly      = isnull(costoly,0.00),
		margly       = case when solesly<>0 then convert(decimal(16,2),((solesly-costoly)/solesly)*100) else 0.00 end,		
				
		sest         = case when solesest<>0 then convert(decimal(16,2),(solesac/solesest)*100)  else 0.00 end,  -- ventas dia actual / ventas dia presupuesto
		saly         = case when solesly<>0  then convert(decimal(16,2),(solesac/solesly)*100)  else 0.00 end,  -- ventas dia actual / ventas dia año pasado

		paressemproc = isnull(paressemproc,0.00),
		solessemproc = isnull(solessemproc,0.00),
		costosemproc = isnull(costosemproc,0.00),
		margsemproc  = case when solessemproc<>0 then convert(decimal(16,2),((solessemproc-costosemproc)/solessemproc)*100) else 0.00 end,

		paressemly   = isnull(paressemly,0.00),
		solessemly   = isnull(solessemly,0.00),
		costosemly   = isnull(costosemly,0.00),		
		margsemly    = case when solessemly<>0 then convert(decimal(16,2),((solessemly-costosemly)/solessemly)*100) else 0.00 end,		

		test         = case when solessemest<>0 then convert(decimal(16,2),(solessemproc/solessemest)*100) else 0.00 end,
		taly         = case when solessemly<>0  then convert(decimal(16,2),(solessemproc/solessemly)*100)  else 0.00 end,

		sem_anterior.cod_line3

	From	
		-- venta fecha actual
		(	Select isnull(cod_line3,'') As cod_line3, sum(isnull(pares,0.00)) As paresac, sum(isnull(soles,0.00)) As solesac, sum(isnull(costo,0.00)) As costoac
			From #VentaxDiaxCate3
			Where fecha = @fecproc
			group by isnull(cod_line3,'')) actual
		-- venta fecha año pasado
		Full Join 
			(	Select isnull(cod_line3,'') As cod_line3, sum(isnull(pares,0.00)) As paresly, sum(isnull(soles,0.00)) As solesly, sum(isnull(costo,0.00)) AS costoly
				From #VentaxDiaxCate3 
				Where fecha=@fecly 
				Group by isnull(cod_line3,'')) anterior
			On actual.cod_line3 = anterior.cod_line3 
		-- venta semana actual (avance hasta el dia actual)
		Full Join
			(	Select isnull(cod_line3,'') As cod_line3, sum(isnull(pares,0.00)) As paressemproc, sum(isnull(soles,0.00)) As solessemproc, sum(isnull(costo,0.00)) As costosemproc
				From #VentaxDiaxCate3
				Where (fecha>=@fisemproc And fecha<=dateadd(day,@dw-1,@fisemproc)) 
				group by isnull(cod_line3,'')) sem_actual 
			On anterior.cod_line3 = sem_actual.cod_line3
		-- venta semana año pasado (avance hasta el dia actual)
		Full Join
			(	Select isnull(cod_line3,'') As cod_line3, sum(isnull(pares,0.00)) As paressemly, sum(isnull(soles,0.00)) As solessemly, sum(isnull(costo,0.00)) As costosemly
				From #VentaxDiaxCate3
				Where (fecha>=@fisemly And fecha<=dateadd(day,@dw-1,@fisemly)) 
				Group by isnull(cod_line3,'')) sem_anterior
			On sem_actual.cod_line3 = sem_anterior.cod_line3
		-- presupuesto dia actual
		Left Join 
			(	Select isnull(p.lin,'') As cod_line3, isnull(sum(p.facturacion),0) As solesest
				From tprerims p 
					Inner Join tentidad_tienda t
						On p.tda = t.cod_entid
				Where p.fecha=@fecproc 
				  And ( rtrim(ltrim(@cod_cadena))='' Or t.cod_cadena=@cod_cadena )
				Group by isnull(p.lin,'')) pres_dia
			On sem_anterior.cod_line3 = pres_dia.cod_line3
		-- presupuesto semana actual (avance hasta el dia actual)
		Left Join 
			(	Select isnull(p.lin,'') As cod_line3, isnull(sum(p.facturacion),0) As solessemest
				From tprerims p 
					Inner Join tentidad_tienda t
						On p.tda = t.cod_entid
				Where (p.fecha>=@fisemproc and p.fecha<=dateadd(day,@dw-1,@fisemproc)) 
				  And ( rtrim(ltrim(@cod_cadena))='' Or t.cod_cadena=@cod_cadena )
				Group by isnull(p.lin,'')) pres_sem
			On pres_dia.cod_line3 = pres_sem.cod_line3

	UNION ALL

	Select 
		linea       = 'ZTOTAL BATA FAMILY',
			
		paresac, 
		solesac,
		costoac,
		margac      = case when solesac<>0 then convert(decimal(16,2),((solesac-costoac)/solesac)*100) else 0.00 end,

		paresly, 
		solesly,
		costoly,
		margly      = case when solesly<>0 then convert(decimal(16,2),((solesly-costoly)/solesly)*100) else 0.00 end,		

		sest        = case when solesest<>0 then convert(decimal(16,2),(solesac/solesest)*100) else 0.00 end, 
		saly        = case when solesly<>0 then convert(decimal(16,2),(solesac/solesly)*100) else 0.00 end,   

		paressemproc,
		solessemproc,
		costosemproc,
		margsemproc = case when solessemproc<>0 then convert(decimal(16,2),((solessemproc-costosemproc)/solessemproc)*100) else 0.00 end,

		paressemly,
		solessemly,
		costosemly,
		margsemly   = case when solessemly<>0 then convert(decimal(16,2),((solessemly-costosemly)/solessemly)*100) else 0.00 end,
				
		test        = case when solessemest<>0 then convert(decimal(16,2),(solessemproc/solessemest)*100) else 0.00 end, 
		taly        = case when solessemly<>0 then convert(decimal(16,2),(solessemproc/solessemly)*100) else 0.00 end,
		cod_line3   = '99'

	from
		-- venta fecha actual
		(	Select sum(isnull(pares,0.00)) As paresac, sum(isnull(soles,0.00)) As solesac, sum(isnull(costo,0.00)) As costoac
			From #VentaxDiaxCate3
			Where fecha=@fecproc ) actual,

		-- venta fecha año pasado
		(	Select sum(isnull(pares,0.00)) As paresly, sum(isnull(soles,0.00)) As solesly, sum(isnull(costo,0.00)) AS costoly
			From #VentaxDiaxCate3
			Where fecha=@fecly ) anterior,

		-- venta semana actual (avance hasta el dia actual)
		(	Select sum(isnull(pares,0.00)) As paressemproc, sum(isnull(soles,0.00)) As solessemproc, sum(isnull(costo,0.00)) AS costosemproc
			From #VentaxDiaxCate3 WITH(NOLOCK)
			Where (fecha>=@fisemproc and fecha<=dateadd(day,@dw-1,@fisemproc)) ) sem_actual,
		
		-- venta semana año pasado (avance hasta el dia actual)
		(	Select sum(isnull(pares,0.00)) As paressemly, sum(isnull(soles,0.00)) solessemly, sum(isnull(costo,0.00)) As costosemly
			From #VentaxDiaxCate3 WITH(NOLOCK)
			Where (fecha>=@fisemly and fecha<=dateadd(day,@dw-1,@fisemly)) ) sem_anterior,
		
		-- presupuesto dia actual
		(	Select isnull(sum(p.facturacion),0) As solesest
			From tprerims p 
				Inner Join tentidad_tienda t
					On p.tda=t.cod_entid
			Where p.fecha=@fecproc 
			  and ( rtrim(ltrim(@cod_cadena))='' Or t.cod_cadena=@cod_cadena ) ) pres_dia,

		-- presupuesto semana actual (avance hasta el dia actual)
		(	Select isnull(sum(p.facturacion),0) As solessemest
			From tprerims p 
				Inner Join tentidad_tienda t
					On p.tda=t.cod_entid
			Where (p.fecha>=@fisemproc and p.fecha<=dateadd(day,@dw-1,@fisemproc)) 
			  And ( rtrim(ltrim(@cod_cadena))='' Or t.cod_cadena=@cod_cadena ) ) pres_sem

	Order by 1

END

