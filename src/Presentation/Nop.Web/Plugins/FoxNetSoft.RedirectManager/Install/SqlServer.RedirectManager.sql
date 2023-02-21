IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id=object_id('[FNS_UrlRewriteRecord]'))
begin
	IF not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[FNS_UrlRewriteRecord]') AND name = N'IX_FNS_UrlRewriteRecord_RequestUrl')
	begin
		CREATE NONCLUSTERED INDEX IX_FNS_UrlRewriteRecord_RequestUrl ON FNS_UrlRewriteRecord ([RequestUrl],[StoreId]) 
	end
	IF not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[FNS_Url404Error]') AND name = N'IX_FNS_Url404Error_Url')
	begin
		CREATE NONCLUSTERED INDEX IX_FNS_Url404Error_Url ON FNS_Url404Error ([Url]) 
	end
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FNS_RedirectManager_GetUrlRewriteRecordsByRequestUrl]') AND type in (N'P', N'PC'))
DROP PROCEDURE [FNS_RedirectManager_GetUrlRewriteRecordsByRequestUrl]
GO
CREATE PROCEDURE [FNS_RedirectManager_GetUrlRewriteRecordsByRequestUrl]
(
	@requestUrl nvarchar(max),	--requestUrl
	@storeId	int, -- Store Id
	@fulllMatch bit  -- If look for the full match
)
AS
BEGIN
SET NOCOUNT ON
declare @id int
set @id=0 
if @fulllMatch=0
	select top 1 @id = F.Id
	from FNS_UrlRewriteRecord F WITH(NOLOCK) 
	where F.RequestUrl = @requestUrl and (F.StoreId=@storeId or F.StoreId=0) 
	order by F.StoreId desc
else
	select top 1 @id = F.Id
	from FNS_UrlRewriteRecord F WITH(NOLOCK) 
	where F.RequestUrl = @requestUrl and F.StoreId=@storeId
	order by F.StoreId desc

if @fulllMatch=0 and @id=0
begin
	if charindex('?', @requestUrl)>0
	begin
		declare @newRequestUrl nvarchar(max)
		set @newRequestUrl = substring(@requestUrl, 0, charindex('?', @requestUrl))
		if len(@newRequestUrl)>0 and right(@newRequestUrl,1)='/'
		begin
			set @newRequestUrl = substring(@newRequestUrl, 0, len(@newRequestUrl))
		end
		select top 1 @id = F.Id
		from FNS_UrlRewriteRecord F WITH(NOLOCK) 
		where F.RequestUrl = @newRequestUrl
			and (F.StoreId=@storeId or F.StoreId=0) 
		order by F.StoreId desc
	END
	/*
	if @id=0
	begin
		select top 1 @Id = F.Id 
		from FNS_UrlRewriteRecord F WITH(NOLOCK, INDEX(IX_FNS_UrlRewriteRecord_RequestUrl)) 
		where F.RequestUrl like '%*' 
			and @requestUrl like substring(F.RequestUrl, 0, charindex('*', F.RequestUrl))+'%'
			and (F.StoreId=@storeId or F.StoreId=0) 
		order by F.StoreId desc
	END*/
end

select * from FNS_UrlRewriteRecord F WITH(NOLOCK) where F.Id=@id
END
GO
