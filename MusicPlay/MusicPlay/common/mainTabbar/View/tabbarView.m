//
//  tabbarView.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/25.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "tabbarView.h"
#import "tabbarDiskView.h"
#import "tabbarLyricView.h"

#import <Masonry.h>
@interface tabbarView()

@property (nonatomic, strong) tabbarLyricView *lyricView;

@property (nonatomic, strong) tabbarDiskView *albumImageView;

@property (nonatomic, strong) UIButton *playBtn;

@end

@implementation tabbarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        [self setInterface];
    }
    return self;
}

- (void)setInterface {
    tabbarDiskView *albumImageView = [[tabbarDiskView alloc]init];
    [self addSubview:albumImageView];
    [albumImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.centerY.mas_equalTo(self);
        make.height.width.mas_equalTo(45);
    }];
    self.albumImageView = albumImageView;

    tabbarLyricView *lyricView = [[tabbarLyricView alloc] init];
    [self addSubview:lyricView];
    [lyricView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(albumImageView);
        make.left.mas_equalTo(albumImageView.mas_right).offset(8);
        make.right.mas_equalTo(self.mas_right).offset(-60);
        make.height.mas_equalTo(35);
    }];
    self.lyricView = lyricView;
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.frame = CGRectMake(ScreenW - 49, 5, 39, 39);
    [playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    [playBtn addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [playBtn addTarget:self action:@selector(buttonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self addSubview:playBtn];
    [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.centerY.mas_equalTo(self);
        make.width.height.mas_equalTo(40);
    }];
    self.playBtn = playBtn;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap)];
    [self addGestureRecognizer:gesture];
}

- (void)setSongName:(NSString *)songName {
    self.lyricView.songNameLabel.text = songName;
}

- (void)setNextText:(NSString *)text {
    self.lyricView.nextLabel.text = text;
}

- (void)setAlbumImageWithURL:(NSString *)url {
    [self.albumImageView setImageWithURL:url];
}

- (void)setAlbumImageAngle:(CGFloat)angle {
    self.albumImageView.transform = CGAffineTransformRotate(self.albumImageView.transform, angle);
}

- (void)setImageAnimation:(BOOL)animation {
    [self.albumImageView setImageAnimation:animation];
}

- (void)changePlayBtnPlay:(BOOL)isplay {
    if(isplay){
        [self.playBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }else{
        [self.playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
}

//播放按钮点击
- (void)playClick:(UIButton *)btn {
    btn.alpha = 1;
    if([self.delegate respondsToSelector:@selector(playBtnClick)]){
        [self.delegate playBtnClick];
    }
}

-(void)buttonTouchDown:(UIButton *)sender{
    sender.alpha = 0.56;
}

-(void)buttonTouchUpOutside:(UIButton *)sender{
    sender.alpha = 1;
}

- (void)viewTap {
    if([self.delegate respondsToSelector:@selector(viewTap)]){
        [self.delegate viewTap];
    }
}

- (NSString *)getNextText {
    return self.lyricView.nextLabel.text;
}
@end
