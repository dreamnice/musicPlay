//
//  downloadSongCell.h
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/28.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "downloadSongModel.h"
#import "deleteButon.h"
NS_ASSUME_NONNULL_BEGIN

@interface downloadSongCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView isFirstCell:(BOOL)firstCell;

@property (nonatomic, strong) deleteButon *deleteBtn;

@property (nonatomic, strong) UILabel *songNameLabel;

@property (nonatomic, strong) UILabel *pauseLabel;

@property (nonatomic, strong) UILabel *fileSizeProgressLabel;

@property (nonatomic, strong) UIProgressView *downloadProgressView;

@property (nonatomic, strong) downloadSongModel *model;

- (void)updataUI;

@end

NS_ASSUME_NONNULL_END
