//
//  baseSevice.h
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/2.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface baseSevice : NSObject

//单例模式
+ (instancetype)shareService;

//销毁单例
+ (void)destroyInstance;

@end

NS_ASSUME_NONNULL_END
