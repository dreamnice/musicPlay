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

- (void)addResumDataObject:(DPResumeDataObject *)object withData:(NSData *)data;

- (void)deleteResumDataObjectWithURLHost:(NSString *)host;

- (void)deleteResumDataObject:(DPResumeDataObject *)object;

- (DPResumeDataObject *)queryWithURLHost:(NSString *)host;

- (void)addLocalMusicObject:(DPLocalMusicObject *)object;

- (void)deleteLocalMusicObjectWithSongid:(NSString *)songid;

- (DPLocalMusicObject *)queryWithSongid:(NSString *)songid;

- (RLMResults <DPLocalMusicObject *>*)queryDownLoadSongData;

- (RLMResults <DPResumeDataObject *>*)queryResumeSongData;
@end

NS_ASSUME_NONNULL_END
