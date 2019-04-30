//
//  localSongTableViewCell.h
//  MusicPlay
//
//  Created by 朱力珅 on 2019/5/1.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface localSongTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView isFirstCell:(BOOL)firstCell;

@property (nonatomic, strong) UILabel *songNameLabel;

@property (nonatomic, strong) UILabel *singerAndAlbumLabel;

@end

NS_ASSUME_NONNULL_END
