//
//  DPLocalLyric.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/25.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "DPLocalLyricObject.h"

@implementation DPLocalLyricObject

- (instancetype)initWithBaseLyric:(NSString *)baseLyric isRoll:(BOOL)isRoll lyricConnect:(BOOL)lyricConnect songID:(NSString *)songID {
    self = [super init];
    if(self){
        self.baseLyricl = baseLyric;
        self.isRoll = isRoll;
        self.lyricConnect = lyricConnect;
        self.lyricid = songID;
    }
    return self;
}

+ (NSString *)primaryKey{
    return @"lyricid";
}

@end
