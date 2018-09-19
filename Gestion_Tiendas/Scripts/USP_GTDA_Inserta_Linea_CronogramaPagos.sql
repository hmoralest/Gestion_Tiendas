If Exists(Select * from sysobjects Where name = 'USP_GTDA_Inserta_Linea_CronogramaPagos' And type = 'P')
	Drop Procedure USP_GTDA_Inserta_Linea_CronogramaPagos
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 21/08/2018
-- Asunto			: Ingresa Cronograma de Pagos (Linea x Linea)
-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 12/09/2018
-- Asunto			: Se agregaron campos para gestión de Cambios
-- ====================================================================================================
/*
	Exec USP_GTDA_Inserta_Linea_CronogramaPagos 
*/

CREATE PROCEDURE [dbo].[USP_GTDA_Inserta_Linea_CronogramaPagos](
	@cod_cont		Varchar(10),	-- Cod. Contrato
	@tip_cont		Varchar(1),		-- TipoContrato

	@nro			Varchar(2),		-- Nro Cuota
	@fijo			Decimal(18,2),	-- Monto Fijo Cuota
	@variable		Decimal(18,2),	-- Monto Variable Cuota

	@fec_ini		SmallDatetime,	-- Fecha Inicio Cuota
	@fec_fin		SmallDatetime,	-- Fecha Fin Cuota
	@vigencia		Varchar(max)
)
   
AS    
BEGIN 

	BEGIN TRY
		BEGIN TRAN Grabar_Cronograma
	
			Insert into GTDA_Cronograma_Pagos (	Cron_ContId, Cron_ContTipo, Cron_Nro, Cron_RenFija, Cron_RenVar, Cron_FecIni, Cron_FecFin, Cron_DesVigencia, 
												Cron_UsuCre, Cron_FecCre, Cron_UsuMod, Cron_FecMod)
			values (@cod_cont, @tip_cont,			--// Identifica Contrato
					@nro, @fijo, @variable,		--// Datos Cronograma
					@fec_ini, @fec_fin, @vigencia,		--// Fechas Cronograma
					'usu', getdate(), 'usu', getdate())	--// datos de usuario

		COMMIT TRAN Grabar_Cronograma
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN Grabar_Cronograma

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