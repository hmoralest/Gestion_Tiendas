If Exists(Select * from sysobjects Where name = 'USP_GTDA_Lista_Locales' And type = 'P')
	Drop Procedure USP_GTDA_Lista_Locales
GO

-- =====================================================================
-- Author			: Henry Morales
-- Create date		: 07/08/2018
-- Description		: Lista Locales 
-- =====================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 24/08/2018
-- Asunto			: Se agregó tabla de estados
-- =====================================================================
/*
	Exec USP_GTDA_Lista_Locales '','','','','','','','',''
*/
CREATE Procedure USP_GTDA_Lista_Locales (
	@id			Varchar(5),
	@cod_int	Varchar(max),
	@des		Varchar(max),
	@tipo		Varchar(3),
	@super		Varchar(max),
	@arren		Varchar(max),
	@ubic		Varchar(max),
	@direc		Varchar(max),
	@estado		Varchar(max)
)
AS 
BEGIN

	--// Modificado por	: Henry D. Morales - 24/08/2018
	--// Asunto			: Se agregó tabla de Estados
	Select
		locales.id			As id,
		est.Est_CodInt		As cod_int,
		locales.des			As des,
		locales.tipo		As tipo,
		locales.super		As super,
		IsNull(Cont.Cont_Arrenda,'')				As arren,
		ubigeo.descripcion	As ubic,
		locales.direc		As direc,
		IsNull(est.Est_Estado,'Sin Contrato')		As estado
	From
	(
		--// Query para Almacenes
		Select 
			ent.cod_entid As id, 
            ent.des_entid As des, 
             'ALM'	As tipo, 
            superv.des_entid  As super, 
            ''  As prop, 
            ent.cod_ubige1 As ubic, 
            ent.des_direc1 As direc, 
            ''              As estado 
		From [POSTGRES].[scomercial].[public].[tentidad] ent 
			Inner Join [POSTGRES].[scomercial].[public].[tentidad_almacen] alm 
				On ent.cod_entid = alm.cod_entid 
			Left Join [POSTGRES].[scomercial].[public].[tentidad_tienda] tda
				On tda.cod_entid = ent.cod_entidp
			Left Join (	Select dist.cod_distri, dist.des_distri, dist.cod_pais, dist.cod_superv, ent.des_entid
						From [POSTGRES].[scomercial].[public].[ttddistritos] dist
							Inner Join [POSTGRES].[scomercial].[public].[tentidad] ent
								On dist.cod_superv = ent.cod_entid
						Where dist.tip_estad = 'A')	superv
				On superv.cod_distri = tda.cod_distri
		Where ent.tip_estad = 'A' And alm.tip_estado = 'A' And alm.tip_estado = 'A'
		UNION
		--// Query para Tiendas
		Select 
			ent.cod_entid As id, 
            ent.des_entid As des, 
			'TDA'			As tipo, 
            superv.des_entid  As super, 
            ''  As prop, 
            ent.cod_ubige1 As ubic, 
            ent.des_direc1 As direc, 
            ''              As estado 
		From [POSTGRES].[scomercial].[public].[tentidad] ent 
            Inner Join [POSTGRES].[scomercial].[public].[tentidad_tienda] tda 
				On ent.cod_entid = tda.cod_entid 
			Left Join (	Select dist.cod_distri, dist.des_distri, dist.cod_pais, dist.cod_superv, ent.des_entid
						From [POSTGRES].[scomercial].[public].[ttddistritos] dist
							Inner Join [POSTGRES].[scomercial].[public].[tentidad] ent
								On dist.cod_superv = ent.cod_entid
						Where dist.tip_estad = 'A')	superv
				On superv.cod_distri = tda.cod_distri
		Where ent.tip_estad = 'A' And tda.flg_propia <> 'P' And tda.tip_estado = 'A'		) locales
	Left Join 
	(
		Select 
			u1.cod_dpto + u1.cod_prov + u1.cod_dist						As codigo,
			u3.des_ubigeo + ' / ' + u2.des_ubigeo + ' / ' + u1.des_ubigeo	As descripcion
		From [POSTGRES].[scomercial].[public].[tubigeo] u1
			Inner Join [POSTGRES].[scomercial].[public].[tubigeo] u2
				On u1.cod_dpto = u2.cod_dpto And u1.cod_prov = u2.cod_prov And u2.cod_dist='00'
			Inner Join [POSTGRES].[scomercial].[public].[tubigeo] u3
				On u1.cod_dpto = u3.cod_dpto And u3.cod_prov = '00' And u3.cod_dist='00'
		Where u1.cod_prov <> '00' And u1.cod_dist <> '00'									)	ubigeo
		On locales.ubic = ubigeo.codigo
	--// Modificado por	: Henry D. Morales - 24/08/2018
	--// Asunto			: Se agregó tabla de Estados
	Left Join GTDA_Estado_Locales est
		On locales.id = est.Est_LocId And locales.tipo = est.Est_LocTipo
	Left Join 
	(
		Select x.Cont_EntidId, x.Cont_TipEnt, x.Cont_Arrenda, x.Cont_Adminis
		From GTDA_Contratos x
		Where x.Cont_Id = (	Select MAX(a.Cont_Id)
							From GTDA_Contratos a
							Where x.Cont_EntidId = a.Cont_EntidId
							  And x.Cont_TipEnt = a.Cont_TipEnt )							)	Cont
		On Cont.Cont_EntidId = locales.id And Cont.Cont_TipEnt = locales.tipo
	--// Se agrega Filtros
	Where 
			(locales.id								like '%' + @id + '%'		Or ltrim(rtrim(@id)) = '')
	  And	(IsNull(est.Est_CodInt,'')				like '%' + @cod_int + '%'	Or ltrim(rtrim(@cod_int)) = '')
	  And	(locales.des							like '%' + @des + '%'		Or ltrim(rtrim(@des)) = '')
	  And	(locales.tipo							like '%' + @tipo + '%'		Or ltrim(rtrim(@tipo)) = '')
	  And	(locales.super							like '%' + @super + '%'		Or ltrim(rtrim(@super)) = '')
	  And	(IsNull(Cont.Cont_Arrenda,'')			like '%' + @arren + '%'		Or ltrim(rtrim(@arren)) = '')
	--  And	(locales.prop							like '%' + @arren + '%'		Or ltrim(rtrim(@arren)) = '')
	  And	(ubigeo.descripcion						like '%' + @ubic + '%'		Or ltrim(rtrim(@ubic)) = '')
	  And	(locales.direc							like '%' + @direc + '%'		Or ltrim(rtrim(@direc)) = '')
	  And	(IsNull(est.Est_Estado,'Sin Contrato')	like '%' + @estado + '%'	Or ltrim(rtrim(@estado)) = '')
	--  And	(locales.estado							like '%' + @estado + '%'	Or ltrim(rtrim(@estado)) = '')

	Order by tipo, ubic, id DESC

	print (@arren)

END