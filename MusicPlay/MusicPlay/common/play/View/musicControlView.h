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

- (void)pauseClick;

- (void)nextSongClick;

- (void)lastSongClick;

- (void)downloadSongClick;

- (void)songProgressClick;

- (void)songProgressChange:(float)value;

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
 调整专辑封面

 @param url url
 */
- (void)setAlubmImageWithURL:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
