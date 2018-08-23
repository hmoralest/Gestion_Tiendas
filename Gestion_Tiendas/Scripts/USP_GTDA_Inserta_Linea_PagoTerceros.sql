If Exists(Select * from sysobjects Where name = 'USP_GTDA_Inserta_Linea_PagoTerceros' And type = 'P')
	Drop Procedure USP_GTDA_Inserta_Linea_PagoTerceros
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 22/08/2018
-- Asunto			: Ingresa Pago a Terceros (Linea x Linea)
-- ====================================================================================================
/*
	Exec USP_GTDA_Inserta_Linea_PagoTerceros 
*/

CREATE PROCEDURE [dbo].[USP_GTDA_Inserta_Linea_PagoTerceros](
	@cod_cont		Varchar(10),	-- Cod. Contrato
	@tip_cont		Varchar(1),		-- TipoContrato

	@id				Varchar(2),
	@ruc			Varchar(15),
	@raz_soc		Varchar(max),

	@porc			Decimal(18,2),

	@ban_id			Varchar(3),
	@ban_des		Varchar(max),
	@ban_cta		Varchar(max)
)
   
AS    
BEGIN 

	BEGIN TRY
		BEGIN TRAN Grabar_PagoTercero
	
			Insert Into GTDA_Pago_Terceros (Pag_ContID, Pag_ContTipo, Pag_Id, Pag_RUC, Pag_RazSoc, Pag_Porc, Pag_BanId, Pag_BanDes, Pag_BanCta)
			Values (@cod_cont, @tip_cont,			--// Identifica Contrato
					@id, @ruc, @raz_soc,		--// RUC
					@porc,
					@ban_id, @ban_des, @ban_cta)		--// Fechas Cronograma

		COMMIT TRAN Grabar_PagoTercero
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN Grabar_PagoTercero

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