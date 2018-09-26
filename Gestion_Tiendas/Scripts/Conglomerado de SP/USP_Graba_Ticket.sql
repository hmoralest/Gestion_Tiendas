If Exists(Select * from sysobjects Where name = 'USP_Graba_Ticket' And type = 'P')
	Drop Procedure USP_Graba_Ticket
GO

-- =======================================================================
-- Author		: Henry Morales
-- Create date	: 26/03/2018
-- Description	: Graba los datos de los Ticket de Activación (Gift Cards)
-- =======================================================================
/*
	Exec USP_Graba_Ticket '50336','0336','00000007','20180503','46366953','HENRY DANIEL','MORALES','TASAICO','E','','','819999003400100001/1/200.0000'
*/

CREATE Procedure USP_Graba_Ticket(
	@tienda			Varchar(5),
	@serie			Varchar(4),
	@codigo			Varchar(8),
	@fecha			varchar(max),-- no se usa
	@dni			Varchar(15),
	@nombres		Varchar(200),
	@apepat			Varchar(200),
	@apemat			Varchar(200),
	@forpag			Varchar(1),
	@tarjeta		Varchar(2),
	@nro_tarj		Varchar(16),
	@detail			Varchar(max)		/* Cod Barra / Cantidad / Monto */
)
AS 
BEGIN

	BEGIN TRY
		BEGIN TRAN Ticket

		Declare @Item		varchar(max),

				@activacion	varchar(max),
				@cantidad	varchar(max),
				@monto		varchar(max);


		INSERT INTO TkActivC (TIENDA, SERIE, NUMERO, FECHA, TIDE, DIDE, NOMCLI, APEPAT, APEMAT, FORPAG, TARJET, NROTAR) 
		--VALUES (@tienda, @serie, @codigo, Convert(Datetime,@fecha), '1', @dni, @nombres, @apepat, @apemat, @forpag, @tarjeta, @nro_tarj);
		VALUES (@tienda, @serie, @codigo, GETDATE(), '1', @dni, @nombres, @apepat, @apemat, @forpag, @tarjeta, @nro_tarj);

		--// Cerrar cursor si está abierto
		IF (SELECT CURSOR_STATUS('global','detalle_cursor')) >= -1
		BEGIN
			IF (SELECT CURSOR_STATUS('global','detalle_cursor')) > -1
			BEGIN
				CLOSE detalle_cursor
			END
			DEALLOCATE detalle_cursor
		END

		--// Se realiza barrido del detalle
		DECLARE detalle_cursor CURSOR FOR
		Select item From UFN_SplitString(@detail,'|');
		
		OPEN detalle_cursor;
		
		FETCH NEXT FROM detalle_cursor
		INTO @Item;
		
		WHILE @@FETCH_STATUS = 0
		BEGIN

			exec USP_ExtraeString	@Item,		'/',		1,		@activacion	OutPut;
			exec USP_ExtraeString	@Item,		'/',		2,		@cantidad	OutPut;
			exec USP_ExtraeString	@Item,		'/',		3,		@monto		OutPut;

			INSERT INTO TkActivD (TIENDA, SERIE, NUMERO, CODACTI, CANT, MTOUNI) 
			VALUES (@tienda, @serie, @codigo, @activacion, Convert(Int,@cantidad), Convert(Decimal(18,4),@monto));
		
			FETCH NEXT FROM detalle_cursor
			INTO @Item;
		END
				
		CLOSE detalle_cursor;
		DEALLOCATE detalle_cursor;

		COMMIT TRAN Ticket
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN Ticket

		DECLARE		@ErrorMessage	NVARCHAR(4000),
					@ErrorSeverity	INT,
					@ErrorState		INT; 

		SELECT		@ErrorMessage = ERROR_MESSAGE(),
					@ErrorSeverity = ERROR_SEVERITY(),
					@ErrorState = ERROR_STATE(); 

		RAISERROR (	@ErrorMessage, @ErrorSeverity, @ErrorState ); 

	END CATCH
END
