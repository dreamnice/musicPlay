//
//  homeInfoView.h
//  MusicPlay
//
//  Created by 朱力珅 on 2019/5/1.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol homeInfoViewDelegate <NSObject>

- (void)downClick;

- (void)topClick;

- (void)randomClick;

@end

@interface homeInfoView : UIView

@property (nonatomic, weak)id <homeInfoViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
