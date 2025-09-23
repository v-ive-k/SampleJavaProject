2025/09/23 21:24:10 AzcopyVersion  10.30.1
2025/09/23 21:24:10 OS-Environment  windows
2025/09/23 21:24:10 OS-Architecture  amd64
2025/09/23 21:24:10 Log times are in UTC. Local time is 23 Sep 2025 16:24:10
2025/09/23 21:24:10 Job-Command copy COA1-DTS01_02.vhd https://ontmr8files01.blob.core.windows.net/backups/COA1-DTS01.vhd?se=2025-09-25t04%3A06%3A44z&sig=-REDACTED-&sp=racwdl&spr=https&sr=c&st=2025-09-23t19%3A51%3A44z&sv=2024-11-04 --blob-type PageBlob --log-level ERROR 
2025/09/23 21:41:47 ==> REQUEST/RESPONSE (Try=1/1.6328ms, OpTime=1.6328ms) -- REQUEST ERROR
   PUT https://ontmr8files01.blob.core.windows.net/backups/COA1-DTS01.vhd?comp=page&se=2025-09-25T04%3A06%3A44Z&sig=-REDACTED-&sp=racwdl&spr=https&sr=c&st=2025-09-23T19%3A51%3A44Z&sv=2024-11-04
   Accept: application/xml
   Content-Length: 4194304
   Content-Type: application/octet-stream
   User-Agent: AzCopy/10.30.1 azsdk-go-azblob/v1.6.2 (go1.24.6; Windows_NT)
   X-Ms-Client-Request-Id: f199a122-b3d1-4e7f-7100-68cedd5c97c3
   x-ms-page-write: update
   x-ms-range: bytes=57248055296-57252249599
   x-ms-version: 2025-05-05
   --------------------------------------------------------------------------------
   ERROR:
Put "https://ontmr8files01.blob.core.windows.net/backups/COA1-DTS01.vhd?comp=page&se=2025-09-25T04%3A06%3A44Z&sig=-REDACTED-&sp=racwdl&spr=https&sr=c&st=2025-09-23T19%3A51%3A44Z&sv=2024-11-04": dial tcp: lookup ontmr8files01.blob.core.windows.net: getaddrinfow: This is usually a temporary error during hostname resolution and means that the local server did not receive a response from an authoritative server.
goroutine 152 [running]:
github.com/Azure/azure-storage-azcopy/v10/ste.stack()
	D:/a/_work/1/s/ste/xferLogPolicy.go:100 +0x5e
github.com/Azure/azure-storage-azcopy/v10/ste.logPolicy.Do({{{0xb2d05e00, 0x0}, 0xc000123380, 0xc000123398}, 0xc00012d5f0, 0xc00012d620, 0xc00012d650}, 0xc001f10a40)
	D:/a/_work/1/s/ste/xferLogPolicy.go:232 +0xadd
github.com/Azure/azure-sdk-for-go/sdk/azcore/internal/exported.(*Request).Next(0xc001f10a00)
	C:/Users/cloudtest/go/pkg/mod/github.com/!azure/azure-sdk-for-go/sdk/azcore@v1.18.1/internal/exported/request.go:146 +0xf0
github.com/Azure/azure-storage-azcopy/v10/ste.(*retryNotificationPolicy).Do(0x0?, 0xc001f10a00)
	D:/a/_work/1/s/ste/xferRetryNotificationPolicy.go:64 +0x2a
github.com/Azure/azure-sdk-for-go/sdk/azcore/internal/exported.(*Request).Next(0xc0013c7110)
	C:/Users/cloudtest/go/pkg/mod/github.com/!azure/azure-sdk-for-go/sdk/azcore@v1.18.1/internal/exported/request.go:146 +0xf0
github.com/Azure/azure-sdk-for-go/sdk/azcore/runtime.(*retryPolicy).Do(0xc0013c74b0?, 0xc001f10980)
	C:/Users/cloudtest/go/pkg/mod/github.com/!azure/azure-sdk-for-go/sdk/azcore@v1.18.1/runtime/policy_retry.go:147 +0x67c
