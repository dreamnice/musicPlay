
//
//  DPMusicDownLoadTool.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/23.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "DPMusicDownLoadTool.h"
#import "DPRealmOperation.h"

@interface DPMusicDownLoadTool()

@property (nonatomic,strong) AFURLSessionManager *manager;

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
    self.manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    NSURLSessionDownloadTask *task;
    //注册任务完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(downLoadData:)
                                                 name:AFNetworkingTaskDidCompleteNotification
                                               object:task];
}

//启动下载
- (NSURLSessionDownloadTask *)AFDownLoadFileWithUrl:(NSString*)URLHost
                                           progress:(DowningProgress)progress
                                       fileLocalUrl:(NSURL *)localURL
                                            success:(DonwLoadSuccessBlock)success
                                            failure:(DownLoadfailBlock)failure {
    NSURLSessionDownloadTask   *downloadTask = nil;
    //从数据库拿出object 判断是否有断点续传
    NSLog(@"开始下载");
    DPResumeDataObject *object = [[DPRealmOperation shareOperation] queryWithURLHost:URLHost];
    if(object){
        NSLog(@"断点续传");
        downloadTask = [self.manager downloadTaskWithResumeData:object.resumeData progress:^(NSProgress * _Nonnull downloadProgress) {
            if(progress){
                progress(1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
            }
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return localURL;
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if ([httpResponse statusCode] == 404) {
                [[NSFileManager defaultManager] removeItemAtURL:filePath error:nil];
            }
            if (error) {
                if (failure) {
                    failure(error,[httpResponse statusCode]);
                }
            }else{
                if (success) {
                    success(filePath,response);
                }
            }
        }];
    }else{
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLHost]];
        downloadTask = [self.manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progress) {
                progress(1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
            }
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return localURL;
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if ([httpResponse statusCode] == 404){
                [[NSFileManager defaultManager] removeItemAtURL:filePath error:nil];
            }
            if (error) {
                if (failure) {
                    failure(error,[httpResponse statusCode]);
                }
            }else{
                if (success) {
                    success(filePath,response);
                }
            }
        }];
    }
    [downloadTask resume];
    return downloadTask;
}

//任务完成操作
- (void)downLoadData:(NSNotification *)notification {
    if([notification.object isKindOfClass:[NSURLSessionDownloadTask class]]){
        NSURLSessionDownloadTask *task = notification.object;
        NSString *URLHost = [task.currentRequest.URL absoluteString];
        NSError *error  = [notification.userInfo objectForKey:AFNetworkingTaskDidCompleteErrorKey] ;
        if (error) {
            if (error.code == -1001) {
                NSLog(@"下载出错,看一下网络是否正常");
            }
            NSData *resumeData = [error.userInfo objectForKey:@"NSURLSessionDownloadTaskResumeData"];
            [self saveHistoryWithKey:URLHost downloadTaskResumeData:resumeData];
        }else{
             [self deleteHistoryWithKey:URLHost];
        }
    }
}

- (void)saveHistoryWithKey:(NSString *)host downloadTaskResumeData:(NSData *)data {
    DPResumeDataObject *object;
    NSLog(@"%@",host);
    if(!data){
        NSData *emptyData = [NSData data];
        object = [[DPResumeDataObject alloc] initWithURLHost:host resumeData:emptyData];
    }else{
        object = [[DPResumeDataObject alloc] initWithURLHost:host resumeData:data];
    }
    [[DPRealmOperation shareOperation] addResumDataObject:object];
}

- (void)deleteHistoryWithKey:(NSString *)host {
    [[DPRealmOperation shareOperation] deleteResumDataObjectWithURLHost:host];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end

