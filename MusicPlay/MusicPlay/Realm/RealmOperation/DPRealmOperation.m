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
            instace.realm = [RLMRealm defaultRealm];
            NSLog(@"%@",[RLMRealmConfiguration defaultConfiguration].fileURL);
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

#pragma mark - 歌曲
- (void)addLocalMusicObject:(DPLocalMusicObject *)object {
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

- (RLMResults <DPLocalMusicObject *>*)querySongData {
    return [DPLocalMusicObject allObjects];
}

@end
