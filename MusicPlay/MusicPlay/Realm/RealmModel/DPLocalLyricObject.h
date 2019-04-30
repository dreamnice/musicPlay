//
//  DPLocalLyric.h
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/25.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "RLMObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface DPLocalLyricObject : RLMObject

@property NSString *lyricid;

@property NSString *baseLyricl;

@property BOOL isRoll;

@property BOOL lyricConnect;

- (instancetype)initWithBaseLyric:(NSString *)baseLyric isRoll:(BOOL)isRoll lyricConnect:(BOOL)lyricConnect songID:(NSString *)songID;

@end

NS_ASSUME_NONNULL_END
