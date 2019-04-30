//
//  mainTabbarController.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/25.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "mainTabbarController.h"
#import "playViewController.h"
#import "tabbarView.h"

@interface mainTabbarController()<tabbarViewDelegate>{
    NSString *lastLyric;
}

@property (nonatomic, strong) songData *data;

@property (nonatomic, strong) tabbarView *myTabbarView;

@property (nonatomic, strong) CADisplayLink *link;

@end

@implementation mainTabbarController

- (instancetype)initWithMainViewController:(UIViewController *)mainViewController {
    self = [super init];
    if(self){
        self.viewControllers = @[mainViewController];
        self.tabBar.translucent = NO;
        songData *data = nil;
        NSNumber *index = nil;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(songClick:) name:DPMusicClick object:data];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(songChange) name:DPMusicChange object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(songPlay) name:DPMusicPlay object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(songPause) name:DPMusicPause object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lyricSearch:) name:DPMusicLyricSearch object:index];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remoteControlProgress:) name:DPMusicRemoteChange object:index];
        [self setInterface];
    }
    return self;
}

- (void)setInterface {
    tabbarView *view = [[tabbarView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tabBar.frame), CGRectGetHeight(self.tabBar.frame))];
    view.delegate = self;
    [self.tabBar addSubview:view];
    self.myTabbarView = view;
    //获取上一首歌
    self.data = [[playManager sharedPlay] songData];
    if(self.data){
        [self.myTabbarView setAlbumImageWithURL:[NSString stringWithFormat:@"https://y.gtimg.cn/music/photo_new/T002R300x300M000%@.jpg",self.data.albummid]];
        [self.myTabbarView setSongName:self.data.songname];
        [self.myTabbarView setNextText:self.data.singerArray[0].name];
    }
}

#pragma mark - 接受通知
//列表点击跳转
- (void)songClick:(NSNotification *)notification {
    songData *data = notification.object;
    playViewController *playVC = [[playViewController alloc] initWithSongData:data isFromTabbar:NO];
    [self presentViewController:playVC animated:YES completion:nil];
}

//歌曲切换
- (void)songChange {
    self.data = [[playManager sharedPlay] songData];
    [self.myTabbarView setAlbumImageWithURL:[NSString stringWithFormat:@"https://y.gtimg.cn/music/photo_new/T002R300x300M000%@.jpg",self.data.albummid]];
    [self.myTabbarView setSongName:self.data.songname];
    [self.myTabbarView setNextText:self.data.singerArray[0].name];
    lastLyric = @"";
    if(self.link.isPaused){
        [self.link setPaused:NO];
    }
}

- (void)songPlay {
    if(lastLyric != nil && ![lastLyric isEqualToString:@""]){
        [self.myTabbarView setNextText:lastLyric];
    }
    [self.myTabbarView changePlayBtnPlay:YES];
    if(self.link.isPaused){
        [self.link setPaused:NO];
    }
}

- (void)songPause {
    lastLyric = [self.myTabbarView getNextText];
    [self.myTabbarView setNextText:self.data.singerArray[0].name];
    [self.myTabbarView changePlayBtnPlay:NO];
    if(!self.link.isPaused){
        [self.link setPaused:YES];
    }
}

- (void)lyricSearch:(NSNotification *)notification {
    NSNumber *indexNum = notification.object;
    NSInteger index = [indexNum integerValue];
    [self.myTabbarView setNextText:self.data.lyricObject.lyricArray[index]];
}

- (void)remoteControlProgress:(NSNotification *)notification {
    NSNumber *num = notification.object;
    NSString *lyricStr = [self lyricStrWithValue:[num integerValue]];
    [self.myTabbarView setNextText:lyricStr];
}

#pragma mark - tabbarViewDelegate
- (void)playBtnClick {
    if(self.data){
        if([[playManager sharedPlay] isPlay]){
            [[playManager sharedPlay] myPause];
        }else{
            [[playManager sharedPlay] myPlay];
        }
    }
}

- (void)viewTap {
    if(self.data){
        playViewController *vc = [[playViewController alloc] initWithSongData:self.data isFromTabbar:YES];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)rollImageView {
    CGFloat angle = self.link.duration * M_1_PI;
    [self.myTabbarView setAlbumImageAngle:angle];
}

- (CADisplayLink *)link {
    if(!_link){
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(rollImageView)];
        [_link setPaused:YES];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return _link;
}

- (NSString *)lyricStrWithValue:(float)value {
    if(self.data.lyricObject.isRoll){
        for(NSInteger i = 0; i <= self.data.lyricObject.timeArray.count - 1; i++){
            if([self.data.lyricObject.timeArray[i] integerValue] > value){
                if(i == 0){
                    return self.data.lyricObject.lyricArray[i];
                }else{
                    return self.data.lyricObject.lyricArray[i - 1];
                }
                break;
            }
            if(i == self.data.lyricObject.timeArray.count - 1){
                return self.data.lyricObject.lyricArray[i];
            }
        }
    }
    return self.data.singerArray[0].name;
}

- (void)dealloc {
    [self.link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}
@end
