//
//  downloadingViewController.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/28.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "downloadingViewController.h"
#import "downloadSongCell.h"
#import "DPMusicDownLoadTool.h"

@interface downloadingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *downloadTableView;

@property (nonatomic, strong) NSMutableArray <downloadSongModel *>* downloadModelArray;

@end

@implementation downloadingViewController

- (instancetype)init {
    self = [super init];
    if(self){

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"正在下载";
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
    self.downloadTableView = tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[DPMusicDownLoadTool shareTool] downLoadingModelArray].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    downloadSongCell *cell = [downloadSongCell cellWithTableView:tableView isFirstCell:NO];
    cell.model = [[DPMusicDownLoadTool shareTool] downLoadingModelArray][indexPath.row];
    __weak __typeof__(self) weakself = self;
    __weak downloadSongCell *weakCell = cell;
    cell.model.completeBlock = ^(NSError *error) {
        if(!error){
            [weakself.downloadTableView reloadData];
        }else {
            [weakCell updataUI];
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[DPMusicDownLoadTool shareTool] downLoadingModelArray][indexPath.row].downloadState == DPDonloadPauseState){
        [[DPMusicDownLoadTool shareTool] AFResumeDoloadWithInteger:indexPath.row progress:^(CGFloat progress) {
            
        } success:^(NSURL *fileURLPath, NSURLResponse *response) {
            
        } failure:^(NSError *error, BOOL inDownloadQueue) {
            
        }];
    }else if([[DPMusicDownLoadTool shareTool] downLoadingModelArray][indexPath.row].downloadState == DPDonloadRunningState){
        [[DPMusicDownLoadTool shareTool] cancelDownloadTaskWithModel:[[DPMusicDownLoadTool shareTool] downLoadingModelArray][indexPath.row]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)backCick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray <downloadSongModel *>*)downloadModelArray {
    if(!_downloadModelArray){
        _downloadModelArray = [[[DPMusicDownLoadTool shareTool] downloadModelArray] mutableCopy];
    }
    return _downloadModelArray;
}


@end
