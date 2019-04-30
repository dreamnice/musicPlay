//
//  tabbarView.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/25.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "tabbarView.h"

@interface tabbarView()

@property (nonatomic, strong) UILabel *songNameLabel;

@property (nonatomic, strong) UILabel *nextLabel;

@property (nonatomic, strong) UIImageView *albumImageView;

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
    UILabel *songNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 8, 200, 15)];
    self.songNameLabel = songNameLabel;
    [self addSubview:songNameLabel];
    songNameLabel.font = [UIFont systemFontOfSize:13];

    UILabel *nextLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 26, 200, 15)];
    nextLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:nextLabel];
    self.nextLabel = nextLabel;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 39, 39)];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:imageView.bounds.size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //设置大小
    maskLayer.frame = imageView.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    imageView.layer.mask = maskLayer;
    imageView.image = [UIImage imageNamed:@"cm2_default_cover_fm"];
    [self addSubview:imageView];
    self.albumImageView = imageView;
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.frame = CGRectMake(ScreenW - 49, 5, 39, 39);
    [playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    [playBtn addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [playBtn addTarget:self action:@selector(buttonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self addSubview:playBtn];
    self.playBtn = playBtn;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap)];
    [self addGestureRecognizer:gesture];
}

- (void)setSongName:(NSString *)songName {
    self.songNameLabel.text = songName;
}

- (void)setNextText:(NSString *)text {
    self.nextLabel.text = text;
}

- (void)setAlbumImageWithURL:(NSString *)url {
    [self.albumImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"cm2_default_cover_fm"]];
}

- (void)setAlbumImageAngle:(CGFloat)angle {
    self.albumImageView.transform = CGAffineTransformRotate(self.albumImageView.transform, angle);
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
    return self.nextLabel.text;
}
@end
