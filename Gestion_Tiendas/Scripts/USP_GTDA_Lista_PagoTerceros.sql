If Exists(Select * from sysobjects Where name = 'USP_GTDA_Lista_PagoTerceros' And type = 'P')
	Drop Procedure USP_GTDA_Lista_PagoTerceros
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 22/08/2018
-- Asunto			: Lista Pagos a Terceros (Por Documento)
-- ====================================================================================================
/*
	Exec USP_GTDA_Lista_PagoTerceros 
*/

CREATE PROCEDURE [dbo].[USP_GTDA_Lista_PagoTerceros](
	@cod_cont			Varchar(10),	-- Cod. Contrato
	@tip_cont			Varchar(1),		-- Contrato
	@cod_ent			Varchar(5),
	@tip_ent			Varchar(3)
)
   
AS    
BEGIN 

	IF(@cod_cont = '')
	BEGIN
		--// Obtenemos codigo 
		If(ltrim(rtrim(isnull(@cod_cont,''))) = '')
			Select @cod_cont= dbo.USP_GTDA_Obten_Contrato(@cod_ent, @tip_ent, GETDATE()), @tip_cont = 'C'

		If Exists (Select 1 From GTDA_Contratos Where Cont_PadreID = @cod_cont)
			Select @cod_cont = MAX(cont_id), @tip_cont = 'A' From GTDA_Contratos Where Cont_PadreID = @cod_cont And Cont_EntidId = @cod_ent And Cont_TipEnt = @tip_ent

	END

	Select 
		Pag_Id			As Id,
		Pag_RUC			As RUC,
		Pag_RazSoc		As raz_soc,
		Pag_Porc		As porcentaje,
		Pag_BanId		As banco_id,
		Pag_BanDes		As banco_desc,
		Pag_BanCta		As banco_cta
	From GTDA_Pago_Terceros
	Where Pag_ContID = @cod_cont
		And Pag_ContTipo = @tip_cont


END