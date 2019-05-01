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
#import <MJRefresh/MJRefresh.h>
#import <MJRefresh.h>

@interface resultViewController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray<songData *> *songDataArray;

@property (nonatomic, strong) UITableView *resultTableView;

@property (nonatomic, assign) NSInteger pageCount;

@property (nonatomic, copy) NSString *keyWorld;

@end

@implementation resultViewController

- (instancetype)initWithSearchBar:(UISearchBar *)searchBar {
    self = [super init];
    if(self){
        searchBar.delegate = self;
        //下载成功重新刷新界面
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadSuccess) name:DPMusicDownloadSuccess object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInterface];
}

- (void)setInterface {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - Navi_Height - TabBar_Height) style:UITableViewStylePlain];
    tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    tableView.separatorStyle = UITableViewCellEditingStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.tableFooterView = [[UIView alloc] init];
    MJRefreshAutoNormalFooter *foot = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    foot.triggerAutomaticallyRefreshPercent = 0;
    [foot setTitle:@"点击加载更多" forState:MJRefreshStateIdle];
    [foot setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    [foot setTitle:@"" forState:MJRefreshStateNoMoreData];
    [foot setState:MJRefreshStateNoMoreData];
    foot.automaticallyRefresh = YES;
    foot.onlyRefreshPerDrag = YES;
    [tableView setMj_footer:foot];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.resultTableView = tableView;
}

- (void)getMoreData {
    __weak __typeof__(self) weakself = self;
    [[DPMusicHttpTool shareTool] searchMusicWithKeyWord:self.keyWorld pageCount:self.pageCount + 1 success:^(NSArray<songData *> * _Nonnull songDataArray, BOOL noData) {
        if(noData) {
            [weakself.resultTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            self.pageCount += 1;
            [weakself.songDataArray addObjectsFromArray:songDataArray];
            [weakself.resultTableView reloadData];
            [weakself.resultTableView.mj_footer endRefreshing];
        }
    } failure:^(NSError * _Nonnull error) {
        [weakself.resultTableView.mj_footer endRefreshing];
    }];
}

/*----------------Delegate-----------------*/
#pragma mark - UITableViewDelegate
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
    [cell setDownLoadimageView:self.songDataArray[indexPath.row].isDownload];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[playManager sharedPlay] getSongList:self.songDataArray currentIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:DPMusicClick object:self.songDataArray[indexPath.row]];
}

#pragma mark - UISearchBarDelegate
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
    if(serachStr == nil || [serachStr isEqualToString:@""]){
        NSLog(@"No MusicName");
        return;
    }
    __weak __typeof__(self) weakself = self;
    
    [[DPMusicHttpTool shareTool] searchMusicWithKeyWord:serachStr pageCount:1 success:^(NSArray<songData *> * _Nonnull songDataArray, BOOL noData) {
        if(!noData){
            self.keyWorld = serachStr;
            weakself.pageCount = 1;
            weakself.songDataArray = [songDataArray mutableCopy];
            [weakself.resultTableView reloadData];
            [weakself.resultTableView.mj_footer resetNoMoreData];
        }else{
            
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    [UIView animateWithDuration:0.1 animations:^{
        self.view.hidden = NO;
    }];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self.songDataArray removeAllObjects];
    [self.resultTableView.mj_footer setState:MJRefreshStateNoMoreData];
    [self.resultTableView reloadData];
    searchBar.text = @"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [UIView animateWithDuration:0.1 animations:^{
        self.view.hidden = YES;
    }];
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
