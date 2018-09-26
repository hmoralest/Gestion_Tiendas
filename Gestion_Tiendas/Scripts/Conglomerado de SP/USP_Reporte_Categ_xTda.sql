If Exists(Select * from sysobjects Where name = 'USP_Reporte_Categ_xTda' And type = 'P')
	Drop Procedure USP_Reporte_Categ_xTda
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 05/09/2018
-- Asunto			: Se creó para ser usado en reporte
-- ====================================================================================================
/*
	Exec USP_Reporte_Categ_xTda '20180801','20180826','80'
	COPY ... TO archivo TYPE XL5
*/

CREATE PROCEDURE [dbo].[USP_Reporte_Categ_xTda](
	@fec_ini		SmallDatetime,
	@fec_fin		SmallDatetime,
	@cod_categ		Varchar(2)
)
   
AS    
BEGIN 

	Select 
		tda.cod_entid			As Cod_Tda,
		tda.des_entid			As Des_Tda,
		tda.cod_cadena			As Canal,
		sum(CASE WHEN cab.FC_SUNA = '07'	
							THEN det.FD_VVTA*(0-1) 
							ELSE det.FD_VVTA END)		As Importe
	From Ffactc as cab with (nolock) 
		Inner Join Ffactd as det with (nolock) 
			On cab.FC_NINT = det.FD_NINT And cab.COD_ENTID = det.COD_ENTID
		Inner Join tarticulo art
			On det.FD_ARTI = art.cod_artic
		Inner Join tentidad_tienda as tda
			On cab.COD_ENTID = tda.cod_entid
	Where cab.FC_FFAC between @fec_ini And @fec_fin And art.cod_categ = @cod_categ
	  And isnull(cab.FC_ESTA,'') <> 'A'
	Group by tda.cod_entid, tda.des_entid, tda.cod_cadena
	Order by Cod_Tda

END
