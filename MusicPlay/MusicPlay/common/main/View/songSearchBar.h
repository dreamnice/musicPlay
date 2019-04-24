//
//  songSearchBar.h
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/24.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface songSearchBar : UISearchBar

- (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder tintColor:(UIColor *)tintColor showCancelButton:(BOOL)showCancelButton cancelTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
