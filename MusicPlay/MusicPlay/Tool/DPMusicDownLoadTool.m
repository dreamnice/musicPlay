
//
//  DPMusicDownLoadTool.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/23.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "DPMusicDownLoadTool.h"

@interface DPMusicDownLoadTool()

@property (nonatomic,strong) AFURLSessionManager *manager;

@property (nonatomic,assign) BOOL *firstOpen;

@end

@implementation DPMusicDownLoadTool

#pragma mark - 初始化
+ (id)shareTool {
    return [[self alloc] init];
}

static DPMusicDownLoadTool *instace = nil;
static dispatch_once_t token;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    dispatch_once(&token, ^{
        instace = [super allocWithZone:zone];
        if(instace){
            [instace setManager];
        }
    });
    return instace;
}

//销毁单例
+ (void)destroyInstance{
    token = 0;
    instace = nil;
}

- (void)setManager {
    RLMResults <DPResumeDataObject *>*result =  [[DPRealmOperation shareOperation] queryResumeSongData];
    for(NSInteger i = 0; i < result.count; i++){
        DPResumeDataObject *object = result[i];
        if(object.songObject.isDownload){
            [[DPRealmOperation shareOperation] deleteResumDataObjectWithURLHost:object.URLHost];
            continue;
        }
        downloadSongModel *model = [[downloadSongModel alloc] initWithDPResumeDataObject:object];
        model.downloadState = DPDonloadPauseState;
        //判断是否来自realam
        [self.downLoadModelDic setValue:model forKey:model.URLHost];
        [self.downLoadingModelArray addObject:model];
    }
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"DP.DPDownloadMusic"];
    configuration.timeoutIntervalForRequest = 10;
    configuration.sessionSendsLaunchEvents = YES;
    self.manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //注册任务完成通知
    NSURLSessionDownloadTask *task = nil;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(downLoadData:)
                                                 name:AFNetworkingTaskDidCompleteNotification
                                               object:task];
}

//根据song下载
- (void)AFDownLoadFileWithSongData:(songData *)data
                addComplete:(AddDonwLoadCompleteBlock)addComplete
                          progress:(DowningProgress)progress
                           success:(DonwLoadSuccessBlock)success
                           failure:(DownLoadfailBlock)failure {
    if(data.playURL == nil || [data.playURL isEqualToString:@""]){
        [[DPMusicHttpTool shareTool] getPlayURLWith:data success:^(NSString * _Nonnull playURL) {
            if(playURL != nil) {
                if(playURL != nil && !([[playURL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] == 0)){
                    data.playURL = playURL;
                    NSURLSessionDownloadTask *downloadTask  = [self AFDownLoadFileWithSongData:data playURL:playURL addSuccessProgress:addComplete progress:progress success:success failure:failure];
                    [downloadTask resume];
                }else{
                    addComplete(NO, YES);
                }
            }
        } failure:^(NSError * _Nonnull error) {
            addComplete(NO, YES);
        }];
    }else{
        NSURLSessionDownloadTask *downloadTask = [self AFDownLoadFileWithSongData:data  playURL:data.playURL addSuccessProgress:addComplete progress:progress success:success failure:failure];
        [[NSNotificationCenter defaultCenter] postNotificationName:DPMusicDownloadAddNew object:nil];
        [downloadTask resume];
    }
}

- (NSURLSessionDownloadTask *)AFDownLoadFileWithSongData:(songData *)data
                            playURL:(NSString *)url
                 addSuccessProgress:(AddDonwLoadCompleteBlock)addComplete
                           progress:(DowningProgress)progress
                            success:(DonwLoadSuccessBlock)success
                            failure:(DownLoadfailBlock)failure {
    downloadSongModel *object = [self.downLoadModelDic objectForKey:url];
    NSURLSessionDownloadTask *downloadTask = nil;
    if(object){
        addComplete(YES, NO);
    }else {
        addComplete(NO, NO);
        DPResumeDataObject *resumObject = [[DPResumeDataObject alloc] initWithURLHost:url songData:data];
        [[DPRealmOperation shareOperation] addResumDataObject:resumObject];
        downloadSongModel *model = [[downloadSongModel alloc] initWithDPResumeDataObject:resumObject];
        [self.downLoadModelDic setValue:model forKey:model.URLHost];
        [self.downLoadingModelArray addObject:model];
        
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [cachesPath stringByAppendingString:[NSString stringWithFormat:@"/%@.m4a",data.songid]];
        NSString *URLHost = data.playURL;
        downloadTask = [self AFDownLoadWithURL:URLHost path:path songData:data model:model progress:progress success:success failure:failure];
        model.downloadTask = downloadTask;
    }
    return downloadTask;
}

- (void)AFResumeDoloadWithInteger:(NSInteger)index
                         progress:(DowningProgress)progress
                          success:(DonwLoadSuccessBlock)success
                          failure:(DownLoadfailBlock)failure {
    NSURLSessionDownloadTask *downloadTask = nil;
    if(index < self.downLoadingModelArray.count){
        downloadSongModel *model = self.downLoadingModelArray[index];
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [cachesPath stringByAppendingString:[NSString stringWithFormat:@"/%@.m4a",model.songObject.songid]];
        if(model){
            NSLog(@"%ld",model.resumeData.length);
            if(model.resumeData.length > 0) {
                downloadTask = [self AFResumeDownLoadWithResumeData:model.resumeData path:path model:model progress:progress success:success failure:failure];
            }else{
                downloadTask = [self AFDownLoadWithURL:model.URLHost path:path songData:model.songObject model:model progress:progress success:success failure:failure];
            }
            model.downloadTask = downloadTask;
        }
    }
    [downloadTask resume];
}

- (NSURLSessionDownloadTask *)AFDownLoadWithURL:(NSString *)url
                                           path:(NSString *)path
                                       songData:(songData *)data
                                          model:(downloadSongModel *)model
                                       progress:(DowningProgress)progress
                                        success:(DonwLoadSuccessBlock)success
                                        failure:(DownLoadfailBlock)failure {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    model.downloadState = DPDonloadRunningState;
    if(model.beiginBlock){
        model.beiginBlock();
    }
    return [self.manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        model.progress.totalBytesWritten = downloadProgress.completedUnitCount;
        model.progress.totalBytesExpectedToWrite = downloadProgress.totalUnitCount;
        if(model.progressBlock){
            //主线程发通知
            dispatch_async(dispatch_get_main_queue(), ^{
                model.progressBlock(1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
            });
        }
        if (progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
            });
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if ([httpResponse statusCode] == 404){
            [[NSFileManager defaultManager] removeItemAtURL:filePath error:nil];
        }
        if (error) {
            model.downloadState = DPDonloadPauseState;
            if (failure) {
                failure(error, NO);
            }
        }else{
            if(filePath){
                data.localFileURL = [NSString stringWithFormat:@"/%@.m4a",data.songid];
                data.isDownload = YES;
                data.fileSize = [DPMusicPlayTool calculateFileSize:response.expectedContentLength];
                data.fileSizeNum = response.expectedContentLength;
                DPLocalMusicObject *object = [[DPLocalMusicObject alloc] initWithSongData:data localFileURL:[NSString stringWithFormat:@"/%@.m4a",data.songid]];
                [[DPRealmOperation shareOperation] addLocalMusicObject:object];
                if(success){
                    success(filePath,response);
                }
            }
        }
    }];
}

