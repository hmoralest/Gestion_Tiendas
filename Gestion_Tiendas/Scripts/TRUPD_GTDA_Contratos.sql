If Exists(Select * from sysobjects Where name = 'TRUPD_GTDA_Contratos' And type = 'TR')
	Drop TRIGGER TRUPD_GTDA_Contratos
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 13/08/2018
-- Asunto			: Actualiza Tablas de Estado Contrato
-- ====================================================================================================
/*
	Exec TRUPD_GTDA_Contratos 
*/

CREATE TRIGGER TRUPD_GTDA_Contratos ON GTDA_Contratos
FOR UPDATE
AS  
BEGIN

	/*Estados*/
	-- Sin Contrato
	-- Contrato Vigente
	-- Contrato por Vencer
	-- Contrato Vencido
	
	Declare @Fecha_Ini_ant		SmallDatetime,
			@Fecha_Fin_ant		SmallDatetime,
			@Fecha_Ini_new		SmallDatetime,
			@Fecha_Fin_new		SmallDatetime,
			@Fecha_actual		SmallDatetime,

			@Local_ID			Varchar(5),
			@Local_Tipo			Varchar(3),
			@Contr_ID			Varchar(10),
			@Contr_Tipo			Varchar(1),

			@dias_vigencia		SmallInt

	Select @Fecha_Ini_ant = Cont_FecIni, @Fecha_Fin_ant = Cont_FecFin From deleted
	Select @Fecha_Ini_new = Cont_FecIni, @Fecha_Fin_new = Cont_FecFin From inserted
	Select @Fecha_actual  = GETDATE()
	
	Select	@Local_ID = Cont_EntidId,	@Local_Tipo = Cont_TipEnt,
			@Contr_ID = Cont_Id,		@Contr_Tipo = Cont_TipoCont	From inserted

	Select @dias_vigencia = Cast(Par_valor AS smallint) From GTDA_Parametros Where Par_codigo = 'dias_vigen'

	IF(@Fecha_Fin_ant != @Fecha_Fin_new)
	BEGIN
	
		IF (DATEDIFF(day, GETDATE(), @Fecha_Fin_new) > @dias_vigencia)
			--// aun vigente (sin alerta)
			Update GTDA_Estado_Locales 
				Set Est_FechaVig = @Fecha_Fin_new, Est_Estado = 'Contrato Vigente',
					Est_ContId = @Contr_ID, Est_ContTipo = @Contr_Tipo
			Where Est_LocId = @Local_ID
			  And Est_LocTipo =@Local_Tipo
			
		IF (DATEDIFF(day, GETDATE(), @Fecha_Fin_new) BETWEEN 0 AND @dias_vigencia)
			--// aun vigente (con alerta)
			Update GTDA_Estado_Locales 
				Set Est_FechaVig = @Fecha_Fin_new, Est_Estado = 'Contrato por Vencer',
					Est_ContId = @Contr_ID, Est_ContTipo = @Contr_Tipo
			Where Est_LocId = @Local_ID
			  And Est_LocTipo =@Local_Tipo

		IF (@Fecha_Fin_new < GETDATE())
			--// Vencido
			Update GTDA_Estado_Locales 
				Set Est_FechaVig = @Fecha_Fin_new, Est_Estado = 'Contrato Vencido',
					Est_ContId = @Contr_ID, Est_ContTipo = @Contr_Tipo
			Where Est_LocId = @Local_ID
			  And Est_LocTipo =@Local_Tipo

	END

END