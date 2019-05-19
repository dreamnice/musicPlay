//
//  songData.h
//  MusicPlay
//
//  Created by 朱力珅 on 2019/3/17.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "singerData.h"
#import "lyricModel.h"



//防止死锁
@class DPLocalMusicObject;

NS_ASSUME_NONNULL_BEGIN

@interface songData : NSObject

- (instancetype)initWithLocalMusicObject:(DPLocalMusicObject *)object;
/**
 歌曲KEY
 */
@property (nonatomic, copy) NSString *songmid;

@property (nonatomic, copy) NSString *songid;

@property (nonatomic, copy) NSString *songname;

@property (nonatomic, copy) NSString *albumname;

@property (nonatomic, copy) NSString *albummid;

@property (nonatomic, assign) NSInteger interval;

@property (nonatomic, strong) NSMutableArray <singerData *>*singerArray;

@property (nonatomic, strong) NSMutableArray <songData *>*grpArray;

@property (nonatomic, copy) NSString *playURL;

@property (nonatomic, copy) NSString *localFileURL;

@property (nonatomic, copy) NSString *fileSize;

@property (nonatomic, strong) UIImage *albumImage;

@property (nonatomic, strong) lyricModel *lyricObject;

@property (nonatomic, assign) int64_t fileSizeNum;

@property (nonatomic, assign) BOOL isDownload;

@property (nonatomic, assign) BOOL cutPlay;

@property (nonatomic, assign) BOOL isLastSong;

@property (nonatomic, assign) BOOL isFromItunes;

@end

NS_ASSUME_NONNULL_END
