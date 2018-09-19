If Exists(Select * from sysobjects Where name = 'USP_GTDA_Elimina_CartaFianza' And type = 'P')
	Drop Procedure USP_GTDA_Elimina_CartaFianza
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 29/08/2018
-- Asunto			: Elimina Cartas Fianzas (Por Documento)
-- ====================================================================================================
/*
	Exec USP_GTDA_Elimina_CartaFianza
*/

CREATE PROCEDURE [dbo].[USP_GTDA_Elimina_CartaFianza](
	@cod_ent			Varchar(10),	-- Cod. Contrato
	@tip_ent			Varchar(1)
)
   
AS    
BEGIN 

	BEGIN TRY
		BEGIN TRAN Elimina_CartaFianza
	
			Delete From GTDA_Carta_Fianza Where CarF_EntCod = @cod_ent And CarF_EntTip = @tip_ent

		COMMIT TRAN Elimina_CartaFianza
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN Elimina_CartaFianza

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