github.com/Azure/azure-sdk-for-go/sdk/azcore/internal/exported.(*Request).Next(0xc001f10940)
	C:/Users/cloudtest/go/pkg/mod/github.com/!azure/azure-sdk-for-go/sdk/azcore@v1.18.1/internal/exported/request.go:146 +0xf0
github.com/Azure/azure-storage-azcopy/v10/ste.(*fileUploadRangeFromURLFixPolicy).Do(0xc0013c7530?, 0xc001f10940)
	D:/a/_work/1/s/ste/sender-azureFileFromURL.go:118 +0x165
github.com/Azure/azure-sdk-for-go/sdk/azcore/internal/exported.(*Request).Next(0xc001f10900)
	C:/Users/cloudtest/go/pkg/mod/github.com/!azure/azure-sdk-for-go/sdk/azcore@v1.18.1/internal/exported/request.go:146 +0xf0
github.com/Azure/azure-storage-azcopy/v10/ste.(*versionPolicy).Do(0xc002ef4000?, 0xc001f10900)
	D:/a/_work/1/s/ste/xferVersionPolicy.go:49 +0x127
github.com/Azure/azure-sdk-for-go/sdk/azcore/internal/exported.(*Request).Next(0xc001f108c0)
	C:/Users/cloudtest/go/pkg/mod/github.com/!azure/azure-sdk-for-go/sdk/azcore@v1.18.1/internal/exported/request.go:146 +0xf0
github.com/Azure/azure-sdk-for-go/sdk/azcore/runtime.(*requestIDPolicy).Do(0xc0013c7678?, 0xc001f108c0)
	C:/Users/cloudtest/go/pkg/mod/github.com/!azure/azure-sdk-for-go/sdk/azcore@v1.18.1/runtime/policy_request_id.go:33 +0x145
github.com/Azure/azure-sdk-for-go/sdk/azcore/internal/exported.(*Request).Next(0xc001f10880)
	C:/Users/cloudtest/go/pkg/mod/github.com/!azure/azure-sdk-for-go/sdk/azcore@v1.18.1/internal/exported/request.go:146 +0xf0
github.com/Azure/azure-sdk-for-go/sdk/azcore/runtime.telemetryPolicy.Do({{0xc0002a4000?, 0x20c3b40?}}, 0xc001f10880)
	C:/Users/cloudtest/go/pkg/mod/github.com/!azure/azure-sdk-for-go/sdk/azcore@v1.18.1/runtime/policy_telemetry.go:70 +0x1b4
github.com/Azure/azure-sdk-for-go/sdk/azcore/internal/exported.(*Request).Next(0xc001f10840)
	C:/Users/cloudtest/go/pkg/mod/github.com/!azure/azure-sdk-for-go/sdk/azcore@v1.18.1/internal/exported/request.go:146 +0xf0
github.com/Azure/azure-sdk-for-go/sdk/azcore/runtime.includeResponsePolicy(0xc001f10840)
	C:/Users/cloudtest/go/pkg/mod/github.com/!azure/azure-sdk-for-go/sdk/azcore@v1.18.1/runtime/policy_include_response.go:19 +0x1c
github.com/Azure/azure-sdk-for-go/sdk/azcore/internal/exported.PolicyFunc.Do(0xd398db?, 0xd7e3eb?)
	C:/Users/cloudtest/go/pkg/mod/github.com/!azure/azure-sdk-for-go/sdk/azcore@v1.18.1/internal/exported/request.go:216 +0x19
github.com/Azure/azure-sdk-for-go/sdk/azcore/internal/exported.(*Request).Next(0xc001f107c0)
	C:/Users/cloudtest/go/pkg/mod/github.com/!azure/azure-sdk-for-go/sdk/azcore@v1.18.1/internal/exported/request.go:146 +0xf0
