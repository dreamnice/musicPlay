//
//  DPResumeDataObject.h
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/23.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "RLMObject.h"
#import "DPLocalMusicObject.h"
#import "downloadSongModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DPResumeDataObject : RLMObject

- (instancetype)initWithURLHost:(NSString *)host songData:(songData *)songData;
- (instancetype)initWithdownloadSongMode:(downloadSongModel *)model;

@property NSString *URLHost;

@property NSData *resumeData;

@property DPLocalMusicObject *songObject;

@property NSDate *uploadDate;
// 已下载的数量
@property int64_t totalBytesWritten;
// 文件的总大小
@property int64_t totalBytesExpectedToWrite;

@end

NS_ASSUME_NONNULL_END
