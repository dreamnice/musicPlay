//
//  downloadSongModel.h
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/28.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DPResumeDataObject;

typedef NS_ENUM(NSInteger, downloadStateType) {
    DPDonloadPauseState = 0,
    DPDonloadRunningState,
    DPDonloadWillState,
    DPDonloadCompleteState
};

NS_ASSUME_NONNULL_BEGIN


@interface downloadProgress : NSObject

// 已下载的数量
@property (nonatomic, assign) int64_t totalBytesWritten;
// 文件的总大小
@property (nonatomic, assign) int64_t totalBytesExpectedToWrite;
// 已下载的数量
@property (nonatomic, copy) NSString *writtenFileSize;
// 文件的总大小
@property (nonatomic, copy) NSString *totalFileSize;
//下载进度
@property (nonatomic, assign) float progress;

@end


@interface downloadSongModel : NSObject

- (instancetype)initWithDPResumeDataObject:(DPResumeDataObject *)object;

@property NSString *URLHost;

@property NSData *resumeData;

@property songData *songObject;

@property (nonatomic, strong)  downloadProgress *progress;

@property (nonatomic, assign) downloadStateType downloadState;

@property (nonatomic, copy) DowningProgress progressBlock;

@property (nonatomic, copy) DowningComplete completeBlock;

@property (nonatomic, copy) DowningBeigin beiginBlock;

@property (nonatomic, copy) DeleteComplete deleteCompleteBlock;

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

@property (nonatomic, assign) BOOL isDeleteModel;

@end



NS_ASSUME_NONNULL_END
