If Exists(Select * from sysobjects Where name = 'USP_GTDA_Grabar_Modificar_Seguros' And type = 'P')
	Drop Procedure USP_GTDA_Grabar_Modificar_Seguros
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 04/09/2018
-- Asunto			: Se creó para Grabar y Modificar Seguros
-- ====================================================================================================
/*
	Exec USP_GTDA_Grabar_Modificar_Seguros 
*/

CREATE PROCEDURE [dbo].[USP_GTDA_Grabar_Modificar_Seguros](
	@ent_cod		Varchar(5),
	@ent_tip		Varchar(3),

	@seg_cod		Varchar(5),
	@seg_tip		Varchar(3),
	@fec_ini		SmallDatetime,
	@fec_fin		SmallDatetime,

	@asg_ruc		Varchar(15),
	@asg_raz		Varchar(max),
	@nro_doc		Varchar(max),
	@ben_ruc		Varchar(15),
	@ben_raz		varchar(max),

	@cantid			Decimal(18,2),
	@unidad			varchar(30),
	@valor			Decimal(18,2),

	@ruta			Varchar(max)
)
   
AS    
BEGIN 


	BEGIN TRY
		BEGIN TRAN Grabar_Seguros
	
		If(@seg_cod = '')
		BEGIN
			Select @seg_cod = Right('00000' + Cast((IsNull(MAX(Seg_Id),0) + 1) As varchar),5) From GTDA_Seguros

			Insert Into GTDA_Seguros (	Seg_EntId, Seg_EntTip, Seg_Id, Seg_Tipo, Seg_FecIni, Seg_FecFin, 
										Seg_AsegRUC, Seg_AsegRazSoc, Seg_NroDoc, Seg_BenefRUC, Seg_BenefRazSoc, 
										Seg_Cant, Seg_Unidad, Seg_Valor, Seg_RutaDoc)
			Values (@ent_cod, @ent_tip, @seg_cod, @seg_tip, @fec_ini, @fec_fin,
					@asg_ruc, @asg_raz, @nro_doc, @ben_ruc, @ben_raz,
					@cantid, @unidad, @valor,
					@ruta)
		END
		ELSE
		BEGIN
			Update GTDA_Seguros Set
				Seg_FecIni		= @fec_ini,
				Seg_FecFin		= @fec_fin,
				Seg_AsegRUC		= @asg_ruc,
				Seg_AsegRazSoc	= @asg_raz,
				Seg_NroDoc		= @nro_doc,
				Seg_BenefRUC	= @ben_ruc,
				Seg_BenefRazSoc	= @ben_raz,
				Seg_Cant		= @cantid,
				Seg_Unidad		= @unidad,
				Seg_Valor		= @valor,
				Seg_RutaDoc		= @ruta
			Where 
				Seg_EntId	=	@ent_cod
			AND Seg_EntTip	=	@ent_tip
			AND	Seg_Id		=	@seg_cod
			AND	Seg_Tipo	=	@seg_tip
		END

		COMMIT TRAN Grabar_Seguros
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN Grabar_Seguros

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