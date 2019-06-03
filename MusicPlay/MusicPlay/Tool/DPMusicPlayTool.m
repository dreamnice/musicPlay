//
//  DPMusicPlayTool.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/22.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "DPMusicPlayTool.h"
#import <MJExtension.h>

@implementation DPMusicPlayTool

+ (void)encodQQLyric:(NSString *)baseLyric complete:(void (^)(NSArray *timeArray, NSArray *lyricArray, NSString *baseLyric, BOOL isRoll))completeBlock {
    NSMutableArray *lyricArray = [NSMutableArray array];
    NSMutableArray *timeArray = [NSMutableArray array];
    NSString *lyric = baseLyric;
    //判断是否滚动
    BOOL rollFlag = YES;
    if(lyric == nil || [lyric isEqualToString:@""]){
        lyric = @"";
        NSString *lyricStr = @"未找到歌词";
        NSString *timeStr = @"0";
        rollFlag = NO;
        [lyricArray addObject:lyricStr];
        [timeArray addObject:timeStr];
    }else{
        NSString *encodeLyric = [[NSString alloc] initWithData:[[NSData alloc] initWithBase64EncodedString:lyric options:0] encoding:NSUTF8StringEncoding];
        NSArray<NSString *> *array = [encodeLyric componentsSeparatedByString:@"\n"];
        if(array.count < 5){
            for(NSString *str in array){
                if(str.length < 10){
                    rollFlag = NO;
                    break;
                }else{
                    if(![[str substringToIndex:1] isEqualToString:@"["] || ![[str substringWithRange:NSMakeRange(9, 1)] isEqualToString:@"]"]){
                        rollFlag = NO;
                        break;
                    }
                }
            }
        }else if(array.count == 5){
            rollFlag = NO;
        }else{
            for(NSInteger i = 5; i <= array.count - 1; i++){
                if(array[i].length < 10){
                    rollFlag = NO;
                    break;
                }else{
                    if(![[array[i] substringToIndex:1] isEqualToString:@"["] || ![[array[i] substringWithRange:NSMakeRange(9, 1)] isEqualToString:@"]"]){
                        rollFlag = NO;
                        break;
                    }
                }
                
            }
        }
        if(rollFlag){
            NSMutableArray *array2 = [array mutableCopy];
            if(array2.count >= 5){
                [array2 removeObjectsInRange:NSMakeRange(0, 5)];
            }else{
                rollFlag = NO;
            }
            for(NSString *str in array2){
                NSString *lyricStr = [str substringFromIndex:10];
                if([lyricStr isEqualToString:@""]){
                    continue;
                }
                NSString *timeStr = [str substringToIndex:10];
                timeStr = [self timeToSecond:timeStr];
                [lyricArray addObject:lyricStr];
                [timeArray addObject:timeStr];
            }
        }else{
            [lyricArray addObjectsFromArray:array];
            [timeArray addObject:@"0"];
        }
    }
    completeBlock(timeArray, lyricArray, lyric, rollFlag);
}

+ (NSString *)timeToSecond:(NSString *)timeStr {
    NSString *minStr = [timeStr substringWithRange:NSMakeRange(1, 2)];
    NSInteger min = [minStr integerValue];
    NSString *secStr = [timeStr substringWithRange:NSMakeRange(4, 2)];
    NSInteger sec = [secStr integerValue];
    NSInteger totalSec = min * 60 + sec;
    NSString *secTimeStr = [NSString stringWithFormat:@"%ld",totalSec];
    return secTimeStr;
}

/*
 判断全是空格
 */
