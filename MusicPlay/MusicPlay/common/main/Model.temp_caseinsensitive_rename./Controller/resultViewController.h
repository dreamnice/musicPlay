//
//  resultViewController.h
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/24.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol resultViewControllerDelegate <NSObject>

- (void)playSong:(songData *)data;

@end

@interface resultViewController : UIViewController

-(instancetype)initWithSearchBar:(UISearchBar *)searchBar;

@property (nonatomic, weak)id <resultViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
