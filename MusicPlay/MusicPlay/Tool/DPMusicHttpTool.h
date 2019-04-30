//
//  DPMusicHttpTool.h
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/25.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DPMusicHttpTool : NSObject

+ (id)shareTool;

- (void)searchMusicWithKeyWord:(NSString *)keyWord pageCount:(NSInteger)page success:(void(^)(NSArray<songData *> *songDataArray, BOOL noData))success  failure:(void(^)(NSError *error))failure;

- (void)getTopMusicSuccess:(void(^)(NSArray<songData *> *songDataArray, BOOL noData))success failure:(void(^)(NSError *error))failure ;

- (void)getRandomMusicSuccess:(void(^)(NSArray<songData *> *songDataArray, BOOL noData))success failure:(void(^)(NSError *error))failure;

- (void)getPlayURLWith:(songData *)data success:(void(^)(NSString *playURL))success failure:(void(^)(NSError *error))failure;


- (void)getLyricWithSongData:(songData *)data complete:(void (^)(lyricModel *lyric))complete;
@end

NS_ASSUME_NONNULL_END
