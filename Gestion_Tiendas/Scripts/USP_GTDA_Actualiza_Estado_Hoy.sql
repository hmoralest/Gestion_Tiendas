If Exists(Select * from sysobjects Where name = 'USP_GTDA_Actualiza_Estado_Hoy' And type = 'P')
	Drop Procedure USP_GTDA_Actualiza_Estado_Hoy
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 17/09/2018
-- Asunto			: Actualiza Estados de Contrato según Vigencia Actual (diario)
-- ====================================================================================================
/*
	Exec USP_GTDA_Actualiza_Estado_Hoy
*/

CREATE PROCEDURE [dbo].[USP_GTDA_Actualiza_Estado_Hoy] 
   
AS    
BEGIN 

	Declare	@codigo				Varchar(5),
			@tipo				Varchar(3),
			@Fec_Fin			SmallDatetime,

			@dias_vigencia		SmallInt
			
	Select @dias_vigencia = Cast(Par_valor AS smallint) From GTDA_Parametros Where Par_codigo = 'dias_vigen'

	DECLARE Estados CURSOR FOR	
	Select Distinct 
		est.Est_LocId ,
		est.Est_LocTipo,
		Est_FechaVig
	From GTDA_Estado_Locales est

	BEGIN TRY	
		BEGIN TRAN Act_Estados

			OPEN Estados
	
			FETCH NEXT FROM Estados
			INTO	@codigo, @tipo, @Fec_Fin


			WHILE @@FETCH_STATUS = 0
			BEGIN
			
				IF (DATEDIFF(day, GETDATE(), @Fec_Fin) > @dias_vigencia)
					--// aun vigente (sin alerta)
					Update GTDA_Estado_Locales 
						Set Est_Estado = 'Contrato Vigente'
					Where Est_LocId = @codigo
					  And Est_LocTipo = @tipo
			
				IF (DATEDIFF(day, GETDATE(), @Fec_Fin) BETWEEN 0 AND @dias_vigencia)
					--// aun vigente (con alerta)
					Update GTDA_Estado_Locales 
						Set Est_Estado = 'Contrato por Vencer'
					Where Est_LocId = @codigo
					  And Est_LocTipo = @tipo

				IF (@Fec_Fin < GETDATE())
					--// Vencido
					Update GTDA_Estado_Locales 
						Set Est_Estado = 'Contrato Vencido'
					Where Est_LocId = @codigo
					  And Est_LocTipo = @tipo
					  
				FETCH NEXT FROM Estados
			INTO	@codigo, @tipo, @Fec_Fin
			END

			CLOSE Estados;
			DEALLOCATE Estados;


		COMMIT TRAN Act_Estados
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN Act_Estados

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