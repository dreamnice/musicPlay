//
//  downloadSongCell.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/28.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "downloadSongCell.h"
#import <Masonry.h>

@implementation downloadSongCell

+ (instancetype)cellWithTableView:(UITableView *)tableView isFirstCell:(BOOL)firstCell {
    NSString *identifier = nil;
    if(firstCell){
        identifier = @"firstCellID";
    }else{
        identifier = @"cellID";
    }
    downloadSongCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[downloadSongCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier isFirstCell:firstCell];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isFirstCell:(BOOL)firstCell {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        if(firstCell){
            [self setupFirstCellUI];
        }else{
            [self setupUI];
        }
    }
    return self;
}

- (void)setupFirstCellUI {
    UILabel *beginLabel = [[UILabel alloc] init];
    beginLabel.font = [UIFont systemFontOfSize:17];
    beginLabel.text = @"点击全部开始";
    [self.contentView addSubview:beginLabel];
    [beginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
    }];
}

- (void)setupUI {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guangpan"]];
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(15);
        make.centerY.mas_equalTo(self.contentView);
        make.height.width.mas_equalTo(20);
    }];
    
    deleteButon *deleteBtn = [deleteButon buttonWithType:UIButtonTypeCustom];
    [deleteBtn setImage:[UIImage imageNamed:@"lajitong"] forState:UIControlStateNormal];
    [self.contentView addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.mas_equalTo(self.contentView);
        make.height.width.mas_equalTo(30);
    }];
    self.deleteBtn = deleteBtn;
    
    UILabel *songNameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:songNameLabel];
    //增强可读性with and
    [songNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(5);
        make.left.equalTo(self.contentView.mas_left).with.offset(45);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(270);
    }];
    self.songNameLabel = songNameLabel;
    
    UILabel *pauseLabel = [[UILabel alloc] init];
    pauseLabel.font = [UIFont systemFontOfSize:14];
    [pauseLabel setTextColor:albumNameColor];
    pauseLabel.text = @"已暂停,点击继续下载";
    [self.contentView addSubview:pauseLabel];
    [pauseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(songNameLabel.mas_bottom).offset(6.5);
        make.left.mas_equalTo(self.contentView.mas_left).offset(45);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(270);
    }];
    self.pauseLabel = pauseLabel;
    
    UILabel *fileSizeProgressLabel = [[UILabel alloc] init];
    fileSizeProgressLabel.font = [UIFont systemFontOfSize:12];
    [fileSizeProgressLabel setTextColor:albumNameColor];
    fileSizeProgressLabel.text =  @"0.0M / 0.0M";
    [self.contentView addSubview:fileSizeProgressLabel];
    [fileSizeProgressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(songNameLabel.mas_bottom).offset(6.5);
        make.left.mas_equalTo(self.contentView.mas_left).offset(45);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(83);
    }];
    self.fileSizeProgressLabel = fileSizeProgressLabel;
    
    UIProgressView *downloadProgressView = [[UIProgressView alloc] init];
    [downloadProgressView setProgressTintColor:[UIColor colorWithRed:76/255.0 green:164/255.0 blue:224/255.0 alpha:1]];
    [downloadProgressView setTrackTintColor:[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1]];
    downloadProgressView.userInteractionEnabled = NO;
    [self.contentView addSubview:downloadProgressView];
    [downloadProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(pauseLabel);
        make.left.mas_equalTo(fileSizeProgressLabel.mas_right).offset(3);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-60);
        make.height.mas_equalTo(3);
    }];
    self.downloadProgressView = downloadProgressView;
}

- (void)updataUI {
    [self updataUIWithModel:self.model];
}

- (void)setModel:(downloadSongModel *)model {
    _model = model;
    [self updataUIWithModel:model];
    __weak downloadSongCell *weakCell = self;
    __weak downloadSongModel *weakModel = model;
    model.progressBlock = ^(CGFloat progress) {
        if(weakCell.model == model){
            weakCell.downloadProgressView.progress = weakModel.progress.progress;
            weakCell.fileSizeProgressLabel.text = [NSString stringWithFormat:@"%@ / %@",weakModel.progress.writtenFileSize, weakModel.progress.totalFileSize];
        }
    };
    model.beiginBlock = ^{
        [weakCell updataUIWithModel:weakModel];
    };
}

- (void)updataUIWithModel:(downloadSongModel *)model {
    self.songNameLabel.text = model.songObject.songname;
    if(model.downloadState == DPDonloadPauseState){
        self.downloadProgressView.hidden = YES;
        self.fileSizeProgressLabel.hidden = YES;
        self.pauseLabel.hidden = NO;
    }else if(model.downloadState == DPDonloadRunningState){
        self.downloadProgressView.hidden = NO;
        self.fileSizeProgressLabel.hidden = NO;
        self.pauseLabel.hidden = YES;
    }
    self.downloadProgressView.progress = model.progress.progress;
    self.fileSizeProgressLabel.text = [NSString stringWithFormat:@"%@ / %@",model.progress.writtenFileSize, model.progress.totalFileSize];
}


@end
