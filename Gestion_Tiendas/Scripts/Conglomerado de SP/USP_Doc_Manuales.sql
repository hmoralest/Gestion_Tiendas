If Exists(Select * from sysobjects Where name = 'USP_Doc_Manuales' And type = 'P')
	Drop Procedure USP_Doc_Manuales
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 18/09/2018
-- Asunto			: Lista los documentos manuales registrados
-- ====================================================================================================
/*
	Exec USP_Doc_Manuales '20180917','20181231','02'
*/

CREATE PROCEDURE [dbo].[USP_Doc_Manuales](
	@Fec_Ini	SmallDatetime,
	@Fec_Fin	SmallDatetime,
	@Empresa	Varchar(2)
)
   
AS    
BEGIN 

	/*Set		@Fec_Ini = '20180101'
	Set		@Fec_Fin = '20181231'
	Set		@Empresa = '02'*/

	SELECT /*FC.FC_NINT, FC.COD_ENTID, FC.FC_SUNA, FC.FC_SFAC, FC.FC_NFAC, FC_FFAC=CONVERT(VARCHAR(8),FC.FC_FFAC,112), FC.FC_NCLI, FC.FC_RUC,
           FC.FC_VVTA, FC.FC_VIMP3, FC.FC_TOTAL, FC_ESTA=ISNULL(FC.FC_ESTA,' '), FC.FC_CREF*/	-- Origianl FoxPro
		FC.FC_NINT,
		FC.COD_ENTID,
		emp.nro_ruc			RUC_EMP,	-- agregado
		ent.cod_ubige1		UBIGEO,			-- agregado
		ent.des_entid		DES_ENT,		-- agregado
		ent.des_direc1		DIR_ENT,		-- agregado
		IsNull(FC.FC_TDOC,'') FC_TDOC,
		FC.FC_SUNA,
		FC.FC_SFAC,
		FC.FC_NFAC,
		FC_FFAC=CONVERT(VARCHAR(8),FC.FC_FFAC,112),
		IsNull(FC.FC_SREF,'')	FC_SREF,			-- agregado
		IsNull(FC.FC_NREF,'')	FC_NREF,			-- agregado
		IsNull(FC.FC_MPUB,'')	FC_MPUB,			-- agregado
		IsNull(FC.FC_VEND,'')	FC_VEND,			-- agregado
		IsNull(FC.FC_DCLI,'')	FC_DCLI,			-- agregado
		IsNull(FC.FC_NCLI,'')	FC_NCLI,
		IsNull(FC.FC_CLIE,'')	FC_CLIE,		-- agregado
		IsNull(FC.FC_RUC,'')	FC_RUC,
		FC.FC_MONE,			-- agregado
		FC.FC_VVTA,
		FC.FC_VDCT1,			-- agregado
		FC.FC_VIMP3,
		FC.FC_VIMP4,			-- agregado
		FC.FC_TOTAL,
		FC_ESTA=ISNULL(FC.FC_ESTA,' '),
		IsNull(FC.FC_CREF,'')	FC_CREF,
		FD.FD_ARTI,			-- agregado
		art.des_artic	a_des1,			-- agregado
		art.des_umedi	a_unim,			-- agregado
		FD.FD_ITEM,			-- agregado
		FD.FD_QFAC,			-- agregado
		FD.FD_VVTA,			-- agregado
		FD.FD_VDCT1,			-- agregado
		FD.FD_SUBT1,			-- agregado
		FD.FD_VIMP3,			-- agregado
		FD.FD_PIMP3,			-- agregado
		FD.FD_TOTAL			-- agregado
	FROM BDTIENDA.DBO.FFACTC FC
		Inner Join BDTIENDA.DBO.FFACTD FD			-- agregado
			ON FC.COD_ENTID = FD.COD_ENTID And FC.FC_NINT = FD.FD_NINT	-- agregado
		Left Join BDTIENDA.DBO.TENTIDAD_TIENDA TE 
			ON TE.COD_ENTID=FC.COD_ENTID
		Inner Join BDTIENDA.DBO.tempresa emp		-- agregado
			On TE.COD_EMPRESA = emp.cod_empresa		-- agregado
		Inner Join BDTIENDA.DBO.TENTIDAD ent		-- agregado
			On TE.COD_ENTID = ent.cod_entid			-- agregado
		Inner Join tarticulo art					-- agregado
			On art.cod_artic = FD.FD_ARTI And art.cod_secci = '5'	-- agregado
    WHERE FC.FC_FFAC>=@Fec_Ini AND  FC.FC_FFAC<=@Fec_Fin
      AND TE.COD_EMPRESA = @Empresa
      AND TE.COD_ADMTDA NOT IN ('RD','FR')
      AND LEFT(FC.FC_SFAC,1) NOT IN ('F','B')
      AND FC.FC_ESTA IS NULL
	ORDER BY FC.FC_NINT

END