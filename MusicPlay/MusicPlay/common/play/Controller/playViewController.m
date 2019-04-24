//
//  playViewController.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/3/14.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "playViewController.h"
#import "musicControlView.h"
#import "lyricData.h"
#import "DPMusicDownLoadTool.h"
#import "DPLocalMusicObject.h"
#import "DPRealmOperation.h"

@interface playViewController ()<playManagerDelegate, musicControlViewDelegate, UITableViewDelegate, UITableViewDataSource>{
 
}

@property (nonatomic, strong) songData *songData;

@property (nonatomic, strong) musicControlView *controlView;

@property (nonatomic, strong) UITableView *lyricTableView;

@property (nonatomic, strong) NSMutableArray *lyricArray;

@property (nonatomic, strong) NSMutableArray *timeArray;

@property (nonatomic, assign) BOOL LyricRoll;

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

    musicControlView *controlView = [[musicControlView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    controlView.delegate = self;
    [self.view addSubview:controlView];
    self.controlView = controlView;
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.frame = CGRectMake(20, 100, 20, 20);
    closeBtn.backgroundColor = [UIColor redColor];
    [closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 450, ScreenW, ScreenH - 450) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellEditingStyleNone;
    [self.controlView addSubview:tableView];
    self.lyricTableView = tableView;
    
    playManager *myPlayManager = [playManager sharedPlay];
    myPlayManager.delegate = self;
    [myPlayManager playWithSong:self.songData];
    
    [self setLyric];
    [self setAlumImage];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lyricArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indentifier = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    cell.textLabel.text = self.lyricArray[indexPath.row];
    return cell;
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

- (void)nextSongClick {
    [[playManager sharedPlay] nextSong];
}

- (void)lastSongClick {
    [[playManager sharedPlay] lastSong];
}

- (void)downloadSongClick {
    [self downBtnClick:self.songData];
}

- (void)songProgressClick {
    [[playManager sharedPlay] setIsChangeState:YES];
}

- (void)songProgressChange:(float)value {
    [[playManager sharedPlay] changeSongProgress:value];
    [self adjustLyric:value];
}
/*/Users/dapao/Library/Developer/CoreSimulator/Devices/47587521-42E3-4D54-A663-B7910F6AA7F6/data/Containers/Data/Application/63490546-6A7C-47AE-B907-3EB5BC813805/Library/Caches/123.m4a*/
/*file:///Users/dapao/Library/Developer/CoreSimulator/Devices/47587521-42E3-4D54-A663-B7910F6AA7F6/data/Containers/Data/Application/63490546-6A7C-47AE-B907-3EB5BC813805/Library/Caches/123.m4a*/
- (void)downBtnClick:(songData *)data {
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [cachesPath stringByAppendingString:[NSString stringWithFormat:@"/%@.m4a",data.songid]];
    if(data.playURL){
        [[DPMusicDownLoadTool shareTool] AFDownLoadFileWithUrl:data.playURL progress:^(CGFloat progress) {
            NSLog(@"%f",progress);
        } fileLocalUrl:[NSURL fileURLWithPath:path] success:^(NSURL *fileURLPath, NSURLResponse *response) {
            if(fileURLPath) {
                NSString *localFlieStr = [[fileURLPath absoluteString] substringFromIndex:7];
                data.localFileURL = localFlieStr;
                DPLocalMusicObject *object = [[DPLocalMusicObject alloc] initWithSongData:data localFileURL:[NSString stringWithFormat:@"/%@.m4a",data.songid]];
                [[DPRealmOperation shareOperation] addLocalMusicObject:object];
            }
        } failure:^(NSError *error, NSInteger statusCode) {
            NSLog(@"%@",error);
        }];
    }else{
        
    }
}

#pragma mark - 歌词设置
//歌词初始化
- (void)setLyric {
    self.LyricRoll = NO;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = 10;
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    //错误2
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/javascript",@"application/json",@"text/json",@"text/plain",@"application/x-javascript",nil];
    [manager.requestSerializer setValue:@"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.110 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"https://y.qq.com/portal/player.html" forHTTPHeaderField:@"Referer"];
    [manager.requestSerializer setValue:@"zh-CN,zh;q=0.8" forHTTPHeaderField:@"Accept-Language"];
    [manager.requestSerializer setValue:@"pgv_pvid=8455821612; ts_uid=1596880404; pgv_pvi=9708980224; yq_index=0; pgv_si=s3191448576; pgv_info=ssid=s8059271672; ts_refer=ADTAGmyqq; yq_playdata=s; ts_last=y.qq.com/portal/player.html; yqq_stat=0; yq_playschange=0; player_exist=1; qqmusic_fromtag=66; yplayer_open=1" forHTTPHeaderField:@"Cookie"];
    [manager.requestSerializer setValue:@"c.y.qq.com" forHTTPHeaderField:@"Host"];
    NSString *lyricUrl = [NSString stringWithFormat:@"https://c.y.qq.com/lyric/fcgi-bin/fcg_query_lyric_new.fcg?callback=MusicJsonCallback_lrc&pcachetime=1494070301711&songmid=%@&g_tk=5381&jsonpCallback=MusicJsonCallback_lrc&loginUin=0&hostUin=0&format=jsonp&inCharset=utf8&outCharset=utf-8¬ice=0&platform=yqq&needNewCode=0",self.songData.songmid];
    //对url进行编码,防止中文
    NSString *utfUrl = [lyricUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    __weak __typeof__(self) weakself = self;
    [manager GET:utfUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        string = [string substringWithRange:NSMakeRange(22, string.length - 23)];
        id dict2 = [NSJSONSerialization  JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        [DPMusicPlayTool encodQQLyric:dict2[@"lyric"] complete:^(NSArray * _Nonnull timeArray, NSArray * _Nonnull lyricArray, BOOL isRoll) {
            weakself.timeArray = [timeArray mutableCopy];
            weakself.lyricArray = [lyricArray mutableCopy];
            weakself.LyricRoll = isRoll;
            [weakself.lyricTableView reloadData];
        }];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        weakself.LyricRoll = NO;
        NSString *lyricStr = @"未找到歌词";
        NSString *timeStr = @"0";
        [self.lyricArray addObject:lyricStr];
        [self.timeArray addObject:timeStr];
        NSLog(@"%@",error);
    }];
}

//歌词调整
- (void)adjustLyric:(float)value {
    if(self.LyricRoll){
        NSInteger totalTime = self.songData.interval;
        NSInteger currentTime = totalTime * value;
        for(NSInteger i = 0; i <= self.timeArray.count - 1; i++){
            if([self.timeArray[i] integerValue] > currentTime){
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i - 1 inSection:0];
                [self.lyricTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
                break;
            }
            if(i == self.timeArray.count - 1){
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.lyricTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            }
        }
    }
}

#pragma mark - 专辑图片设置
- (void)setAlumImage {
    NSString *imageStr = [NSString stringWithFormat:@"https://y.gtimg.cn/music/photo_new/T002R300x300M000%@.jpg",self.songData.albummid];
    [self.controlView setAlubmImageWithURL:imageStr];
}

#pragma mark - playManagerDelegate
- (void)getCurrentTime:(NSNumber *)time isChange:(BOOL)change{
    NSInteger currentIntTime = [time integerValue];
    float currentTime = currentIntTime;
    NSInteger totalTime = self.songData.interval;
    if(!change){
        [self.controlView setSongProgressValue:currentTime/totalTime animated:YES];
    }
    /*
     知识点,NSString知识点
     */
    NSString *str = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%ld",currentIntTime]];
    NSLog(@"%@",str);
    if(self.LyricRoll){
        NSUInteger index = [self.timeArray indexOfObject:str];
        if(index != NSNotFound){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [self.lyricTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }
    }
}

- (void)changeSong:(songData *)song {
    self.songData = song;
    [self setLyric];
    [self setAlumImage];
}

- (void)remoteControlProgress:(float)value {
    for(NSInteger i = 0; i <= self.timeArray.count - 1; i++){
        if([self.timeArray[i] integerValue] > value){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i - 1 inSection:0];
            [self.lyricTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            break;
        }
        if(i == self.timeArray.count - 1){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.lyricTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)lyricArray {
    if(!_lyricArray){
        _lyricArray = [NSMutableArray array];
    }
    return _lyricArray;
}

- (NSMutableArray *)timeArray {
    if(!_timeArray){
        _timeArray = [NSMutableArray array];
    }
    return _timeArray;
}

@end
