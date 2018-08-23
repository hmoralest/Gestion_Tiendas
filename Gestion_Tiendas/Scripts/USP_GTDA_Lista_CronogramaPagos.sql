If Exists(Select * from sysobjects Where name = 'USP_GTDA_Lista_CronogramaPagos' And type = 'P')
	Drop Procedure USP_GTDA_Lista_CronogramaPagos
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 21/08/2018
-- Asunto			: Lista Cronograma de Pagos Registrado (Por Documento)
-- ====================================================================================================
/*
	Exec USP_GTDA_Lista_CronogramaPagos 
*/

CREATE PROCEDURE [dbo].[USP_GTDA_Lista_CronogramaPagos](
	@cod_cont			Varchar(10),	-- Cod. Contrato
	@tip_cont			Varchar(1)
)
   
AS    
BEGIN 

	Select 
		Cron_ContId								As Cont_Id,
		Cron_ContTipo							As Cont_Tipo,
		Cron_Nro								As Nro,
		Cron_RenFija							As Fijo,
		Cron_RenVar								As Variable,
		Convert(Varchar, Cron_FecIni, 103)		As Fec_Ini,
		Convert(Varchar, Cron_FecFin, 103)		As Fec_Fin,
		Cron_DesVigencia						As Fecha
	From GTDA_Cronograma_Pagos
	Where Cron_ContId = @cod_cont
	  And Cron_ContTipo = @tip_cont

END