- (NSURLSessionDownloadTask *)AFResumeDownLoadWithResumeData:(NSData *)redumeData
                                                        path:(NSString *)path
                                                       model:(downloadSongModel *)model
                                                    progress:(DowningProgress)progress
                                                     success:(DonwLoadSuccessBlock)success
                                                     failure:(DownLoadfailBlock)failure {
    model.downloadState = DPDonloadRunningState;
    if(model.beiginBlock){
        model.beiginBlock();
    }
    return [self.manager downloadTaskWithResumeData:redumeData progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        if(model.progressBlock){
            model.progress.totalBytesWritten = downloadProgress.completedUnitCount;
            model.progress.totalBytesExpectedToWrite = downloadProgress.totalUnitCount;
            if(model.progressBlock){
                //主线程发通知
                dispatch_async(dispatch_get_main_queue(), ^{
                    model.progressBlock(1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
                });
            }
            //主线程发通知
            dispatch_async(dispatch_get_main_queue(), ^{
                model.progressBlock(1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
            });
        }
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if ([httpResponse statusCode] == 404) {
            [[NSFileManager defaultManager] removeItemAtURL:filePath error:nil];
        }
        if (error) {
            model.downloadState = DPDonloadPauseState;
            if(failure){
                failure(error,NO);
            }
        }else{
            if(filePath){
                model.songObject.localFileURL = [NSString stringWithFormat:@"/%@.m4a",model.songObject.songid];
                model.songObject.isDownload = YES;
                NSString *fileStr = [filePath absoluteString];
                fileStr = [fileStr substringFromIndex:7];
                long long fileSize = [DPMusicPlayTool getFileSizeAtPath:fileStr];
                if(fileSize == 0){
                    fileSize = response.expectedContentLength;
                }
                model.songObject.fileSize = [DPMusicPlayTool calculateFileSize:fileSize];
                model.songObject.fileSizeNum = fileSize;
                DPLocalMusicObject *object = [[DPLocalMusicObject alloc] initWithSongData:model.songObject localFileURL:[NSString stringWithFormat:@"/%@.m4a",model.songObject.songid]];
                [[DPRealmOperation shareOperation] addLocalMusicObject:object];
            }
            if (success) {
                success(filePath,response);
            }
        }
    }];
}

//任务完成操作
- (void)downLoadData:(NSNotification *)notification {
    if([notification.object isKindOfClass:[NSURLSessionDownloadTask class]]){
        NSLog(@"接收到了");
        NSURLSessionDownloadTask *task = notification.object;
        NSError *error  = [notification.userInfo objectForKey:AFNetworkingTaskDidCompleteErrorKey] ;
        NSString *URLHost = [task.currentRequest.URL absoluteString];
        downloadSongModel *model = [self.downLoadModelDic objectForKey:URLHost];
        if (error) {
            model.downloadState = DPDonloadPauseState;
            if (error.code == -1001) {
                NSLog(@"下载出错,看一下网络是否正常");
            }
            if(model.isDeleteModel){
                [self deleteHistoryWithKey:model.URLHost];
                [self.downLoadingModelArray removeObject:model];
                [self.downLoadModelDic removeObjectForKey:model.URLHost];
                if(model){
                    if(model.deleteCompleteBlock){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            model.deleteCompleteBlock();
                        });
                    }
                }
            }else{
                NSData *resumeData = [error.userInfo objectForKey:@"NSURLSessionDownloadTaskResumeData"];
                NSLog(@"接收%lld---期望接收%lld",task.countOfBytesReceived, task.countOfBytesExpectedToReceive);
                [self saveHistoryWithTask:task downloadModel:model downloadTaskResumeData:resumeData];
            }
        }else{
            [self deleteHistoryWithKey:URLHost];
            [self.downLoadingModelArray removeObject:model];
            [self.downLoadModelDic removeObjectForKey:URLHost];
            [[NSNotificationCenter defaultCenter] postNotificationName:DPMusicDownloadSuccess object:nil];
            model.downloadState = DPDonloadCompleteState;
        }
        if(model){
            if(model.completeBlock){
                //主线程发通知
                dispatch_async(dispatch_get_main_queue(), ^{
                    model.completeBlock(error);
                });
            }
        }
    }
}

