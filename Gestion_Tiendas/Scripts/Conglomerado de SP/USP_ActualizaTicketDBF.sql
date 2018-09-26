If Exists(Select * from sysobjects Where name = 'USP_ActualizaTicketDBF' And type = 'P')
	Drop Procedure USP_ActualizaTicketDBF
GO

-- ========================================================================================
-- Author			: Henry Morales
-- Create date		: 23/04/2018
-- Description		: Se Actualiza estado de los tickets que ya han sido enviados a Central
--					@estado = 'P'	-> Procesado
-- ========================================================================================
/*
	Exec USP_ActualizaTicketDBF
*/

CREATE Procedure USP_ActualizaTicketDBF(
	@tienda			Varchar(5),
	@serie			Varchar(4),
	@numero			Varchar(8),
	@estado			Varchar(1)
)
AS 
BEGIN

	BEGIN TRY
		BEGIN TRAN act_Venta

			Update TkActivC Set EstDBF = @estado Where TIENDA = @tienda And SERIE = @serie And NUMERO = @numero;
				
		COMMIT TRAN act_Venta
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN act_Venta

		DECLARE		@ErrorMessage	NVARCHAR(4000),
					@ErrorSeverity	INT,
					@ErrorState		INT; 

		SELECT		@ErrorMessage = ERROR_MESSAGE(),
					@ErrorSeverity = ERROR_SEVERITY(),
					@ErrorState = ERROR_STATE(); 

		RAISERROR (	@ErrorMessage, @ErrorSeverity, @ErrorState ); 

	END CATCH
END