If Exists(Select * from sysobjects Where name = 'USP_GTDA_Actualiza_Contrato' And type = 'P')
	Drop Procedure USP_GTDA_Actualiza_Contrato
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 13/08/2018
-- Asunto			: Actualiza Contrato
-- ====================================================================================================
/*
	Exec USP_GTDA_Actualiza_Contrato 
*/

CREATE PROCEDURE [dbo].[USP_GTDA_Actualiza_Contrato](
	@codigo			Varchar(5),		-- Cod. Entidad
	@tipo			Varchar(3),		-- Tipo Entidad (ALM, TDA)
	@Id				Varchar(10),
	@fechaini		SmallDatetime,	-- Contrato
	@fechafin		SmallDatetime,	-- Contrato
	@area			Decimal(18,2),
	@moneda			Varchar(3),		-- Contrato
	
	@arrendador		Varchar(max),
	@administra		Varchar(max),

	@rent_fij		Decimal(18,2),
	@rent_var		Decimal(18,2),
	@adelanto		Decimal(18,2),
	@garantia		Decimal(18,2),
	@der_ingr		Decimal(18,2),
	@rev_proy		Decimal(18,2),
	@promocio		Decimal(18,2),
	@gast_com		Decimal(18,2),
	@gs_com_v		Decimal(18,2),

	@dbJulio		Bit,
	@dbDiciembre	Bit,
	@serv_public	Bit,
	@arbitrios		Bit,

	@IPC_renta		Bit,
	@IPC_promo		Bit,
	@IPC_comun		Bit,
	@IPC_frecu		SmallInt,
	@fecha_IPC		SmallDatetime,

	@pag_terce		Bit,
	@obl_segur		Bit,
	@obl_carta		Bit,

	@ruta_plano		Varchar(max),
	@ruta_contr		Varchar(max)
)
   
AS    
BEGIN 

	BEGIN TRY
		BEGIN TRAN Grabar_Contratos
	
			Update GTDA_Contratos Set
				Cont_Area	=  @area,
				Cont_FecIni	=  @fechaini,
				Cont_FecFin	=  @fechafin,
				Cont_Moneda	=  @moneda,
				Cont_Arrenda = @arrendador,
				Cont_Adminis = @administra,
				Cont_RentFija	=  @rent_fij,
				Cont_RentVar	=  @rent_var,
				Cont_Adela	=  @adelanto,
				Cont_Garantia	=  @garantia,
				Cont_Ingreso	=  @der_ingr,
				Cont_RevProy	=  @rev_proy,
				Cont_FondProm	=  @promocio,
				Cont_GComunFijo	=  @gast_com,
				Cont_GComunVar	=  @gs_com_v,
				Cont_DbJul	=  @dbJulio,
				Cont_DbDic	=  @dbDiciembre,
				Cont_ServPub	=  @serv_public,
				Cont_ArbMunic	=  @arbitrios,
				Cont_IPC_RentFija	=  @IPC_renta,
				Cont_IPC_FondProm	=  @IPC_promo,
				Cont_IPC_GComun	=  @IPC_comun,
				Cont_IPC_Frecue	=  @IPC_frecu,
				Cont_IPC_Fec	=  @fecha_IPC,
				Cont_PagoTercer	=  @pag_terce,
				Cont_CartFianza	=  @obl_carta,
				Cont_OblSegur	=  @obl_segur,
				Cont_RutaPlano	=  @ruta_plano,
				Cont_RutaCont	=  @ruta_contr
			Where 
				Cont_Id	=  @Id
			AND Cont_TipoCont = 'C'
			AND	Cont_EntidId	=  @codigo
			AND	Cont_TipEnt	=  @tipo


		COMMIT TRAN Grabar_Contratos
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN Grabar_Contratos

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