- (void)cancelDownloadTaskWithModel:(downloadSongModel *)model {
    if(model.downloadState == DPDonloadRunningState){
        model.downloadState = DPDonloadPauseState;
        [model.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
    
        }];
    }
}

- (void)deleteDonwloadTaskWithModel:(downloadSongModel *)model {
    if(model){
        if(model.downloadState != DPDonloadCompleteState){
            if(model.downloadTask){
                model.isDeleteModel = YES;
                [model.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
                    
                }];
            }else{
                [self deleteHistoryWithKey:model.URLHost];
                [self.downLoadingModelArray removeObject:model];
                [self.downLoadModelDic removeObjectForKey:model.URLHost];
                if(model){
                    if(model.deleteCompleteBlock){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            model.deleteCompleteBlock();
                        });
                    }
                }
            }
        }
    }
}

- (void)cancelAllDownloadTask {
    if(self.manager.downloadTasks.count == 0) {
        return;
    }
    //当程序终结的时候,只会执行主线程中的代码,此时如果再通过获取线程向主线程添加任务的话,那么该任务就不会添加到主线程队列里去
    for(NSURLSessionDownloadTask *task in self.manager.downloadTasks){
        [task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            
        }];
    }

}

- (void)saveHistoryWithTask:(NSURLSessionDownloadTask *)task downloadModel:(downloadSongModel *)model downloadTaskResumeData:(NSData *)data {
    if(data){
        model.resumeData = [data copy];
    }else{
        model.resumeData = [NSData data];
    }
    model.progress.totalBytesExpectedToWrite = task.countOfBytesExpectedToReceive;
    model.progress.totalBytesWritten = task.countOfBytesReceived;
    DPResumeDataObject *object = [[DPResumeDataObject alloc] initWithdownloadSongMode:model];
    [[DPRealmOperation shareOperation] addResumDataObject:object];
    model.downloadTask = nil;
}

- (void)deleteHistoryWithKey:(NSString *)host {
    [[DPRealmOperation shareOperation] deleteResumDataObjectWithURLHost:host];
}

#pragma mark - 懒加载
- (NSMutableArray <downloadSongModel *>*)downLoadingModelArray {
    if(!_downLoadingModelArray) {
        _downLoadingModelArray = [NSMutableArray array];
    }
    return _downLoadingModelArray;
}

- (NSMutableDictionary *)downLoadModelDic {
    if(!_downLoadModelDic) {
        _downLoadModelDic = [NSMutableDictionary dictionary];
    }
    return _downLoadModelDic;
}

//- (NSMutableArray <DPResumeDataObject *>*)downLoadIngArray {
//    if(!_downLoadIngArray) {
//        _downLoadIngArray = [NSMutableArray array];
//    }
//    return _downLoadIngArray;
//}
//
//- (NSMutableDictionary *)downLoadDic {
//    if(!_downLoadDic) {
//        _downLoadDic = [NSMutableDictionary dictionary];
//    }
//    return _downLoadDic;
//}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end

