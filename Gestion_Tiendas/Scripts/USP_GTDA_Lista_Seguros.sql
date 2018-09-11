If Exists(Select * from sysobjects Where name = 'USP_GTDA_Lista_Seguros' And type = 'P')
	Drop Procedure USP_GTDA_Lista_Seguros
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 04/09/2018
-- Asunto			: Obtiene el Listado de los Tipos de Seguros Activos (A)
-- ====================================================================================================
/*
	Exec USP_GTDA_Lista_Seguros
*/

CREATE PROCEDURE [dbo].[USP_GTDA_Lista_Seguros](
	@cod_ent		Varchar(5),
	@tip_ent		Varchar(3),
	@tip_seg		Varchar(3),
	@cod_seg		Varchar(5)
)
AS    
BEGIN 
	
	Select 
		Seg_EntId			As loc_cod,
		Seg_EntTip			As loc_tip,
		Seg_Id				As Id,
		Seg_Tipo			As Tipo,
		Convert(Varchar, Seg_FecIni, 103)			As Fec_Ini,
		Convert(Varchar, Seg_FecFin, 103)			As Fec_Fin,
		Seg_AsegRUC			As Aseg_RUC,
		Seg_AsegRazSoc		As Aseg_Raz,
		Seg_NroDoc			As Nro_Doc,
		Seg_BenefRUC		As Benef_RUC,
		Seg_BenefRazSoc		As Benef_Raz,
		Seg_Cant			As Cantidad,
		Seg_Unidad			As Unidad,
		Seg_Valor			As Valor,
		Seg_RutaDoc			As Ruta
	From GTDA_Seguros
	Where  Seg_EntId	= @cod_ent
	  And  Seg_EntTip	= @tip_ent
	  And  Seg_Tipo		= @tip_seg
	  And (Seg_Id		= @cod_seg	Or @cod_seg = '')

END