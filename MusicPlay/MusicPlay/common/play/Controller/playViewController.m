//
//  playViewController.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/3/14.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "playViewController.h"
#import "musicControlView.h"
#import "musicInfoView.h"
#import "lyricModel.h"
#import "DPMusicDownLoadTool.h"
#import "DPLocalMusicObject.h"
#import "DPRealmOperation.h"

#import "MBProgressHUD+JJ.h"

@interface playViewController ()<musicControlViewDelegate, musicInfoViewDelegate>{
    NSString *basePlayURL;
}

@property (nonatomic, strong) songData *songData;

@property (nonatomic, strong) musicControlView *controlView;

@property (nonatomic, strong) musicInfoView *infoView;

@property (nonatomic, assign) BOOL isTabbar;

@end

@implementation playViewController

- (instancetype)initWithSongData:(songData *)song isFromTabbar:(BOOL)isTabbar{ 
    self = [super init];
    if(self){
        self.songData = song;
        lyricModel *lyric = nil;
        NSNumber *index = nil;
        //设置歌词
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setLyric:) name:DPMusicLyricChange object:lyric];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(songChange) name:DPMusicChange object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(songPlay) name:DPMusicPlay object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(songPause) name:DPMusicPause object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCurrentTime:) name:DPMusicPerSeconds object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lyricSearch:) name:DPMusicLyricSearch object:index];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remoteControlProgress:) name:DPMusicRemoteChange object:index];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(songTotalTimeChange) name:DPMusicTotalTimeChange object:nil];
        self.isTabbar = isTabbar;
        if(!isTabbar && [song.songid isEqualToString:[[playManager sharedPlay] songData].songid] && ![[playManager sharedPlay] songData].isLastSong ){
            self.isTabbar = YES;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInterface];
}

- (void)setInterface {
    self.view.backgroundColor = [UIColor blackColor];

    musicInfoView *infoView = [[musicInfoView alloc] initWithFrame:CGRectMake(0, keyWindowsafeAreaInsets.top, ScreenW, ScreenH - 180 - keyWindowsafeAreaInsets.top) isTabbar:self.isTabbar];
    infoView.backgroundColor = [UIColor blackColor];
    infoView.delegate = self;
    [self.view addSubview:infoView];
    self.infoView = infoView;
    
    musicControlView *controlView = [[musicControlView alloc] initWithFrame:CGRectMake(0, ScreenH - 180, ScreenW, 180)];
    controlView.backgroundColor = [UIColor blackColor];
    controlView.delegate = self;
    [self.view addSubview:controlView];
    self.controlView = controlView;
    
    playManager *manager = [playManager sharedPlay];
    if(self.isTabbar){
        if(!self.songData.isLastSong){
            [self.controlView setSongProgressValue:manager.currentTime/self.songData.interval animated:YES];
            [self.infoView loadTimeArray:self.songData.lyricObject.timeArray lyricArray:self.songData.lyricObject.lyricArray isRoll:self.songData.lyricObject.isRoll];
            [self.infoView setTabbrValue:manager.currentTime];
        }else{
            [self.infoView loadTimeArray:self.songData.lyricObject.timeArray lyricArray:self.songData.lyricObject.lyricArray isRoll:self.songData.lyricObject.isRoll];
        }
    }else{
        [manager playWithSong:self.songData];
    }
    [self.controlView setRightLabelText:self.songData.interval];
    [self.controlView changePlayTypeBtn:[[playManager sharedPlay] playState]];
    [self.infoView setSongName:self.songData.songname singerName:self.songData.singerArray[0].name];
    if(self.songData.albumImage){
        [self.infoView setAlbumImageWithImage:self.songData.albumImage];
    }else{
        NSString *imageStr = [NSString stringWithFormat:@"https://y.gtimg.cn/music/photo_new/T002R300x300M000%@.jpg",self.songData.albummid];
        [self.infoView setAlbumImageWithURL:imageStr];
    }
    if(manager.isPlay){
        [self.infoView setImageAnimation:YES];
        [self.controlView changePlayBtnPlay:YES];
    }else{
        [self.infoView setImageAnimation:NO];
        [self.controlView changePlayBtnPlay:NO];
    }
    if(self.songData.isDownload){
        [self.controlView setDownLoadBtnState:YES];
    }else{
        [self.controlView setDownLoadBtnState:NO];
    }
    if([[playManager sharedPlay] lastIsLyric]){
        [self.infoView changeLyricAndAlbumHidden];
    }
}

#pragma mark - musicInfoViewDelegate
- (void)closeBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)lyricBtnClick {
    [self.infoView removeTimeAndLyricArray];
    [self.infoView loadTimeArray:@[@"0"] lyricArray:@[@"正在搜索歌词...."] isRoll:NO];
    [[DPMusicHttpTool shareTool] getLyricWithSongData:self.songData complete:^(lyricModel * _Nonnull lyric) {
        playManager *manager = [playManager sharedPlay];
        [self.infoView removeTimeAndLyricArray];
        [self.infoView loadTimeArray:self.songData.lyricObject.timeArray lyricArray:self.songData.lyricObject.lyricArray isRoll:self.songData.lyricObject.isRoll];
        [self.infoView lyricTableViewScrollWithValue:manager.currentTime animated:NO];
    }];
}

