//
//  homePageViewController.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/24.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "homePageViewController.h"
#import "localMusicViewController.h"
#import "netMusicViewController.h"
#import "resultViewController.h"

#import "songSearchBar.h"
#import "homeInfoView.h"

#import <Masonry.h>

@interface homePageViewController ()<UISearchBarDelegate, resultViewControllerDelegate, homeInfoViewDelegate>


@property (nonatomic, strong) songSearchBar *searchBar;

@property (nonatomic, strong) UIView *resultView;

@property (nonatomic, strong) resultViewController *resultVC;

@end

@implementation homePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    homeInfoView *infoView = [[homeInfoView alloc] init];
    infoView.delegate = self;
    [self.view addSubview:infoView];
    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerY.centerX.equalTo(self.view);
        make.height.mas_equalTo(200);
    }];

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
}

- (void)setResultVC {
    resultViewController *resultVC = [[resultViewController alloc] initWithSearchBar:self.searchBar];
    resultVC.delegate = self;
    resultVC.view.frame = CGRectMake(0, Navi_Height, ScreenW, ScreenH - Navi_Height - TabBar_Height);
    resultVC.view.hidden = YES;
    [self.view addSubview:resultVC.view];
    self.resultVC = resultVC;
}

#pragma mark - homeInfoViewDelegate
- (void)downClick {
    localMusicViewController *vc = [[localMusicViewController alloc] initWithLocalSong];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)topClick {
    netMusicViewController *vc = [[netMusicViewController alloc] initWithNetMusicType:DPTopMusicType];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)randomClick {
    netMusicViewController *vc = [[netMusicViewController alloc] initWithNetMusicType:DPRandomMusicType];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
