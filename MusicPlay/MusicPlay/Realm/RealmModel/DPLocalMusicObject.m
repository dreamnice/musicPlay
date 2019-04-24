//
//  DPLocalMusicObject.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/23.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "DPLocalMusicObject.h"

@implementation DPLocalMusicObject

- (instancetype)initWithSongData:(songData *)data localFileURL:(NSString *)url {
    self = [super init];
    if(self){
        self.localFileURL = url;
        self.songid = data.songid;
        self.songmid = data.songmid;
        self.songname = data.songname;
        self.albummid = data.albummid;
        self.albumname = data.albumname;
        self.lyric = data.lyric;
        self.interval = data.interval;
        if(data.singerArray.count >= 1) {
            self.singer = data.singerArray[0].name;
        }
    }
    return self;
}

+ (NSString *)primaryKey{
    return @"songid";
}

@end
