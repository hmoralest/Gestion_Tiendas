If Exists(Select * from sysobjects Where name = 'USP_AprobacionPromocion' And type = 'P')
	Drop Procedure USP_AprobacionPromocion
GO

-- ==========================================================================================
-- Author		: Henry Morales
-- Create date	: 21/02/2018
-- Description	: Envía correo electrónico para la aprobación de la Promo recien creada
-- ==========================================================================================
-- tablas		: promociones_cab
--				  promociones_aprob
-- ==========================================================================================
/*
	Exec USP_AprobacionPromocion
*/

CREATE Procedure USP_AprobacionPromocion(
	@id_promo		Varchar(8),
	@coduser		Varchar(3),
	@estado			Char(1),			/*A=Aprobado; R=Rechazado*/
	@comentario		Varchar(max)
)
AS 
BEGIN

	BEGIN TRY
		BEGIN TRAN Aprobacion_PROMO

		Insert Into promociones_aprob (idpromo, iduser, estado, complemento, fecreg)
		values (@id_promo, @coduser, @estado, @comentario, getdate());

		/*If(@estado = 'A')
		BEGIN
			IF Not Exists(	Select 1
							From aprobaciones
							Where id_promocion = 0 
							  And estado = 'A' And email Not IN (	Select email
																	From aprobaciones
																	Where id_promocion = @id_promo And estado = 'A') )
			BEGIN
				Update promociones_cab Set estado = 1 Where idpromo = @id_promo;
			END
		END

		If(@estado = 'R')
		BEGIN
			Update promociones_cab Set estado = 2 Where idpromo = @id_promo;
		END*/

				
		COMMIT TRAN Aprobacion_PROMO
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN Aprobacion_PROMO

		DECLARE		@ErrorMessage	NVARCHAR(4000),
					@ErrorSeverity	INT,
					@ErrorState		INT; 

		SELECT		@ErrorMessage = ERROR_MESSAGE(),
					@ErrorSeverity = ERROR_SEVERITY(),
					@ErrorState = ERROR_STATE(); 

		RAISERROR (	@ErrorMessage, @ErrorSeverity, @ErrorState ); 

	END CATCH
END