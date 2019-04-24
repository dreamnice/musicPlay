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
#import "DPRealmOperation.h"

#import <AFNetworking.h>
#import <AVFoundation/AVFoundation.h>
@interface searchViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray <songData *>*songDataArray;

@property (nonatomic, strong) UITableView *resultTableView;

@end

@implementation searchViewController

- (id)initWithLocalSong {
    self = [super init];
    if(self){
        RLMResults <DPLocalMusicObject *>*result = [[DPRealmOperation shareOperation] querySongData];
        NSLog(@"%ld",result.count);
        for(NSInteger i = 0; i < result.count; i++){
            DPLocalMusicObject *object = result[i];
            songData *data = [[songData alloc] initWithLocalMusicObject:object];
            [self.songDataArray addObject:data];
        }
    }
    return self;
}

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
   // cell.singerAndAlbumLabel.text = [self getSingerAndAlbumTxt:self.songDataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    playViewController *vc = [[playViewController alloc] initWithSongData:self.songDataArray[indexPath.row]];
    [[playManager sharedPlay] getSongList:self.songDataArray currentIndex:indexPath.row];
    [self presentViewController:vc animated:YES completion:nil];
}

- (NSMutableArray *)songDataArray{
    if(!_songDataArray){
        _songDataArray = [NSMutableArray array];
    }
    return _songDataArray;
}

@end
