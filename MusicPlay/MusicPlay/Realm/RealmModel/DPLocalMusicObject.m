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
        self.uploadDate = [NSDate date];
        self.isDownload = data.isDownload;
        self.localFileURL = url;
        self.songid = data.songid;
        self.songmid = data.songmid;
        self.songname = data.songname;
        self.albummid = data.albummid;
        self.albumname = data.albumname;
        self.interval = data.interval;
        self.playURL = data.playURL;
        self.fileSize = data.fileSize;
        self.fileSizeNum = data.fileSizeNum;
        if(data.lyricObject != nil){
            DPLocalLyricObject *object = [[DPLocalLyricObject alloc] initWithBaseLyric:data.lyricObject.baseLyricl isRoll:data.lyricObject.isRoll lyricConnect:data.lyricObject.lyricConnect songID:data.songid];
            self.lyricObject = object;
        }
        if(data.singerArray.count >= 1) {
            self.singer = data.singerArray[0].name;
        }
    }
    return self;
}

- (instancetype)initWithSongData:(songData *)data {
    self = [super init];
    if(self){
        self.uploadDate = [NSDate date];
        self.songid = data.songid;
        self.songmid = data.songmid;
        self.songname = data.songname;
        self.albummid = data.albummid;
        self.albumname = data.albumname;
        self.interval = data.interval;
        self.isDownload = data.isDownload;
        self.playURL = data.playURL;
        self.localFileURL = data.localFileURL;
        self.fileSize = data.fileSize;
        self.fileSizeNum = data.fileSizeNum;
        if(data.lyricObject != nil){
            DPLocalLyricObject *object = [[DPLocalLyricObject alloc] initWithBaseLyric:data.lyricObject.baseLyricl isRoll:data.lyricObject.isRoll lyricConnect:data.lyricObject.lyricConnect songID:data.songid];
            self.lyricObject = object;
        }
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
