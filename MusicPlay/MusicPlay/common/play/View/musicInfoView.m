//
//  musicInfoView.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/26.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "musicInfoView.h"
#import "lyricCell.h"
#import "diskView.h"

#import <Masonry.h>

@interface musicInfoView ()<UITableViewDelegate, UITableViewDataSource>{
    float tabbarValue;
}

@property (nonatomic, strong) UILabel *songNameLabel;

@property (nonatomic, strong) UILabel *singerLabel;

@property (nonatomic, strong) UITableView *lyricTableView;

@property (nonatomic, strong) UIButton *lyricBtn;

@property (nonatomic, strong) diskView *albumView;

@property (nonatomic, strong) NSMutableArray *lyricArray;

@property (nonatomic, strong) NSMutableArray *timeArray;

@property (nonatomic, strong) lyricCell *lastCell;

@property (nonatomic ,assign) BOOL LyricRoll;

@property (nonatomic ,assign) BOOL isScroll;

@property (nonatomic ,assign) BOOL isTabbar;

@property (nonatomic, assign) NSInteger currentRow;;



@end

@implementation musicInfoView

- (instancetype)initWithFrame:(CGRect)frame isTabbar:(BOOL)isTabbar{
    self = [super initWithFrame:frame];
    if(self){
        self.isTabbar = isTabbar;
        self.isScroll = isTabbar;
        for(NSInteger i = 0; i < 7; i++){
            [self.timeArray addObject:@""];
            [self.lyricArray addObject:@""];
        }
        [self setInterface];
    }
    return self;
}

- (void)setInterface {
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"close_white"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_top).offset(20);
        make.left.mas_equalTo(self.mas_left).offset(20);
        make.height.width.mas_equalTo(25);
    }];
    
    UIButton *lyricBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lyricBtn setImage:[UIImage imageNamed:@"geci_white"] forState:UIControlStateNormal];
    [lyricBtn addTarget:self action:@selector(lyricClick) forControlEvents:UIControlEventTouchUpInside];
    lyricBtn.hidden = YES;
    lyricBtn.alpha = 0;
    [self addSubview:lyricBtn];
    [lyricBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_top).offset(20);
        make.right.mas_equalTo(self.mas_right).offset(-20);
        make.height.width.mas_equalTo(25);
    }];
    self.lyricBtn = lyricBtn;
    
    UILabel *songNmaeLabel = [[UILabel alloc] init];
    songNmaeLabel.textAlignment = NSTextAlignmentCenter;
    songNmaeLabel.font = [UIFont systemFontOfSize:17];
    songNmaeLabel.textColor = [UIColor whiteColor];
    songNmaeLabel.text = @"一千年以后";
    [self addSubview:songNmaeLabel];
    [songNmaeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.centerX.equalTo(self);
        make.left.mas_equalTo(closeBtn.mas_right);
        make.height.mas_equalTo(20);
    }];
    self.songNameLabel = songNmaeLabel;
    
    UILabel *singerNmaeLabel = [[UILabel alloc] init];
    singerNmaeLabel.textAlignment = NSTextAlignmentCenter;
    singerNmaeLabel.font = [UIFont systemFontOfSize:12];
    singerNmaeLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    singerNmaeLabel.text = @"林俊杰";
    [self addSubview:singerNmaeLabel];
    [singerNmaeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(songNmaeLabel.mas_bottom);
        make.centerX.equalTo(self);
        make.left.mas_equalTo(closeBtn.mas_right);
        make.height.mas_equalTo(20);
    }];
    self.singerLabel = singerNmaeLabel;
    
    diskView *disk = [[diskView alloc] init];
    disk.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(diskViewTap)];
    [disk addGestureRecognizer:gesture];
    [self addSubview:disk];
    [disk mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(singerNmaeLabel.mas_bottom).offset(50);
        make.left.right.equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-50);
    }];
    self.albumView = disk;
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor blackColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.hidden = YES;
    tableView.alpha = 0;
    tableView.separatorStyle = UITableViewCellEditingStyleNone;
    tableView.allowsSelection = NO;
    tableView.rowHeight = 40;
    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTap)];
    [tableView addGestureRecognizer:gesture2];
    [self addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(singerNmaeLabel.mas_bottom).offset(50);
        make.left.right.equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-50);
    }];
    self.lyricTableView = tableView;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lyricArray.count;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    lyricCell *cell = [lyricCell cellWithTableView:tableView];
    if(self.currentRow == indexPath.row){
        if(self.lastCell){
            self.lastCell.lyricLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.45];;
        }
        cell.lyricLabel.textColor = [UIColor whiteColor];
        self.lastCell = cell;
    }else{
        cell.lyricLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.45];;
    }
    cell.lyricLabel.text = self.lyricArray[indexPath.row];
    return cell;
}

//tableView加载完成
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        dispatch_async(dispatch_get_main_queue(),^{
            __weak __typeof__(self) weakself = self;
            if(!weakself.isScroll){
                [weakself lyricTableViewScrollToIndex:[NSIndexPath indexPathForRow:7 inSection:0] animated:NO];
                weakself.isScroll = YES;
            }
            if(weakself.isTabbar){
                [weakself lyricTableViewScrollWithValue:tabbarValue animated:NO];
                weakself.isTabbar = NO;
            }
        });
    }
}
    
