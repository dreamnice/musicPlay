//
//  songData.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/3/17.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "songData.h"
#import "DPLocalMusicObject.h"
#import <MJExtension/MJExtension.h>

@implementation songData
/*
 @property (nonatomic, copy) NSString *songmid;
 
 @property (nonatomic, copy) NSString *songid;
 
 @property (nonatomic, copy) NSString *songname;
 
 @property (nonatomic, copy) NSString *lyric;
 
 @property (nonatomic, copy) NSString *albumname;
 
 @property (nonatomic, copy) NSString *albummid;
 
 @property (nonatomic, assign) NSInteger interval;
 
 @property (nonatomic, strong) NSMutableArray <singerData *>*singerArray;
 
 @property (nonatomic, strong) NSMutableArray <songData *>*grpArray;
 
 @property (nonatomic, copy) NSString *playURL;
 
 @property (nonatomic, copy) NSString *fileLocalURL;
 */
- (instancetype)initWithLocalMusicObject:(DPLocalMusicObject *)object {
    self = [super init];
    if(self){
        if(object.localFileURL){
            self.localFileURL = object.localFileURL;
        }
        self.songmid = object.songmid;
        self.songid = object.songid;
        self.songname = object.songname;
        self.albumname = object.albumname;
        self.albummid = object.albummid;
        self.interval = object.interval;
        self.isDownload = object.isDownload;
        self.playURL = object.playURL;
        self.fileSize = object.fileSize;
        self.fileSizeNum = object.fileSizeNum;
        singerData *data = [[singerData alloc] init];
        data.name = object.singer;
        if(data.name == nil || [data.name isEqualToString:@""]){
            data.name = @"位置歌手";
        }
        self.singerArray = [NSMutableArray array];
        [self.singerArray addObject:data];
        if(object.lyricObject != nil){
            [DPMusicPlayTool encodQQLyric:object.lyricObject.baseLyricl complete:^(NSArray * _Nonnull timeArray, NSArray * _Nonnull lyricArray, NSString * _Nonnull baseLyric, BOOL isRoll) {
                lyricModel *model = [[lyricModel alloc] initWithTimeArray:timeArray lyricArray:lyricArray baseLyric:object.lyricObject.baseLyricl isRoll:isRoll lyricConect:object.lyricObject.lyricConnect lyricID:object.songid];
                self.lyricObject = model;
            }];
        }
    }
    return self;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"singerArray" : @"singer",
             @"grpArray"    : @"grap"
             };
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"singerArray" : @"singerData",
             @"grpArray"    : @"songData"
             };
}

@end
