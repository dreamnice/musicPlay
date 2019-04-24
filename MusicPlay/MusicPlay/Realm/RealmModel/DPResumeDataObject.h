//
//  DPResumeDataObject.h
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/23.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "RLMObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface DPResumeDataObject : RLMObject

- (instancetype)initWithURLHost:(NSString *)host resumeData:(NSData *)data;
- (instancetype)initWithURLHost:(NSString *)host;

@property NSString *URLHost;

@property NSData *resumeData;

@end

NS_ASSUME_NONNULL_END
