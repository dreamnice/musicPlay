//
//  tabbarDiskView.h
//  MusicPlay
//
//  Created by 朱力珅 on 2019/5/1.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface tabbarDiskView : UIView

@property (nonatomic, copy)  NSString *imgUrl;

- (void)setImageWithURL:(NSString *)url;

- (void)setImageWithImage:(UIImage *)image;

- (void)setImageAnimation:(BOOL)animation;

@end

NS_ASSUME_NONNULL_END
