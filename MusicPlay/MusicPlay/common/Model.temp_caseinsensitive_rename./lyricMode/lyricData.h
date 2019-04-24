//
//  lyricData.h
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/15.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface lyricData : NSObject

- (instancetype)initWithTimeStr:(NSString *)timeStr lyricStr:(NSString *)lyricStr;

@property (nonatomic, readonly, copy) NSString *timeStr;

@property (nonatomic, readonly, copy) NSString *lyricStr;

@property (nonatomic, assign) BOOL isSelect;

@end

NS_ASSUME_NONNULL_END
