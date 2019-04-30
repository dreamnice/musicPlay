//
//  musicConrolView.h
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/3.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol musicControlViewDelegate <NSObject>

- (void)playClick;

- (void)nextSongClick;

- (void)lastSongClick;

- (void)playaStateChangeClick;

- (void)downloadSongClick;

- (void)songProgressClick;

- (void)songProgressChange:(float)value;

- (void)songProgressChangeEveryTime:(float)value;

@end

@interface musicControlView : UIView

@property (nonatomic, weak) id<musicControlViewDelegate> delegate;

/**
 设置歌曲进度条

 @param value 进度条值 (0 - 1)
 @param animated 是否有动画
 */
- (void)setSongProgressValue:(float)value animated:(BOOL)animated;

/**
 设置播放状态

 @param isplay 是否播放
 */
- (void)changePlayBtnPlay:(BOOL)isplay;

/**
 调整专辑封面

 @param url url
 */
- (void)setAlubmImageWithURL:(NSString *)url;

/**
 设置右边时间

 @param num 秒
 */
- (void)setRightLabelText:(NSInteger)num;

/**
 设置左边时间

 @param num 秒
 */
- (void)setLeftLabelText:(NSInteger)num;

/**
 设置播放状态图片

 @param type type
 */
- (void)changePlayTypeBtn:(playStateType)type;

/**
 设置是否下载

 @param isDownload down
 */
- (void)setDownLoadBtnState:(BOOL)isDownload;

@end

NS_ASSUME_NONNULL_END
