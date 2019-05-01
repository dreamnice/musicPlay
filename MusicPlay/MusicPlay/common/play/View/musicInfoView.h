//
//  musicInfoView.h
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/26.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol musicInfoViewDelegate <NSObject>

- (void)closeBtnClick;

- (void)lyricBtnClick;

@end

@interface musicInfoView : UIView

- (instancetype)initWithFrame:(CGRect)frame isTabbar:(BOOL)isTabbar;

@property (nonatomic, weak) id <musicInfoViewDelegate> delegate;

- (void)setSongName:(NSString *)songName singerName:(NSString *)singerName;

- (void)loadTimeArray:(NSArray *)timeArry lyricArray:(NSArray *)lyricArray isRoll:(BOOL)roll;

- (void)removeTimeAndLyricArray;

- (void)lyricTableViewScrollWithValue:(float)value animated:(BOOL)animated;

- (void)lyricTableViewScrollWithNum:(NSInteger)num animated:(BOOL)animated;

- (void)setTabbrValue:(float)value;

- (void)setAlbumImageWithURL:(NSString *)url;

- (void)setImageAnimation:(BOOL)animation;

- (void)changeLyricAndAlbumHidden;

@end

NS_ASSUME_NONNULL_END
