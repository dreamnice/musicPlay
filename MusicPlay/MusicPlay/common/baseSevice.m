//
//  baseSevice.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/2.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "baseSevice.h"

@implementation baseSevice

+ (id)shareService {
    return [[self alloc] init];
}

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

- (AFHTTPSessionManager *)manager {
    if(!_manager){
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = 10;
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
        //错误2
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/javascript",@"application/json",@"text/json",@"text/plain",@"application/x-javascript",nil];
        _manager = manager;
    }
    return _manager;
}
@end
