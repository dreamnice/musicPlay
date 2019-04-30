//
//  lyricModel.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/25.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "lyricModel.h"

@implementation lyricModel

- (instancetype)initWithTimeArray:(NSArray *)timeArray lyricArray:(NSArray *)lyricArray baseLyric:(NSString *)baseLyric isRoll:(BOOL)isRoll lyricConect:(BOOL)lyricConnect lyricID:(NSString *)ID {
    self = [super init];
    if(self){
        self.timeArray = [timeArray copy];
        self.lyricArray = [lyricArray copy];
        self.baseLyricl = baseLyric;
        self.isRoll = isRoll;
        self.lyricConnect = lyricConnect;
        self.lyricid = ID;
    }
    return self;
}

@end
