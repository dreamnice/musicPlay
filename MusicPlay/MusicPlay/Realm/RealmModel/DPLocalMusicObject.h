//
//  DPLocalMusicObject.h
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/23.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "RLMObject.h"
#import "DPLocalLyricObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface DPLocalMusicObject : RLMObject

- (instancetype)initWithSongData:(songData *)data localFileURL:(NSString *)url;

- (instancetype)initWithSongData:(songData *)data;

@property NSString *songmid;

@property NSString *songid;

@property NSString *songname;

@property NSString *albumname;

@property NSString *albummid;

@property NSInteger interval;

@property NSString *singer;

@property NSString *playURL;

@property NSString *localFileURL;

@property BOOL isDownload;

@property DPLocalLyricObject *lyricObject;

@property NSDate *uploadDate;

@end

NS_ASSUME_NONNULL_END
