If Exists(Select * from sysobjects Where name = 'USP_GTDA_Ver_Documento_Real' And type = 'P')
	Drop Procedure USP_GTDA_Ver_Documento_Real
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 08/08/2018
-- Asunto			: Obtiene el Documento Real
-- ====================================================================================================
/*
	Exec USP_GTDA_Ver_Documento_Real '0000000006','CONT','09993','ALM'
*/

CREATE PROCEDURE [dbo].[USP_GTDA_Ver_Documento_Real](
	@cod_cont		Varchar(10),
	@tipo_cont		Varchar(1),
	@cod_tda		Varchar(5),
	@tipo			Varchar(3)
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
			@PagoTercer		Bit,
			@CartFianza		Bit,
			@OblSegur		Bit,
			@RutaPlano		Varchar(max),
			@RutaCont		Varchar(max);

	--// Obtenemos codigo 
	If(ltrim(rtrim(isnull(@cod_cont,''))) = '')
		Select @cod_cont= dbo.USP_GTDA_Obten_Contrato(@cod_tda, @tipo, GETDATE())

	--// Obtenemos los datos del contrato con mayor vigencia
	Select *
	Into #temp_Contrato
	From GTDA_Contratos
	Where Cont_EntidId = @cod_tda
	  And Cont_TipEnt = @tipo
	  And Cont_Id = @cod_cont
	  And Cont_TipoCont = @tipo_cont
	  
	--// Muestra Datos
	Select * from #temp_Contrato

	--// Elimina Temporal
	Drop table #temp_Contrato

END
