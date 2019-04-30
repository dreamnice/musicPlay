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
//开始播放通知
static NSString * const DPMusicPlay = @"music_play";
//暂停通知
static NSString * const DPMusicPause = @"music_pause";
//歌曲切换通知
static NSString * const DPMusicChange = @"music_change";
//歌词切换通知
static NSString * const DPMusicLyricChange = @"musicLyric_change";
//每秒回调通知
static NSString * const DPMusicPerSeconds = @"music_perSeconds";
//找到歌词通知
static NSString * const DPMusicLyricSearch = @"musicLyeic_search";
//远程控制通知
static NSString * const DPMusicRemoteChange = @"musicRemote_change";
//总时间更改通知
static NSString * const DPMusicTotalTimeChange = @"musicTotalTime_change";

typedef NS_ENUM(NSInteger, playStateType) {
    playStateListCycleType = 0,
    playStateOneCycleType,
    playStateRandomType
};

//用于OC转swift
NS_ASSUME_NONNULL_BEGIN

@interface playManager : NSObject

@property (nonatomic, readonly, strong) songData *songData;

@property (nonatomic, readonly, assign) BOOL isPlay;

@property (nonatomic, readonly, assign) playStateType playState;
//当前播放时间
@property (nonatomic, assign) double currentTime;

@property (nonatomic, assign) BOOL lastIsLyric;
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
 tabbar 播放
 */
- (void)tabbarPlay;

/**
 tabbar 暂停
 */
- (void)tabbarPause;

/**
 下一首歌
 */
- (void)nextSong;

/**
 上一首歌
 */
- (void)lastSong;

/**
 改变播放状态
 */
- (void)changePlayState;

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
- (void)changeSongProgress:(double)value;

/**
 设置是否处于改变歌曲状态

 @param change bool
 */
- (void)setIsChangeState:(BOOL)change;

@end

NS_ASSUME_NONNULL_END
