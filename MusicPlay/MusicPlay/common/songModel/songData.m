//
//  songData.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/3/17.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "songData.h"
#import <MJExtension/MJExtension.h>

@implementation songData

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
