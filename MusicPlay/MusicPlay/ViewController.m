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
#import "DPMusicDownLoadTool.h"

#import <AFNetworking.h>
#import <AVFoundation/AVFoundation.h>
#import <MJExtension/MJExtension.h>

@interface ViewController (){
    BOOL isPlay;
}

@property (nonatomic, copy) NSString *musicName;

@property (nonatomic, strong)AVPlayer *myplayer;

@property (nonatomic, strong) AVPlayer *myPlayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(30, 120, 200, 30)];
    textField.placeholder = @"输入歌曲名字";
    [textField addTarget:self action:@selector(textFieldsChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:textField];
    
    
    UIButton *playClick = [UIButton buttonWithType:UIButtonTypeCustom];
    playClick.frame = CGRectMake(30, 160, 50, 50);
    playClick.backgroundColor = [UIColor blueColor];
    [playClick addTarget:self action:@selector(musicPlayClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playClick];
    
    UIButton *downClick = [UIButton buttonWithType:UIButtonTypeCustom];
    downClick.frame = CGRectMake(30, 300, 30, 30);
    [downClick setBackgroundImage:[UIImage imageNamed:@"downloaded"] forState:UIControlStateNormal];
    [downClick addTarget:self action:@selector(downBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downClick];
    
    
    UITableView *tableVew = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, ScreenW, ScreenH - SafeAreaTopHeight) style:UITableViewStylePlain];
    tableVew.backgroundColor = [UIColor redColor];
    [self.view addSubview:tableVew];
    
    searchViewController *vc = [[searchViewController alloc] initWithLocalSong];
    UISearchController *searcherController = [[UISearchController alloc] initWithSearchResultsController:vc];
    [searcherController.searchBar sizeToFit];
    searcherController.hidesNavigationBarDuringPresentation = NO;
    self.navigationItem.searchController = searcherController;
    self.navigationItem.hidesSearchBarWhenScrolling = NO;
    
    /*
    UIImageView *imageView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"register_bg.jpeg"]];
    imageView.frame =self.view.frame;
    [self.view addSubview:imageView];
    
    //iOS 8.0
    /*
    模糊效果的三种风格
     第三方
     LBBlurredImage
     
     @param UIBlurEffectStyle
    
     UIBlurEffectStyleExtraLight,  //高亮
     UIBlurEffectStyleLight,       //亮
     UIBlurEffectStyleDark         //暗

     
    UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView =[[UIVisualEffectView alloc]initWithEffect:blurEffect];
    effectView.frame = CGRectMake(imageView.frame.size.width/2,0,
                                  imageView.frame.size.width/2, imageView.frame.size.height);
    [self.view addSubview:effectView];
    */
    /*
    NSString *path = [[NSBundle mainBundle]pathForResource:@"image"ofType:@"jpg"];
    
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    self.view.layer.contents = (id)image.CGImage;
     */
 //   self.view.layer.contents = (id)[UIImage imageNamed:@"bg_1"].CGImage;
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//}

- (void)downBtnClick {
    searchViewController *vc = [[searchViewController alloc] initWithLocalSong];
    [self.navigationController pushViewController:vc animated:YES];
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
            if(![data.songmid isEqualToString:@""] && data.songmid != nil){
                [array addObject:data];
            }
        }
        if(array){
            searchViewController *vc = [[searchViewController alloc] initWithDataArray:array];
            [self.navigationController pushViewController:vc animated:YES];
        }
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
