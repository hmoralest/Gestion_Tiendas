If Exists(Select * from sysobjects Where name = 'USP_GTDA_Lista_CartaFianza' And type = 'P')
	Drop Procedure USP_GTDA_Lista_CartaFianza
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 28/08/2018
-- Asunto			: Lista Cronograma de Pagos Registrado (Por Documento)
-- ====================================================================================================
/*
	Exec USP_GTDA_Lista_CartaFianza '',''
*/

CREATE PROCEDURE [dbo].[USP_GTDA_Lista_CartaFianza](
	@cod_cont			Varchar(10),	-- Cod. Contrato
	@tip_cont			Varchar(1)
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
		CarF_Monto							As Monto
	From GTDA_Carta_Fianza
	Where CarF_ContId = @cod_cont
	  And CarF_ContTipo = @tip_cont

END