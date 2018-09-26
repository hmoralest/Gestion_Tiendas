If Exists(Select * from sysobjects Where name = 'USP_ActualizaVentas_PS' And type = 'P')
	Drop Procedure USP_ActualizaVentas_PS
GO

-- ==========================================================================================
-- Author			: Henry Morales
-- Create date		: 21/02/2018
-- Description		: Se Actualiza estado de las Ventas que han sido enviadas a los DBF
--					  Se agerga @estado para poder hacer RollBack Manual
-- ==========================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 06/04/2018
-- Asunto			: Se agreg� el par�metro @tipo, para agregar tambi�n Notas de Cr�dito
--						VT = Ventas
--						NC = Notas de Cr�dito
-- ==========================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 17/05/2018
-- Asunto			: Se actualiz� para poder usarlo en la funci�n de Visual FoxPro, USP_Exportar_Ventas_Bata
-- ==========================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 19/06/2018
-- Asunto			: Se actualiz� para poder tomar correctamente las Notas de Cr�dito
-- ==========================================================================================
/*
	Exec USP_ActualizaVentas_PS 'F09500000001','P', 'FA'
*/

CREATE Procedure USP_ActualizaVentas_PS(
	@id			Varchar(12),
	@estado		Varchar(1),
	@tipo		Varchar(3)
)
AS 
BEGIN

	BEGIN TRY
		BEGIN TRAN act_Venta

		IF(@tipo IN ('FA','BO'))
		--IF(@tipo = 'VT')
		BEGIN
			Update Venta Set Ven_EstAct_Alm = @estado Where Ven_Id = @Id;
		END
		IF (@tipo = 'NC')
		BEGIN
			--Update Nota_Credito Set Not_EstAct_Alm = @estado Where Not_Id = @Id;
			Update Nota_Credito Set Not_EstAct_Alm = @estado Where dbo.Devolver_Serie_Doc(Not_BasId,Not_Alm_Id) + right(replicate('0',8) + cast(not_numero as varchar(15)),8) = @id;
		END
				
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