//
//  DPMusicPlayTool.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/22.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "DPMusicPlayTool.h"

@implementation DPMusicPlayTool

+ (void)encodQQLyric:(NSString *)lyric complete:(void (^)(NSArray *timeArray, NSArray *lyricArray, BOOL isRoll))completeBlock {
    NSMutableArray *lyricArray = [NSMutableArray array];
    NSMutableArray *timeArray = [NSMutableArray array];
    //判断是否滚动
    BOOL rollFlag = YES;
    if(lyric == nil || [lyric isEqualToString:@""]){
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
    completeBlock(timeArray, lyricArray, rollFlag);
}


- (NSDictionary *)encodKuGouLyric:(NSString *)lyric {
    return nil;
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
            return [NSString stringWithFormat:@"%@·%@",song.singerArray[0].name,song.albumname];
        }
    }else{
        return @"";
    }
}

@end
