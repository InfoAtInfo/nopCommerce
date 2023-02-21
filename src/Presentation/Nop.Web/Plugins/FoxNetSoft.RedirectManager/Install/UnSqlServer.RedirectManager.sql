IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FNS_RedirectManager_GetUrlRewriteRecordsByRequestUrl]') AND type in (N'P', N'PC'))
DROP PROCEDURE [FNS_RedirectManager_GetUrlRewriteRecordsByRequestUrl]
GO
