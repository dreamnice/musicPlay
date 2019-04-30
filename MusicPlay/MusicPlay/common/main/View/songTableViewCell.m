//
//  songCellTableViewCell.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/3/22.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "songTableViewCell.h"

#import <Masonry.h>

@implementation songTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"cellID";
    songTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[songTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setupUI];
    }
    return self;
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
    hasDownloadImageView.hidden = YES;
    [self.contentView addSubview:hasDownloadImageView];
    [hasDownloadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.songNameLabel.mas_left);
        make.top.equalTo(self.songNameLabel.mas_bottom).offset(10);
        make.width.height.mas_equalTo(13);
    }];
    self.downloadImageViwe = hasDownloadImageView;
    
    UILabel *singerAndAlbumLabel = [[UILabel alloc] init];
    singerAndAlbumLabel.font = [UIFont systemFontOfSize:14];
    [singerAndAlbumLabel setTextColor:albumNameColor];
    [self.contentView addSubview:singerAndAlbumLabel];
    [singerAndAlbumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(songNameLabel.mas_left);
        make.top.equalTo(songNameLabel.mas_bottom).offset(6.5);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(300);
    }];
    self.singerAndAlbumLabel = singerAndAlbumLabel;
}

- (void)setDownLoadimageView:(BOOL)isDownLoad {
    if(isDownLoad){
        self.downloadImageViwe.hidden = NO;
        [self.singerAndAlbumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.downloadImageViwe);
            make.left.mas_equalTo(self.downloadImageViwe.mas_right).offset(5);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(300);
        }];
    }else{
        self.downloadImageViwe.hidden = YES;
        [self.singerAndAlbumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.songNameLabel.mas_left);
            make.top.equalTo(self.songNameLabel.mas_bottom).offset(6.5);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(300);
        }];
    }
}

@end
