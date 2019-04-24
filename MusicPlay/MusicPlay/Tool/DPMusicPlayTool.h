//
//  DPMusicPlayTool.h
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/22.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DPMusicPlayTool : NSObject

//解析歌词
+ (void)encodQQLyric:(NSString *)lyric complete:(void (^)(NSArray *timeArray, NSArray *lyricArray, BOOL isRoll))completeBlock;

//解析歌手名+专辑名
+ (NSString *)getSingerAndAlbumTxt:(songData *)song;

@end

NS_ASSUME_NONNULL_END