//
//  homePageViewController.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/24.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "homePageViewController.h"
#import "searchViewController.h"
#import "resultViewController.h"
#import "playViewController.h"

#import "DPMusicDownLoadTool.h"
#import "songSearchBar.h"
#import "DPSearchController.h"

#import <AFNetworking.h>
#import <AVFoundation/AVFoundation.h>
#import <MJExtension/MJExtension.h>

@interface homePageViewController ()<UISearchBarDelegate, resultViewControllerDelegate>{
    BOOL isPlay;
}

@property (nonatomic, copy) NSString *musicName;

@property (nonatomic, strong) AVPlayer *myplayer;

@property (nonatomic, strong) AVPlayer *myPlayer;

@property (nonatomic, strong) songSearchBar *searchBar;

@property (nonatomic, strong) UIView *resultView;

@property (nonatomic, strong) resultViewController *resultVC;

@property (nonatomic, strong) UIButton *cancelBtn;
@end

@implementation homePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *downClick = [UIButton buttonWithType:UIButtonTypeCustom];
    downClick.frame = CGRectMake(30, 300, 30, 30);
    [downClick setBackgroundImage:[UIImage imageNamed:@"downloaded"] forState:UIControlStateNormal];
    [downClick addTarget:self action:@selector(downBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downClick];
//    resultViewController *resultVC = [[resultViewController alloc] init];
//    self.resultVC = resultVC;
//    DPSearchController *searchVC = [[DPSearchController alloc] initWithSearchResultsController:vc];
//    [searchVC.searchBar sizeToFit];
//    self.navigationItem.titleView = searchVC.searchBar;
    /*
     该设置搜索框方法有两个缺点，第一个缺点导致搜索框的frame不可控，随着titleview的frame变化，第二个缺点是有可能导致titleview在设置搜索框后，整个navigationBar的高度会向下延伸，导致显示的高度大于实际的高度(44),造成对下面内容的遮挡。
        笔记
     */
    songSearchBar *searchBar = [[songSearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenW - 20, 44) placeholder:@"搜索歌曲" tintColor:[UIColor blackColor] showCancelButton:NO cancelTitle:@"取消"];
    searchBar.delegate = self;
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW - 20, 44)];
    [searchView addSubview:searchBar];
    
    self.navigationItem.titleView = searchView;
    self.searchBar = searchBar;
    [self setResultVC];
    
    /*
     UIImageView *imageView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"register_bg.jpeg"]];
     imageView.frame =self.view.frame;
     [self.view addSubview:imageView];
     
     //iOS 8.0
     /*
     模糊效果的三种风格
     第三方
     LBBlurredImage
     
     @param UIBlurEffectStyle
     
     UIBlurEffectStyleExtraLight,  //高亮
     UIBlurEffectStyleLight,       //亮
     UIBlurEffectStyleDark         //暗
     
     
     UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
     UIVisualEffectView *effectView =[[UIVisualEffectView alloc]initWithEffect:blurEffect];
     effectView.frame = CGRectMake(imageView.frame.size.width/2,0,
     imageView.frame.size.width/2, imageView.frame.size.height);
     [self.view addSubview:effectView];
     */
    /*
     NSString *path = [[NSBundle mainBundle]pathForResource:@"image"ofType:@"jpg"];
     
     UIImage *image = [UIImage imageWithContentsOfFile:path];
     
     self.view.layer.contents = (id)image.CGImage;
     */
    //   self.view.layer.contents = (id)[UIImage imageNamed:@"bg_1"].CGImage;
}

- (void)setResultVC {
    resultViewController *resultVC = [[resultViewController alloc] initWithSearchBar:self.searchBar];
    resultVC.delegate = self;
    resultVC.view.frame = CGRectMake(0, 88, ScreenW, ScreenH - 88);
    resultVC.view.hidden = YES;
    [self.view addSubview:resultVC.view];
    self.resultVC = resultVC;
}

- (void)downBtnClick {
    searchViewController *vc = [[searchViewController alloc] initWithLocalSong];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - resultViewControllerDelegate
- (void)playSong:(songData *)data {
    playViewController *vc = [[playViewController alloc] initWithSongData:data];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
