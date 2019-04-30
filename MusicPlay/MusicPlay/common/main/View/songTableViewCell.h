//
//  songCellTableViewCell.h
//  MusicPlay
//
//  Created by 朱力珅 on 2019/3/22.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface songTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) UILabel *songNameLabel;

@property (nonatomic, strong) UILabel *singerAndAlbumLabel;

@property (nonatomic, strong) UIImageView *downloadImageViwe;

- (void)setDownLoadimageView:(BOOL)isDownLoad;

@end

NS_ASSUME_NONNULL_END
