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
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cm2_default_cover_80"]];
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(15);
        make.centerY.mas_equalTo(self.contentView);
        make.height.width.mas_equalTo(20);
    }];
    
    UILabel *songNameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:songNameLabel];
    //增强可读性with and
    [songNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(5);
        make.left.equalTo(self.contentView.mas_left).with.offset(45);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(300);
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
        make.width.mas_equalTo(300);
    }];
    self.pauseLabel = pauseLabel;
    
    UIProgressView *downloadProgressViewr = [[UIProgressView alloc] init];
    downloadProgressViewr.userInteractionEnabled = NO;
    [self.contentView addSubview:downloadProgressViewr];
    [downloadProgressViewr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(pauseLabel);
        make.left.mas_equalTo(self.contentView.mas_left).offset(45);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-50);
        make.height.mas_equalTo(5);
    }];
    self.downloadProgressView = downloadProgressViewr;
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
        self.pauseLabel.hidden = NO;
    }else if(model.downloadState == DPDonloadRunningState){
        self.downloadProgressView.hidden = NO;
        self.pauseLabel.hidden = YES;
    }
    self.downloadProgressView.progress = model.progress.progress;
}


@end
