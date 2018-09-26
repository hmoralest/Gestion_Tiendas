If Exists(Select * from sysobjects Where name = 'USP_Reporte_GiftCard' And type = 'P')
	Drop Procedure USP_Reporte_GiftCard
GO

-- =====================================================================
-- Author			: Henry Morales
-- Create date		: 06/08/2018
-- Description		: Lista las Gift Card, que ya han sido activadas,
--					  mostrando los datos de activacion y consumo
-- =====================================================================
/*
	Exec BdTienda.dbo.USP_Reporte_GiftCard '20180701', '20180831'
*/

CREATE Procedure USP_Reporte_GiftCard(
	@fecha_ini		SmallDatetime,
	@fecha_fin		SmallDatetime
)
AS 
BEGIN

	select	
			IsNull(a.codacti,c.cup_barra_alterno)		As COD_ACTIV, 
			IsNull(c.CUP_SERIE,'')						As Cod_Interno, 
			IsNull(C.CUP_NUMERO,'')						As Numero_GiftCard, 
			IsNull(C.Cup_Val_Monto,0)					As Valor_GiftCard, 
			CASE WHEN C.Cup_EstID='CO' THEN 'CONSUMIDO' ELSE CASE WHEN C.Cup_EstID='DS' THEN 'ACTIVADO' ELSE '???' END END AS ESTADO_GIFT,
			IsNull(Cast(a.TIENDA As varchar),'OFICINA') As TIENDA_ACTIVA,
			IsNull(tda.des_entid,'')					As DESC_TDA_Activa,
			IsNull(C.CUP_DNI_ORI,'')					As DNI_Activa, 
			/*IsNull(C.Cup_Nom_Ori,'')					As Nombre_Activa, 
			IsNull(C.Cup_ApePat_Ori,'')					As ApePat_Activa, 
			IsNull(C.Cup_ApeMat_Ori,'')					As ApeMat_Activa, */
			CASE WHEN a.TIENDA Is Null	THEN ltrim(rtrim(IsNull(C.Cup_Nom_Ori,'')))
										ELSE ltrim(rtrim(IsNull(C.Cup_Nom_Ori,''))) + ' ' + ltrim(rtrim(IsNull(C.Cup_ApePat_Ori,''))) + ' '  + ltrim(rtrim(IsNull(C.Cup_ApeMat_Ori,'')))
			END											As Nombres_Activa,
			--IsNull(Convert(Varchar,C.Cup_Fecha_Act,103),'')		As Fecha_Activa,  
			--IsNull(left(replace(Convert(Varchar,C.Cup_Fecha_Act,103),'/',''),4)+right(replace(Convert(Varchar,C.Cup_Fecha_Act,103),'/',''),2),'')		As Fecha_Activa, 
			IsNull(left(replace(Convert(Varchar,IsNull(a.FECHA,C.Cup_Fecha_Act),103),'/',''),4)+right(replace(Convert(Varchar,IsNull(a.FECHA,C.Cup_Fecha_Act),103),'/',''),2),'')		As Fecha_Activa,  
			IsNull(C.Cup_Tda_Ven,'')					As TIENDA_Consumo, 
			IsNull(tda2.des_entid,'')					As DESC_TDA_Consumo,
			IsNull(C.Cup_SerieDoc_Ven,'')				As Serie_Doc_Consumo, 
			IsNull(C.Cup_NumDoc_Ven,'')					As Numero_Doc_Consumo,
			IsNull(C.Cup_Dni_Ven,'')					As DNI_Consumo,
			--IsNull(C.Cup_Nom_Ven,'')					As Nombres_Consumo,
			IsNull(Left(C.Cup_Nom_Ven,15),'')					As Nombres_Consumo,
			--IsNull(Convert(Varchar,C.Cup_FecDoc_Ven,103),'')	As Fecha_Consumo
			IsNull(left(replace(Convert(Varchar,C.Cup_FecDoc_Ven,103),'/',''),4)+right(replace(Convert(Varchar,C.Cup_FecDoc_Ven,103),'/',''),2),'')		As Fecha_Consumo
	  From cupones c With (NoLock)
		Full Join
			(	Select c.TIENDA,d.CODACTI, c.FECHA
				From TkActivC c 
					Inner Join TkActivD d 
						On c.tienda=d.tienda And c.serie=d.serie And c.NUMERO=d.NUMERO) a 
			On a.CODACTI=c.Cup_Barra_Alterno
		Left Join  tentidad_tienda tda
			On a.TIENDA = tda.cod_entid
		Left Join  tentidad_tienda tda2
			On c.Cup_Tda_Ven = tda2.cod_entid
	 Where c.Cup_Serie='000055' And c.Cup_EstID IN ('DS','CO') And c.Cup_PromID!='0057'
	   And IsNull(a.FECHA,C.Cup_Fecha_Act) Between @fecha_ini And @fecha_fin
	 Order By ESTADO_GIFT, c.Cup_Fecha_Act
	 
END

