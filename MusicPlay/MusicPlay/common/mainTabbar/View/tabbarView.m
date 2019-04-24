//
//  tabbarView.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/25.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "tabbarView.h"

@interface tabbarView()

@property (nonatomic, strong)UILabel *songNameLabel;

@property (nonatomic, strong)UILabel *nextLabel;

@end

@implementation tabbarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        [self setInterface];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(songChange) name:DPMusicChange object:nil];
    }
    return self;
}

- (void)setInterface {
    UILabel *songNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 200, 15)];
    [self addSubview:songNameLabel];
    songNameLabel.font = [UIFont systemFontOfSize:14];
    self.songNameLabel = songNameLabel;
    
    UILabel *nextLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 30, 200, 15)];
    nextLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:nextLabel];
    self.nextLabel = nextLabel;
}

- (void)songChange {
    self.songNameLabel.text = [[playManager sharedPlay] songData].songname;
    self.nextLabel.text =  [[playManager sharedPlay] songData].singerArray[0].name;
}

@end
