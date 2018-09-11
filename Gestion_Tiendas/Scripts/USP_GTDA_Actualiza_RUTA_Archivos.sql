If Exists(Select * from sysobjects Where name = 'USP_GTDA_Actualiza_RUTA_Archivos' And type = 'P')
	Drop Procedure USP_GTDA_Actualiza_RUTA_Archivos
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 10/09/2018
-- Asunto			: Actualiza las Rutas de los Archivos
-- Tipos			: PLAN = Plano de Contrato
--					  CONT = Contrato
-- ====================================================================================================
/*
	Exec USP_GTDA_Actualiza_RUTA_Archivos
*/

CREATE PROCEDURE [dbo].[USP_GTDA_Actualiza_RUTA_Archivos](
	@cod_doc		Varchar(10),
	@tip_doc		Varchar(3),

	@tip_ruta		Varchar(4),
	@new_ruta		Varchar(max)
)
   
AS    
BEGIN 



	BEGIN TRY
		BEGIN TRAN Grabar_Archivos
	
			IF @tip_ruta = 'PLAN'
				Update GTDA_Contratos Set
					Cont_RutaPlano = @new_ruta
				Where 
					Cont_Id	=  @cod_doc
				AND Cont_TipoCont = @tip_doc
				
			IF @tip_ruta = 'CONT'
				Update GTDA_Contratos Set
					Cont_RutaCont = @new_ruta
				Where 
					Cont_Id	=  @cod_doc
				AND Cont_TipoCont = @tip_doc
				
			IF @tip_ruta = 'CART'
				Update GTDA_Carta_Fianza Set
					CarF_RutaDoc = @new_ruta
				Where 
					CarF_Id	=  @cod_doc
				
			IF @tip_ruta = 'SEGU'
				Update GTDA_Seguros Set
					Seg_RutaDoc = @new_ruta
				Where 
					Seg_Id	=  @cod_doc
				AND Seg_Tipo = @tip_doc

		COMMIT TRAN Grabar_Archivos
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN Grabar_Archivos

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