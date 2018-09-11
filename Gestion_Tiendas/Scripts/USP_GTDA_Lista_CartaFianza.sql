If Exists(Select * from sysobjects Where name = 'USP_GTDA_Lista_CartaFianza' And type = 'P')
	Drop Procedure USP_GTDA_Lista_CartaFianza
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 28/08/2018
-- Asunto			: Lista Cronograma de Pagos Registrado (Por Documento)
-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 06/09/2018
-- Asunto			: Se modificó para que dependan unicamente de los locales
-- ====================================================================================================
/*
	Exec USP_GTDA_Lista_CartaFianza '',''
*/

CREATE PROCEDURE [dbo].[USP_GTDA_Lista_CartaFianza](
	@cod_ent			Varchar(5),
	@tip_ent			Varchar(3)
)
   
AS    
BEGIN 

	Select 
		CarF_Id								As Id,
		Convert(Varchar, CarF_FecIni, 103)	As Fecha_Ini,
		Convert(Varchar, CarF_FecFin, 103)	As Fecha_Fin,
		CarF_BanId							As Bco_Id,
		CarF_BanDes							As Bco_Des,
		CarF_NroDoc							As Nro_Doc,
		CarF_BenefRUC						As Benef_RUC,
		CarF_BenefDesc						As Benef_desc,
		CarF_Monto							As Monto,
		CarF_RutaDoc						As Ruta
	From GTDA_Carta_Fianza
	Where CarF_EntCod = @cod_ent
	  And CarF_EntTip = @tip_ent
	--Where CarF_ContId = @cod_cont
	--  And CarF_ContTipo = @tip_cont

END