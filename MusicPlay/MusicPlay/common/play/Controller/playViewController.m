//
//  playViewController.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/3/14.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "playViewController.h"
#import "songData.h"

@interface playViewController ()

@property (nonatomic, strong) songData *song;

@end

@implementation playViewController

- (instancetype)initWithSongData:(songData *)song {
    self = [super init];
    if(self){
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

@end
