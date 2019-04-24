//
//  DPMusicDownLoadTool.h
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/23.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DonwLoadSuccessBlock)(NSURL *fileURLPath ,NSURLResponse *  response );
typedef void (^DownLoadfailBlock)(NSError*  error ,NSInteger statusCode);
typedef void (^DowningProgress)(CGFloat  progress);

NS_ASSUME_NONNULL_BEGIN

@interface DPMusicDownLoadTool : NSObject

+ (id)shareTool;

- (NSURLSessionDownloadTask *)AFDownLoadFileWithUrl:(NSString*)URLHost
                                           progress:(DowningProgress)progress
                                       fileLocalUrl:(NSURL *)localURL
                                            success:(DonwLoadSuccessBlock)success
                                            failure:(DownLoadfailBlock)failure;

@end

NS_ASSUME_NONNULL_END
