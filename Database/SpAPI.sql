--liquibase formatted sql
--changeset cgomez:1 dbms:mssql runOnChange:true stripComments:false endDelimiter:GO
-- =======================================================
-- Drop Stored Procedure 
-- =======================================================

-- Drop stored procedure if it already exists
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[SpAPI]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[SpAPI]
GO
-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
--SET QUOTED_IDENTIFIER ON
--GO
-- =============================================
-- Author:	Ing. Cristian Gomez Taboada
-- Create date:	 
-- Description:			
-- =============================================
/*
exec	[SpAPI] 
	@OP		= 'SA'
	, @ModelId	= '1'
	, @JSON		= N'{"Codigo":"2","Nombre":"color 2"}'
*/
CREATE PROCEDURE [SpAPI]
	-- Add the parameters for the stored procedure here
	@Op		varchar (50)	= 'S'
	, @ModelId	numeric		= null
	, @JSON		varchar (max)	= null
	
WITH ENCRYPTION 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;	
	
	BEGIN TRY 
		DECLARE @SwCommit int
		
		SET @SwCommit=0
		
		IF @@TRANCOUNT = 0 
		BEGIN 
			BEGIN TRANSACTION 
			
			SET @SwCommit=1 
		END
		
		-- =============================================		
		-- Declaración y Asignación de Variables
		-- =============================================
		
		-- =============================================
		-- Validaciones
		-- =============================================
		
		-- =============================================
		-- Ejecución de acción
		-- =============================================
		if @ModelId = 1
		begin
			exec	SpAPI_Color	
				@Op	= @Op
				, @JSON = @JSON
		end
		-- =============================================
		
		IF @SwCommit=1 
		BEGIN 
			while @@TRANCOUNT > 0
			begin
				COMMIT TRANSACTION 
			END
		end
	END TRY
	BEGIN CATCH
		IF @SwCommit=1 
		BEGIN 
			while @@TRANCOUNT > 0
			begin
				ROLLBACK TRANSACTION 
			END
		end
		
		DECLARE @ds_error VARCHAR(500)
		
		--if error_number () = 2601
		--begin
		--	SET @ds_error= ''
		--end
		--else
		--begin
			SET @ds_error= error_message () + ', SpAPI'
		--end
		
		RAISERROR (@ds_error,16,1)
	END CATCH
END
GO

--SET QUOTED_IDENTIFIER OFF
--GO
