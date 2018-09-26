If Exists(Select * from sysobjects Where name = 'USP_Envia_CorreoAprobar' And type = 'P')
	Drop Procedure USP_Envia_CorreoAprobar
GO

-- ==========================================================================================
-- Author		: Henry Morales
-- Create date	: 21/02/2018
-- Description	: Envía correo electrónico para la aprobación de la Promo recien creada
-- ==========================================================================================
-- tablas		: promociones_cab	(Cabecera de Promociones)
--				  promociones_det1	(Detalle de Articulos de Promociones)
--				  promociones_det2	(Detalle de Tiendas de Promociones)
--				  promociones_aprob	(Aprobaciones de Promociones)
-- ==========================================================================================
/*
	Exec USP_Envia_CorreoAprobar 'prueba'
*/

CREATE Procedure USP_Envia_CorreoAprobar(
	@id_promo	varchar(8)
)
AS 
BEGIN

	-- Declaramos variables
	Declare	@cuerpo				Varchar(max),
			@asunto				Varchar(max),
			
			@url_datos_adic		Varchar(max),
			@url_aprueba		Varchar(max),
			@url_rechaza		Varchar(max),
			@url_complementa	Varchar(max),
			
			@seccion			Varchar(1),
			@creador			Varchar(30),
			@desc_promo			Varchar(50),
			@fecha_crea			Datetime,
			@fec_ini_vigen		Datetime,
			@fec_fin_vigen		Datetime,

			@email				Varchar(100),
			@codmail			Varchar(3),
			@nombre_mail		Varchar(100);

	-- Seteamos la sección :
	Set	@seccion = '5';
			
	-- Seteamos las URL que contendrá el correo
	Set @url_datos_adic	= 'http://localhost:53098/DatosAdic.aspx?';
	Set @url_aprueba	= 'http://localhost:53098/Aprueba.aspx?';
	Set @url_rechaza	= 'http://localhost:53098/Rechaza.aspx?';
			

	-- Se trae la información de la promoción
	Select	@creador = usuario,
			@desc_promo = descrip,
			@fecha_crea = fecreg,
			@fec_ini_vigen = fecini,
			@fec_fin_vigen = fecfin
	From promociones_cab
	Where estado = 'A'
	  And idpromo = @id_promo;
	
	
		/*********buscar datos promocion**************/
		/*********llenamos datos de promocion en tabla para mostrar*********/
		Declare	@descripcion	As Varchar(50),
				@tabla_activa	As Varchar(max),
				@tabla_promo	As Varchar(max),
				@tabla_tiendas	As Varchar(max);

		Set @tabla_activa = '<table style="font-family:Lucida Console;font-size:12px"> <tr> <td style="font-family:Verdana;font-size:16px;font-weight:bold;color:#892B14">Productos Activadores : </td> </tr> ';
		Set @tabla_promo = '<table style="font-family:Lucida Console;font-size:12px"> <tr> <td style="font-family:Verdana;font-size:16px;font-weight:bold;color:#892B14">Productos en Promoción : </td> </tr> ';
		Set @tabla_tiendas = '<table style="font-family:Lucida Console;font-size:12px"> <tr> <td style="font-family:Verdana;font-size:16px;font-weight:bold;color:#892B14">Tiendas : </td> </tr> ';
		
		--//=========================================\\--
		--// Obtiene datos de Productos de Activación\\--
		--//=========================================\\--
		DECLARE tabla1_cursor CURSOR FOR
		Select TOP 5 art.des_artic
		From promociones_det1 act
		Inner Join [BdTienda].[dbo].[tarticulo] art
			On act.artic = art.cod_artic And art.cod_secci = @seccion
		Where act.idpromo = @id_promo
		  And act.activadorpromo = 1; --Activador

		OPEN tabla1_cursor
		
		FETCH NEXT FROM tabla1_cursor
		INTO @descripcion

		WHILE @@FETCH_STATUS = 0
		BEGIN
			
			Set	@tabla_activa += '<tr> <td>- ' + @descripcion + '</td> </tr> ';

			FETCH NEXT FROM tabla1_cursor
		INTO @descripcion
		END

		CLOSE tabla1_cursor;
		DEALLOCATE tabla1_cursor;
		
		--//=========================================\\--
		--// Obtiene datos de Productos de Promoción \\--
		--//=========================================\\--
		DECLARE tabla2_cursor CURSOR FOR
		Select TOP 5 art.des_artic
		From promociones_det1 pro
		Inner Join [BdTienda].[dbo].[tarticulo] art
			On pro.artic = art.cod_artic And art.cod_secci = @seccion
		Where pro.idpromo = @id_promo
		  And pro.activadorpromo = 2; -- Promo

		OPEN tabla2_cursor
		
		FETCH NEXT FROM tabla2_cursor
		INTO @descripcion

		WHILE @@FETCH_STATUS = 0
		BEGIN
			
			Set	@tabla_promo += '<tr> <td>- ' + @descripcion + '</td> </tr> ';

			FETCH NEXT FROM tabla2_cursor
		INTO @descripcion
		END
		
		CLOSE tabla2_cursor;
		DEALLOCATE tabla2_cursor;
		
		--//=================================\\--
		--// Obtiene datos de Tiendas		 \\--
		--//=================================\\--
		DECLARE tabla3_cursor CURSOR FOR
		Select TOP 5 ent.des_entid
		From promociones_det2 tda
		Inner Join [BdTienda].[dbo].[tentidad_tienda] ent
			On tda.tienda = ent.cod_entid
		Inner Join [BdTienda].[dbo].[Tienda] tien 
			On tien.Cod_Tienda = ent.cod_entid
		Where tda.idpromo = @id_promo;

		OPEN tabla3_cursor
		
		FETCH NEXT FROM tabla3_cursor
		INTO @descripcion

		WHILE @@FETCH_STATUS = 0
		BEGIN
			
			Set	@tabla_tiendas += '<tr> <td>- ' + @descripcion + '</td> </tr> ';

			FETCH NEXT FROM tabla3_cursor
		INTO @descripcion
		END
		
		CLOSE tabla3_cursor;
		DEALLOCATE tabla3_cursor;

		--// Se agrega linea final
		IF((Select count (*) From promociones_det1 Where idpromo = @id_promo And activadorpromo = 1)>5)
			Set @tabla_activa	+= '<tr> <td>- (... más )</td> </tr> ';
		IF((Select count (*) From promociones_det1 Where idpromo = @id_promo And activadorpromo = 2)>5)
			Set @tabla_promo	+= '<tr> <td>- (... más )</td> </tr> ';
		IF((Select count (*) From promociones_det2 Where idpromo = @id_promo)>5)
			Set @tabla_tiendas	+= '<tr> <td>- (... más )</td> </tr> ';

		--// Se cierra tabla
		Set @tabla_activa	+= ' </table>';
		Set @tabla_promo	+= ' </table>';
		Set @tabla_tiendas	+= ' </table>';
		
		--//=========================================\\--
		--// Busca datos de aprobacion y correos	 \\--
		--//=========================================\\--
		-- Declaramos Cursor para buscar todos los correos que aún no han respondido
		DECLARE email_cursor CURSOR FOR
		Select email, nombres+' '+apellidos, iduser
		From promociones_user_aprob
		Where estado = 'A'
		  And iduser Not IN (Select iduser
							From promociones_aprob
							Where idpromo = @id_promo
							  And estado = 'A');
							
		OPEN email_cursor
	
		FETCH NEXT FROM email_cursor
		INTO @email, @nombre_mail, @codmail
		
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- Datos que se enviarán en el get
			Set @url_complementa = 'promo='+@id_promo+'&mail='+@codmail+'';
			-- Asunto del Correo
			Set @asunto = '[Promociones Bata] Solicitud de Aprobación - ' + @desc_promo;
			-- Cuerpo del Correo
			Set @cuerpo  =	'<!DOCTYPE html> ';
			Set @cuerpo +=	'<html> ';
			Set @cuerpo +=	'<head> ';
			Set @cuerpo +=	'<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/> ';
			Set @cuerpo +=	    '<title></title> ';
			Set @cuerpo +=		'<meta charset="utf-8" /> ';
			Set @cuerpo +=	'</head> ';
			Set @cuerpo +=	'<body> ';
			Set @cuerpo +=	    '<table style="width:800px;font-family:Calibri;font-size:16px"> ';
			Set @cuerpo +=	        '<tr> ';
			Set @cuerpo +=	            '<td colspan="6" style="font-family:Arial;font-size:16px">Estimado(a) Sr(a). <font style="font-weight:bold">' + @nombre_mail + '</font>,</td>';
			Set @cuerpo +=	        '</tr> ';
			Set @cuerpo +=	        '<tr> ';
			Set @cuerpo +=	            '<td colspan="6">&nbsp;</td>';
			Set @cuerpo +=	        '</tr> ';
			Set @cuerpo +=	        '<tr> ';
			Set @cuerpo +=	            '<td colspan="6">El sistema de solicitudes de ofertas y promociones le informa que se ha generado la siguiente solicitud, que requiere su aprobación:</td>';
			Set @cuerpo +=	        '</tr> ';
			Set @cuerpo +=	        '<tr> ';
			Set @cuerpo +=	            '<td>Descripción:</font></td>';
			Set @cuerpo +=	            '<td style="font-weight:bold;color:#3275B8">' + @desc_promo + '</td>';
			Set @cuerpo +=	            '<td colspan="4">&nbsp;</td>';
			Set @cuerpo +=	        '</tr> ';
			Set @cuerpo +=	        '<tr> ';
			Set @cuerpo +=	            '<td>Generado por:</td>';
			Set @cuerpo +=	            '<td style="font-weight:bold;color:#3275B8">' + @creador + '</td>';
			Set @cuerpo +=	            '<td>&nbsp;</td>';
			Set @cuerpo +=	            '<td>Fecha y Hora:</td>';
			Set @cuerpo +=	            '<td style="font-weight:bold;color:#3275B8">' + Convert(varchar,@fecha_crea,103) + ' ' + Convert(varchar,@fecha_crea,108) + '</td>';
			Set @cuerpo +=	            '<td>&nbsp;</td>';
			Set @cuerpo +=	        '</tr> ';
			Set @cuerpo +=	        '<tr> ';
			Set @cuerpo +=	            '<td colspan="6">&nbsp;</td>';
			Set @cuerpo +=	        '</tr> ';
			Set @cuerpo +=	        '<tr> ';
			Set @cuerpo +=					'<td colspan="3" valign="top">' + @tabla_activa + '</td>';
			Set @cuerpo +=					'<td colspan="3" valign="top">' + @tabla_promo + '</td>';
			Set @cuerpo +=	        '</tr> ';
			Set @cuerpo +=	        '<tr> ';
			Set @cuerpo +=	            '<td colspan="6">&nbsp;</td>';
			Set @cuerpo +=	        '</tr> ';
			Set @cuerpo +=	        '<tr> ';
			Set @cuerpo +=	            '  <td colspan="6" valign="top">' + @tabla_tiendas + '</td>';
			Set @cuerpo +=	        '</tr> ';
			Set @cuerpo +=	        '<tr> ';
			Set @cuerpo +=	            '<td colspan="6">&nbsp;</td>';
			Set @cuerpo +=	        '</tr> ';
			Set @cuerpo +=	        '<tr> ';
			Set @cuerpo +=	            '<td>Fecha Vigencia: </td>';
			Set @cuerpo +=	            '<td colspan="5">Desde:  <font style="font-weight:bold;color:#4EA751">' + Convert(varchar,@fec_ini_vigen,103) + '</font> Hasta: <font style="font-weight:bold;color:#4EA751">' + Convert(varchar,@fec_fin_vigen,103) + '</font></td>';
			Set @cuerpo +=	        '</tr> ';
			Set @cuerpo +=	        '<tr style="font-size:12px;color:#2B5290"> ';
			Set @cuerpo +=	            '<td colspan="6">(Para ver el detalle completo de la solicitud <a href="' + @url_datos_adic + @url_complementa + '">haga clic aquí.</a>)</td>';
			Set @cuerpo +=	        '</tr> ';
			Set @cuerpo +=	        '<tr style="font-family:Arial;font-size:16px"> ';
			Set @cuerpo +=	            '<td colspan="4" style="width:600px">Para aprobar o rechazar la solicitud haga clic en el siguiente link:</td>';
			Set @cuerpo +=	            '<td align="center" style="font-size:20px"> <a href="' + @url_aprueba + @url_complementa + '"> <span>Aprobar</span> </a> </td>';
			Set @cuerpo +=	            '<td align="center" style="font-size:20px"> <a href="' + @url_rechaza + @url_complementa + '"> <span>Rechazar</span> </a> </td>';
			Set @cuerpo +=	        '</tr> ';
			Set @cuerpo +=	        '<tr> ';
			Set @cuerpo +=	            '<td colspan="6">&nbsp;</td>';
			Set @cuerpo +=	        '</tr> ';
			Set @cuerpo +=	        '<tr> ';
			Set @cuerpo +=	            '<td colspan="6">Saludos Cordiales.</td>';
			Set @cuerpo +=	        '</tr> ';
			Set @cuerpo +=	    '</table> ';
			Set @cuerpo +=	'</body>';
			Set @cuerpo +=	'</html>';
			
			--// Se envía correo
			Exec USP_EnviarCorreos @email,@asunto,@cuerpo,null;

			FETCH NEXT FROM email_cursor
		INTO @email, @nombre_mail, @codmail
		END
		
		CLOSE email_cursor;
		DEALLOCATE email_cursor;
		
END