- (void)lyricClick {
    if([self.delegate respondsToSelector:@selector(lyricBtnClick)]){
        [self.delegate lyricBtnClick];
    }
}

- (void)closeClick {
    if([self.delegate respondsToSelector:@selector(closeBtnClick)]){
        [self.delegate closeBtnClick];
    }
}

- (void)diskViewTap {
    if(self.lyricTableView.hidden && !self.albumView.hidden) {
        [[playManager sharedPlay] setLastIsLyric:YES];
        self.lyricTableView.hidden = NO;
        self.lyricBtn.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.lyricTableView.alpha = 1;
            self.lyricBtn.alpha = 1;
            self.albumView.alpha = 0;
        } completion:^(BOOL finished) {
            self.albumView.hidden = YES;
        }];
    }
}

- (void)tableViewTap {
    if(self.albumView.hidden && !self.lyricTableView.hidden) {
        self.albumView.hidden = NO;
        [[playManager sharedPlay] setLastIsLyric:NO];
        [UIView animateWithDuration:0.5 animations:^{
            self.albumView.alpha = 1;
            self.lyricTableView.alpha = 0;
            self.lyricBtn.alpha = 0;
        } completion:^(BOOL finished) {
            self.lyricTableView.hidden = YES;
            self.lyricBtn.hidden = YES;
        }];
    }
}

- (void)lyricTableViewScrollWithNum:(NSInteger)num animated:(BOOL)animated {
    NSInteger num2 = num + 7;
    if(self.lyricArray.count - 7 >= num2 + 1 && self.LyricRoll){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:num2 inSection:0];
        [self lyricTableViewScrollToIndex:indexPath animated:animated];
    }
}

- (void)lyricTableViewScrollWithValue:(float)value animated:(BOOL)animated {
    NSLog(@"放手");
    if(self.LyricRoll){
        for(NSInteger i = 7; i <= self.timeArray.count - 1; i++){
            if([self.timeArray[i] integerValue] > value){
                NSLog(@"%ld 大于现在的时间 %f",[self.timeArray[i] integerValue] ,value);
                if(i == 7){
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    [self lyricTableViewScrollToIndex:indexPath animated:animated];
                }else{
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i - 1 inSection:0];
                    [self lyricTableViewScrollToIndex:indexPath animated:animated];
                }
                break;
            }
            if(i == self.timeArray.count - 1 - 7){
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self lyricTableViewScrollToIndex:indexPath animated:animated];
            }
        }
    }
}

//需等到self.tableView加载完成才执行
- (void)setTabbrValue:(float)value {
    tabbarValue = value;
}

- (void)lyricTableViewScrollToIndex:(NSIndexPath *)indexPath animated:(BOOL)animated{
    if(indexPath.row < self.lyricArray.count){
        if(self.lastCell){
            self.lastCell.lyricLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.45];
        }
        lyricCell *cell = [self.lyricTableView cellForRowAtIndexPath:indexPath];
        cell.lyricLabel.textColor = [UIColor whiteColor];
        self.lastCell = cell;
        self.currentRow = indexPath.row;
        [self.lyricTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:animated];
    }
}

- (void)setSongName:(NSString *)songName singerName:(NSString *)singerName {
    self.songNameLabel.text = songName;
    self.singerLabel.text = singerName;
}

- (void)loadTimeArray:(NSArray *)timeArry lyricArray:(NSArray *)lyricArray isRoll:(BOOL)roll {
    if(self.lastCell){
        self.lastCell.lyricLabel.textColor = [UIColor blackColor];
    }
    [self.timeArray addObjectsFromArray:timeArry];
    [self.lyricArray addObjectsFromArray:lyricArray];
    self.LyricRoll = roll;
    self.currentRow = 0;
    for(NSInteger i = 0; i < 7; i++){
        [self.timeArray addObject:@""];
        [self.lyricArray addObject:@""];
    }
    [self.lyricTableView reloadData];
    [self lyricTableViewScrollToIndex:[NSIndexPath indexPathForRow:7 inSection:0] animated:NO];
}

- (void)removeTimeAndLyricArray {
    [self.timeArray removeAllObjects];
    [self.lyricArray removeAllObjects];
    [self.lyricTableView reloadData];
    for(NSInteger i = 0; i < 7; i++){
        [self.timeArray addObject:@""];
        [self.lyricArray addObject:@""];
    }
}

- (void)changeLyricAndAlbumHidden {
    BOOL temp = self.albumView.hidden;
    self.albumView.alpha = 0;
    self.albumView.hidden = !temp;
    self.lyricTableView.alpha = 1;
    self.lyricTableView.hidden = temp;
    self.lyricBtn.alpha = 1;
    self.lyricBtn.hidden = temp;
}

//通过URL设置专辑图片
- (void)setAlbumImageWithURL:(NSString *)url {
    [self.albumView setImageWithURL:url];
}
//通过image设置专辑图片
- (void)setAlbumImageWithImage:(UIImage *)image {
    [self.albumView setImageWithImage:image];
}

- (void)setImageAnimation:(BOOL)animation {
    [self.albumView setImageAnimation:animation];
}

#pragma mark - 懒加载
- (NSMutableArray *)lyricArray {
    if(!_lyricArray){
        _lyricArray = [NSMutableArray array];
    }
    return _lyricArray;
}

- (NSMutableArray *)timeArray {
    if(!_timeArray){
        _timeArray = [NSMutableArray array];
    }
    return _timeArray;
}


@end
