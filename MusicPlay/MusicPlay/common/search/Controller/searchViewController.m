//
//  searchViewController.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/3/13.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "searchViewController.h"
#import "songData.h"
#import "songTableViewCell.h"
#import "playViewController.h"

#import <AFNetworking.h>
#import <AVFoundation/AVFoundation.h>
@interface searchViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray <songData *>*songDataArray;

@end

@implementation searchViewController

- (id)initWithDataArray:(NSArray *)dataArray{
    self = [super init];
    if(self){
        self.songDataArray = [dataArray mutableCopy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, ScreenW, ScreenH - SafeAreaTopHeight) style:UITableViewStylePlain];
    tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    NSLog(@"%@", self.songDataArray);
    NSLog(@"%ld",self.songDataArray.count);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.songDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    songTableViewCell *cell = [songTableViewCell cellWithTableView:tableView];
    cell.songNameLabel.text = self.songDataArray[indexPath.row].songname;
    cell.singerAndAlbumLabel.text = [self getSingerAndAlbumTxt:self.songDataArray[indexPath.row]];
    return cell;
}

/*
 判断全是空格
 */
- (NSString *)getSingerAndAlbumTxt:(songData *)song{
    if(song.singerArray != nil && song.singerArray.count > 0){
        if(song.albumname == nil || [[song.albumname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0){
            return song.singerArray[0].name;
        }else{
            return [NSString stringWithFormat:@"%@·%@",song.singerArray[0].name,song.albumname];
        }
    }else{
        return @"";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    playViewController *vc = [[playViewController alloc] initWithSongData:self.songDataArray[indexPath.row]];
    [[playManager sharedPlay] getSongList:self.songDataArray currentIndex:indexPath.row];
    [self presentViewController:vc animated:YES completion:nil];
    
    /*
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = 10;
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    //错误2
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/javascript",@"application/json",@"text/json",@"text/plain",@"application/x-javascript",nil];

    NSString *songMid = self.songDataArray[indexPath.row].songmid;
    NSString *playTokenURL = [NSString stringWithFormat:@"https://c.y.qq.com/base/fcgi-bin/fcg_music_express_mobile3.fcg?format=json205361747&platform=yqq&cid=205361747&songmid=%@&filename=C400%@.m4a&guid=126548448",songMid,songMid];
    NSString *fileName = [NSString stringWithFormat:@"C400%@.m4a",songMid];
    [manager GET:playTokenURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *playString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",playString);
        NSError *err2;
        id dict2 = [NSJSONSerialization  JSONObjectWithData:[playString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&err2];
        NSString *playKey = dict2[@"data"][@"items"][0][@"vkey"];
        NSString *playkeyUrl = [NSString stringWithFormat:@"http://ws.stream.qqmusic.qq.com/%@?fromtag=0&guid=126548448&vkey=%@",fileName,playKey];
//        AVPlayer *pkayer = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:playkeyUrl]];
//        [pkayer play];
        [[playManager sharedPlay] playWithURL:playkeyUrl];
        [[playManager sharedPlay] myPlay];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    */
}

- (NSMutableArray *)songDataArray{
    if(!_songDataArray){
        _songDataArray = [NSMutableArray array];
    }
    return _songDataArray;
}

@end
