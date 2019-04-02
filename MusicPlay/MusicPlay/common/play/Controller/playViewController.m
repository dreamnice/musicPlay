//
//  playViewController.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/3/14.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "playViewController.h"

#import <AFNetworking.h>

@interface playViewController ()<playManagerDelegate>

@property (nonatomic, strong) songData *songData;

@property (nonatomic, strong) UISlider *progresssSlider;
@end

@implementation playViewController

- (instancetype)initWithSongData:(songData *)song {
    self = [super init];
    if(self){
        self.songData = song;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.frame = CGRectMake(20, 100, 20, 20);
    closeBtn.backgroundColor = [UIColor redColor];
    [closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    playBtn.frame = CGRectMake(20, 150, 50, 20);
    playBtn.backgroundColor = [UIColor redColor];
    [playBtn setTitle:@"播放" forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
    
    UIButton *pauseBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    pauseBtn.frame = CGRectMake(20, 200, 50, 20);
    [pauseBtn setTitle:@"暂停" forState:UIControlStateNormal];
    pauseBtn.backgroundColor = [UIColor redColor];
    [pauseBtn addTarget:self action:@selector(pauseClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pauseBtn];
    
    UISlider *progresssSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, 400, 300, 20)];
    [self.view addSubview:progresssSlider];
    self.progresssSlider = progresssSlider;
    
    playManager *myPlayManager = [playManager sharedPlay];
    myPlayManager.delegate = self;
    [myPlayManager playWithSong:self.songData];
}

- (void)closeClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)playClick {
    [[playManager sharedPlay] myPlay];
}

- (void)pauseClick {
    [[playManager sharedPlay] myPause];
}

- (void)getCurrentTime:(NSNumber *)time{
    NSLog(@"%@",time);
    float currentTime = [time floatValue];
    NSInteger totalTime = self.songData.interval;
    [self.progresssSlider setValue:currentTime/totalTime animated:YES];
}

@end
