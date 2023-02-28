CREATE OR ALTER PROCEDURE DeletePictures
	@ProductId int 
AS	
		Declare @PictureId int
		Declare cs SCROLL CURSOR For
		Select PictureId
			From Product_Picture_Mapping
				Where ProductId = 15308

		Open cs
		FETCH cs into @PictureId;
		While @@FETCH_STATUS = 0
			Begin
				FETCH NEXT FROM cs
					Into @PictureId
				Delete Product_Picture_Mapping
				where PictureId = @PictureId;
				Delete PictureBinary
				where PictureId = @PictureId;
				Delete Picture
				where Id = @PictureId;
			End;
		Close cs
		Deallocate cs