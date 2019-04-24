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
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        self.localFileURL = [cachesPath stringByAppendingString:object.localFileURL];
        self.songmid = object.songmid;
        self.songid = object.songid;
        self.songname = object.songname;
        self.lyric = object.lyric;
        self.albumname = object.albumname;
        self.albummid = object.albummid;
        self.interval = object.interval;
        singerData *data = [[singerData alloc] init];
        data.name = object.singer;
        if(data.name == nil || [data.name isEqualToString:@""]){
            data.name = @"位置歌手";
        }
        self.singerArray = [NSMutableArray array];
        [self.singerArray addObject:data];
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