+ (NSString *)getSingerAndAlbumTxt:(songData *)song {
    if(song.singerArray != nil && song.singerArray.count > 0){
        if(song.albumname == nil || [[song.albumname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] == 0){
            return song.singerArray[0].name;
        }else{
            return [NSString stringWithFormat:@"%@ - %@",song.singerArray[0].name,song.albumname];
        }
    }else{
        return @"";
    }
}

+ (NSString *)encodeTimeWithNum:(NSInteger)num {
    if(num < 10){
        return [NSString stringWithFormat:@"00:0%ld",num];
    }else if(num < 60){
        return [NSString stringWithFormat:@"00:%ld",num];
    }else{
        NSInteger min = num / 60;
        NSInteger second = num % 60;
        if(min < 10){
            if(second < 10){
                return [NSString stringWithFormat:@"0%ld:0%ld",min, second];
            }else{
                return [NSString stringWithFormat:@"0%ld:%ld",min, second];
            }
        }else{
            if(second < 10){
                return [NSString stringWithFormat:@"%ld:0%ld",min, second];
            }else{
                return [NSString stringWithFormat:@"%ld:%ld",min, second];
            }
        }
    }
}
/*
 @property (nonatomic, copy) NSString *songmid;
 
 @property (nonatomic, copy) NSString *songid;
 
 @property (nonatomic, copy) NSString *songname;
 
 @property (nonatomic, copy) NSString *albumname;
 
 @property (nonatomic, copy) NSString *albummid;
 
 @property (nonatomic, assign) NSInteger interval;
 
 @property (nonatomic, strong) NSMutableArray <singerData *>*singerArray;
 
 @property (nonatomic, strong) NSMutableArray <songData *>*grpArray;
 
 @property (nonatomic, copy) NSString *playURL;
 
 @property (nonatomic, copy) NSString *localFileURL;
 
 @property (nonatomic, strong) lyricModel *lyricObject;
 
 @property (nonatomic, assign) BOOL isDownload;
 
 @property (nonatomic, assign) BOOL cutPlay;
 */

+ (songData *)getLastPlaySong {
    songData *data = nil;
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:DPUserDefaultsLastMusic];
    if(dic){
        data = [songData mj_objectWithKeyValues:dic];
        if([dic objectForKey:@"baseLyric"]){
            [self encodQQLyric:dic[@"baseLyric"] complete:^(NSArray * _Nonnull timeArray, NSArray * _Nonnull lyricArray, NSString * _Nonnull baseLyric, BOOL isRoll) {
                lyricModel *model = [[lyricModel alloc] initWithTimeArray:timeArray lyricArray:lyricArray baseLyric:baseLyric isRoll:isRoll lyricConect:NO lyricID:data.songid];
                data.lyricObject = model;
            }];
        }else{
            [[DPMusicHttpTool shareTool] getLyricWithSongData:data complete:^(lyricModel * _Nonnull lyric) {
                data.lyricObject = lyric;
            }];
        }
        singerData *singgerdata = [[singerData alloc] init];
        singgerdata.name = [dic objectForKey:@"singger"];
        data.singerArray = [NSMutableArray arrayWithObject:singgerdata];
        data.isLastSong = YES;
    }
    return data;
}
//解析本地音乐
+ (NSArray <songData *>*)getItunesSong {
    // 1.创建媒体选择队列（从ipod库中读出音乐文件）
    MPMediaQuery *everything = [MPMediaQuery songsQuery];
    // 2.创建读取条件(类似于对数据做一个筛选)  Value：作用等同于MPMediaType枚举值
    MPMediaPropertyPredicate *albumNamePredicate = [MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithInt:MPMediaTypeMusic ] forProperty: MPMediaItemPropertyMediaType];
    //3.给队列添加读取条件
    [everything addFilterPredicate:albumNamePredicate];
    //4.从队列中获取符合条件的数组集合
    NSArray *itemsFromGenericQuery = [everything items];
    //5.便利解析数据
    NSMutableArray  <songData *>*musicArray = [self resolverMediaItem:itemsFromGenericQuery];
    return musicArray;
}

#pragma mark -解析iTune音乐数据
+ (NSMutableArray <songData *>*)resolverMediaItem:(NSArray *)songArray {
    NSMutableArray <songData *>*ituneSongArray = [NSMutableArray array];
    for (MPMediaItem *song in songArray) {
        //歌曲路径(有些歌曲有版权,拿不到路径直接跳过)
        NSURL *url = [song valueForProperty: MPMediaItemPropertyAssetURL];
        if(url == nil){
            continue;
        }
        NSString *fileStr = [url absoluteString];
        //歌名
        NSString *name = [song valueForProperty: MPMediaItemPropertyTitle];
        //歌手名字
        NSString *singer = [song valueForProperty: MPMediaItemPropertyArtist];
        //歌曲时长（单位：秒）
        NSInteger interval = [[song valueForProperty: MPMediaItemPropertyPlaybackDuration] integerValue];
        //专辑名称
        NSString *albumStr = [song valueForKeyPath:MPMediaItemPropertyAlbumTitle];
        if(singer == nil){
            singer = @"未知歌手";
        }
        //歌曲插图（如果没有插图，则返回nil）
        MPMediaItemArtwork *artwork = [song valueForProperty: MPMediaItemPropertyArtwork];
        //从插图中获取图像，参数size是图像的大小
        UIImage *image = [artwork imageWithSize:CGSizeMake(50, 50)];
        
        songData *data = [[songData alloc] init];
        data.isDownload = YES;
        data.isFromItunes = YES;
        data.songname = name;
        data.albumname = albumStr;
        data.localFileURL = fileStr;
        data.albumImage = image;
        data.interval = interval;
        singerData *singerdata = [[singerData alloc] init];
        singerdata.name = singer;
        [data.singerArray addObject:singerdata];
        data.fileSizeNum = [DPMusicPlayTool getFileSizeAtPath:fileStr];
        if(data.fileSizeNum == 0){
            data.fileSize = @"未知";
        }else{
            data.fileSize = [DPMusicPlayTool calculateFileSize:data.fileSizeNum];
        }
        [ituneSongArray addObject:data];
    }
  
    return ituneSongArray;
}

