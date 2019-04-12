//
//  musicConrolView.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/3.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "musicControlView.h"

@interface musicControlView ()

@property (nonatomic, strong) UISlider *progresssSlider;

@end

@implementation musicControlView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        [self setControl];
    }
    return self;
}

- (void)setControl {
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    playBtn.frame = CGRectMake(20, 150, 50, 20);
    playBtn.backgroundColor = [UIColor redColor];
    [playBtn setTitle:@"播放" forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:playBtn];
    
    UIButton *pauseBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    pauseBtn.frame = CGRectMake(20, 200, 50, 20);
    [pauseBtn setTitle:@"暂停" forState:UIControlStateNormal];
    pauseBtn.backgroundColor = [UIColor redColor];
    [pauseBtn addTarget:self action:@selector(pauseClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:pauseBtn];
    
    UIButton *nextSongBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    nextSongBtn.frame = CGRectMake(20, 250, 50, 20);
    [nextSongBtn setTitle:@"下一首歌" forState:UIControlStateNormal];
    nextSongBtn.backgroundColor = [UIColor redColor];
    [nextSongBtn addTarget:self action:@selector(nextSongClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nextSongBtn];
    
    UIButton *lastSongBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    lastSongBtn.frame = CGRectMake(20, 300, 50, 20);
    [lastSongBtn setTitle:@"上一首歌" forState:UIControlStateNormal];
    lastSongBtn.backgroundColor = [UIColor redColor];
    [lastSongBtn addTarget:self action:@selector(lastSongClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:lastSongBtn];
    
    
    UISlider *progresssSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, 400, 300, 20)];
    [self addSubview:progresssSlider];
    self.progresssSlider = progresssSlider;
}

- (void)playClick {
    if([self.delegate respondsToSelector:@selector(playClick)]) {
        [self.delegate playClick];
    }
}

- (void)pauseClick {
    if([self.delegate respondsToSelector:@selector(pauseClick)]) {
        [self.delegate pauseClick];
    }
}

- (void)nextSongClick {
    if([self.delegate respondsToSelector:@selector(nextSongClick)]) {
        [self.delegate nextSongClick];
    }
}

- (void)lastSongClick {
    if([self.delegate respondsToSelector:@selector(lastSongClick)]) {
        [self.delegate lastSongClick];
    }
}

- (void)setSongProgressValue:(float)value animated:(BOOL)animated {
    [self.progresssSlider setValue:value animated:animated];
}
@end
