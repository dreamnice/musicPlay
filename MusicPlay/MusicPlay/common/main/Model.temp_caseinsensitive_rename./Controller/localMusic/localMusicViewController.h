//
//  searchViewController.h
//  MusicPlay
//
//  Created by 朱力珅 on 2019/3/13.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface localMusicViewController : UIViewController

- (id)initWithDataArray:(NSArray *)dataArray;
- (id)initWithLocalSong;

@end

NS_ASSUME_NONNULL_END