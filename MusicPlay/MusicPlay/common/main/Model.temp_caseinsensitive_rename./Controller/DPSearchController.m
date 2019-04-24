//
//  DPSearchController.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/25.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "DPSearchController.h"

@interface DPSearchController ()

@end

@implementation DPSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.frame = CGRectMake(40, 40, 50, 50);
    setBtn.backgroundColor = [UIColor blackColor];
    [self.view addSubview:setBtn];
}



@end
