If Exists(Select * from sysobjects Where name = 'USP_GTDA_Inserta_Contrato' And type = 'P')
	Drop Procedure USP_GTDA_Inserta_Contrato
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 09/08/2018
-- Asunto			: Ingresa Contrato/Adenda Nuevo
-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 03/09/2018
-- Asunto			: Se agregó campo de Retencion de 1ra Categ
-- ====================================================================================================
/*
	Exec USP_GTDA_Inserta_Contrato 
*/

CREATE PROCEDURE [dbo].[USP_GTDA_Inserta_Contrato](
	@codigo			Varchar(5),		-- Cod. Entidad
	@tipo			Varchar(3),		-- Tipo Entidad (ALM, TDA)
	@tipo_doc		Varchar(1),		-- Documento (C: Contrato; A: Adenda)
	@cont_pad		Varchar(10),	-- Documento padre
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
	@promoc_v		Decimal(18,2),
	@gast_com		Decimal(18,2),
	@gs_com_p		bit,
	@gs_com_v		Decimal(18,2),

	@Reten			Bit,
	@dbJulio		Bit,
	@dbDiciembre	Bit,
	@serv_public	Bit,
	@arbitrios		Bit,

	@IPC_renta		Bit,
	@IPC_promo		Bit,
	@IPC_comun		Bit,
	@IPC_frecu		SmallInt,
	@fecha_IPCa		Varchar(10),
	--@fecha_IPC		SmallDatetime,

	@pag_terce		Bit,
	@obl_segur		Bit,
	@obl_carta		Bit,

	@ruta_plano		Varchar(max),
	@ruta_contr		Varchar(max)
)
   
