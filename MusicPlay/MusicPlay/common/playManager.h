//
//  playTool.h
//  MusicPlay
//
//  Created by 朱力珅 on 2019/3/13.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "songData.h"

//用于OC转swift
NS_ASSUME_NONNULL_BEGIN

@protocol playManagerDelegate <NSObject>

- (void)getCurrentTime:(NSNumber *)time;

- (void)changeSong:(songData *)song;

@end

@interface playManager : NSObject

@property (nonatomic, strong) songData *songData;

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

 @param song songData
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

@end

NS_ASSUME_NONNULL_END
