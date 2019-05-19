//
//  tabbarDiskView.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/5/1.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "tabbarDiskView.h"
#import <Masonry.h>

@interface tabbarDiskView()

@property (nonatomic, strong) UIImageView *albumView;

@property (nonatomic, strong) CADisplayLink *link;

@property (nonatomic, strong) UIImageView *diskView;

@end

@implementation tabbarDiskView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        [self setInterface];
    }
    return self;
}

- (void)setInterface {
    [self addSubview:self.diskView];
    [self.diskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.height.width.equalTo(self);
    }];
    
    [self.diskView addSubview:self.albumView];
    
    CGFloat height = 31;
    [self.albumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.diskView);
        make.width.height.mas_equalTo(height);
    }];
    self.albumView.layer.cornerRadius = height * 0.5;
    self.albumView.layer.masksToBounds = YES;
    self.albumView.image = [UIImage imageNamed:@"cm2_default_cover_fm"];
}

- (void)setImageWithURL:(NSString *)url {
    _imgUrl = url;
    if (url) {
        [self.albumView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"cm2_default_cover_fm"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            //恢复
            self.diskView.transform = CGAffineTransformIdentity;
        }];
    }else {
        self.albumView.image = [UIImage imageNamed:@"cm2_default_cover_fm"];
    }
}

- (void)setImageWithImage:(UIImage *)image; {
    self.albumView.image = image;
}

- (void)setImageAnimation:(BOOL)animation {
    [self.link setPaused:!animation];
}

- (void)rollImageView {
    self.diskView.transform = CGAffineTransformRotate(self.diskView.transform, M_PI_4 / 100.0f);
}

#pragma mark - 懒加载
- (UIImageView *)diskView {
    if(!_diskView){
        _diskView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cm2_play_disc-ip6"]];
        _diskView.contentMode = UIViewContentModeScaleAspectFit;
        _diskView.clipsToBounds = YES;
    }
    return _diskView;
}

- (UIImageView *)albumView {
    if(!_albumView){
        _albumView = [[UIImageView alloc] init];
        _albumView.backgroundColor = [UIColor blackColor];
    }
    return _albumView;
}

- (CADisplayLink *)link {
    if(!_link){
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(rollImageView)];
        [_link setPaused:YES];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return _link;
}

- (void)dealloc {
    [self.link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

@end
