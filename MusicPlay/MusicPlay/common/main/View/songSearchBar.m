//
//  songSearchBar.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/24.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "songSearchBar.h"

@implementation songSearchBar

- (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder tintColor:(UIColor *)tintColor showCancelButton:(BOOL)showCancelButton cancelTitle:(NSString *)title {
    self = [super initWithFrame:frame];
    if(self) {
        self.placeholder = placeholder;
        self.tintColor = tintColor;
        self.showsCancelButton = showCancelButton;
        [self setCancelTitle:title];
        self.tintColor = tintColor;
    }
    return self;
}

- (void)setCancelTitle:(NSString *)title {
    //笔记,设置UISearchBar文字
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitle:title];
}

@end
