//
//  musicConrolView.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/3.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "musicControlView.h"

#import <Masonry.h>

@interface musicControlView ()

@property (nonatomic, strong) UIImageView *alnumImageView;

@property (nonatomic, strong) UISlider *progresssSlider;

@property (nonatomic, strong) UIButton *playBtn;

@property (nonatomic, strong) UIButton *playTypeBtn;

@property (nonatomic, strong) UIButton *downLoadBtn;

@property (nonatomic, strong) UILabel *leftTimeLabel;

@property (nonatomic, strong) UILabel *rightTimeLabel;

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
    UISlider *progressSlider = [[UISlider alloc] init];
    progressSlider.minimumTrackTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    progressSlider.maximumTrackTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    [progressSlider setThumbImage:[UIImage imageNamed:@"cm2_fm_vol_btn"] forState:UIControlStateNormal];
    [progressSlider addTarget:self action:@selector(progressClick) forControlEvents:UIControlEventTouchDown];
    [progressSlider addTarget:self action:@selector(progressChange) forControlEvents:UIControlEventTouchUpInside];
    [progressSlider addTarget:self action:@selector(progressChange) forControlEvents:UIControlEventTouchUpOutside];
    [progressSlider addTarget:self action:@selector(progressChangeEveryTime) forControlEvents:UIControlEventValueChanged];
    [self addSubview:progressSlider];
    [progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.left.mas_equalTo(self.mas_left).offset(50);
        make.right.mas_equalTo(self.mas_right).offset(-50);
        make.height.mas_equalTo(20);
    }];
    self.progresssSlider = progressSlider;
    
    UILabel *leftTimeLabel = [[UILabel alloc] init];
    leftTimeLabel.font = [UIFont systemFontOfSize:10];
    leftTimeLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    leftTimeLabel.text = @"00:00";
    [self addSubview:leftTimeLabel];
    [leftTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(progressSlider.mas_left).offset(-8);
        make.centerY.equalTo(progressSlider);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(10);
    }];
    self.leftTimeLabel = leftTimeLabel;
    
    UILabel *rightTimeLabel = [[UILabel alloc] init];
    rightTimeLabel.font = [UIFont systemFontOfSize:10];
    rightTimeLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    rightTimeLabel.text = @"00:00";
    [self addSubview:rightTimeLabel];
    [rightTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(progressSlider.mas_right).offset(8);
        make.centerY.equalTo(progressSlider);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(10);
    }];
    self.rightTimeLabel = rightTimeLabel;
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setImage:[UIImage imageNamed:@"play_white"] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:playBtn];
    [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(self.mas_top).offset(50);
        make.width.height.mas_equalTo(80);
    }];
    self.playBtn = playBtn;
    
    UIButton *nextSongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextSongBtn setImage:[UIImage imageNamed:@"next_white"] forState:UIControlStateNormal];
    [nextSongBtn addTarget:self action:@selector(nextSongClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nextSongBtn];
    [nextSongBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(playBtn.mas_right).offset(20);
        make.centerY.equalTo(playBtn);
        make.height.width.mas_equalTo(45);
    }];
    
    UIButton *lastSongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lastSongBtn setImage:[UIImage imageNamed:@"last_white"] forState:UIControlStateNormal];
    [lastSongBtn addTarget:self action:@selector(lastSongClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:lastSongBtn];
    [lastSongBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(playBtn.mas_left).offset(-20);
        make.centerY.equalTo(playBtn);
        make.height.width.mas_equalTo(45);
    }];
    
    UIButton *playTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playTypeBtn setImage:[UIImage imageNamed:@"listCycle_white"] forState:UIControlStateNormal];
    [playTypeBtn addTarget:self action:@selector(playaStateChangeClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:playTypeBtn];
    [playTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(lastSongBtn);
        make.height.width.mas_equalTo(30);
    }];
    self.playTypeBtn = playTypeBtn;
    
    UIButton *downLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [downLoadBtn setImage:[UIImage imageNamed:@"download_white"] forState:UIControlStateNormal];
    [downLoadBtn addTarget:self action:@selector(downloadSongClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:downLoadBtn];
    [downLoadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(nextSongBtn);
        make.height.width.mas_equalTo(30);
    }];
    self.downLoadBtn = downLoadBtn;
}

- (void)playClick {
    if([self.delegate respondsToSelector:@selector(playClick)]) {
        [self.delegate playClick];
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

- (void)playaStateChangeClick {
    if([self.delegate respondsToSelector:@selector(playaStateChangeClick)]) {
        [self.delegate playaStateChangeClick];
    }
}

- (void)downloadSongClick {
    if([self.delegate respondsToSelector:@selector(downloadSongClick)]) {
        [self.delegate downloadSongClick];
    }
}

- (void)progressClick {
    if([self.delegate respondsToSelector:@selector(songProgressClick)]){
        [self.delegate songProgressClick];
    }
}

- (void)progressChange {
    if([self.delegate respondsToSelector:@selector(songProgressChange:)]){
        [self.delegate songProgressChange:self.progresssSlider.value];
    }
}

- (void)progressChangeEveryTime {
    if([self.delegate respondsToSelector:@selector(songProgressChangeEveryTime:)]){
        [self.delegate songProgressChangeEveryTime:self.progresssSlider.value];
    }
}

- (void)setSongProgressValue:(float)value animated:(BOOL)animated {
    [self.progresssSlider setValue:value animated:animated];
}

- (void)setRightLabelText:(NSInteger)num {
    self.rightTimeLabel.text = [DPMusicPlayTool encodeTimeWithNum:num];
}

- (void)setLeftLabelText:(NSInteger)num {
    self.leftTimeLabel.text = [DPMusicPlayTool encodeTimeWithNum:num];
}

- (void)changePlayBtnPlay:(BOOL)isplay {
    if(isplay){
        [self.playBtn setImage:[UIImage imageNamed:@"pause_white"] forState:UIControlStateNormal];
    }else{
        [self.playBtn setImage:[UIImage imageNamed:@"play_white"] forState:UIControlStateNormal];
    }
}

- (void)setAlubmImageWithURL:(NSString *)url {
    //对url编码
    NSString *encodeURL = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *imageURL = [NSURL URLWithString:encodeURL];
    [self.alnumImageView sd_setImageWithURL:imageURL];
}

- (void)changePlayTypeBtn:(playStateType)type {
    switch (type) {
        case playStateListCycleType:
            [self.playTypeBtn setImage:[UIImage imageNamed:@"listCycle_white"] forState:UIControlStateNormal];
            break;
            case playStateOneCycleType:
            [self.playTypeBtn setImage:[UIImage imageNamed:@"oneCycle_white"] forState:UIControlStateNormal];
            break;
            case playStateRandomType:
            [self.playTypeBtn setImage:[UIImage imageNamed:@"random_white"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (void)setDownLoadBtnState:(BOOL)isDownload {
    if(isDownload){
        [self.downLoadBtn setImage:[UIImage imageNamed:@"hasdownload_white"] forState:UIControlStateNormal];
    }else{
        [self.downLoadBtn setImage:[UIImage imageNamed:@"download_white"] forState:UIControlStateNormal];
    }
}

-(void)buttonTouchUpInside:(UIButton *)sender{
    sender.alpha = 1;
}

-(void)buttonTouchDown:(UIButton *)sender{
    sender.alpha = 0.56;
}

-(void)buttonTouchUpOutside:(UIButton *)sender{
    sender.alpha = 1;
}

@end
