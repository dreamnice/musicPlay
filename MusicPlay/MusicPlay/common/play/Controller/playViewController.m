//
//  playViewController.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/3/14.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "playViewController.h"
#import "musicControlView.h"

#import <AFNetworking.h>

@interface playViewController ()<playManagerDelegate, musicControlViewDelegate, UITableViewDelegate, UITableViewDataSource>{
    NSDictionary *lyricDic;
}

@property (nonatomic, strong) songData *songData;

@property (nonatomic, strong) musicControlView *controlView;

@property (nonatomic, strong) UITableView *lyricTableView;

@property (nonatomic, strong) NSMutableArray *lyricArray;

@property (nonatomic, strong) NSMutableArray *timeArray;

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
    
    playManager *myPlayManager = [playManager sharedPlay];
    myPlayManager.delegate = self;
    [myPlayManager playWithSong:self.songData];
    
    [self setLyric];
}

- (void)setLyric {
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
        [weakself encodQQLyric:dict2[@"lyric"]];
        [weakself.lyricTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 450, ScreenW, ScreenH - 450) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.controlView addSubview:tableView];
    self.lyricTableView = tableView;
}

- (NSDictionary *)encodQQLyric:(NSString *)lyric {
    [self.lyricArray removeAllObjects];
    [self.timeArray removeAllObjects];
    NSString *encodeLyric = [[NSString alloc] initWithData:[[NSData alloc] initWithBase64EncodedString:lyric options:0] encoding:NSUTF8StringEncoding];
    NSArray *array = [encodeLyric componentsSeparatedByString:@"\n"];
    NSMutableArray *array2 = [array mutableCopy];
    if(array2.count >= 5){
        [array2 removeObjectsInRange:NSMakeRange(0, 5)];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for(NSString *str in array2){
        NSString *lyricStr = [str substringFromIndex:10];
        if([lyricStr isEqualToString:@""]){
            continue;
        }
        NSLog(@"%@",lyricStr);
        NSString *timeStr = [str substringToIndex:10];
        NSLog(@"%@",timeStr);
        timeStr = [self timeToSecond:timeStr];
        [self.lyricArray addObject:lyricStr];
        [self.timeArray addObject:timeStr];
        [dic setObject:lyricStr forKey:timeStr];
    }
    return dic;
}

- (NSDictionary *)encodKuGouLyric:(NSString *)lyric {
    return nil;
}
- (NSString *)timeToSecond:(NSString *)timeStr {
    NSString *minStr = [timeStr substringWithRange:NSMakeRange(1, 2)];
    NSInteger min = [minStr integerValue];
    NSString *secStr = [timeStr substringWithRange:NSMakeRange(4, 2)];
    NSInteger sec = [secStr integerValue];
    NSLog(@"min == %ld, sec == %ld",min,sec);
    NSInteger totalSec = min * 60 + sec;
    NSString *secTimeStr = [NSString stringWithFormat:@"%ld",totalSec];
    return secTimeStr;
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

#pragma mark - playManagerDelegate
- (void)getCurrentTime:(NSNumber *)time {
    NSLog(@"%@",time);
    float currentTime = [time floatValue];
    NSInteger totalTime = self.songData.interval;
    [self.controlView setSongProgressValue:currentTime/totalTime animated:YES];
}

- (void)changeSong:(songData *)song {
    self.songData = song;
    [self setLyric];
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