AS    
BEGIN 
	--/-/-/-/-/-/-/-/-/- Faltan validaciones y Adendas
	Declare @codigo_cont	Varchar(10)

	Set @codigo_cont = Right(Concat('0000000000',Cast(isnull((Select Cast(MAX(Cont_Id) As int)+1 From GTDA_Contratos),1) As Varchar)),10)
	
	--// Valida Fecha en vacío
	Declare @fecha_IPC Datetime

	If(@fecha_IPCa= '1/01/0001')
		Select @fecha_IPC = null
	Else 
		Select @fecha_IPC = CONVERT(SmallDateTime, @fecha_IPCa)

	--// Si es conrtato nuevo
	IF @tipo_doc='C'
	BEGIN
		Set @cont_pad = null;
	END
	--// Si es adenda nueva
	IF @tipo_doc='A'
	BEGIN
		IF OBJECT_ID('tempdb.dbo.#Contratos', 'U') IS NOT NULL
			Drop table #Contratos;
		CREATE TABLE #Contratos(
			Cont_Id				Varchar(10),
			Cont_TipoCont		Varchar(1),
			Cont_PadreID		Varchar(10),
			Cont_EntidId		Varchar(5),
			Cont_TipEnt			Varchar(3),
			Cont_Area			Decimal(18, 2),
			Cont_FecIni			Smalldatetime,
			Cont_FecFin			Smalldatetime,
			Cont_Moneda			Varchar(3),
			Cont_Arrenda		Varchar(max),
			Cont_Adminis		Varchar(max),
			Cont_RentFija		Decimal(18, 2),
			Cont_RentVar		Decimal(18, 2),
			Cont_Adela			Decimal(18, 2),
			Cont_Garantia		Decimal(18, 2),
			Cont_Ingreso		Decimal(18, 2),
			Cont_RevProy		Decimal(18, 2),
			Cont_FondProm		Decimal(18, 2),
			Cont_FondPromVar	Decimal(18, 2),
			Cont_GComunFijo		Decimal(18, 2),
			Cont_GComunFijo_P	Bit,
			Cont_GComunVar		Decimal(18, 2),
			Cont_Reten			Bit,
			Cont_DbJul			Bit,
			Cont_DbDic			Bit,
			Cont_ServPub		Bit,
			Cont_ArbMunic		Bit,
			Cont_IPC_RentFija	Bit,
			Cont_IPC_FondProm	Bit,
			Cont_IPC_GComun		Bit,
			Cont_IPC_Frecue		Smallint,
			Cont_IPC_Fec		Smalldatetime,
			Cont_PagoTercer		Bit,
			Cont_CartFianza		Bit,
			Cont_OblSegur		Bit,
			Cont_RutaPlano		Varchar(max),
			Cont_RutaCont		Varchar(max)
		)

		Insert Into #Contratos
		Exec USP_GTDA_Ver_Contrato_Actual @cont_pad,@codigo, @tipo

		if(@area = (Select Cont_Area From #Contratos))
			Set @area = null;
		if(@moneda = (Select Cont_Moneda From #Contratos))
			Set @moneda = null;
			
		if(@arrendador = (Select Cont_Arrenda From #Contratos))
			Set @arrendador = null;
		if(@administra = (Select Cont_Adminis From #Contratos))
			Set @administra = null;

		if(@rent_fij = (Select Cont_RentFija From #Contratos))
			Set @rent_fij = null;
		if(@rent_var = (Select Cont_RentVar From #Contratos))
			Set @rent_var = null;
		if(@adelanto = (Select Cont_Adela From #Contratos))
			Set @adelanto = null;
		if(@garantia = (Select Cont_Garantia From #Contratos))
			Set @garantia = null;
		if(@der_ingr = (Select Cont_Ingreso From #Contratos))
			Set @der_ingr = null;
		if(@rev_proy = (Select Cont_RevProy From #Contratos))
			Set @rev_proy = null;
		if(@promocio = (Select Cont_FondProm From #Contratos))
			Set @promocio = null;
		if(@promoc_v = (Select Cont_FondPromVar From #Contratos))
			Set @promoc_v = null;
		if(@gs_com_p = (Select Cont_GComunFijo From #Contratos))
			Set @gs_com_p = null;
		if(@gast_com = (Select Cont_GComunFijo_P From #Contratos))
			Set @gast_com = null;
		if(@gs_com_v = (Select Cont_GComunVar From #Contratos))
			Set @gs_com_v = null;
			
		if(@Reten = (Select Cont_Reten From #Contratos))
			Set @Reten = null;
		if(@dbJulio = (Select Cont_DbJul From #Contratos))
			Set @dbJulio = null;
		if(@dbDiciembre = (Select Cont_DbDic From #Contratos))
			Set @dbDiciembre = null;
		if(@serv_public = (Select Cont_ServPub From #Contratos))
			Set @serv_public = null;
		if(@arbitrios = (Select Cont_ArbMunic From #Contratos))
			Set @arbitrios = null;

		if(@IPC_renta = (Select Cont_IPC_RentFija From #Contratos))
			Set @IPC_renta = null;
		if(@IPC_promo = (Select Cont_IPC_FondProm From #Contratos))
			Set @IPC_promo = null;
		if(@IPC_comun = (Select Cont_IPC_GComun From #Contratos))
			Set @IPC_comun = null;
		if(@IPC_frecu = (Select Cont_IPC_Frecue From #Contratos) Or (@IPC_renta = 0 And @IPC_promo = 0 And @IPC_comun = 0))
			Set @IPC_frecu = null;
		if(@fecha_IPC = (Select Cont_IPC_Fec From #Contratos) Or (@IPC_renta = 0 And @IPC_promo = 0 And @IPC_comun = 0))
			Set @fecha_IPC = null;

		if(@pag_terce = (Select Cont_PagoTercer From #Contratos))
			Set @pag_terce = null;
		if(@obl_segur = (Select Cont_OblSegur From #Contratos))
			Set @obl_segur = null;
		if(@obl_carta = (Select Cont_CartFianza From #Contratos))
			Set @obl_carta = null;
			
		if(@ruta_plano = (Select Cont_RutaPlano From #Contratos))
			Set @ruta_plano = null;

	END


	BEGIN TRY
		BEGIN TRAN Grabar_Contratos
	
			Insert into GTDA_Contratos
			values (@codigo_cont, @tipo_doc, @cont_pad, @codigo, @tipo, @area, @fechaini, @fechafin, @moneda,	--// Valores grales de contrato
					@arrendador, @administra,		--// relacion
					@rent_fij, @rent_var, @adelanto, @garantia, @der_ingr, @rev_proy, @promocio, @promoc_v,  @gast_com, @gs_com_p, @gs_com_v,	--// Valores monetarios y porcentajes
					@Reten, @dbJulio, @dbDiciembre, @serv_public, @arbitrios,	--// Flags de comportamiento
					@IPC_renta, @IPC_promo,  @IPC_comun, @IPC_frecu, @fecha_IPC,	--// Comportamiento IPC
					@pag_terce, @obl_segur, @obl_carta,		--// Flags de Documentos Adicionales
					@ruta_plano,  @ruta_contr)			--// Rutas de documentos

			Select @codigo_cont As codigo
		COMMIT TRAN Grabar_Contratos
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN Grabar_Contratos

		Select '' As codigo

		/*DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT; 		
				
		SET @ErrorMessage	= ERROR_MESSAGE();
		SET @ErrorSeverity	= ERROR_SEVERITY();
		SET @ErrorState		= ERROR_STATE(); 		

		RAISERROR (@ErrorMessage,	-- Message text.
           @ErrorSeverity,			-- Severity.
           @ErrorState);			-- State.*/
	END CATCH
END