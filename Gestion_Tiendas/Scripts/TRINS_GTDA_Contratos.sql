  If Exists(Select * from sysobjects Where name = 'TRINS_GTDA_Contratos' And type = 'TR')
	Drop TRIGGER TRINS_GTDA_Contratos
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 27/08/2018
-- Asunto			: Actualiza Tablas de Estado Contrato
-- ====================================================================================================
/*
	Exec TRINS_GTDA_Contratos 
*/

CREATE TRIGGER TRINS_GTDA_Contratos ON GTDA_Contratos
FOR INSERT
AS  
BEGIN

	/*Estados*/
	-- Sin Contrato
	-- Contrato Vigente
	-- Contrato por Vencer
	-- Contrato Vencido
	
	Declare
			@Fecha_Ini_new		SmallDatetime,
			@Fecha_Fin_new		SmallDatetime,
			@Fecha_actual		SmallDatetime,

			@Local_ID			Varchar(5),
			@Local_Tipo			Varchar(3),
			@Contr_ID			Varchar(10),
			@Contr_Tipo			Varchar(1),

			@Cod_Int			Varchar(max),

			@dias_vigencia		SmallInt

	Select @Fecha_Ini_new = Cont_FecIni, @Fecha_Fin_new = Cont_FecFin From inserted
	Select @Fecha_actual  = GETDATE()
	
	Select	@Local_ID = Cont_EntidId,	@Local_Tipo = Cont_TipEnt,
			@Contr_ID = Cont_Id,		@Contr_Tipo = Cont_TipoCont, 	@Cod_Int = Cont_CodInt From inserted

	Select @dias_vigencia = Cast(Par_valor AS smallint) From GTDA_Parametros Where Par_codigo = 'dias_vigen'
	
	IF NOT Exists (Select 1 From GTDA_Estado_Locales Where Est_LocId = @Local_ID And Est_LocTipo = @Local_Tipo)
	Begin

		Insert Into GTDA_Estado_Locales (Est_LocId, Est_LocTipo, Est_ContId, Est_ContTipo, Est_FechaVig, Est_Estado)
		Values (@Local_ID, @Local_Tipo, Null, Null, Null, Null)

	End
	
		--// aun vigente (sin alerta)
		IF (DATEDIFF(day, GETDATE(), @Fecha_Fin_new) > @dias_vigencia)
			Update GTDA_Estado_Locales 
				Set Est_FechaVig = @Fecha_Fin_new, Est_Estado = 'Contrato Vigente',
					Est_ContId = @Contr_ID, Est_ContTipo = @Contr_Tipo,
					Est_CodInt = @Cod_Int
			Where Est_LocId = @Local_ID
			  And Est_LocTipo = @Local_Tipo
			
		--// aun vigente (con alerta)
		IF (DATEDIFF(day, GETDATE(), @Fecha_Fin_new) BETWEEN 0 AND @dias_vigencia)
			Update GTDA_Estado_Locales 
				Set Est_FechaVig = @Fecha_Fin_new, Est_Estado = 'Contrato por Vencer',
					Est_ContId = @Contr_ID, Est_ContTipo = @Contr_Tipo,
					Est_CodInt = @Cod_Int
			Where Est_LocId = @Local_ID
			  And Est_LocTipo = @Local_Tipo

		--// Vencido
		IF (@Fecha_Fin_new < GETDATE())
			Update GTDA_Estado_Locales 
				Set Est_FechaVig = @Fecha_Fin_new, Est_Estado = 'Contrato Vencido',
					Est_ContId = @Contr_ID, Est_ContTipo = @Contr_Tipo,
					Est_CodInt = @Cod_Int
			Where Est_LocId = @Local_ID
			  And Est_LocTipo = @Local_Tipo

END