If Exists(Select * from sysobjects Where name = 'USP_Correo_VentasxDia_HM' And type = 'P')
	Drop Procedure USP_Correo_VentasxDia_HM
GO

-- =====================================================================
-- Author		: Henry Morales
-- Create date	: 30/04/2018
-- Description	: Envía correo de Ventas por Día por Cadena (o todas)
-- =====================================================================
/*
	exec [dbo].[USP_Correo_VentasxDia_HM]  '','DIA ANTERIOR', 0
	exec [dbo].[USP_Correo_VentasxDia_2]  'BA','DIA ACTUAL', 0
*/

CREATE PROCEDURE USP_Correo_VentasxDia_HM(
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
	DECLARE @tabla table
	(distrito varchar(20), nrotdas int, 
	paresac money, solesac money, costoac money, margac numeric(8,2),
	paresly money, solesly money, costoly money, margly numeric(8,2),
	margest numeric(8,2), sest numeric(8,2), saly numeric(8,2),
	paresseac money, solesseac money, costoseac money, margseac numeric(8,2),
	paressely money, solessely money, costosely money, margsely numeric(8,2),
	margseest numeric(8,2), test numeric(10,2), taly numeric(10,2) )

	print @fecproc
	print @cod_cadena
	print @fecly
	print @semproc
	print @semly
	print @fisemproc
	print @ffsemproc
	print @fisemly
	print @ffsemly
	print @dw

	--insert into @tabla exec dbo.USP_Consulta_VentaxDiaxDistrito_HM @fecproc, @cod_cadena, @fecly, @semproc, @semly, @fisemproc, @ffsemproc, @fisemly, @ffsemly, @dw
	/**************************************************************************************************************************/
		IF OBJECT_ID('tempdb..#VtaxDiax') Is Not Null  
		BEGIN  
			Drop table #VtaxDiax;
		END  

		Create table #VtaxDiax(
			cod_cadena	Varchar(5), 
			fecha		Date, 
			distrito	Varchar(5),
			tienda		Varchar(10),
			cod_line3	Varchar(2),
			pares		Money, 
			costo		Money, 
			soles		Money, 
			qfac		Money
		)

		--// Se obtiene información a usar
		Insert Into #VtaxDiax (cod_cadena, fecha, distrito, tienda, cod_line3, pares, costo, soles, qfac)
		Select	 td.cod_cadena
				,c.FC_FFAC
				,td.cod_distri
				,td.COD_ENTID
				,IsNull(tc.cod_line3,'')
				,sum(IsNull(case when td.cod_cadena='BA' then case when left(d.FD_ARTI,1)!='9' THEN d.FD_QFAC else 0 end else d.FD_QFAC end * case when c.fc_suna='07' then -1 else 1 end,0.00))
				,sum(IsNull(dbo.fcosto(d.FD_ARTI,d.ID_CALIDAD,c.FC_FFAC)*d.fd_qfac*case when c.fc_suna='07' then -1 else 1 end,0))
				,sum(IsNull(d.FD_VVTA*case when c.fc_suna='07' then -1 else 1 end,0.00))
				,sum(IsNull(d.fd_qfac*case when c.fc_suna='07' then -1 else 1 end,0.00))
		From FFACTC c with(nolock)
			Inner join FFACTD d with(nolock) 
				on c.COD_ENTID=d.COD_ENTID AND c.FC_NINT=d.FD_NINT
				And not (c.cod_entid>='50850' and c.cod_entid<='50899')
			Inner Join tarticulo t with(nolock)
				On t.cod_artic = d.FD_ARTI And t.cod_secci = d.COD_SECCI And t.cod_artic!='9998888' And t.COD_SECCI='5'
			Inner Join tcategori3 tc with(nolock)  
				On tc.cod_cate3 = t.cod_cate3
			Inner join tentidad_tienda td with(nolock) 
				on td.cod_entid=c.COD_ENTID And td.cod_distri <> '521' 
		where ((c.FC_FFAC>=@fisemproc and c.FC_FFAC<=@ffsemproc) OR (c.FC_FFAC>=@fisemly and c.FC_FFAC<=@ffsemly))
		  And c.FC_ESTA IS NULL 
		  And (rtrim(ltrim(@cod_cadena))='' Or (td.cod_cadena=@cod_cadena))
		Group by td.cod_cadena, c.FC_FFAC, td.cod_distri, td.COD_ENTID, IsNull(tc.cod_line3,'')
		--Select * from #VtaxDiax
	/**************************************************************************************************************************/


		Insert Into @tabla
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
	/**************************************************************************************************************************/
	--Select * from @tabla
	SET @NRegs = (SELECT COUNT(*) FROM @Tabla)		
	if @NRegs > 0
	begin
		select @agrega_html=@agrega_html + ' <tr> '+
			'<td> <font face="Arial" size="2"> '+IsNull(distrito,'') + ' </font> </td> '+
			'<td align="right"> <font face="Calibri,Arial" size="3"> '+IsNull(Convert(varchar(17),nrotdas),'') + ' </font> </td> '+
			'<td align="right"> <font face="Calibri,Arial" size="3"> '+IsNull(replace(Convert(varchar(17),cast(Convert(int,paresac) as money),1),'.00',''),'') + ' </font> </td> '+
			'<td align="right"> <font face="Calibri,Arial" size="3"> '+IsNull(replace(Convert(varchar(17),cast(Convert(int,solesac) as money),1),'.00',''),'') + ' </font> </td> '+
			'<td align="right"> <font face="Calibri,Arial" size="3"> '+IsNull(Convert(varchar(17),cast(margac as money),1),'') + ' </font> </td> '+
			'<td align="right"> <font face="Calibri,Arial" size="3"> '+IsNull(Convert(varchar(17),cast(margly as money),1),'') + ' </font> </td> '+
			'<td align="right"> <font face="Calibri,Arial" size="3"> '+IsNull(Convert(varchar(17),cast(margest as money),1),'') + ' </font> </td> '+
			'<td align="right"> <font face="Calibri,Arial" size="3"> '+IsNull(Convert(varchar(17),cast(sest as money),1),'') + ' </font> </td> '+
			'<td align="right"> <font face="Calibri,Arial" size="3"> '+IsNull(Convert(varchar(17),cast(saly as money),1),'') + ' </font> </td> '+
			'<td align="right"> <font face="Calibri,Arial" size="3"> '+IsNull(replace(Convert(varchar(17),cast(Convert(int,paresseac) as money),1),'.00',''),'') + ' </font> </td> '+
			'<td align="right"> <font face="Calibri,Arial" size="3"> '+IsNull(replace(Convert(varchar(17),cast(Convert(int,solesseac) as money),1),'.00',''),'') + ' </font> </td> '+
			'<td align="right"> <font face="Calibri,Arial" size="3"> '+IsNull(Convert(varchar(17),cast(margseac as money),1),'') + ' </font> </td> '+
			'<td align="right"> <font face="Calibri,Arial" size="3"> '+IsNull(Convert(varchar(17),cast(margsely as money),1),'') + ' </font> </td> '+
			'<td align="right"> <font face="Calibri,Arial" size="3"> '+IsNull(Convert(varchar(17),cast(margseest as money),1),'') + ' </font> </td> '+
			'<td align="right"> <font face="Calibri,Arial" size="3"> '+IsNull(Convert(varchar(17),cast(test as money),1),'') + ' </font> </td> '+
			'<td align="right"> <font face="Calibri,Arial" size="3"> '+IsNull(Convert(varchar(17),cast(taly as money),1),'') + ' </font> </td> '+
			'</tr> '
		from @tabla

		SET @html_formato=REPLACE(@html_formato,'vartitulo1',@titulo1)
		SET @html_formato=REPLACE(@html_formato,'vartitulo2',@titulo2)
		SET @html_formato=REPLACE(@html_formato,'vartitulo3',@titulo3)
		SET @html_formato=REPLACE(@html_formato,'vardetalle',@agrega_html)
		SET @html_formato=REPLACE(@html_formato,'vartitle',@tipo)		

	end
	-- FIN: VENTAS X DISTRITO

	-- INICIO: VENTAS X CATE3
	DECLARE @html_formato2 nvarchar(max)=(select Html from tFormato_Html where Codigo='02')	

	IF @cod_cadena!='BA'
	BEGIN
	  SET @html_formato2 = REPLACE(@html_formato2, 'Pares', 'Unidades')
	END

	SET @agrega_html = ''
	SET @titulo1 = 'Informe de ventas del dia Tiendas '+@cadena
	SET @titulo2 = 'Ventas del dia '  + Convert(char(2),day(@fecproc)) + ' ' + DATENAME(month,@fecproc) + ' ' + Convert(char(4),year(@fecproc))	
	--SET @semac   = (select cod_semana from tsemana where @fecha>=fec_inicio and @fecha<=fec_final)
	SET @titulo3 = 'Ventas de la semana ' + substring(@semproc,5,2)

	-- Obtener venta desde tabla tventasxdia
	DECLARE @tabla2 table
	(linea varchar(30),  
	paresac money, solesac money, costoac money, margac numeric(8,2),
	paresly money, solesly money, costoly money, margly numeric(8,2),
	sest numeric(8,2), saly numeric(8,2),
	paresseac money, solesseac money, costoseac money, margseac numeric(8,2),
	paressely money, solessely money, costosely money, margsely numeric(8,2),
	test numeric(10,2), taly numeric(10,2), cod_line3 varchar(2))
	
	--Insert Into @tabla2 exec dbo.USP_Consulta_VentaxDiaxCate3_HM @fecproc, @cod_cadena, @fecly, @semproc, @semly, @fisemproc, @ffsemproc, @fisemly, @ffsemly, @dw
	/******************************************************************************************************************/
		Insert Into @tabla2
		select 
			linea        = IsNull(ttl3.des_line3 ,''),

			paresac      = IsNull(paresac,0.00),
			solesac      = IsNull(solesac,0.00),
			costoac      = IsNull(costoac,0.00),
			margac       = case when solesac<>0 then Convert(decimal(16,2),Isnull(((solesac-costoac)/solesac),0)*100) else 0.00 end,   

			paresly      = IsNull(paresly,0.00),
			solesly      = IsNull(solesly,0.00),
			costoly      = IsNull(costoly,0.00),
			margly       = case when solesly<>0 then Convert(decimal(16,2),Isnull(((solesly-costoly)/solesly),0)*100) else 0.00 end,		
				
			sest         = case when solesest<>0 then Convert(decimal(16,2),Isnull((solesac/solesest),0)*100)  else 0.00 end,  -- ventas dia actual / ventas dia presupuesto
			saly         = case when solesly<>0  then Convert(decimal(16,2),Isnull((solesac/solesly),0)*100)  else 0.00 end,  -- ventas dia actual / ventas dia año pasado

			paressemproc = IsNull(paressemproc,0.00),
			solessemproc = IsNull(solessemproc,0.00),
			costosemproc = IsNull(costosemproc,0.00),
			margsemproc  = case when solessemproc<>0 then Convert(decimal(16,2),Isnull(((solessemproc-costosemproc)/solessemproc),0)*100) else 0.00 end,

			paressemly   = IsNull(paressemly,0.00),
			solessemly   = IsNull(solessemly,0.00),
			costosemly   = IsNull(costosemly,0.00),		
			margsemly    = case when solessemly<>0 then Convert(decimal(16,2),Isnull(((solessemly-costosemly)/solessemly),0)*100) else 0.00 end,		

			test         = case when solessemest<>0 then Convert(decimal(16,2),Isnull((solessemproc/solessemest),0)*100) else 0.00 end,
			taly         = case when solessemly<>0  then Convert(decimal(16,2),Isnull((solessemproc/solessemly),0)*100)  else 0.00 end,

			ttl3.cod_line3

		From	tline3 ttl3
			-- venta fecha actual
			Full Join
				(	Select cod_line3 , sum(IsNull(pares,0.00)) As paresac, sum(IsNull(soles,0.00)) As solesac, sum(IsNull(costo,0.00)) As costoac
					From #VtaxDiax
					Where fecha = @fecproc
					group by cod_line3	) actual
				On ttl3.cod_line3 = actual.cod_line3 
			-- venta fecha año pasado
			Full Join 
				(	Select cod_line3 , sum(IsNull(pares,0.00)) As paresly, sum(IsNull(soles,0.00)) As solesly, sum(IsNull(costo,0.00)) AS costoly
					From #VtaxDiax 
					Where fecha=@fecly 
					Group by cod_line3	) anterior
				On ttl3.cod_line3 = anterior.cod_line3 
			-- venta semana actual (avance hasta el dia actual)
			Full Join
				(	Select cod_line3, sum(IsNull(pares,0.00)) As paressemproc, sum(IsNull(soles,0.00)) As solessemproc, sum(IsNull(costo,0.00)) As costosemproc
					From #VtaxDiax
					Where (fecha>=@fisemproc And fecha<=dateadd(day,@dw-1,@fisemproc)) 
					group by cod_line3	) sem_actual 
				On ttl3.cod_line3 = sem_actual.cod_line3
			-- venta semana año pasado (avance hasta el dia actual)
			Full Join
				(	Select cod_line3, sum(IsNull(pares,0.00)) As paressemly, sum(IsNull(soles,0.00)) As solessemly, sum(IsNull(costo,0.00)) As costosemly
					From #VtaxDiax
					Where (fecha>=@fisemly And fecha<=dateadd(day,@dw-1,@fisemly)) 
					Group by cod_line3	) sem_anterior
				On ttl3.cod_line3 = sem_anterior.cod_line3
			-- presupuesto dia actual
			Left Join 
				(	Select IsNull(p.lin,'') As cod_line3, IsNull(sum(p.facturacion),0) As solesest
					From tprerims p 
						Inner Join tentidad_tienda t
							On p.tda = t.cod_entid
					Where p.fecha=@fecproc 
					  And ( rtrim(ltrim(@cod_cadena))='' Or t.cod_cadena=@cod_cadena )
					Group by IsNull(p.lin,'')) pres_dia
				On ttl3.cod_line3 = pres_dia.cod_line3
			-- presupuesto semana actual (avance hasta el dia actual)
			Left Join 
				(	Select IsNull(p.lin,'') As cod_line3, IsNull(sum(p.facturacion),0) As solessemest
					From tprerims p 
						Inner Join tentidad_tienda t
							On p.tda = t.cod_entid
					Where (p.fecha>=@fisemproc and p.fecha<=dateadd(day,@dw-1,@fisemproc)) 
					  And ( rtrim(ltrim(@cod_cadena))='' Or t.cod_cadena=@cod_cadena )
					Group by IsNull(p.lin,'')) pres_sem
				On ttl3.cod_line3 = pres_sem.cod_line3
		WHERE actual.cod_line3 Is Not Null Or anterior.cod_line3 Is Not Null Or sem_actual.cod_line3 Is Not Null Or sem_anterior.cod_line3 Is Not Null
		   Or IsNull(pres_dia.solesest,0)<>0 Or IsNull(pres_sem.solessemest,0)<>0 
				
		UNION ALL

		Select 
			linea       = 'ZTOTAL BATA FAMILY',
			
			paresac, 
			solesac,
			costoac,
			margac      = case when solesac<>0 then Convert(decimal(16,2),((solesac-costoac)/solesac)*100) else 0.00 end,

			paresly, 
			solesly,
			costoly,
			margly      = case when solesly<>0 then Convert(decimal(16,2),((solesly-costoly)/solesly)*100) else 0.00 end,		

			sest        = case when solesest<>0 then Convert(decimal(16,2),(solesac/solesest)*100) else 0.00 end, 
			saly        = case when solesly<>0 then Convert(decimal(16,2),(solesac/solesly)*100) else 0.00 end,   

			paressemproc,
			solessemproc,
			costosemproc,
			margsemproc = case when solessemproc<>0 then Convert(decimal(16,2),((solessemproc-costosemproc)/solessemproc)*100) else 0.00 end,

			paressemly,
			solessemly,
			costosemly,
			margsemly   = case when solessemly<>0 then Convert(decimal(16,2),((solessemly-costosemly)/solessemly)*100) else 0.00 end,
				
			test        = case when solessemest<>0 then Convert(decimal(16,2),(solessemproc/solessemest)*100) else 0.00 end, 
			taly        = case when solessemly<>0 then Convert(decimal(16,2),(solessemproc/solessemly)*100) else 0.00 end,
			cod_line3   = '99'

		from
			-- venta fecha actual
			(	Select sum(IsNull(pares,0.00)) As paresac, sum(IsNull(soles,0.00)) As solesac, sum(IsNull(costo,0.00)) As costoac
				From #VtaxDiax
				Where fecha=@fecproc ) actual,

			-- venta fecha año pasado
			(	Select sum(IsNull(pares,0.00)) As paresly, sum(IsNull(soles,0.00)) As solesly, sum(IsNull(costo,0.00)) AS costoly
				From #VtaxDiax
				Where fecha=@fecly ) anterior,

			-- venta semana actual (avance hasta el dia actual)
			(	Select sum(IsNull(pares,0.00)) As paressemproc, sum(IsNull(soles,0.00)) As solessemproc, sum(IsNull(costo,0.00)) AS costosemproc
				From #VtaxDiax WITH(NOLOCK)
				Where (fecha>=@fisemproc and fecha<=dateadd(day,@dw-1,@fisemproc)) ) sem_actual,
		
			-- venta semana año pasado (avance hasta el dia actual)
			(	Select sum(IsNull(pares,0.00)) As paressemly, sum(IsNull(soles,0.00)) solessemly, sum(IsNull(costo,0.00)) As costosemly
				From #VtaxDiax WITH(NOLOCK)
				Where (fecha>=@fisemly and fecha<=dateadd(day,@dw-1,@fisemly)) ) sem_anterior,
		
			-- presupuesto dia actual
			(	Select IsNull(sum(p.facturacion),0) As solesest
				From tprerims p 
					Inner Join tentidad_tienda t
						On p.tda=t.cod_entid
				Where p.fecha=@fecproc 
				  and ( rtrim(ltrim(@cod_cadena))='' Or t.cod_cadena=@cod_cadena ) ) pres_dia,

			-- presupuesto semana actual (avance hasta el dia actual)
			(	Select IsNull(sum(p.facturacion),0) As solessemest
				From tprerims p 
					Inner Join tentidad_tienda t
						On p.tda=t.cod_entid
				Where (p.fecha>=@fisemproc and p.fecha<=dateadd(day,@dw-1,@fisemproc)) 
				  And ( rtrim(ltrim(@cod_cadena))='' Or t.cod_cadena=@cod_cadena ) ) pres_sem

		Order by cod_line3
	/******************************************************************************************************************/
	--Select * from @tabla2
	SET @NRegs = (SELECT COUNT(*) FROM @tabla2)		
	if @NRegs > 0
	begin
		select @agrega_html=@agrega_html + ' <tr> '+
			'<td> <font face="Arial" size="2"> '+IsNull(case when linea='ZTOTAL BATA FAMILY' then 'TOTAL' else linea end,'') + ' </font> </td> '+
			'<td align="right"> <font face="Calibri,Arial" size="3"> '+IsNull(replace(Convert(varchar(17),cast(Convert(int,paresac) as money),1),'.00',''),'') + ' </font> </td> '+
			'<td align="right"> <font face="Calibri,Arial" size="3"> '+IsNull(replace(Convert(varchar(17),cast(Convert(int,solesac) as money),1),'.00',''),'') + ' </font> </td> '+
			'<td align="right"> <font face="Calibri,Arial" size="3"> '+IsNull(Convert(varchar(17),cast(margac as money),1),'') + ' </font> </td> '+
			'<td align="right"> <font face="Calibri,Arial" size="3"> '+IsNull(Convert(varchar(17),cast(margly as money),1),'') + ' </font> </td> '+			
			'<td align="right"> <font face="Calibri,Arial" size="3"> '+IsNull(Convert(varchar(17),cast(sest as money),1),'') + ' </font> </td> '+
			'<td align="right"> <font face="Calibri,Arial" size="3"> '+IsNull(Convert(varchar(17),cast(saly as money),1),'') + ' </font> </td> '+
			'<td align="right"> <font face="Calibri,Arial" size="3"> '+IsNull(replace(Convert(varchar(17),cast(Convert(int,paresseac) as money),1),'.00',''),'') + ' </font> </td> '+
			'<td align="right"> <font face="Calibri,Arial" size="3"> '+IsNull(replace(Convert(varchar(17),cast(Convert(int,solesseac) as money),1),'.00',''),'') + ' </font> </td> '+
			'<td align="right"> <font face="Calibri,Arial" size="3"> '+IsNull(Convert(varchar(17),cast(margseac as money),1),'') + ' </font> </td> '+
			'<td align="right"> <font face="Calibri,Arial" size="3"> '+IsNull(Convert(varchar(17),cast(margsely as money),1),'') + ' </font> </td> '+			
			'<td align="right"> <font face="Calibri,Arial" size="3"> '+IsNull(Convert(varchar(17),cast(test as money),1),'') + ' </font> </td> '+
			'<td align="right"> <font face="Calibri,Arial" size="3"> '+IsNull(Convert(varchar(17),cast(taly as money),1),'') + ' </font> </td> '+
			'</tr> '
		from @tabla2

		SET @html_formato2=REPLACE(@html_formato2,'vartitulo1',@titulo1)
		SET @html_formato2=REPLACE(@html_formato2,'vartitulo2',@titulo2)
		SET @html_formato2=REPLACE(@html_formato2,'vartitulo3',@titulo3)
		SET @html_formato2=REPLACE(@html_formato2,'vardetalle',@agrega_html)
		SET @html_formato=REPLACE(@html_formato,'vartitle',@tipo)		
	end
	-- FIN:  VENTAS X CATE3

	DECLARE @html nvarchar(max) = @html_formato + '<br></br><br></br><br></br>' + @html_formato2 + '<br></br>'
	
	declare @destino varchar(max) = (select email_destino from tFormato_Html where Codigo=CASE @cod_cadena WHEN '' THEN 'BA' ELSE @cod_cadena END)
	DECLARE @ASUNTO VARCHAR(500)
	SET @ASUNTO = 'Informe Diario de Ventas de Tiendas '+@cadena
		

	-- cquinto: si es info de hoy solo se envia a los usuarios locales (no enviar a justo ni paul)
	declare @fecha_hoy date = getdate()
    --select @fecha
	if @fecproc=@fecha_hoy OR @cod_cadena!='BA'
	begin
		set @destino=replace(@destino,'justo.fuentes@bata.com;','') 
		set @destino=replace(@destino,'paul.vigouroux@bata.com;','')
		set @destino=replace(@destino,'ivania.goic@bata.com;','')
		--set @destino='carlos.quinto@bata.com;cquinto100@hotmail.com' --;cesar.garciap@bata.com'
	end	

	-- HMorales no ingresa a la condicion cuando se usan todas las cadenas
 	if @fecproc=@fecha_hoy and @cod_cadena!='BA' And @cod_cadena <> ''
	begin  
	  set @destino='erick.osorio@bata.com;diana.berlanga@bata.com;alfredo.jimenez@bata.com;walter.dianderas@bata.com;patricia.ortiz@bata.com;carlos.quinto@bata.com;jesus.limaco@bata.com;camilo.aranda@bata.com'
	end

	if @tipo='DIA ANTERIOR'
	begin
	  set @destino=@destino+';katherine.nakakado@bata.com'
	end
	print @asunto;
	print @html;
	--set @destino='carlos.quinto@bata.com'
	--set @destino='cquintop@gmail.com'
	--set @destino='carlos.quinto@bata.com;emmanuel.wullens@bata.com;cesar.garciap@bata.com'		
	--Select @html;
	set @destino = 'henry.morales@tawa.com.pe;carlos.quinto@bata.com'
	if @sendmail=1
	begin
	  EXECUTE dbo.USP_EnviarCorreos @destino, @asunto, @html, null
	end

	--*** GENERAR ARCHIVO HTML
	IF @cod_cadena='BA' and 1=0 --OJO YA NO SE GENERA LOS HTML
	BEGIN
	  if object_id('tempdb..##tmpx') > 0 
       begin
        truncate table ##tmpx
       end
      else
	   BEGIN
	    create table ##tmpx (campo1 nvarchar(max)) 
	   END
	  --DROP TABLE ##tmpx
	  --DELETE FROM ##tmpx
	  insert into ##tmpx (campo1) values (@html)

	  --select campo1 from @tmpx 

	  DECLARE @filehtml varchar(100)
	  SET @filehtml = '\\10.10.10.206\rrhh\Imagenes\' + CASE @tipo
	                    WHEN 'SEMANA ANTERIOR' THEN 'ventas01.html'
					    WHEN 'DIA ANTERIOR' THEN 'ventas02.html'
					    WHEN 'DIA ACTUAL' THEN 'ventas03.html'
                      END

	  DECLARE @bcpCommand VARCHAR(8000)
	  SET @bcpCommand = 'bcp "select campo1 from ##tmpx" queryout '
	  set @bcpCommand = @bcpCommand + ' ' + @filehtml + ' -c -t; -T -S -C ACP'
      -- print @bcpCommand	ee
      exec xp_cmdShell @bcpCommand, no_output 
    END
	
END