#pragma mark - musicControlViewDelegate
- (void)closeClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)playClick {
    if([[playManager sharedPlay] isPlay]){
        [[playManager sharedPlay] myPause];
    }else{
        [[playManager sharedPlay] myPlay];
    }
}

- (void)nextSongClick {
    [[playManager sharedPlay] nextSong];
}

- (void)lastSongClick {
    [[playManager sharedPlay] lastSong];
}

- (void)playaStateChangeClick {
    [[playManager sharedPlay] changePlayState];
    [self.controlView changePlayTypeBtn:[[playManager sharedPlay] playState]];
}

- (void)downloadSongClick:(UIButton *)btn {
    [self downBtnClick:self.songData downLoadButon:btn];
}

- (void)songProgressClick {
    [[playManager sharedPlay] setIsChangeState:YES];
}

- (void)songProgressChange:(float)value {
    [[playManager sharedPlay] changeSongProgress:value];
    [self.controlView setLeftLabelText:self.songData.interval * value];
    [self adjustLyric:value];
}

- (void)songProgressChangeEveryTime:(float)value {
    [self.controlView setLeftLabelText:self.songData.interval * value];
}

- (void)downBtnClick:(songData *)data downLoadButon:(UIButton *)btn {
    btn.enabled = NO;
    if(data.isDownload){
        btn.enabled = YES;
        [self showAlertWihtMessage:@"歌曲已下载过"];
    }else{
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        __weak __typeof__(self) weakself = self;
        [[DPMusicDownLoadTool shareTool] AFDownLoadFileWithSongData:data addComplete:^(BOOL inDownloadQueue, BOOL downloadURLFailure) {
            if(!inDownloadQueue && !downloadURLFailure){
                [self showAlertWihtMessage:@"已加入下载队列"];
            }else if(inDownloadQueue){
                [self showAlertWihtMessage:@"歌曲正在下载"];
            }else{
                [self showAlertWihtMessage:@"获取下载地址失败"];
            }
            btn.enabled = YES;
        } progress:nil success:nil failure:nil];

    }
}

#pragma mark - 歌词设置
//歌词调整
- (void)adjustLyric:(float)value {
    NSInteger totalTime = self.songData.interval;
    float currentTime = totalTime * value;
    [self.infoView lyricTableViewScrollWithValue:currentTime animated:YES];
}

- (void)adjustLyricToCurrentTime:(float)currentTime {
    [self.infoView lyricTableViewScrollWithValue:currentTime animated:YES];
}

#pragma mark - 接受通知
//歌词初始化
- (void)setLyric:(NSNotification *)notification {
    lyricModel *lyric = notification.object;
    NSLog(@"测试");
    [self.infoView loadTimeArray:lyric.timeArray lyricArray:lyric.lyricArray isRoll:lyric.isRoll];
}

//歌曲切换
- (void)songChange {
    self.songData = [[playManager sharedPlay] songData];
    [self.infoView removeTimeAndLyricArray];
    [self.controlView setLeftLabelText:0];
    [self.controlView setRightLabelText:self.songData.interval];
    [self.infoView setSongName:self.songData.songname singerName:self.songData.singerArray[0].name];
    if(self.songData.isDownload){
        [self.controlView setDownLoadBtnState:YES];
    }else{
        [self.controlView setDownLoadBtnState:NO];
    }
    NSString *imageStr = [NSString stringWithFormat:@"https://y.gtimg.cn/music/photo_new/T002R300x300M000%@.jpg",self.songData.albummid];
    [self.infoView setAlbumImageWithURL:imageStr];
}

- (void)songTotalTimeChange {
    [self.controlView setRightLabelText:self.songData.interval];
}

//播放
- (void)songPlay {
    [self.infoView setImageAnimation:YES];
    [self.controlView changePlayBtnPlay:YES];
}

//暂停
- (void)songPause {
    [self.infoView setImageAnimation:NO];
    [self.controlView changePlayBtnPlay:NO];
}

//每秒返回
- (void)getCurrentTime:(NSNotification *)notification {
    NSNumber *time = [notification.userInfo objectForKey:@"time"];
    BOOL change = [[notification.userInfo objectForKey:@"isChange"] boolValue];
    NSInteger currentIntTime = [time integerValue];
    float currentTime = currentIntTime;
    NSInteger totalTime = self.songData.interval;
    if(!change){
        [self.controlView setSongProgressValue:currentTime/totalTime animated:YES];
        [self.controlView setLeftLabelText:currentIntTime];
    }
}

//歌词跳转
- (void)lyricSearch:(NSNotification *)notification {
    NSNumber *indexNum = notification.object;
    [self.infoView lyricTableViewScrollWithNum:[indexNum integerValue] animated:YES];
}

//远程控制
- (void)remoteControlProgress:(NSNotification *)notification {
    NSNumber *num = notification.object;
    double currentTime = [num doubleValue];
    [self adjustLyricToCurrentTime:currentTime];
}

- (void)showAlertWihtMessage:(NSString *)message {
    [MBProgressHUD showMessage:message];
}

//设置状态栏为白色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - 懒加载
- (void)dealloc {
    NSLog(@"播放界面销毁了");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