github.com/Azure/azure-sdk-for-go/sdk/azcore/internal/exported.Pipeline.Do({{0xc0001ae780?, 0x0?, 0x0?}}, 0x0?)
	C:/Users/cloudtest/go/pkg/mod/github.com/!azure/azure-sdk-for-go/sdk/azcore@v1.18.1/internal/exported/pipeline.go:76 +0x45
github.com/Azure/azure-sdk-for-go/sdk/storage/azblob/internal/generated.(*PageBlobClient).UploadPages(0xc000122780, {0x24ce7d0?, 0xc00292f260?}, 0x3286d00?, {0x24cc3a0?, 0xc00292f230?}, 0xd39c54?, 0xc0013c7aa8?, 0xd39c54?, 0x0, ...)
	C:/Users/cloudtest/go/pkg/mod/github.com/!azure/azure-sdk-for-go/sdk/storage/azblob@v1.6.2/internal/generated/zz_pageblob_client.go:956 +0xcb
github.com/Azure/azure-sdk-for-go/sdk/storage/azblob/pageblob.(*Client).UploadPages(0xc000122798, {0x24ce7d0, 0xc00292f260}, {0x24cc3a0, 0xc00292f230}, {0xc00266b410?, 0x1f6d800?}, 0xc0013c7ca8)
	C:/Users/cloudtest/go/pkg/mod/github.com/!azure/azure-sdk-for-go/sdk/storage/azblob@v1.6.2/pageblob/client.go:182 +0x313
github.com/Azure/azure-storage-azcopy/v10/ste.(*pageBlobUploader).GenerateUploadFunc.func1()
	D:/a/_work/1/s/ste/sender-pageBlobFromLocal.go:116 +0x6b0
github.com/Azure/azure-storage-azcopy/v10/ste.(*pageBlobUploader).GenerateUploadFunc.createSendToRemoteChunkFunc.createChunkFunc.func2(0x5f5e100?)
	D:/a/_work/1/s/ste/sender.go:207 +0x294
github.com/Azure/azure-storage-azcopy/v10/ste.(*jobMgr).chunkProcessor(0xc00039ec08, 0x17)
	D:/a/_work/1/s/ste/mgr-JobMgr.go:1055 +0xab
created by github.com/Azure/azure-storage-azcopy/v10/ste.(*jobMgr).poolSizer in goroutine 19
	D:/a/_work/1/s/ste/mgr-JobMgr.go:957 +0x236

