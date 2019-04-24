//
//  lyricData.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/15.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "lyricData.h"

@implementation lyricData

- (instancetype)initWithTimeStr:(NSString *)timeStr lyricStr:(NSString *)lyricStr {
    self = [super init];
    if (self) {
        _timeStr = timeStr;
        _lyricStr = lyricStr;
    }
    return self;
}

@end
