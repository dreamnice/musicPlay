//
//  playTool.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/3/13.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "playManager.h"

#import <AVFoundation/AVFoundation.h>

@interface playManager ()

@property (nonatomic, strong) AVPlayer *myPlayer;

@property (nonatomic, strong) AVPlayerItem *currentItem;

@property (nonatomic, copy) NSString *currentURL;

@end

@implementation playManager

#pragma mark - init

+ (id)sharedPlay{
    return [[self alloc] init];
}

static id instace;
static dispatch_once_t token;

+ (id)allocWithZone:(struct _NSZone *)zone {

    dispatch_once(&token, ^{
        instace = [super allocWithZone:zone];
        //设置AVAudioSession后台播放
        AVAudioSession *session = [AVAudioSession  sharedInstance];
        [session setActive:YES error:nil];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    });
    return instace;
}

- (id)copyWithZone:(NSZone *)zone{
    return instace;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    return instace;
}

//销毁单例
+ (void)destroyInstance{
    token = 0;
    instace = nil;
}


- (void)dealloc{
    NSLog(@"BaseSevice单例已销毁");
}


#pragma mark - methoes

- (void)playWithURL:(NSString *)url{
    if(!url){
        return;
    }
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:url]];
    if(item){
        self.currentItem = item;
    }else{
        return;
    }
    [self.myPlayer replaceCurrentItemWithPlayerItem:item];
}

- (void)myPlay{
    [self.myPlayer play];
}

- (void)myPause{
    [self.myPlayer pause];
}

- (AVPlayer *)myPlayer{
    if(!_myPlayer){
        _myPlayer = [[AVPlayer alloc] init];
    }
    return _myPlayer;
}
@end
