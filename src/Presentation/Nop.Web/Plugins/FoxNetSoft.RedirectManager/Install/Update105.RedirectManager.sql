IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=object_id('[FNS_UrlRewriteRecord]') and NAME='Comment')
BEGIN
	ALTER TABLE [FNS_UrlRewriteRecord]
	ADD [Comment] nvarchar(100) NULL
END
GO
update [FNS_UrlRewriteRecord]
set RequestUrl = SUBSTRING(RequestUrl,1,len(RequestUrl)-1)
where len(RequestUrl)>0 and SUBSTRING(RequestUrl,len(RequestUrl),1)='/'
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=object_id('[FNS_Url404Error]') and NAME='Count')
BEGIN
	ALTER TABLE [FNS_Url404Error] ADD [Count] int NOT NULL CONSTRAINT DF_FNS_Url404Error_Count DEFAULT 1
END
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=object_id('[FNS_UrlRewriteRecord]') and NAME='PreserveQueryStrings')
BEGIN
	ALTER TABLE [FNS_UrlRewriteRecord]
	ADD [PreserveQueryStrings] bit NOT NULL CONSTRAINT DF_FNS_UrlRewriteRecord_PreserveQueryStrings DEFAULT 0
END
GO
