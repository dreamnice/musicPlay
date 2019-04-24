//
//  playTool.h
//  MusicPlay
//
//  Created by 朱力珅 on 2019/3/13.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "songData.h"
/*
 若前面不加static 会报duplicate symbols for architecture x86_64错误
 在.h或者pch文件使用 NSString * const 均会报错
 */
static NSString * const DPMusicPlay = @"music_play";
static NSString * const DPMusicPause = @"music_pause";
static NSString * const DPMusicChange = @"music_change";
static NSString * const DPMusicLyeicChange = @"musicLyric_change";
//用于OC转swift
NS_ASSUME_NONNULL_BEGIN

@protocol playManagerDelegate <NSObject>

- (void)getCurrentTime:(NSNumber *)time isChange:(BOOL)change;

- (void)changeSong:(songData *)song;

- (void)remoteControlProgress:(float)value;

@end

@interface playManager : NSObject

@property (nonatomic, readonly, strong) songData *songData;

@property (nonatomic, readonly, assign) BOOL isPlay;

@property (nonatomic, weak) id<playManagerDelegate> delegate;

/**
 创建单例

 @return self
 */
+ (id)sharedPlay;

/**
 销毁单例
 */
+ (void)destroyInstance;

/**
 设置URL

 @param url 歌曲URL
 */
- (void)playWithURL:(NSString *)url;

/**
 根据songData播放歌曲

 @param songData songData
 */
- (void)playWithSong:(songData *)songData;

/**
 开始播放
 */
- (void)myPlay;

/**
 暂停播放
 */
- (void)myPause;

/**
 下一首歌
 */
- (void)nextSong;

/**
 上一首歌
 */
- (void)lastSong;

/**
 添加歌曲列表
 
 @param listArray 歌曲数组
 */
- (void)getSongList:(NSArray <songData*> *)listArray currentIndex:(NSInteger)index;

/**
 更新歌曲列表

 @param listArray 歌曲数组
 */
- (void)addSongList:(NSArray <songData *>*)listArray;

/**
 调整歌曲进度

 @param value 0-1
 */
- (void)changeSongProgress:(float)value;

/**
 设置是否处于改变歌曲状态

 @param change bool
 */
- (void)setIsChangeState:(BOOL)change;

@end

NS_ASSUME_NONNULL_END
