If Exists(Select * from sysobjects Where name = 'USP_GTDA_Ver_Contrato_Real' And type = 'P')
	Drop Procedure USP_GTDA_Ver_Contrato_Real
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 08/08/2018
-- Asunto			: Obtiene el Contrato Real, sin los datos actualizados por Adendas
-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 03/09/2018
-- Asunto			: Se agregó campo para Retencion de 1ra Categ
-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 12/09/2018
-- Asunto			: Se mopdificó para que no considere campos de gestión de usuarios
-- ====================================================================================================
/*
	Exec USP_GTDA_Ver_Contrato_Real '','50102', 'TDA'
*/

CREATE PROCEDURE [dbo].[USP_GTDA_Ver_Contrato_Real](
	@codigo		Varchar(10),
	@cod_tda	Varchar(5),
	@tipo		Varchar(3)
)
   
AS    
BEGIN 
	
	Declare	
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
			@GComunFijo		Decimal(18,2),
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

	--// Obtenemos codigo 
	If(ltrim(rtrim(isnull(@codigo,''))) = '')
		Select @codigo= dbo.USP_GTDA_Obten_Contrato(@cod_tda, @tipo, GETDATE())

	--// Obtenemos los datos del contrato con mayor vigencia
	Select Cont_Id, Cont_TipoCont, Cont_PadreID, Cont_EntidId, Cont_TipEnt, Cont_CodInt, Cont_Area,
			Cont_FecIni, Cont_FecFin, Cont_Moneda, Cont_Arrenda, Cont_Adminis, 
			Cont_RentFija, Cont_RentVar, Cont_Adela, Cont_Garantia, Cont_Ingreso, Cont_RevProy, Cont_FondProm, Cont_FondPromVar, Cont_GComunFijo, Cont_GComunFijo_P, Cont_GComunVar, Cont_Reten, 
			Cont_DbJul, Cont_DbDic, Cont_ServPub, Cont_ArbMunic, 
			Cont_IPC_RentFija, Cont_IPC_FondProm, Cont_IPC_GComun, Cont_IPC_Frecue, Cont_IPC_Fec, 
			Cont_RutaPlano, Cont_RutaCont
	Into #temp_Contrato
	From GTDA_Contratos
	Where Cont_EntidId = @cod_tda
	  And Cont_TipEnt = @tipo
	  And Cont_Id = @codigo
	  And Cont_TipoCont = 'C'
	  
	--// Muestra Datos
	Select * from #temp_Contrato

	--// Elimina Temporal
	Drop table #temp_Contrato

END

