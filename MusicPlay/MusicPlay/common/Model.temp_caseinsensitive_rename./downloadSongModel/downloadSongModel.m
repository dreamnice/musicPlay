//
//  downloadSongModel.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/28.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "downloadSongModel.h"
#import "DPResumeDataObject.h"

@implementation downloadProgress

- (float)progress {
    if (_totalBytesWritten == 0) {
        return 0;
    }
    return (CGFloat)_totalBytesWritten/_totalBytesExpectedToWrite;
}

@end

@implementation downloadSongModel

- (instancetype)initWithDPResumeDataObject:(DPResumeDataObject *)object {
    self = [super init];
    if(self){
        songData *data = [[songData alloc] initWithLocalMusicObject:object.songObject];
        self.songObject = data;
        self.URLHost = object.URLHost;
        self.resumeData = [object.resumeData copy];
        self.progress.totalBytesExpectedToWrite = object.totalBytesExpectedToWrite;
        self.progress.totalBytesWritten = object.totalBytesWritten;
    }
    return self;
}

- (downloadProgress *)progress{
    if(!_progress) {
        _progress = [[downloadProgress alloc] init];
    }
    return _progress;
}
@end
