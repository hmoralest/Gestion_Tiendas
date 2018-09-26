If Exists(Select * from sysobjects Where name = 'USP_ListaTicketGC' And type = 'P')
	Drop Procedure USP_ListaTicketGC
GO

-- =========================================================================
-- Author			: Henry Morales
-- Create date		: 23-04-2018
-- Description		: Lista Tickets de Activación de GC para llevarlos a DBF
-- =========================================================================
/*
	Exec USP_ListaTicketGC 
*/
CREATE Procedure USP_ListaTicketGC
AS 
BEGIN

	Select 
		cab.TIENDA,
		cab.SERIE,
		cab.NUMERO,
		Convert(Varchar,cab.FECHA,103) As FECHA,
		cab.TIDE,
		cab.DIDE,
		cab.NOMCLI,
		cab.APEPAT,
		cab.APEMAT,
		cab.FORPAG,
		cab.TARJET,
		cab.NROTAR,
		det.CODACTI,
		Cast(det.CANT As Varchar) As CANT,
		Cast(det.MTOUNI As Varchar) As MTOUNI
	From TkActivC cab  with(Nolock)
		Inner Join TkActivD det  with(Nolock)
			On cab.TIENDA = det.TIENDA And cab.SERIE = det.SERIE And cab.NUMERO = det.NUMERO
	Where IsNull(estDBF,'') <> 'P'

END
GO