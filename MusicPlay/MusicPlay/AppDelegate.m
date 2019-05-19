//
//  AppDelegate.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/1/20.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "AppDelegate.h"
#import "homePageViewController.h"
#include "mainTabbarController.h"
#import "DPMusicDownLoadTool.h"
#import "DPResumeDataObject.h"
#import "mainNavigationController.h"
#import <Realm/Realm.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //设置AVAudioSession后台播放
    AVAudioSession *session = [AVAudioSession  sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    // 在App启动后开启远程控制事件, 接收来自锁屏界面和上拉菜单的控制
    [application beginReceivingRemoteControlEvents];
    
    homePageViewController *vc = [[homePageViewController alloc] init];
    mainNavigationController *navc = [[mainNavigationController alloc] initWithRootViewController:vc];
    mainTabbarController *tabbarVC = [[mainTabbarController alloc] initWithMainViewController:navc];
    //开启下载功能
    [DPMusicDownLoadTool shareTool];
    [playManager sharedPlay];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = tabbarVC;
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // 实现如下代码，才能使程序处于后台时被杀死，调用applicationWillTerminate:方法
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^(){
        NSLog(@"后台杀死了");
    }];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [DPMusicPlayTool savePlayStateAndLastSongData:[[playManager sharedPlay] songData]];
    NSLog(@"退出程序了");
}

@end
