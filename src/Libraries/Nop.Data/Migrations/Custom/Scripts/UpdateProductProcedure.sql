CREATE OR ALTER PROCEDURE UpdateProduct
	@Name	nvarchar(max),
	@Price	decimal,
	@Weight	decimal,
	@Length	decimal,
	@Width	decimal,
	@Height	decimal,
	@UpdatedOnUtc	datetime2,
	@CategoryId	int,
	@StockQuantity int,
	@ProductCode nvarchar(400),
	@ProductId int OUTPUT
AS
		Declare @Stock int, @NameChanged bit;
		Set @NameChanged = (SELECT NameChanged FROM Product WHERE ManufacturerPartNumber = @ProductCode );
		Set @Stock = (SELECT StockQuantity FROM Product WHERE ManufacturerPartNumber = @ProductCode );
		Set @ProductId = (SELECT Id FROM Product WHERE ManufacturerPartNumber = @ProductCode );

		IF @NameChanged != 1
		BEGIN
			UPDATE Product
			SET Name = @Name
			WHERE ManufacturerPartNumber = @ProductCode;
		END;

		UPDATE Product
		SET Price = @Price, Weight = @Weight, Length = @Length, Width = @Width, Height = @Height, 
					UpdatedOnUtc = @UpdatedOnUtc, StockQuantity = @StockQuantity, ManufacturerPartNumber = @ProductCode
		WHERE ManufacturerPartNumber = @ProductCode;

		UPDATE Product_Category_Mapping
		SET CategoryId = @CategoryId
		WHERE ProductId IN (SELECT Id FROM Product WHERE ManufacturerPartNumber = @ProductCode);

		IF @Stock != @StockQuantity
		BEGIN
			 INSERT INTO StockQuantityHistory(ProductId, CombinationId, WarehouseId, QuantityAdjustment, StockQuantity, Message, CreatedOnUtc)
							VALUES (@ProductId, null, null, @StockQuantity - @Stock, @StockQuantity, 'The stock quantity has been edited', @UpdatedOnUtc);
		END;
		RETURN @ProductId;