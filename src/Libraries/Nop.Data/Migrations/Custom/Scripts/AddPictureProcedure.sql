CREATE OR ALTER PROCEDURE AddPicture
	@MimeType	nvarchar(max),
	@Name	nvarchar(max),
	@ProductId int,
	@BinaryData varbinary(max),
	@WebPicture nvarchar(max),
	@PictureId int OUTPUT
AS	
	DECLARE @SeoFilenameVar nvarchar(max) = REPLACE(LOWER(@Name),' ','-');
	INSERT INTO PICTURE(
						MimeType,
						SeoFilename,
						AltAttribute,
						TitleAttribute,
						IsNew,
						VirtualPath,
						WebPicture
						) VALUES (
							@MimeType,
							@SeoFilenameVar,
							@Name,
							@Name,
							'True',
							null,
							@WebPicture
						);

		SET @PictureId = SCOPE_IDENTITY();
		
		INSERT INTO Product_Picture_Mapping(ProductId, PictureId, DisplayOrder) VALUES (@ProductId, @PictureId, 0);

		INSERT INTO PictureBinary(PictureId, BinaryData) VALUES (@PictureId,@BinaryData);

		RETURN @PictureId;