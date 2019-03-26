//
//  playTool.h
//  MusicPlay
//
//  Created by 朱力珅 on 2019/3/13.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import <Foundation/Foundation.h>

//用于OC转swift
NS_ASSUME_NONNULL_BEGIN

@interface playManager : NSObject

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
 开始播放
 */
- (void)myPlay;

/**
 暂停播放
 */
- (void)myPause;

@end

NS_ASSUME_NONNULL_END
