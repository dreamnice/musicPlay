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
+ (void)encodQQLyric:(NSString *)lyric complete:(void (^)(NSArray *timeArray, NSArray *lyricArray, NSString *baseLyric, BOOL isRoll))completeBlock ;

//解析歌手名+专辑名
+ (NSString *)getSingerAndAlbumTxt:(songData *)song;

//解析时间
+ (NSString *)encodeTimeWithNum:(NSInteger)num;

//存储上一次播放歌曲到本地
+ (void)saveLastSongData:(songData *)data;

//得到上一次播放歌曲
+ (songData *)getLastPlaySong;

@end

NS_ASSUME_NONNULL_END
