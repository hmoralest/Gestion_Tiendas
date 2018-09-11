If Exists(Select * from sysobjects Where name = 'USP_GTDA_Grabar_Modificar_CartaFianza' And type = 'P')
	Drop Procedure USP_GTDA_Grabar_Modificar_CartaFianza
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 04/09/2018
-- Asunto			: Se creó para Grabar y Modificar CartaFianza
-- ====================================================================================================
/*
	Exec USP_GTDA_Grabar_Modificar_CartaFianza '09993','ALM','','20180101','20181231','0012','Banco de la Nacion','123123123','1110','D:\Conglomerado de SP\QuitaEsp.txt' 
*/

CREATE PROCEDURE [dbo].[USP_GTDA_Grabar_Modificar_CartaFianza](
	@ent_cod		Varchar(5),
	@ent_tip		Varchar(3),

	@id				Varchar(4),
	@fec_ini		SmallDatetime,
	@fec_fin		SmallDatetime,

	@ban_id			Varchar(4),
	@ban_des		Varchar(max),
	@nro_doc		Varchar(max),

	@ruc			Varchar(15),
	@raz_soc		varchar(max),

	@monto			Decimal(18,2),

	@ruta			Varchar(max)
)
   
AS    
BEGIN 


	BEGIN TRY
		BEGIN TRAN Grabar_CartaFianza
	
		If(@id = '')
		BEGIN
			Select @id = Right('0000' + Cast((IsNull(MAX(CarF_Id),0) + 1) As varchar),4) From GTDA_Carta_Fianza

			Insert Into GTDA_Carta_Fianza (	CarF_EntCod, CarF_EntTip, CarF_Id, CarF_FecIni, CarF_FecFin, CarF_BanId, CarF_BanDes, CarF_NroDoc, CarF_BenefRUC, CarF_BenefDesc, CarF_Monto, CarF_RutaDoc)
			Values (@ent_cod, @ent_tip, @id, @fec_ini, @fec_fin,
					@ban_id, @ban_des, @nro_doc,
					@ruc, @raz_soc, @monto, @ruta)
		END
		ELSE
		BEGIN
			Update GTDA_Carta_Fianza Set
				CarF_FecIni = @fec_ini,
				CarF_FecFin = @fec_fin,
				CarF_BanId = @ban_id,
				CarF_BanDes = @ban_des,
				CarF_NroDoc = @nro_doc,
				CarF_BenefRUC = @ruc,
				CarF_BenefDesc = @raz_soc,
				CarF_Monto = @monto,
				CarF_RutaDoc = @ruta
			Where 
				CarF_EntCod	=	@ent_cod
			AND CarF_EntTip	=	@ent_tip
			AND	CarF_Id		=	@id
		END

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