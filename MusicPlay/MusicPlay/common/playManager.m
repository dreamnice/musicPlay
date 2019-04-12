//
//  playTool.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/3/13.
//  Copyright © 2019 朱力珅. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>

@interface playManager (){
    BOOL isPlay;
}

@property (nonatomic, strong) AVPlayer *myPlayer;

@property (nonatomic, strong) AVPlayerItem *currentItem;

@property (nonatomic, copy) NSString *currentURL;

@property (nonatomic, strong) NSMutableArray <songData *>*songListArray;

@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation playManager

#pragma mark - init

+ (id)sharedPlay {
    return [[self alloc] init];
}

static id instace;
static dispatch_once_t token;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    dispatch_once(&token, ^{
        instace = [super allocWithZone:zone];
        //设置AVAudioSession后台播放
        AVAudioSession *session = [AVAudioSession  sharedInstance];
        [session setActive:YES error:nil];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    });
    return instace;
}

- (instancetype)copyWithZone:(NSZone *)zone{
    return instace;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone{
    return instace;
}

//销毁单例
+ (void)destroyInstance{
    token = 0;
    instace = nil;
}

- (void)dealloc{
    NSLog(@"单例已销毁");
}

#pragma mark - methoes

- (void)playWithURL:(NSString *)url{
    if(!url){
        return;
    }
    AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL URLWithString:url]];
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
    if(item){
        //添加观察者,观察播放动态
        [self.currentItem removeObserver:self forKeyPath:@"status" context:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.currentItem];
        self.currentItem = item;
        [self.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerFinish:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.currentItem];
        [self.myPlayer replaceCurrentItemWithPlayerItem:item];
    }else{
        return;
    }

}

- (void)playWithSong:(songData *)songData {
    baseSevice *seviceMangager = [baseSevice shareService];
    NSString *songMid = songData.songmid;
    NSString *playTokenURL = [NSString stringWithFormat:@"https://c.y.qq.com/base/fcgi-bin/fcg_music_express_mobile3.fcg?format=json205361747&platform=yqq&cid=205361747&songmid=%@&filename=C400%@.m4a&guid=126548448",songMid,songMid];
    NSString *fileName = [NSString stringWithFormat:@"C400%@.m4a",songMid];
    [seviceMangager.manager GET:playTokenURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *playString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",playString);
        NSError *err2;
        id dict2 = [NSJSONSerialization  JSONObjectWithData:[playString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&err2];
        NSString *playKey = dict2[@"data"][@"items"][0][@"vkey"];
        NSString *playkeyUrl = [NSString stringWithFormat:@"http://ws.stream.qqmusic.qq.com/%@?fromtag=0&guid=126548448&vkey=%@",fileName,playKey];
        [self playWithURL:playkeyUrl];
        self.songData = songData;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

/*笔记
 kvo检测播放状态
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] integerValue];
        if (status == AVPlayerItemStatusReadyToPlay) {
            NSLog(@"AVPlayerItemStatusReadyToPlay");
            NSLog(@"%f",CMTimeGetSeconds(self.currentItem.asset.duration));
            //当准备播放时开始播放
            [self myPlay];
        } else if (status == AVPlayerItemStatusUnknown) {
            NSLog(@"AVPlayerItemStatusUnknown");
        } else if (status == AVPlayerItemStatusFailed) {
            NSLog(@"AVPlayerItemStatusFailed");
        }
    }
}

//开始播放
- (void)myPlay{
    isPlay = YES;
    [self.myPlayer play];
}

//暂停
- (void)myPause {
    if(isPlay){
        isPlay = NO;
        [self.myPlayer pause];
    }
}

//下一首歌
- (void)nextSong {
    if(self.currentIndex >= self.songListArray.count - 1){
        self.currentIndex = 0;
    }else{
        self.currentIndex += 1;
    }
    [self changeSong:self.currentIndex];
}

//上一首歌
- (void)lastSong {
    if(self.currentIndex <= 0){
        self.currentIndex = self.songListArray.count - 1;
    }else{
        self.currentIndex -= 1;
    }
    [self changeSong:self.currentIndex];
}

//跳转至指定index歌曲
- (void)changeSong:(NSInteger)songIndex {
    if([self.delegate respondsToSelector:@selector(changeSong:)]){
        [self.delegate changeSong:self.songListArray[songIndex]];
        [self myPause];
        [self playWithSong:self.songListArray[songIndex]];
    }
}

//添加歌曲列表
- (void)getSongList:(NSArray <songData *>*)listArray currentIndex:(NSInteger)index{
    self.currentIndex = index;
    self.songListArray = [listArray mutableCopy];;
}

//更新歌曲列表
- (void)addSongList:(NSArray <songData *>*)listArray {
    [self.songListArray addObjectsFromArray:listArray];
}

//结束播放
- (void)playerFinish:(NSNotification *)notice {
    [self nextSong];
}

- (AVPlayer *)myPlayer{
    if(!_myPlayer){
        _myPlayer = [[AVPlayer alloc] init];
        /*笔记
         添加每秒回调
         */
        __weak __typeof__(self) weakself = self;
        [_myPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:nil usingBlock:^(CMTime time){
            // NSLog(@"%f",CMTimeGetSeconds(time));
            NSNumber *num = [NSNumber numberWithInteger:CMTimeGetSeconds(time)];
            if([weakself.delegate respondsToSelector:@selector(getCurrentTime:)]){
                [weakself.delegate getCurrentTime:num];
            }
        }];
    }
    return _myPlayer;
}

//懒加载
- (NSMutableArray <songData *>*)songListArray {
    if(_songListArray == nil){
        _songListArray = [NSMutableArray array];
    }
    return _songListArray;
}
@end
