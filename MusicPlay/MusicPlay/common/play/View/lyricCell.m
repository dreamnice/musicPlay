//
//  lyricCell.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/27.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "lyricCell.h"
#import <Masonry.h>

@interface lyricCell()

@end

@implementation lyricCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"cellID";
    lyricCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[lyricCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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

- (void)setupUI{
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    self.contentView.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.contentView);
    }];
    self.lyricLabel = label;
}

//- (void)setLyricLabelText:(NSString *)lyric {
//    self.lyricLabel.text = lyric;
//}

@end
