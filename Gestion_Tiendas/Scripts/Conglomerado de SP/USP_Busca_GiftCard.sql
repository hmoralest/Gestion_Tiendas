If Exists(Select * from sysobjects Where name = 'USP_Busca_GiftCard' And type = 'P')
	Drop Procedure USP_Busca_GiftCard
GO

-- =====================================================================
-- Author			: Henry Morales
-- Create date		: 22/03/2018
-- Description		: Busca Gift Card para su Activación
-- =====================================================================
-- Modificado por	: Henry Morales Tasaico
-- Fch. Modifica	: 27/04/2018
-- Asunto			: Se modificó la estructura del código de Activación
-- =====================================================================
/*
	Exec USP_Busca_GiftCard '827999003300100013'
*/

CREATE Procedure USP_Busca_GiftCard(
	@codigo_act		Varchar(20)
)
AS 
BEGIN

	Declare @cod_seccion varchar(1);
	Set		@cod_seccion = '5';

	--// Modificado por	: Henry Morales Tasaico - 27/04/2018
	--// Se cambio el uso de la tabla equivalencias, debido a cambio en estructura de código de Activación
	Select 
		 art.cod_artic								As articulo
		,RTRIM(LTRIM(substring(cup.Cup_Barra_Alterno,14,5)))		As activacion
		,art.des_artic								As descripcion
		,prom.Prom_Des								As promocion
		,convert(varchar,cup.Cup_Fecha_Ing,103)		As fec_crea
		,1											As cant
		,cup.Cup_Val_Monto							As monto
		,cup.Cup_Barra_Alterno						As cod_barra
		,cup.Cup_EstID								As estado
	From Promocion prom with(Nolock)
		Inner Join Cupones cup with(Nolock)
			On prom.Prom_ID = cup.Cup_PromID
		--// Se agregó equivalencia - Henry Morales - 11/04/18
		--Inner Join GC_Equivalencias eq
		--	On Left(cup.Cup_Barra_Alterno,5) = eq.GC_PrefijoTarj
		Left Join tarticulo art with(Nolock)
			On art.cod_artic = substring(cup.Cup_Barra_Alterno,4,7) And art.cod_secci = @cod_seccion
		--	On art.cod_artic = eq.GC_ArtId And art.cod_secci = eq.GC_ArtSecci
		--	On  art.cod_artic = Left(det.CODACTI,7) And art.cod_secci = @cod_seccion
	Where cup.Cup_Barra_Alterno = @codigo_act


	/*Select 
		 substring(@codigo_act,1,7)								As articulo
		,substring(@codigo_act,8,5)			As activacion
		,'Gift Card de prueba'								As descripcion
		,'Lote Prueba'								As promocion
		,convert(varchar,getdate(),103)		As fec_crea
		,1											As cant
		,100							As monto
		,@codigo_act						As cod_barra
		,'E'								As estado*/

END
