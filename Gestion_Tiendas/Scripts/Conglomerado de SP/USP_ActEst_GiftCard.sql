If Exists(Select * from sysobjects Where name = 'USP_ActEst_GiftCard' And type = 'P')
	Drop Procedure USP_ActEst_GiftCard
GO

-- ==========================================================================================
-- Author		: Henry Morales
-- Create date	: 21/02/2018
-- Description	: Se Actualiza estado de las Gift Cards
--				  - EM = Emitidas
--				  - DS = Activadas
--				  - CO = Consumidas
-- ==========================================================================================
/*
	Exec USP_ActEst_GiftCard '999181700001', 'DS', '46366953','Henry Daniel','Morales','Tasaico'
*/

CREATE Procedure USP_ActEst_GiftCard(
	@codigo			Varchar(20),
	@estado			Varchar(2),
	@dni			Varchar(15),
	@nombres		Varchar(200),
	@apepat			Varchar(200),
	@apemat			Varchar(200)
)
AS 
BEGIN

	BEGIN TRY
		BEGIN TRAN act_Venta
			If(@estado = 'DS')
			Begin
				Update	Cupones 
				Set		Cup_EstID		= @estado,
						Cup_Dni_Ori		= @dni,
						Cup_Nom_Ori		= @nombres,
						Cup_ApePat_Ori	= @apepat,
						Cup_ApeMat_Ori	= @apemat,
						Cup_Fecha_Ing	= GETDATE(),
						Cup_Fecha_Act	= GETDATE()
				Where	Cup_Barra_Alterno = @codigo;
			End
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