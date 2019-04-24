//
//  resultViewController.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/24.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "resultViewController.h"
#import "playViewController.h"
#import "songTableViewCell.h"

#import <MJExtension/MJExtension.h>

@interface resultViewController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray<songData *> *songDataArray;

@property (nonatomic, strong) UITableView *resultTableView;

@end

@implementation resultViewController

- (instancetype)initWithSearchBar:(UISearchBar *)searchBar {
    self = [super init];
    if(self){
        searchBar.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - 88) style:UITableViewStylePlain];
    tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.resultTableView = tableView;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.view removeObserver:self forKeyPath:@"hidden"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.songDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    songTableViewCell *cell = [songTableViewCell cellWithTableView:tableView];
    cell.songNameLabel.text = self.songDataArray[indexPath.row].songname;
    cell.singerAndAlbumLabel.text = [DPMusicPlayTool getSingerAndAlbumTxt:self.songDataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[playManager sharedPlay] getSongList:self.songDataArray currentIndex:indexPath.row];
    if([self.delegate respondsToSelector:@selector(playSong:)]){
        [self.delegate playSong:self.songDataArray[indexPath.row]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"songClick" object:self.songDataArray[indexPath.row]];
}

#pragma mark - UISearchBarDelegate
- (void)searchClick:(NSNotification *)notification{
    
    NSString *serachStr = notification.userInfo[@"keyword"];
    NSString *baseURL = @"https://c.y.qq.com/soso/fcgi-bin/client_search_cp?aggr=1&cr=1&flag_qc=0&p=1&n=30&w=";
    if(serachStr == nil || [serachStr isEqualToString:@""]){
        NSLog(@"No MusicName");
        return;
    }
    //错误1
    NSString *URL = [baseURL stringByAppendingString:serachStr];
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
        for(NSDictionary *dataDic in baseArray){
            songData *data = [songData mj_objectWithKeyValues:dataDic];
            if(![data.songmid isEqualToString:@""] && data.songmid != nil){
                [self.songDataArray addObject:data];
            }
        }
        [self.resultTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"searchViewAppear" object:nil];
    [UIView animateWithDuration:0.1 animations:^{
        self.view.hidden = NO;
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    //KVC方法直接设置
    UIButton *cancelBtn = [searchBar valueForKey:@"cancelButton"]; //首先取出cancelBtn
    cancelBtn.enabled = YES; //把enabled设置为yes
    if([searchBar.text isEqualToString:@""]){
        return;
    }
    [self.songDataArray removeAllObjects];
    NSString *serachStr = searchBar.text;
    NSString *baseURL = @"https://c.y.qq.com/soso/fcgi-bin/client_search_cp?aggr=1&cr=1&flag_qc=0&p=1&n=30&w=";
    if(serachStr == nil || [serachStr isEqualToString:@""]){
        NSLog(@"No MusicName");
        return;
    }
    //错误1
    NSString *URL = [baseURL stringByAppendingString:serachStr];
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
        for(NSDictionary *dataDic in baseArray){
            songData *data = [songData mj_objectWithKeyValues:dataDic];
            if(![data.songmid isEqualToString:@""] && data.songmid != nil){
                [self.songDataArray addObject:data];
            }
        }
        [self.resultTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self.songDataArray removeAllObjects];
    [self.resultTableView reloadData];
    searchBar.text = @"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [UIView animateWithDuration:0.1 animations:^{
        self.view.hidden = YES;
    }];
}

- (NSMutableArray<songData *> *)songDataArray{
    if(!_songDataArray){
        _songDataArray = [NSMutableArray array];
    }
    return _songDataArray;
}
@end
