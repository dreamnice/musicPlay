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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newDownloadAdd) name:DPMusicDownloadAddNew object:nil];
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

- (void)viewWillAppear:(BOOL)animated {
    [self.downloadTableView reloadData];
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
    cell.deleteBtn.indexPath = indexPath;
    [cell.deleteBtn addTarget:self action:@selector(deleteCell:) forControlEvents:UIControlEventTouchUpInside];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    __weak __typeof__(self) weakself = self;
    __weak downloadSongCell *weakCell = cell;
    cell.model.completeBlock = ^(NSError *error) {
        if(!error){
            [weakself.downloadTableView reloadData];
        }else {
            [weakCell updataUI];
        }
    };
    cell.model.deleteCompleteBlock = ^{
        [weakself.downloadTableView reloadData];
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

- (void)deleteCell:(deleteButon *)button {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"确定删除下载" preferredStyle:UIAlertControllerStyleAlert];
    downloadSongModel *model = [[DPMusicDownLoadTool shareTool] downLoadingModelArray][button.indexPath.row];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[DPMusicDownLoadTool shareTool] deleteDonwloadTaskWithModel:model];
    }];
    UIAlertAction *cancelfAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:deleteAction];
    [alertController addAction:cancelfAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)backCick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)newDownloadAdd {

}

- (NSMutableArray <downloadSongModel *>*)downloadModelArray {
    if(!_downloadModelArray){
        _downloadModelArray = [[[DPMusicDownLoadTool shareTool] downloadModelArray] mutableCopy];
    }
    return _downloadModelArray;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DPMusicDownloadAddNew object:nil];
}

@end
