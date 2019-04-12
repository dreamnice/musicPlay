//
//  ViewController.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/1/20.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "ViewController.h"
#import "searchViewController.h"
#import "songData.h"

#import <AFNetworking.h>
#import <AVFoundation/AVFoundation.h>
#import <MJExtension/MJExtension.h>

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>{
    BOOL isPlay;
    NSDictionary *lyricDic;
    NSMutableArray *lyricArray;
    NSMutableArray *timeArray;
}

@property (nonatomic, copy) NSString *musicName;

@property (nonatomic, strong)AVPlayer *myplayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(30, 120, 200, 30)];
    textField.placeholder = @"输入歌曲名字";
    [self.view addSubview:textField];
    UIButton *playClick = [UIButton buttonWithType:UIButtonTypeCustom];
    playClick.frame = CGRectMake(30, 160, 50, 50);
    playClick.backgroundColor = [UIColor blueColor];
    [self.view addSubview:playClick];
    [playClick addTarget:self action:@selector(musicPlayClick) forControlEvents:UIControlEventTouchUpInside];
    [textField addTarget:self action:@selector(textFieldsChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)musicPlayClick {
    NSString *baseURL = @"https://c.y.qq.com/soso/fcgi-bin/client_search_cp?aggr=1&cr=1&flag_qc=0&p=1&n=30&w=";
    if(self.musicName == nil || [self.musicName isEqualToString:@""]){
        NSLog(@"No MusicName");
        return;
    }
    //错误1
    NSString *URL = [baseURL stringByAppendingString:self.musicName];
    NSCharacterSet *encodeUrlSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *url2 = [URL stringByAddingPercentEncodingWithAllowedCharacters:encodeUrlSet];
    NSLog(@"%@",url2);
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = 10;
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    //错误2
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/javascript",@"application/json",@"text/json",@"text/plain",@"application/x-javascript",nil];
  //  application/x-javascript
    //错误3
    //要点: 进行数据解析。
    [manager GET:url2 parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSError *err;
//        string = [string stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
//        string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//        string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        string = [string substringWithRange:NSMakeRange(0, string.length - 1)];
        string = [string substringFromIndex:9];
        id dict = [NSJSONSerialization  JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&err];
        NSLog(@"%@",err);
      //  NSLog(@"获取到的数据为：%@",dict);
        NSArray *baseArray = dict[@"data"][@"song"][@"list"];
        NSMutableArray <songData *>*array = [NSMutableArray array];
        for(NSDictionary *dataDic in baseArray){
            songData *data = [songData mj_objectWithKeyValues:dataDic];
            [array addObject:data];
        }
        if(array){
            searchViewController *vc = [[searchViewController alloc] initWithDataArray:array];
            [self.navigationController pushViewController:vc animated:YES];
        }
        

//        NSString *playTokenURL = [NSString stringWithFormat:@"https://c.y.qq.com/base/fcgi-bin/fcg_music_express_mobile3.fcg?format=json205361747&platform=yqq&cid=205361747&songmid=%@&filename=C400%@.m4a&guid=126548448",songMid,songMid];
//        NSString *fileName = [NSString stringWithFormat:@"C400%@.m4a",songMid];
//        [manager GET:playTokenURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSString *playString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//            NSLog(@"%@",playString);
//            NSError *err2;
//            id dict2 = [NSJSONSerialization  JSONObjectWithData:[playString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&err2];
//            NSString *playKey = dict2[@"data"][@"items"][0][@"vkey"];
//            NSString *playkeyUrl = [NSString stringWithFormat:@"http://ws.stream.qqmusic.qq.com/%@?fromtag=0&guid=126548448&vkey=%@",fileName,playKey];
//            [[playManager sharedPlay] playWithURL:playkeyUrl];
//            [[playManager sharedPlay] myPlay];
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            NSLog(@"%@",err);
//        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
//江南
- (void)textFieldsChange:(UITextField *)textField {
    self.musicName = textField.text;
}

//第一次骑摩托的时候
@end
