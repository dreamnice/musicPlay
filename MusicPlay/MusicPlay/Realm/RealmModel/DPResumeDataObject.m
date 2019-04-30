//
//  DPResumeDataObject.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/23.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "DPResumeDataObject.h"

@implementation DPResumeDataObject

- (instancetype)initWithURLHost:(NSString *)host songData:(songData *)songData {
    self = [super init];
    if(self){
        self.uploadDate = [NSDate date];
        self.URLHost = host;
        DPLocalMusicObject *object = [[DPLocalMusicObject alloc] initWithSongData:songData];
        self.songObject = object;
    }
    return self;
}

- (instancetype)initWithdownloadSongMode:(downloadSongModel *)model {
    self = [super init];
    if(self){
        self.uploadDate = [NSDate date];
        self.URLHost = model.URLHost;
        self.resumeData = [model.resumeData copy];
        DPLocalMusicObject *object = [[DPLocalMusicObject alloc] initWithSongData:model.songObject];
        self.songObject = object;
        self.totalBytesExpectedToWrite = model.progress.totalBytesExpectedToWrite;
        self.totalBytesWritten = model.progress.totalBytesWritten;
    }
    return self;
}

+ (NSString *)primaryKey{
    return @"URLHost";
}

//属性默认值
+ (NSDictionary *)defaultPropertyValues {
    return @{@"resumeData" : [NSData data]};
}

@end
