//
//  baseSevice.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/2.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "baseSevice.h"

@implementation baseSevice

static id instace;
static dispatch_once_t token;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    dispatch_once(&token, ^{
        instace = [super allocWithZone:zone];
    });
    return instace;
}

//销毁单例
+ (void)destroyInstance{
    token = 0;
    instace = nil;
}

@end
