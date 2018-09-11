If Exists(Select * from sysobjects Where name = 'USP_GTDA_Obten_Contrato' And type = 'FN')
	Drop Function USP_GTDA_Obten_Contrato
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 08/08/2018
-- Asunto			: Obtiene el Código Contrato Actual
-- ====================================================================================================
/*
	Select dbo.USP_GTDA_Obten_Contrato('50102', 'TDA', '20180810')
*/

CREATE FUNCTION [dbo].[USP_GTDA_Obten_Contrato](
	@cod_tda	Varchar(5),
	@tipo		Varchar(3),
	@Fecha		Date
)
RETURNS Varchar(10)
AS    
BEGIN 

	Declare	@codigo	Varchar(10)
	
	--// Obtenemos mayor codigo (correlativo)
	Select 	@codigo = MAX(Cont_Id)
	From GTDA_Contratos
	Where Convert(Varchar,Cont_FecIni,103) <= Convert(Varchar,@Fecha,103)
	  And Cont_EntidId = @cod_tda
	  And Cont_TipEnt = @tipo
	  And Cont_TipoCont = 'C'

	RETURN @codigo  

END