2025/09/23 21:41:47 ERR: [P#0-T#0] UPLOADFAILED: \\?\Z:\Virtual Hard Disks\COA1-DTS01_02.vhd : 000 : Put "https://ontmr8files01.blob.core.windows.net/backups/COA1-DTS01.vhd?comp=page&se=2025-09-25T04%3A06%3A44Z&sig=-REDACTED-&sp=racwdl&spr=https&sr=c&st=2025-09-23T19%3A51%3A44Z&sv=2024-11-04": dial tcp: lookup ontmr8files01.blob.core.windows.net: getaddrinfow: This is usually a temporary error during hostname resolution and means that the local server did not receive a response from an authoritative server.. When Uploading page. X-Ms-Request-Id: 

   Dst: https://ontmr8files01.blob.core.windows.net/backups/COA1-DTS01.vhd
2025/09/23 21:41:47 ==> REQUEST/RESPONSE (Try=1/513.9µs, OpTime=513.9µs) -- REQUEST ERROR
   DELETE https://ontmr8files01.blob.core.windows.net/backups/COA1-DTS01.vhd?se=2025-09-25T04%3A06%3A44Z&sig=-REDACTED-&sp=racwdl&spr=https&sr=c&st=2025-09-23T19%3A51%3A44Z&sv=2024-11-04
   Accept: application/xml
   User-Agent: AzCopy/10.30.1 azsdk-go-azblob/v1.6.2 (go1.24.6; Windows_NT)
   X-Ms-Client-Request-Id: 91b20377-efab-4321-7768-13767e642bd4
   x-ms-version: 2025-05-05
   --------------------------------------------------------------------------------
   ERROR:
Delete "https://ontmr8files01.blob.core.windows.net/backups/COA1-DTS01.vhd?se=2025-09-25T04%3A06%3A44Z&sig=-REDACTED-&sp=racwdl&spr=https&sr=c&st=2025-09-23T19%3A51%3A44Z&sv=2024-11-04": dial tcp: lookup ontmr8files01.blob.core.windows.net: getaddrinfow: This is usually a temporary error during hostname resolution and means that the local server did not receive a response from an authoritative server.
goroutine 146 [running]:
github.com/Azure/azure-storage-azcopy/v10/ste.stack()
	D:/a/_work/1/s/ste/xferLogPolicy.go:100 +0x5e
github.com/Azure/azure-storage-azcopy/v10/ste.logPolicy.Do({{{0xb2d05e00, 0x0}, 0xc000123380, 0xc000123398}, 0xc00012d5f0, 0xc00012d620, 0xc00012d650}, 0xc001ea0400)
	D:/a/_work/1/s/ste/xferLogPolicy.go:232 +0xadd
github.com/Azure/azure-sdk-for-go/sdk/azcore/internal/exported.(*Request).Next(0xc001ea03c0)
	C:/Users/cloudtest/go/pkg/mod/github.com/!azure/azure-sdk-for-go/sdk/azcore@v1.18.1/internal/exported/request.go:146 +0xf0
github.com/Azure/azure-storage-azcopy/v10/ste.(*retryNotificationPolicy).Do(0x0?, 0xc001ea03c0)
	D:/a/_work/1/s/ste/xferRetryNotificationPolicy.go:64 +0x2a
github.com/Azure/azure-sdk-for-go/sdk/azcore/internal/exported.(*Request).Next(0xc0012d9230)
	C:/Users/cloudtest/go/pkg/mod/github.com/!azure/azure-sdk-for-go/sdk/azcore@v1.18.1/internal/exported/request.go:146 +0xf0
github.com/Azure/azure-sdk-for-go/sdk/azcore/runtime.(*retryPolicy).Do(0xc0012d95d0?, 0xc001ea0300)
	C:/Users/cloudtest/go/pkg/mod/github.com/!azure/azure-sdk-for-go/sdk/azcore@v1.18.1/runtime/policy_retry.go:147 +0x67c
github.com/Azure/azure-sdk-for-go/sdk/azcore/internal/exported.(*Request).Next(0xc001ea02c0)
	C:/Users/cloudtest/go/pkg/mod/github.com/!azure/azure-sdk-for-go/sdk/azcore@v1.18.1/internal/exported/request.go:146 +0xf0
github.com/Azure/azure-storage-azcopy/v10/ste.(*fileUploadRangeFromURLFixPolicy).Do(0xc0012d9650?, 0xc001ea02c0)
	D:/a/_work/1/s/ste/sender-azureFileFromURL.go:118 +0x165
github.com/Azure/azure-sdk-for-go/sdk/azcore/internal/exported.(*Request).Next(0xc001ea0280)
	C:/Users/cloudtest/go/pkg/mod/github.com/!azure/azure-sdk-for-go/sdk/azcore@v1.18.1/internal/exported/request.go:146 +0xf0
github.com/Azure/azure-storage-azcopy/v10/ste.(*versionPolicy).Do(0xc002df65b8?, 0xc001ea0280)
	D:/a/_work/1/s/ste/xferVersionPolicy.go:49 +0x127
github.com/Azure/azure-sdk-for-go/sdk/azcore/internal/exported.(*Request).Next(0xc001ea0240)
	C:/Users/cloudtest/go/pkg/mod/github.com/!azure/azure-sdk-for-go/sdk/azcore@v1.18.1/internal/exported/request.go:146 +0xf0
github.com/Azure/azure-sdk-for-go/sdk/azcore/runtime.(*requestIDPolicy).Do(0xc0012d9798?, 0xc001ea0240)
	C:/Users/cloudtest/go/pkg/mod/github.com/!azure/azure-sdk-for-go/sdk/azcore@v1.18.1/runtime/policy_request_id.go:33 +0x145
github.com/Azure/azure-sdk-for-go/sdk/azcore/internal/exported.(*Request).Next(0xc001ea0200)
	C:/Users/cloudtest/go/pkg/mod/github.com/!azure/azure-sdk-for-go/sdk/azcore@v1.18.1/internal/exported/request.go:146 +0xf0
github.com/Azure/azure-sdk-for-go/sdk/azcore/runtime.telemetryPolicy.Do({{0xc0002a4000?, 0x20c3b40?}}, 0xc001ea0200)
	C:/Users/cloudtest/go/pkg/mod/github.com/!azure/azure-sdk-for-go/sdk/azcore@v1.18.1/runtime/policy_telemetry.go:70 +0x1b4
github.com/Azure/azure-sdk-for-go/sdk/azcore/internal/exported.(*Request).Next(0xc001ea01c0)
	C:/Users/cloudtest/go/pkg/mod/github.com/!azure/azure-sdk-for-go/sdk/azcore@v1.18.1/internal/exported/request.go:146 +0xf0
github.com/Azure/azure-sdk-for-go/sdk/azcore/runtime.includeResponsePolicy(0xc001ea01c0)
	C:/Users/cloudtest/go/pkg/mod/github.com/!azure/azure-sdk-for-go/sdk/azcore@v1.18.1/runtime/policy_include_response.go:19 +0x1c
github.com/Azure/azure-sdk-for-go/sdk/azcore/internal/exported.PolicyFunc.Do(0x32c0560?, 0xc0037b8d30?)
	C:/Users/cloudtest/go/pkg/mod/github.com/!azure/azure-sdk-for-go/sdk/azcore@v1.18.1/internal/exported/request.go:216 +0x19
github.com/Azure/azure-sdk-for-go/sdk/azcore/internal/exported.(*Request).Next(0xc001ea0140)
	C:/Users/cloudtest/go/pkg/mod/github.com/!azure/azure-sdk-for-go/sdk/azcore@v1.18.1/internal/exported/request.go:146 +0xf0
github.com/Azure/azure-sdk-for-go/sdk/azcore/internal/exported.Pipeline.Do({{0xc0001ae780?, 0x24ce878?, 0xc001ce8f50?}}, 0x0?)
	C:/Users/cloudtest/go/pkg/mod/github.com/!azure/azure-sdk-for-go/sdk/azcore@v1.18.1/internal/exported/pipeline.go:76 +0x45
github.com/Azure/azure-sdk-for-go/sdk/storage/azblob/internal/generated.(*BlobClient).Delete(0xc000122768, {0x24ce878?, 0xc001ce8f50?}, 0xc22ce2ee77ab09a0?, 0xfd42ba4ba1?, 0xc0037b8d30?)
	C:/Users/cloudtest/go/pkg/mod/github.com/!azure/azure-sdk-for-go/sdk/storage/azblob@v1.6.2/internal/generated/zz_blob_client.go:737 +0x49
github.com/Azure/azure-sdk-for-go/sdk/storage/azblob/blob.(*Client).Delete(0xe55dcd?, {0x24ce878?, 0xc001ce8f50?}, 0x32be860?)
	C:/Users/cloudtest/go/pkg/mod/github.com/!azure/azure-sdk-for-go/sdk/storage/azblob@v1.6.2/blob/client.go:155 +0x85
github.com/Azure/azure-sdk-for-go/sdk/storage/azblob/pageblob.(*Client).Delete(0x24ce7d0?, {0x24ce878?, 0xc001ce8f50?}, 0x33076a0?)
	C:/Users/cloudtest/go/pkg/mod/github.com/!azure/azure-sdk-for-go/sdk/storage/azblob@v1.6.2/pageblob/client.go:332 +0x55
github.com/Azure/azure-storage-azcopy/v10/ste.(*pageBlobSenderBase).Cleanup(0xc0002a08f0)
	D:/a/_work/1/s/ste/sender-pageBlob.go:292 +0xd7
github.com/Azure/azure-storage-azcopy/v10/ste.epilogueWithCleanupSendToRemote({0x24e88e8, 0xc00020c770}, {0x24d4ad0, 0xc0002a08f0}, {0x24d15c0, 0xc0001226d8})
	D:/a/_work/1/s/ste/xfer-anyToRemote-file.go:592 +0x3c2
github.com/Azure/azure-storage-azcopy/v10/ste.anyToRemote_file.func1()
	D:/a/_work/1/s/ste/xfer-anyToRemote-file.go:375 +0x2b
github.com/Azure/azure-storage-azcopy/v10/ste.(*jobPartTransferMgr).runActionAfterLastChunk(...)
	D:/a/_work/1/s/ste/mgr-JobPartTransferMgr.go:665
github.com/Azure/azure-storage-azcopy/v10/ste.(*jobPartTransferMgr).ReportChunkDone(0xc00020c770, {{0xc000230060, 0x2b}, 0x1400000000, 0x200, 0xc002041ce4, 0xc002041ce8})
	D:/a/_work/1/s/ste/mgr-JobPartTransferMgr.go:651 +0x136
github.com/Azure/azure-storage-azcopy/v10/ste.scheduleSendChunks.createSendToRemoteChunkFunc.createChunkFunc.func2(0x5f5e100?)
	D:/a/_work/1/s/ste/sender.go:193 +0x390
github.com/Azure/azure-storage-azcopy/v10/ste.(*jobMgr).chunkProcessor(0xc00039ec08, 0x11)
	D:/a/_work/1/s/ste/mgr-JobMgr.go:1055 +0xab
created by github.com/Azure/azure-storage-azcopy/v10/ste.(*jobMgr).poolSizer in goroutine 19
	D:/a/_work/1/s/ste/mgr-JobMgr.go:957 +0x236

2025/09/23 21:41:47 ERR: [P#0-T#0] https://ontmr8files01.blob.core.windows.net/backups/COA1-DTS01.vhd?se=2025-09-25T04%3A06%3A44Z&sig=-REDACTED-&sp=racwdl&spr=https&sr=c&st=2025-09-23T19%3A51%3A44Z&sv=2024-11-04: 0: Delete (incomplete) Page Blob -Delete "https://ontmr8files01.blob.core.windows.net/backups/COA1-DTS01.vhd?se=2025-09-25T04%3A06%3A44Z&sig=-REDACTED-&sp=racwdl&spr=https&sr=c&st=2025-09-23T19%3A51%3A44Z&sv=2024-11-04": dial tcp: lookup ontmr8files01.blob.core.windows.net: getaddrinfow: This is usually a temporary error during hostname resolution and means that the local server did not receive a response from an authoritative server.. X-Ms-Request-Id:

2025/09/23 21:41:49 

Diagnostic stats:
IOPS: 12
End-to-end ms per request: 94
Network Errors: 0.01%
Server Busy: 0.00%


Job 84b4b100-d279-1c43-6bc2-5954b2209018 summary
Elapsed Time (Minutes): 17.648
Number of File Transfers: 1
Number of Folder Property Transfers: 0
Number of Symlink Transfers: 0
Total Number of Transfers: 1
Number of File Transfers Completed: 0
Number of Folder Transfers Completed: 0
Number of File Transfers Failed: 1
Number of Folder Transfers Failed: 0
Number of File Transfers Skipped: 0
Number of Folder Transfers Skipped: 0
Number of Symbolic Links Skipped: 0
Number of Hardlinks Converted: 0
Number of Special Files Skipped: 0
Total Number of Bytes Transferred: 0
Final Job Status: Failed

2025/09/23 21:41:49 Closing Log
