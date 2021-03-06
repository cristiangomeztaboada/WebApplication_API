--liquibase formatted sql
--changeset cgomez:1 dbms:mssql runOnChange:true stripComments:false endDelimiter:GO
-- =======================================================
-- Drop Stored Procedure 
-- =======================================================

-- Drop stored procedure if it already exists
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[SpAPI_Color]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[SpAPI_Color]
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
CREATE PROCEDURE [SpAPI_Color]
	-- Add the parameters for the stored procedure here
	@Op		varchar (50)	= 'S'
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
		declare	@TblColor table
		(
			Iden		numeric
			, Codigo	varchar (20)
			, Nombre	varchar (50)
		)
		-- =============================================
		-- Validaciones
		-- =============================================
		
		-- =============================================
		-- Ejecución de acción
		-- =============================================
		insert	@TblColor
		(
			Iden
			, Codigo
			, Nombre
		)
		select	*
		from	OPENJSON(@JSON)
		WITH 
		(   
			      Iden	numeric		'$.Iden',  
			      Codigo	VARCHAR(50)	'$.Codigo',  
			      Nombre	VARCHAR(500)	'$.Nombre'
		 )
		 -- =============================================
		 if	@Op in ('I', 'U')
		 begin
			delete	Color
			from	Color 
				join	@TblColor TblColor 
					on	Color.IDEN = TblColor.Iden

			delete	Color
			from	Color 
				join	@TblColor TblColor 
					on	Color.Codigo = TblColor.Codigo

			insert	Color
			(
				Codigo
				, Nombre
			)
			select	Codigo
				, Nombre
			from	@TblColor
		 end
		-- =============================================
		if	@Op in ('D')
		begin
			delete	Color
			from	Color 
				join	@TblColor TblColor 
					on	Color.IDEN = TblColor.Iden
		end
		-- =============================================
		if	@Op in ('S')
		begin
			select	Color.*
			from	Color 
				join	@TblColor TblColor 
					on	Color.Iden = TblColor.Iden
		end
		-- =============================================
		if	@Op in ('SA')
		begin
			select	Color.*
			from	Color 
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
			SET @ds_error= error_message () + ', SpAPI_Color'
		--end
		
		RAISERROR (@ds_error,16,1)
	END CATCH
END
GO

--SET QUOTED_IDENTIFIER OFF
--GO
