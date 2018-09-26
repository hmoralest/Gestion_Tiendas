If Exists(Select * from sysobjects Where name = 'USP_GTDA_Grabar_Modificar_Usuario' And type = 'P')
	Drop Procedure USP_GTDA_Grabar_Modificar_Usuario
GO

-- ====================================================================================================
-- Modificado por	: Henry Morales
-- Fch. Modifica	: 24/09/2018
-- Asunto			: Se creó para Grabar y Modificar Usuarios
-- ====================================================================================================
/*
	Exec USP_GTDA_Grabar_Modificar_Usuario '09993','ALM','','20180101','20181231','0012','Banco de la Nacion','123123123','1110','D:\Conglomerado de SP\QuitaEsp.txt' 
*/

CREATE PROCEDURE [dbo].[USP_GTDA_Grabar_Modificar_Usuario](
	@Id				Varchar(3),
	@nombres		Varchar(max),
	@apellid		Varchar(max),

	@login			Varchar(10),
	@contra			varchar(max),
	
	@usu_act		Varchar(max)
)
   
AS    
BEGIN

	BEGIN TRY
		BEGIN TRAN Grabar_Usuario

			IF (IsNull(@Id,'') = '' ) 
			BEGIN
				
				Select @Id = Right('000'+Cast(IsNull(max(Usu_Id),0)+1 AS varchar),3) From GTDA_Usuarios
			
				Insert Into GTDA_Usuarios (	Usu_Id, Usu_Nombres, Usu_Apellidos, Usu_Login, Usu_Contraseña, 
											Usu_UsuCre, Usu_FecCre, Usu_UsuMod, Usu_FecMod)
				Values (@Id, @nombres, @apellid, @login, dbo.USP_GTDA_Ingresa_Clave(@contra),
						@usu_act, GETDATE(), @usu_act, GETDATE())
			END
			ELSE
			BEGIN

				Update GTDA_Usuarios
				Set
					Usu_Nombres = @nombres,
					Usu_Apellidos = @apellid,
					Usu_Contraseña =  dbo.USP_GTDA_Ingresa_Clave(@contra)
				Where Usu_Id = @Id
				  And Usu_Login = @login

			END

		COMMIT TRAN Grabar_Usuario
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN Grabar_Usuario

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT; 		
				
		SET @ErrorMessage	= ERROR_MESSAGE();
		SET @ErrorSeverity	= ERROR_SEVERITY();
		SET @ErrorState		= ERROR_STATE(); 		

		RAISERROR (@ErrorMessage,	-- Message text.
           @ErrorSeverity,			-- Severity.
           @ErrorState);			-- State.
	END CATCH
END