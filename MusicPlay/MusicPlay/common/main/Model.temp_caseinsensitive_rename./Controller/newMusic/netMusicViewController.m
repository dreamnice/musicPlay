//
//  netMusicViewController.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/30.
//  Copyright © 2019 朱力珅. All rights reserved.
//


#import "netMusicViewController.h"
#import "songTableViewCell.h"

#import "playViewController.h"
#import "DPRealmOperation.h"
#import "downloadingViewController.h"

@interface netMusicViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray <songData *>*songDataArray;

@property (nonatomic, strong) UITableView *resultTableView;

@end

@implementation netMusicViewController
- (instancetype)initWithNetMusicType:(DPNetMusicType)musicType {
    self = [super init];
    if(self){
        //下载成功重新刷新界面
        __weak __typeof__(self) weakself = self;
        switch (musicType) {
                case DPTopMusicType:
            {
                self.title = @"热门歌曲";
                [[DPMusicHttpTool shareTool] getTopMusicSuccess:^(NSArray<songData *> * _Nonnull songDataArray, BOOL noData) {
                    weakself.songDataArray = [songDataArray mutableCopy];
                    [weakself.resultTableView reloadData];
                } failure:^(NSError * _Nonnull error) {
                    NSLog(@"%@",error);
                }];
            }
                break;
                case DPRandomMusicType:
            {
                self.title = @"推荐歌曲";
                [[DPMusicHttpTool shareTool] getRandomMusicSuccess:^(NSArray<songData *> * _Nonnull songDataArray, BOOL noData) {
                    weakself.songDataArray = [songDataArray mutableCopy];
                    [weakself.resultTableView reloadData];
                } failure:^(NSError * _Nonnull error) {
                    NSLog(@"%@",error);
                }];
            }
                break;
            default:
                break;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *leftbarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [btn1 setImage:[UIImage imageNamed:@"back"] forState:0];
    [btn1 addTarget:self action:@selector(backCick) forControlEvents:UIControlEventTouchUpInside];
    [leftbarView addSubview:btn1];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:leftbarView];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Navi_Height, ScreenW, SafeH) style:UITableViewStylePlain];
    tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    tableView.separatorStyle = UITableViewCellEditingStyleNone;
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.resultTableView = tableView;
    
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
    cell.singerAndAlbumLabel.text = [DPMusicPlayTool getSingerAndAlbumTxt:self.songDataArray[indexPath.row]];
    [cell setDownLoadimageView:self.songDataArray[indexPath.row].isDownload];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    playViewController *vc = [[playViewController alloc] initWithSongData:self.songDataArray[indexPath.row] isFromTabbar:NO];
    [[playManager sharedPlay] getSongList:self.songDataArray currentIndex:indexPath.row];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)backCick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)downloadSuccess {
    [self.resultTableView reloadData];
}

- (NSMutableArray<songData *> *)songDataArray{
    if(!_songDataArray){
        _songDataArray = [NSMutableArray array];
    }
    return _songDataArray;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DPMusicDownloadSuccess object:nil];
}

@end
