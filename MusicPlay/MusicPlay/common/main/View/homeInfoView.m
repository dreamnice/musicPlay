//
//  homeInfoView.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/5/1.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "homeInfoView.h"
#import <Masonry.h>

@implementation homeInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        [self setUI];
    }
    return self;
}

- (void)setUI {
    UIButton *downClick = [UIButton buttonWithType:UIButtonTypeCustom];
    [downClick setBackgroundImage:[UIImage imageNamed:@"hasdownload"] forState:UIControlStateNormal];
    [downClick addTarget:self action:@selector(downBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [downClick addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [downClick addTarget:self action:@selector(buttonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self addSubview:downClick];
    [downClick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left).offset(40);
        make.width.height.mas_equalTo(40);
    }];
    
    UIButton *topClick = [UIButton buttonWithType:UIButtonTypeCustom];
    [topClick setBackgroundImage:[UIImage imageNamed:@"top"] forState:UIControlStateNormal];
    [topClick addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topClick addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [topClick addTarget:self action:@selector(buttonTouchUpOutside:)forControlEvents:UIControlEventTouchUpOutside];
    [self addSubview:topClick];
    [topClick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.centerX.equalTo(self);
        make.width.height.mas_equalTo(40);
    }];
    
    UIButton *random = [UIButton buttonWithType:UIButtonTypeCustom];
    [random setBackgroundImage:[UIImage imageNamed:@"suiji"] forState:UIControlStateNormal];
    [random addTarget:self action:@selector(randomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [random addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [random addTarget:self action:@selector(buttonTouchUpOutside:)forControlEvents:UIControlEventTouchUpOutside];
    [self addSubview:random];
    [random mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.right.mas_equalTo(self.mas_right).offset(-40);
        make.width.height.mas_equalTo(40);
    }];
}

- (void)downBtnClick:(UIButton *)sender {
    sender.alpha = 1;
    if([self.delegate respondsToSelector:@selector(downClick)]){
        [self.delegate downClick];
    }
}

- (void)topBtnClick:(UIButton *)sender {
    sender.alpha = 1;
    if([self.delegate respondsToSelector:@selector(topClick)]){
        [self.delegate topClick];
    }
}

- (void)randomBtnClick:(UIButton *)sender {
    sender.alpha = 1;
    if([self.delegate respondsToSelector:@selector(randomClick)]){
        [self.delegate randomClick];
    }
}

-(void)buttonTouchDown:(UIButton *)sender{
    sender.alpha = 0.56;
}

-(void)buttonTouchUpOutside:(UIButton *)sender{
    sender.alpha = 1;
}

@end
