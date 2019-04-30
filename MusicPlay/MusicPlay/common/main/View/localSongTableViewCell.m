//
//  localSongTableViewCell.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/5/1.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "localSongTableViewCell.h"
#import <Masonry.h>

@implementation localSongTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView isFirstCell:(BOOL)firstCell {
    NSString *identifier = nil;
    if(firstCell){
        identifier = @"firstCellID";
    }else{
        identifier = @"cellID";
    }
    localSongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[localSongTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier isFirstCell:firstCell];
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
    UILabel *songNameLabel = [[UILabel alloc] init];
    songNameLabel.text = @"正在下载";
    [self.contentView addSubview:songNameLabel];
    //增强可读性with and
    [songNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(10);
    }];
}

- (void)setupUI {
    UILabel *songNameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:songNameLabel];
    //增强可读性with and
    [songNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(5);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(300);
    }];
    self.songNameLabel = songNameLabel;
    
    UIImageView *hasDownloadImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cm2_list_icn_dld_ok"]];
    [self.contentView addSubview:hasDownloadImageView];
    [hasDownloadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(songNameLabel.mas_left);
        make.top.equalTo(songNameLabel.mas_bottom).offset(10);
        make.width.height.mas_equalTo(13);
    }];
    
    UILabel *singerAndAlbumLabel = [[UILabel alloc] init];
    singerAndAlbumLabel.font = [UIFont systemFontOfSize:14];
    [singerAndAlbumLabel setTextColor:albumNameColor];
    [self.contentView addSubview:singerAndAlbumLabel];
    [singerAndAlbumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(hasDownloadImageView);
        make.left.mas_equalTo(hasDownloadImageView.mas_right).offset(5);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(300);
    }];
    self.singerAndAlbumLabel = singerAndAlbumLabel;
    
}

@end
