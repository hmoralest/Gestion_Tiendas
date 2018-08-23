If Exists(Select * from sysobjects Where name = 'USP_GTDA_Elimina_CronogramaPagos' And type = 'P')
	Drop Procedure USP_GTDA_Elimina_CronogramaPagos
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 21/08/2018
-- Asunto			: Elimina Cronograma de Pagos Registrado (Por Documento)
-- ====================================================================================================
/*
	Exec USP_GTDA_Elimina_CronogramaPagos 
*/

CREATE PROCEDURE [dbo].[USP_GTDA_Elimina_CronogramaPagos](
	@cod_cont			Varchar(10),	-- Cod. Contrato
	@tip_cont			Varchar(1)
)
   
AS    
BEGIN 

	BEGIN TRY
		BEGIN TRAN Elimina_Cronograma
	
			Delete From GTDA_Cronograma_Pagos Where Cron_ContId = @cod_cont And Cron_ContTipo = @tip_cont

		COMMIT TRAN Elimina_Cronograma
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN Elimina_Cronograma

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT; 		
				
		SET @ErrorMessage	= ERROR_MESSAGE();
		SET @ErrorSeverity	= ERROR_SEVERITY();
		SET @ErrorState		= ERROR_STATE(); 		

		RAISERROR (@ErrorMessage,	-- Message text.
           @ErrorSeverity,			-- Severity.
           @ErrorState);			-- State.
	END CATCH
END