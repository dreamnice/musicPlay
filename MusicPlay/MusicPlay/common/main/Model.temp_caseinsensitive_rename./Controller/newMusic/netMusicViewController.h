//
//  netMusicViewController.h
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/30.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,DPNetMusicType) {
    DPTopMusicType = 0,
    DPRandomMusicType
};

NS_ASSUME_NONNULL_BEGIN

@interface netMusicViewController : UIViewController

- (instancetype)initWithNetMusicType:(DPNetMusicType)musicType;

@end

NS_ASSUME_NONNULL_END
