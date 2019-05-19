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


/**
 添加断点重连数据

 @param object object
 */
- (void)addResumDataObject:(DPResumeDataObject *)object;

/**
 根据resumedata添加数据

 @param object 模型
 @param data 断点重连数据
 */
- (void)addResumDataObject:(DPResumeDataObject *)object withData:(NSData *)data;

/**
 通过url删除断点重连数据

 @param host url
 */
- (void)deleteResumDataObjectWithURLHost:(NSString *)host;

/**
 删除断点重连数据

 @param object s
 */
- (void)deleteResumDataObject:(DPResumeDataObject *)object;

/**
 通过url查询断点重传数据

 @param host url
 @return 数据
 */
- (DPResumeDataObject *)queryWithURLHost:(NSString *)host;

/**
 查询断点续传数据
 
 @return 数据
 */
- (RLMResults <DPResumeDataObject *>*)queryResumeSongData;

/**
 添加或更新歌曲

 @param object 歌曲
 */
- (void)addLocalMusicObject:(DPLocalMusicObject *)object;

/**
 删除songid为key的数据

 @param songid songid
 */
- (void)deleteLocalMusicObjectWithSongid:(NSString *)songid;

/**
 通过songid查询歌曲

 @param songid songid
 @return n
 */
- (DPLocalMusicObject *)queryWithSongid:(NSString *)songid;

/**
 已下载数据

 @return 数据
 */
- (RLMResults <DPLocalMusicObject *>*)queryDownLoadSongData;

@end

NS_ASSUME_NONNULL_END
