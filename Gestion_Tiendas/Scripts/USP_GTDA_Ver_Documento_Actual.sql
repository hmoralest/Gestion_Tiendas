If Exists(Select * from sysobjects Where name = 'USP_GTDA_Ver_Documento_Actual' And type = 'P')
	Drop Procedure USP_GTDA_Ver_Documento_Actual
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 08/08/2018
-- Asunto			: Obtiene el Documento Actual, con los datos actualizados por Adendas
-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 03/09/2018
-- Asunto			: Se agreg� campo para retenci�n de 1ra Categ
-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 12/09/2018
-- Asunto			: Se mopdific� para que no considere campos de gesti�n de usuarios
-- ====================================================================================================
/*
	Exec USP_GTDA_Ver_Documento_Actual '0000000006','CONT','09993','ALM'
*/

CREATE PROCEDURE [dbo].[USP_GTDA_Ver_Documento_Actual](
	@cod_cont		Varchar(10),
	@tipo_cont		Varchar(1),
	@cod_tda		Varchar(5),
	@tipo			Varchar(3)
)
   
AS    
BEGIN 
	
	Declare	
			@cod_cont_ini	varchar(10),
			--// Variables usadas en Cursor
			@Id				Varchar(10),	--NO SE USA
			@TipoCont		Varchar(1),		--NO SE USA
			@PadreID		Varchar(10),	--NO SE USA
			@EntidId		Varchar(5),		--NO SE USA
			@TipEnt			Varchar(3),		--NO SE USA
			@Area			Decimal(18,2),
			@FecIni			Smalldatetime,
			@FecFin			Smalldatetime,
			@Moneda			Varchar(3),
			@Arrenda		Varchar(max),
			@Adminis		Varchar(max),
			@RentFija		Decimal(18,2),
			@RentVar		Decimal(18,2),
			@Adela			Decimal(18,2),
			@Garantia		Decimal(18,2),
			@Ingreso		Decimal(18,2),
			@RevProy		Decimal(18,2),
			@FondProm		Decimal(18,2),
			@FondPromVar	Decimal(18,2),
			@GComunFijo		Decimal(18,2),
			@GComunFijo_P	Bit,
			@GComunVar		Decimal(18,2),
			@Reten			Bit,
			@DbJul			Bit,
			@DbDic			Bit,
			@ServPub		Bit,
			@ArbMunic		Bit,
			@IPC_RentFija	Bit,
			@IPC_FondProm	Bit,
			@IPC_GComun		Bit,
			@IPC_Frecue		Smallint,
			@IPC_Fec		Smalldatetime,
		--	@PagoTercer		Bit,
		--	@CartFianza		Bit,
		--	@OblSegur		Bit,
			@RutaPlano		Varchar(max),
			@RutaCont		Varchar(max);

	IF (@tipo_cont = 'A')
	BEGIN 
		--// Obtenemos codigo 
		Select @cod_cont_ini = Cont_PadreID
		From GTDA_Contratos
		Where Cont_Id = @cod_cont
		  And Cont_TipoCont = @tipo_cont
		
		--// Obtenemos los datos del contrato con mayor vigencia
		Select	Cont_Id, Cont_TipoCont, Cont_PadreID, Cont_EntidId, Cont_TipEnt, Cont_CodInt, Cont_Area,
				Cont_FecIni, Cont_FecFin, Cont_Moneda, Cont_Arrenda, Cont_Adminis, 
				Cont_RentFija, Cont_RentVar, Cont_Adela, Cont_Garantia, Cont_Ingreso, Cont_RevProy, Cont_FondProm, Cont_FondPromVar, Cont_GComunFijo, Cont_GComunFijo_P, Cont_GComunVar, Cont_Reten, 
				Cont_DbJul, Cont_DbDic, Cont_ServPub, Cont_ArbMunic, 
				Cont_IPC_RentFija, Cont_IPC_FondProm, Cont_IPC_GComun, Cont_IPC_Frecue, Cont_IPC_Fec, 
				Cont_RutaPlano, Cont_RutaCont
		Into #temp_Contratos
		From GTDA_Contratos
		Where Cont_EntidId = @cod_tda
		  And Cont_TipEnt = @tipo
		  And Cont_Id = @cod_cont_ini
		  And Cont_TipoCont = 'C'
		  
		--// Declaramos Cursor
		DECLARE Adendas CURSOR FOR		
		Select	Cont_Id, Cont_TipoCont, Cont_PadreID, Cont_EntidId, Cont_TipEnt, Cont_CodInt, Cont_Area,
				Cont_FecIni, Cont_FecFin, Cont_Moneda, Cont_Arrenda, Cont_Adminis, 
				Cont_RentFija, Cont_RentVar, Cont_Adela, Cont_Garantia, Cont_Ingreso, Cont_RevProy, Cont_FondProm, Cont_FondPromVar, Cont_GComunFijo, Cont_GComunFijo_P, Cont_GComunVar, Cont_Reten, 
				Cont_DbJul, Cont_DbDic, Cont_ServPub, Cont_ArbMunic, 
				Cont_IPC_RentFija, Cont_IPC_FondProm, Cont_IPC_GComun, Cont_IPC_Frecue, Cont_IPC_Fec, 
				Cont_RutaPlano, Cont_RutaCont
		From GTDA_Contratos
		Where Cont_EntidId = @cod_tda
		  And Cont_TipEnt = @tipo
		  And Cont_PadreID = @cod_cont_ini
		  And Cont_TipoCont = 'A'
		  And Cont_Id <= @cod_cont
		Order By Cont_FecIni ASC;
	  
		--// Abrimos y recorremos cada Adenda
		OPEN Adendas
	
		FETCH NEXT FROM Adendas
		INTO	@Id, @TipoCont, @PadreID, @EntidId, @TipEnt, @Area, @FecIni, @FecFin, @Moneda, 
				@Arrenda, @Adminis,
				@RentFija, @RentVar, @Adela, @Garantia, @Ingreso, @RevProy, @FondProm, @FondPromVar, @GComunFijo, @GComunFijo_P, @GComunVar,
				@Reten, @DbJul, @DbDic, @ServPub, @ArbMunic, 
				@IPC_RentFija, @IPC_FondProm, @IPC_GComun, @IPC_Frecue, @IPC_Fec, 
		--		@PagoTercer, @CartFianza, @OblSegur, 
				@RutaPlano, @RutaCont


		WHILE @@FETCH_STATUS = 0
		BEGIN

			--// Actualizamos datos en el temporal
			Update #temp_Contratos 
			Set	
				Cont_TipoCont		= IsNull(@TipoCont,		Cont_TipoCont),
				Cont_Area			= IsNull(@Area,			Cont_Area),
				Cont_FecIni			= IsNull(@FecIni,		Cont_FecIni),
				Cont_FecFin			= IsNull(@FecFin,		Cont_FecFin),
				Cont_Moneda			= IsNull(@Moneda,		Cont_Moneda),
				Cont_Arrenda		= IsNull(@Arrenda,		Cont_Arrenda),
				Cont_Adminis		= IsNull(@Adminis,		Cont_Adminis),
				Cont_RentFija		= IsNull(@RentFija,		Cont_RentFija),
				Cont_RentVar		= IsNull(@RentVar,		Cont_RentVar),
				Cont_Adela			= IsNull(@Adela,		Cont_Adela),
				Cont_Garantia		= IsNull(@Garantia,		Cont_Garantia),
				Cont_Ingreso		= IsNull(@Ingreso,		Cont_Ingreso),
				Cont_RevProy		= IsNull(@RevProy,		Cont_RevProy),
				Cont_FondProm		= IsNull(@FondProm,		Cont_FondProm),
				Cont_FondPromVar	= IsNull(@FondPromVar,	Cont_FondPromVar),
				Cont_GComunFijo		= IsNull(@GComunFijo,	Cont_GComunFijo),
				Cont_GComunFijo_P	= IsNull(@GComunFijo_P,	Cont_GComunFijo_P),
				Cont_GComunVar		= IsNull(@GComunVar,	Cont_GComunVar),
				Cont_Reten			= IsNull(@Reten,		Cont_Reten),
				Cont_DbJul			= IsNull(@DbJul,		Cont_DbJul),
				Cont_DbDic			= IsNull(@DbDic,		Cont_DbDic),
				Cont_ServPub		= IsNull(@ServPub,		Cont_ServPub),
				Cont_ArbMunic		= IsNull(@ArbMunic,		Cont_ArbMunic),
				Cont_IPC_RentFija	= IsNull(@IPC_RentFija,	Cont_IPC_RentFija),
				Cont_IPC_FondProm	= IsNull(@IPC_FondProm,	Cont_IPC_FondProm),
				Cont_IPC_GComun		= IsNull(@IPC_GComun,	Cont_IPC_GComun),
				Cont_IPC_Frecue		= IsNull(@IPC_Frecue,	Cont_IPC_Frecue),
				Cont_IPC_Fec		= CASE WHEN (@IPC_RentFija = 0 And @IPC_FondProm = 0 And @IPC_GComun = 0) THEN null ELSE IsNull(@IPC_Fec, Cont_IPC_Fec) END,
		--		Cont_PagoTercer		= IsNull(@PagoTercer,	Cont_PagoTercer),
		--		Cont_CartFianza		= IsNull(@CartFianza,	Cont_CartFianza),
		--		Cont_OblSegur		= IsNull(@OblSegur,		Cont_OblSegur),
				Cont_RutaPlano		= IsNull(@RutaPlano,	Cont_RutaPlano),
				Cont_RutaCont		= IsNull(@RutaCont,		Cont_RutaCont)
			Where Cont_EntidId = @cod_tda
			  And Cont_TipEnt = @tipo
			  And Cont_Id = @cod_cont_ini


			FETCH NEXT FROM Adendas
			INTO	@Id, @TipoCont, @PadreID, @EntidId, @TipEnt, @Area, @FecIni, @FecFin, @Moneda, 
					@Arrenda, @Adminis,
					@RentFija, @RentVar, @Adela, @Garantia, @Ingreso, @RevProy, @FondProm, @FondPromVar, @GComunFijo, @GComunFijo_P, @GComunVar,
					@Reten, @DbJul, @DbDic, @ServPub, @ArbMunic, 
					@IPC_RentFija, @IPC_FondProm, @IPC_GComun, @IPC_Frecue, @IPC_Fec, 
			--		@PagoTercer, @CartFianza, @OblSegur, 
					@RutaPlano, @RutaCont
		END

		CLOSE Adendas;
		DEALLOCATE Adendas;
		
		--// Muestra Datos
		Select * from #temp_Contratos

		--// Elimina Temporal
		Drop table #temp_Contratos

	END
	IF (@tipo_cont = 'C')
	BEGIN 
		Exec USP_GTDA_Ver_Documento_Real @cod_cont_ini, @tipo_cont, @cod_tda, @tipo
	END


END
