//
//  singerData.h
//  MusicPlay
//
//  Created by 朱力珅 on 2019/3/17.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface singerData : NSObject

/**
 歌手ID
 */
@property (nonatomic, assign) NSInteger ID;

/**
 歌手KEY
 */
@property (nonatomic, copy) NSString *mid;

/**
 歌手姓名
 */
@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
