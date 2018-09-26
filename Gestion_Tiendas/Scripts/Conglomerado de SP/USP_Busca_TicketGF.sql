If Exists(Select * from sysobjects Where name = 'USP_Busca_TicketGF' And type = 'P')
	Drop Procedure USP_Busca_TicketGF
GO

-- =====================================================================
-- Author		: Henry Morales
-- Create date	: 26/03/2018
-- Description	: Busca Datos de Ticket de Activación para Gift Card
--				  Para proceder a su impresión.
-- =====================================================================
-- Modificado por	: Henry Morales Tasaico
-- Fch. Modifica	: 27/04/2018
-- Asunto			: Se modificó la estructura del código de Activación
-- =====================================================================
/*
	Exec USP_Busca_TicketGF '02','0336','00000014'
*/

CREATE Procedure USP_Busca_TicketGF(
	@empresa		Varchar(2),
	@serie			Varchar(4),
	@numero			Varchar(8)
)
AS 
BEGIN

	Declare @cod_secci Varchar(1);

	Set		@cod_secci = '5';
	
	--// Modificado por	: Henry Morales Tasaico - 27/04/2018
	--// Se cambio el uso de la tabla equivalencias, debido a cambio en estructura de código de Activación
	Select 
	/*Cabecera*/
		 'BATA'							As encabezado
		,IsNull(emp.dir_empresa	,'')			As direccion
		,IsNull(emp.tel_empresa,'')				As telefono
		,'BATA - ' + IsNull(emp.des_empresa,'')	As raz_social
		,IsNull(emp.nro_ruc,'')							As ruc
		,IsNull(@serie,'') + '-' + IsNull(@numero,'')			As ticket
		,IsNull(cab.DIDE,'')						As dni
		,IsNull(cab.NOMCLI,'') + ' '+IsNull(cab.APEPAT,'')+ ' '+IsNull(cab.APEMAT,'') As cliente
		,IsNull(cab.FECHA, getdate())						As fecha
		,'Estimado Cliente, Favor de Verificar que el número de Gift Card figura en el ticket de Activación.'		As Glosa
	/* Detalle */
		,IsNull(art.cod_artic,'')					As cod_artic
		,IsNull(art.des_artic,'')					As descripcion
		,IsNull(det.CODACTI,'')					As activacion
		,IsNull(det.CANT,0)						As cantidad
		,IsNull(det.MTOUNI,0)						As monto
		,Right('********'+Right(IsNull(cup.Cup_Barra_Alterno,''),4),8)					As cod_uso
	From TkActivC cab with(Nolock)
		Inner Join TkActivD det with(Nolock)
			On cab.TIENDA = det.TIENDA And cab.SERIE = det.SERIE And cab.NUMERO = det.NUMERO
		--// Se agregó equivalencia - Henry Morales - 11/04/18
		--Inner Join GC_Equivalencias eq
		--	On Left(det.CODACTI,5) = eq.GC_PrefijoTarj
		Left Join Cupones cup  with(Nolock)
			On det.CODACTI = cup.Cup_Barra_Alterno
		Left Join tarticulo art with(Nolock)
			On art.cod_artic = substring(cup.Cup_Barra_Alterno,4,7) And art.cod_secci = @cod_secci
		--	On art.cod_artic = eq.GC_ArtId And art.cod_secci = eq.GC_ArtSecci
		--	On  art.cod_artic = Left(det.CODACTI,7) And art.cod_secci = @cod_secci
		Inner Join tempresa emp with(Nolock)
			On emp.cod_empresa = @empresa
	Where cab.SERIE = @serie And cab.NUMERO = @numero;

END
