If Exists(Select * from sysobjects Where name = 'USP_GTDA_Inserta_Linea_CartaFianza' And type = 'P')
	Drop Procedure USP_GTDA_Inserta_Linea_CartaFianza
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 29/08/2018
-- Asunto			: Ingresa Carta Fianza (Linea x Linea)
-- ====================================================================================================
/*
	Exec USP_GTDA_Inserta_Linea_CartaFianza
*/

CREATE PROCEDURE [dbo].[USP_GTDA_Inserta_Linea_CartaFianza](
	@cod_cont		Varchar(10),	-- Cod. Contrato
	@tip_cont		Varchar(1),		-- TipoContrato

	@id				Varchar(2),
	@fec_ini		SmallDatetime,
	@fec_fin		SmallDatetime,
	
	@ban_id			Varchar(3),
	@ban_des		Varchar(max),

	@nro_doc		Varchar(max),

	@ruc			Varchar(15),
	@raz_soc		Varchar(max),

	@monto			Decimal(18,2)
)
   
AS    
BEGIN 

	BEGIN TRY
		BEGIN TRAN Grabar_CartaFianza
	
			Insert Into GTDA_Carta_Fianza(CarF_ContId, CarF_ContTipo, CarF_Id, CarF_FecIni, CarF_FecFin, CarF_BanId, CarF_BanDes, CarF_NroDoc, CarF_BenefRUC, CarF_BenefDesc,CarF_Monto)
			Values (@cod_cont, @tip_cont,			--// Identifica Contrato
					@id, @fec_ini, @fec_fin,		--// Identifica Carta
					@ban_id, @ban_des, @nro_doc,	--// Banco y Nro Documento
					@ruc, @raz_soc, @monto)		--// Benef

		COMMIT TRAN Grabar_CartaFianza
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN Grabar_CartaFianza

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