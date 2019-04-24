//
//  realmOperation.h
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/23.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

#import "DPResumeDataObject.h"
#import "DPLocalMusicObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface DPRealmOperation : NSObject

+ (id)shareOperation;

- (void)addResumDataObject:(DPResumeDataObject *)object;
- (void)deleteResumDataObjectWithURLHost:(NSString *)host;
- (DPResumeDataObject *)queryWithURLHost:(NSString *)host;

- (void)addLocalMusicObject:(DPLocalMusicObject *)object;
- (void)deleteLocalMusicObjectWithSongid:(NSString *)songid;
- (DPResumeDataObject *)queryWithSongid:(NSString *)songid;
- (RLMResults <DPLocalMusicObject *>*)querySongData;
@end

NS_ASSUME_NONNULL_END
