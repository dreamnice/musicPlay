//
//  playViewController.h
//  MusicPlay
//
//  Created by 朱力珅 on 2019/3/14.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "songData.h"

NS_ASSUME_NONNULL_BEGIN

@interface playViewController : UIViewController

- (instancetype)initWithSongData:(songData *)song isFromTabbar:(BOOL)isTabbar;

@end

NS_ASSUME_NONNULL_END