+ (void)savePlayStateAndLastSongData:(songData *)data {
    if(data && !data.isFromItunes){
        NSDictionary *dic = nil;
        if(data.isDownload){
            if(data.lyricObject){
                dic = @{
                        @"songmid"      : data.songmid,
                        @"songid"       : data.songid,
                        @"songname"     : data.songname,
                        @"albumname"    : data.albumname,
                        @"albummid"     : data.albummid,
                        @"interval"     : [NSNumber numberWithInteger:data.interval],
                        @"baseLyric"    : data.lyricObject.baseLyricl,
                        @"singger"      : data.singerArray[0].name,
                        @"isDownload"   : [NSNumber numberWithBool:data.isDownload],
                        @"localFileURL" : data.localFileURL,
                        @"fileSize"     : data.fileSize,
                        @"fileSizeNum"  : [NSNumber numberWithLongLong:data.fileSizeNum],
                        @"isFromItunes" : [NSNumber numberWithBool:data.isFromItunes]
                        };
            }else{
                dic = @{
                        @"songmid"      : data.songmid,
                        @"songid"       : data.songid,
                        @"songname"     : data.songname,
                        @"albumname"    : data.albumname,
                        @"albummid"     : data.albummid,
                        @"interval"     : [NSNumber numberWithInteger:data.interval],
                        @"singger"      : data.singerArray[0].name,
                        @"isDownload"   : [NSNumber numberWithBool:data.isDownload],
                        @"localFileURL" : data.localFileURL,
                        @"fileSize"     : data.fileSize,
                        @"fileSizeNum"  : [NSNumber numberWithLongLong:data.fileSizeNum],
                        @"isFromItunes" : [NSNumber numberWithBool:data.isFromItunes]
                        };
            }
        }else{
            if(data.lyricObject){
                dic = @{
                        @"songmid"   : data.songmid,
                        @"songid"    : data.songid,
                        @"songname"  : data.songname,
                        @"albumname" : data.albumname,
                        @"albummid"  : data.albummid,
                        @"interval"  : [NSNumber numberWithInteger:data.interval],
                        @"baseLyric" : data.lyricObject.baseLyricl,
                        @"singger"   : data.singerArray[0].name,
                        @"isFromItunes" : [NSNumber numberWithBool:data.isFromItunes]
                        };
            }else{
                dic = @{
                        @"songmid"   : data.songmid,
                        @"songid"    : data.songid,
                        @"songname"  : data.songname,
                        @"albumname" : data.albumname,
                        @"albummid"  : data.albummid,
                        @"interval"  : [NSNumber numberWithInteger:data.interval],
                        @"singger"   : data.singerArray[0].name,
                        @"isFromItunes" : [NSNumber numberWithBool:data.isFromItunes]
                        };
            }
        }
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:DPUserDefaultsLastMusic];
    }
    [[NSUserDefaults standardUserDefaults] setInteger:[[playManager sharedPlay] playState] forKey:DPUserDefaultsPlayState];
    [[NSUserDefaults standardUserDefaults]  synchronize];
}


+ (float)calculateFileSizeInUnit:(unsigned long long)contentLength {
    if(contentLength >= pow(1024, 3))
    return (float) (contentLength / (float)pow(1024, 3));
    else if(contentLength >= pow(1024, 2))
    return (float) (contentLength / (float)pow(1024, 2));
    else if(contentLength >= 1024)
    return (float) (contentLength / (float)1024);
    else
    return (float) (contentLength);
}

+ (NSString *)calculateUnit:(unsigned long long)contentLength {
    if(contentLength >= pow(1024, 3))
    return @"G";
    else if(contentLength >= pow(1024, 2))
    return @"M";
    else if(contentLength >= 1024)
    return @"K";
    else
    return @"b";
}

+ (NSString *)calculateFileSize:(unsigned long long)contentLength {
    float siezInUnit = [DPMusicPlayTool calculateFileSizeInUnit:(unsigned long long)contentLength];
    NSString *unit = [DPMusicPlayTool calculateUnit:(unsigned long long)contentLength];
    NSString *writtenFileSize = [NSString stringWithFormat:@"%.1f%@",siezInUnit,unit];
    return writtenFileSize;
}

+ (long long)getFileSizeAtPath:(NSString *)path {
    BOOL isDirectory = NO;
    long long fileSize = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path isDirectory:&isDirectory]){
        NSDictionary * attributes = [fileManager attributesOfItemAtPath:path error:nil];
        // file size
        NSNumber *theFileSize;
        if ((theFileSize = [attributes objectForKey:NSFileSize])){
            fileSize = [theFileSize longLongValue];
        }
    }
    return fileSize;
}
@end
