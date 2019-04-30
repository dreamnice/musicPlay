//
//  lyricModel.h
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/25.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface lyricModel : NSObject

@property (nonatomic, copy)NSArray *timeArray;

@property (nonatomic, copy)NSArray *lyricArray;

@property (nonatomic, copy)NSString *baseLyricl;

@property (nonatomic, assign) BOOL isRoll;

@property (nonatomic, assign) BOOL lyricConnect;

@property (nonatomic, copy) NSString *lyricid;

- (instancetype)initWithTimeArray:(NSArray *)timeArray lyricArray:(NSArray *)lyricArray baseLyric:(NSString *)baseLyric isRoll:(BOOL)isRoll lyricConect:(BOOL)lyricConnect lyricID:(NSString *)ID;

@end

NS_ASSUME_NONNULL_END
