//
//  tabbarView.h
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/25.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol tabbarViewDelegate <NSObject>

- (void)playBtnClick;

- (void)viewTap;

@end


@interface tabbarView : UIView

@property(nonatomic, weak) id <tabbarViewDelegate> delegate;

- (void)setSongName:(NSString *)songName;

- (void)setNextText:(NSString *)text;

- (NSString *)getNextText;

- (void)setAlbumImageWithURL:(NSString *)url;

- (void)setAlbumImageAngle:(CGFloat)angle;

- (void)changePlayBtnPlay:(BOOL)isplay;

- (void)setImageAnimation:(BOOL)animation;

@end

NS_ASSUME_NONNULL_END
