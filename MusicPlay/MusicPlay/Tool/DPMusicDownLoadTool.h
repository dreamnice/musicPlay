//
//  DPMusicDownLoadTool.h
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/23.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPRealmOperation.h"
#import "downloadSongModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DPMusicDownLoadTool : NSObject

@property (nonatomic, strong) NSMutableArray <downloadSongModel *>*downLoadingModelArray;

@property (nonatomic, strong) NSMutableDictionary *downLoadModelDic;

+ (id)shareTool;

- (NSURLSessionDownloadTask *)AFDownLoadFileWithUrl:(NSString*)URLHost
                                           progress:(DowningProgress)progress
                                       fileLocalUrl:(NSURL *)localURL
                                            success:(DonwLoadSuccessBlock)success
                                            failure:(DownLoadfailBlock)failure;

//根据songData下载
- (void)AFDownLoadFileWithSongData:(songData *)data
                       addComplete:(AddDonwLoadCompleteBlock)addComplete
                          progress:(DowningProgress)progress
                           success:(DonwLoadSuccessBlock)success
                           failure:(DownLoadfailBlock)failure;

//下载列表点击下载
- (void)AFResumeDoloadWithInteger:(NSInteger)index
                         progress:(DowningProgress)progress
                          success:(DonwLoadSuccessBlock)success
                          failure:(DownLoadfailBlock)failure;

- (void)cancelDownloadTaskWithModel:(downloadSongModel *)model;
- (void)cancelAllDownloadTask;

@end

NS_ASSUME_NONNULL_END
