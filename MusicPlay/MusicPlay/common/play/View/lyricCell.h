//
//  lyricCell.h
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/27.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface lyricCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) UILabel *lyricLabel;

@end

NS_ASSUME_NONNULL_END
