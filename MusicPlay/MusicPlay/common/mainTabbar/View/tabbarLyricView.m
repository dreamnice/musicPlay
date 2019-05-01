//
//  tabbarLyricView.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/5/1.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "tabbarLyricView.h"
#import <Masonry.h>

@implementation tabbarLyricView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        [self setInterface];
    }
    return self;
}

- (void)setInterface {
    UILabel *songNameLabel = [[UILabel alloc] init];
    songNameLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:songNameLabel];
    [songNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_centerY).offset(-2.5);
    }];
    self.songNameLabel = songNameLabel;
    
    UILabel *nextLabel = [[UILabel alloc] init];
    nextLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:nextLabel];
    [nextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_centerY).offset(-2.5);
    }];
    self.nextLabel = nextLabel;
}

@end
