//
//  DPResumeDataObject.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/23.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "DPResumeDataObject.h"

@implementation DPResumeDataObject

- (instancetype)initWithURLHost:(NSString *)host resumeData:(NSData *)data {
    self = [super init];
    if(self){
        self.URLHost = host;
        self.resumeData = data;
    }
    return self;
}

- (instancetype)initWithURLHost:(NSString *)host {
    self = [super init];
    if(self){
        self.URLHost = host;
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
