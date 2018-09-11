If Exists(Select * from sysobjects Where name = 'USP_GTDA_Elimina_PagoTercero' And type = 'P')
	Drop Procedure USP_GTDA_Elimina_PagoTercero
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 21/08/2018
-- Asunto			: Elimina Pagos a Terceros (Por Documento)
-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 05/09/2018
-- Asunto			: Se actualizó para trabajar directo con Locales
-- ====================================================================================================
/*
	Exec USP_GTDA_Elimina_PagoTercero
*/

CREATE PROCEDURE [dbo].[USP_GTDA_Elimina_PagoTercero](
	@cod_loc			Varchar(5),
	@tip_loc			Varchar(3)
	--@cod_cont			Varchar(10),	-- Cod. Contrato
	--@tip_cont			Varchar(1)
)
   
AS    
BEGIN 

	BEGIN TRY
		BEGIN TRAN Elimina_PagoTercero
	
			Delete From GTDA_Pago_Terceros Where Pag_CodLoc = @cod_loc And Pag_TipLoc = @tip_loc
			--Delete From GTDA_Pago_Terceros Where Pag_ContID = @cod_cont And Pag_ContTipo = @tip_cont

		COMMIT TRAN Elimina_PagoTercero
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN Elimina_PagoTercero

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