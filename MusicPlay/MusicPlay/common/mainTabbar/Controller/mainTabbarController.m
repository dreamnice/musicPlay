//
//  mainTabbarController.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/25.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "mainTabbarController.h"
#import "tabbarView.h"

@implementation mainTabbarController

- (instancetype)initWithMainViewController:(UIViewController *)mainViewController {
    self = [super init];
    if(self){
        self.viewControllers = @[mainViewController];
        self.tabBar.translucent = NO;
        [self setInterface];
    }
    return self;
}

- (void)setInterface {
    tabbarView *view = [[tabbarView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tabBar.frame), CGRectGetHeight(self.tabBar.frame))];
    [self.tabBar addSubview:view];
}

@end
