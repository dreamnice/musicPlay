//
//  realmOperation.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/23.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "DPRealmOperation.h"

@interface DPRealmOperation()

@property (nonatomic, strong)RLMRealm *realm;

@end

@implementation DPRealmOperation

+ (id)shareOperation {
    return [[self alloc] init];
}

static DPRealmOperation *instace = nil;
static dispatch_once_t token;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    dispatch_once(&token, ^{
        instace = [super allocWithZone:zone];
        if(instace){
            NSLog(@"%@",[RLMRealmConfiguration defaultConfiguration].fileURL);
            instace.realm = [RLMRealm defaultRealm];
        }
    });
    return instace;
}

//销毁单例
+ (void)destroyInstance{
    token = 0;
    instace = nil;
}

#pragma mark - 断点续传
- (void)addResumDataObject:(DPResumeDataObject *)object {
    [self.realm beginWriteTransaction];
    [self.realm addOrUpdateObject:object];
    [self.realm commitWriteTransaction];
}

- (void)addResumDataObject:(DPResumeDataObject *)object withData:(NSData *)data {
    [self.realm beginWriteTransaction];
    object.resumeData = [data copy];
    [self.realm commitWriteTransaction];
}

- (void)deleteResumDataObject:(DPResumeDataObject *)object {
    [self.realm beginWriteTransaction];
    [self.realm deleteObject:object];
    [self.realm commitWriteTransaction];
}

- (void)deleteResumDataObjectWithURLHost:(NSString *)host {
    DPResumeDataObject *object = [DPResumeDataObject objectInRealm:self.realm forPrimaryKey:host];
    if(object){
        [self deleteResumDataObject:object];
    }
}

- (DPResumeDataObject *)queryWithURLHost:(NSString *)host {
    DPResumeDataObject *object = [DPResumeDataObject objectInRealm:self.realm forPrimaryKey:host];
    return object;
}

//ascending 升序
- (RLMResults <DPResumeDataObject *>*)queryResumeSongData {
    RLMResults *results = [DPResumeDataObject allObjects];
    return [results sortedResultsUsingKeyPath:@"uploadDate" ascending:NO];
}

#pragma mark - 歌曲
- (void)addLocalMusicObject:(DPLocalMusicObject *)object {
    if(object == nil){
        return;
    }
    [self.realm beginWriteTransaction];
    [self.realm addOrUpdateObject:object];
    [self.realm commitWriteTransaction];
}

- (void)deleteLocalMusicObject:(DPLocalMusicObject *)object {
    [self.realm beginWriteTransaction];
    [self.realm deleteObject:object];
    [self.realm commitWriteTransaction];
}

- (void)deleteLocalMusicObjectWithSongid:(NSString *)songid {
    DPLocalMusicObject *object = [DPLocalMusicObject objectInRealm:self.realm forPrimaryKey:songid];
    if(object){
        [self deleteLocalMusicObject:object];
    }
}

- (DPLocalMusicObject *)queryWithSongid:(NSString *)songid {
    DPLocalMusicObject *object = [DPLocalMusicObject objectInRealm:self.realm forPrimaryKey:songid];
    return object;
}

- (RLMResults <DPLocalMusicObject *>*)queryDownLoadSongData {
    BOOL downLoad = YES;
    RLMResults *results = [DPLocalMusicObject objectsWhere:@"isDownload == %d", downLoad];
    return [results sortedResultsUsingKeyPath:@"uploadDate" ascending:NO];
}


@end
