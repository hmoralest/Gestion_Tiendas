If Exists(Select * from sysobjects Where name = 'USP_Valida_Pedido' And type = 'P')
	Drop Procedure USP_Valida_Pedido
GO

-- ==========================================================================================
-- Author			: Henry Morales
-- Create date		: 22/05/2018
-- Description		: Valida la existencia del pedido
-- ==========================================================================================
/*
	declare @val numeric
	Exec USP_Valida_Pedido '4', @val output
	select @val
*/

CREATE PROCEDURE USP_Valida_Pedido
	@id				varchar(12),
	@valida			numeric output
as
	Select @valida=count(*) 
	From Liquidacion
	Where Liq_Id=@id
	
	If @valida is null Begin Set @valida=0 End
	

