//
//  songData.h
//  MusicPlay
//
//  Created by 朱力珅 on 2019/3/17.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "singerData.h"

NS_ASSUME_NONNULL_BEGIN

@interface songData : NSObject

/**
 歌曲KEY
 */
@property (nonatomic, copy) NSString *songmid;

@property (nonatomic, copy) NSString *songid;

@property (nonatomic, copy) NSString *songname;

@property (nonatomic, copy) NSString *lyric;

@property (nonatomic, copy) NSString *albumname;

@property (nonatomic, copy) NSString *albummid;

@property (nonatomic, strong) NSMutableArray <singerData *>*singerArray;

@property (nonatomic, strong) NSMutableArray <songData *>*grpArray;

@end

NS_ASSUME_NONNULL_END
