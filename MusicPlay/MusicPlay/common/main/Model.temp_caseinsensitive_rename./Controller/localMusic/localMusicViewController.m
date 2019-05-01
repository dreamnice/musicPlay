//
//  searchViewController.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/3/13.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "localMusicViewController.h"
#import "localSongTableViewCell.h"

#import "playViewController.h"
#import "DPRealmOperation.h"
#import "downloadingViewController.h"

@interface localMusicViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray <songData *>*songDataArray;

@property (nonatomic, strong) UITableView *resultTableView;

@end

@implementation localMusicViewController

- (id)initWithLocalSong {
    self = [super init];
    if(self){
        self.title = @"本地歌曲";
        //下载成功重新刷新界面
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadSuccess) name:DPMusicDownloadSuccess object:nil];
        RLMResults <DPLocalMusicObject *>*result = [[DPRealmOperation shareOperation] queryDownLoadSongData];
        NSLog(@"%ld",result.count);
        for(NSInteger i = 0; i < result.count; i++){
            DPLocalMusicObject *object = result[i];
            songData *data = [[songData alloc] initWithLocalMusicObject:object];
            [self.songDataArray addObject:data];
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
    return self.songDataArray.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    localSongTableViewCell *cell = nil;
    if(indexPath.row == 0){
        cell = [localSongTableViewCell cellWithTableView:tableView isFirstCell:YES];
    }else{
        cell = [localSongTableViewCell cellWithTableView:tableView isFirstCell:NO];
        cell.songNameLabel.text = self.songDataArray[indexPath.row - 1].songname;
        cell.singerAndAlbumLabel.text = [NSString stringWithFormat:@"%@ %@",self.songDataArray[indexPath.row - 1].fileSize ,[DPMusicPlayTool getSingerAndAlbumTxt:self.songDataArray[indexPath.row - 1]]];
    }
    return cell;
}

//删除操作
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //只要实现这个方法，就实现了默认滑动删除！！！！！
    if (editingStyle != UITableViewCellEditingStyleDelete){
        return;
    }
    [[DPRealmOperation shareOperation] deleteLocalMusicObjectWithSongid:self.songDataArray[indexPath.row - 1].songid];
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [cachesPath stringByAppendingString:self.songDataArray[indexPath.row - 1].localFileURL];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    self.songDataArray[indexPath.row - 1].isDownload = NO;
    self.songDataArray[indexPath.row - 1].localFileURL = nil;
    self.songDataArray[indexPath.row - 1].fileSizeNum = 0;
    self.songDataArray[indexPath.row - 1].fileSize = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:DPMusicDelete object:self.songDataArray[indexPath.row - 1].songid];
    [self.songDataArray removeObjectAtIndex:indexPath.row - 1];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

}
/*
   0x7ff2fe168320
 */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0){
        downloadingViewController *vc = [[downloadingViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        /*
         0x7ff2fe168320
         */
        songData *songData = self.songDataArray[indexPath.row - 1];
        playViewController *vc = [[playViewController alloc] initWithSongData:songData isFromTabbar:NO];
        [[playManager sharedPlay] getSongList:self.songDataArray currentIndex:indexPath.row - 1];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)backCick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)downloadSuccess {
    RLMResults <DPLocalMusicObject *>*result = [[DPRealmOperation shareOperation] queryDownLoadSongData];
    [self.songDataArray removeAllObjects];
    for(NSInteger i = 0; i < result.count; i++){
        DPLocalMusicObject *object = result[i];
        songData *data = [[songData alloc] initWithLocalMusicObject:object];
        [self.songDataArray addObject:data];
    }
    [self.resultTableView reloadData];
}

- (NSMutableArray *)songDataArray{
    if(!_songDataArray){
        _songDataArray = [NSMutableArray array];
    }
    return _songDataArray;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DPMusicDownloadSuccess object:nil];
}

@end
