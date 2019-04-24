//
//  playTool.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/3/13.
//  Copyright © 2019 朱力珅. All rights reserved.
//


/*
 NowPlayingCenter的刷新时机
 频繁的刷新NowPlayingCenter并不可取，特别是在有Artwork的情况下。所以需要在合适的时候进行刷新。
 依照我自己的经验下面几个情况下刷新NowPlayingCenter比较合适：
 当前播放歌曲进度被拖动时
 当前播放的歌曲变化时
 播放暂停或者恢复时
 当前播放歌曲的信息发生变化时（例如Artwork，duration等）
 在刷新时可以适当的通过判断app是否active来决定是否必须刷新以减少刷新次数。
 */

#import <AVFoundation/AVFoundation.h>

@interface playManager (){

    BOOL nextOrLast;
    BOOL connectFail;
    NSInteger failCount;
}

@property (nonatomic, strong) AVPlayer *myPlayer;

@property (nonatomic, strong) AVPlayerItem *currentItem;

@property (nonatomic, copy) NSString *currentURL;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign) BOOL isChange;

@property (nonatomic, strong) NSMutableDictionary *remoteDic;

@property (nonatomic, assign) double currentTime;

@property (nonatomic, assign) double TotleTime;

@property (nonatomic, strong) NSMutableArray <songData *>*songListArray;

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
        if(instace){
            [instace remoteControlEventHandler];
        }
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
//外部调用方法
- (void)playWithSong:(songData *)songData {
    [self playInClassWithSong:songData];
    failCount = 0;
}

- (void)playInClassWithSong:(songData *)songData {
    _songData = songData;
    [[NSNotificationCenter defaultCenter] postNotificationName:DPMusicChange object:_songData];
    self.TotleTime = self.songData.interval;
    self.currentTime = 0;
    [self setNowPlayingInfo];
    if(songData.localFileURL != nil){
        [self playWithFileURL:songData.localFileURL];
    }else{
        if(songData.playURL != nil){
            [self playWithURL:songData.playURL];
        }else{
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
                if(playKey != nil && !([[playKey stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] == 0)){
                    songData.playURL = playkeyUrl;
                }
                [self playWithURL:playkeyUrl];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //链接失败
                self->connectFail = YES;
            }];
        }
    }
}

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

- (void)playWithFileURL:(NSString *)fileURL {
    if(!fileURL){
        return;
    }
    AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:fileURL]];
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

/*笔记
 kvo检测播放状态
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    self.songData.interval = CMTimeGetSeconds(self.currentItem.asset.duration);
    if(self.TotleTime != self.songData.interval){
        self.TotleTime = self.songData.interval;
        //设置总时长
        [self.remoteDic setObject:[NSNumber numberWithDouble:self.songData.interval] forKey:MPMediaItemPropertyPlaybackDuration];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:self.remoteDic];
    }
    if(connectFail){
        MPMediaItemArtwork *artImage = [[MPMediaItemArtwork alloc] initWithBoundsSize:CGSizeMake(300, 300) requestHandler:^UIImage * _Nonnull(CGSize size) {
            NSString *imageURL = [NSString stringWithFormat:@"https://y.gtimg.cn/music/photo_new/T002R300x300M000%@.jpg",self.songData.albummid];
            NSString *encodeURL = [imageURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:encodeURL]];
            UIImage *image = [UIImage imageWithData:data];
            return image;
        }];
        [self.remoteDic setObject:artImage forKey:MPMediaItemPropertyArtwork];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:self.remoteDic];
        connectFail = NO;
    }
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] integerValue];
        if (status == AVPlayerItemStatusReadyToPlay) {
            NSLog(@"AVPlayerItemStatusReadyToPlay");
            NSLog(@"%f",CMTimeGetSeconds(self.currentItem.asset.duration));
            failCount = 0;
            //当准备播放时开始播放
            [self myPlay];
        }else{
            //设置自动跳转次数
            connectFail = YES;
            failCount += 1;
            if(failCount < 2){
                if(nextOrLast){
                    [self lastSong];
                }else{
                    [self nextSong];
                }
            }
        }
    }
}

//开始播放
- (void)myPlay{
    if(connectFail){
        [self playInClassWithSong:self.songListArray[self.currentIndex]];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:DPMusicPlay object:self.songData];
        _isPlay = YES;
        [self.myPlayer play];
        [self.remoteDic setObject:[NSNumber numberWithDouble:CMTimeGetSeconds(self.myPlayer.currentTime)] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        [self.remoteDic setObject:[NSNumber numberWithFloat:1.0] forKey:MPNowPlayingInfoPropertyPlaybackRate];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:self.remoteDic];
    }
}

//暂停
- (void)myPause {
    [[NSNotificationCenter defaultCenter] postNotificationName:DPMusicPause object:self.songData];
    _isPlay = NO;
    [self.myPlayer pause];
    //设置当前时长
    [self.remoteDic setObject:[NSNumber numberWithDouble:CMTimeGetSeconds(self.myPlayer.currentTime)] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    [self.remoteDic setObject:[NSNumber numberWithFloat:0.0] forKey:MPNowPlayingInfoPropertyPlaybackRate];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:self.remoteDic];
}

//暂停
- (void)myChangeSongPause {
    _isPlay = NO;
    [self.myPlayer pause];
}

//用于线控
- (void)playAndpayse {
    if(_isPlay){
        [self myPause];
    }else{
        [self myPlay];
    }
}

//下一首歌
- (void)nextSong {
    nextOrLast = NO;
    if(self.currentIndex >= self.songListArray.count - 1){
        self.currentIndex = 0;
    }else{
        self.currentIndex += 1;
    }
    [self changeSong:self.currentIndex];
}

//上一首歌
- (void)lastSong {
    nextOrLast = YES;
    if(self.currentIndex <= 0){
        self.currentIndex = self.songListArray.count - 1;
    }else{
        self.currentIndex -= 1;
    }
    [self changeSong:self.currentIndex];
}

//结束播放
- (void)playerFinish:(NSNotification *)notice {
    [self nextSong];
}

//跳转至指定index歌曲
- (void)changeSong:(NSInteger)songIndex {
    [self myChangeSongPause];
    [self playInClassWithSong:self.songListArray[songIndex]];
    if([self.delegate respondsToSelector:@selector(changeSong:)]){
        [self.delegate changeSong:self.songListArray[songIndex]];
    }
}

//调整歌曲进度
- (void)changeSongProgress:(float)value {
    [self myPause];
    float time = self.songData.interval * value;
    __weak __typeof__(self) weakself = self;
    [self.myPlayer seekToTime:CMTimeMake(time, 1) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        weakself.isChange = !finished;
        [weakself myPlay];
    }];
}

- (void)changeSongProgressInLock:(float)value {
    [self myPause];
    __weak __typeof__(self) weakself = self;
    [self.myPlayer seekToTime:CMTimeMake(value, 1) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        weakself.isChange = !finished;
        [weakself myPlay];
    }];
}

//设置改变状态(命名坑,写成set方法了)
- (void)setIsChangeState:(BOOL)change {
    self.isChange = change;
}

//添加歌曲列表
- (void)getSongList:(NSArray <songData *>*)listArray currentIndex:(NSInteger)index {
    self.currentIndex = index;
    self.songListArray = [listArray mutableCopy];;
}

//更新歌曲列表
- (void)addSongList:(NSArray <songData *>*)listArray {
    [self.songListArray addObjectsFromArray:listArray];
}

//设置远程控制
- (void)remoteControlEventHandler {
    __weak __typeof__(self) weakself = self;
    // 直接使用sharedCommandCenter来获取MPRemoteCommandCenter的shared实例
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    // 启用播放命令 (锁屏界面和上拉快捷功能菜单处的播放按钮触发的命令)
    commandCenter.playCommand.enabled = YES;
    // 为播放命令添加响应事件, 在点击后触发
    [commandCenter.playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        [weakself myPlay];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    // 播放, 暂停, 上下曲的命令默认都是启用状态, 即enabled默认为YES
    [commandCenter.pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        //点击了暂停
        [weakself myPause];
        return MPRemoteCommandHandlerStatusSuccess;
    }];

    [commandCenter.previousTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        [weakself lastSong];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [commandCenter.nextTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        [weakself nextSong];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    // 启用耳机的播放/暂停命令 (耳机上的播放按钮触发的命令)
    commandCenter.togglePlayPauseCommand.enabled = YES;
    // 为耳机的按钮操作添加相关的响应事件
    [commandCenter.togglePlayPauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        // 进行播放/暂停的相关操作 (耳机的播放/暂停按钮)
        [weakself playAndpayse];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    //拖动进度条
    [commandCenter.changePlaybackPositionCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        MPChangePlaybackPositionCommandEvent * playbackPositionEvent = (MPChangePlaybackPositionCommandEvent *)event;
        [weakself changeSongProgressInLock:playbackPositionEvent.positionTime];
        if([weakself.delegate respondsToSelector:@selector(remoteControlProgress:)]){
            [weakself.delegate remoteControlProgress:playbackPositionEvent.positionTime];
        }
        return MPRemoteCommandHandlerStatusSuccess;
    }];
}

//设置展示信息
- (void)setNowPlayingInfo {
    //笔记,各种type代表什么意思
    //设置标题
    [self.remoteDic setObject:self.songData.songname forKey:MPMediaItemPropertyTitle];
    //设置歌手
    if(self.songData.singerArray != nil && self.songData.singerArray.count >= 1){
        [self.remoteDic setObject:self.songData.singerArray[0].name forKey:MPMediaItemPropertyArtist];
    }else{
        [self.remoteDic setObject:@"未知歌手" forKey:MPMediaItemPropertyArtist];
    }
    //设置专辑
    [self.remoteDic setObject:self.songData.albumname forKey:MPMediaItemPropertyAlbumTitle];
    //设置专辑封面
    MPMediaItemArtwork *artImage = [[MPMediaItemArtwork alloc] initWithBoundsSize:CGSizeMake(300, 300) requestHandler:^UIImage * _Nonnull(CGSize size) {
        NSString *imageURL = [NSString stringWithFormat:@"https://y.gtimg.cn/music/photo_new/T002R300x300M000%@.jpg",self.songData.albummid];
        NSString *encodeURL = [imageURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:encodeURL]];
        UIImage *image = [UIImage imageWithData:data];
        return image;
    }];
    [self.remoteDic setObject:artImage forKey:MPMediaItemPropertyArtwork];
    //设置总时长
    [self.remoteDic setObject:[NSNumber numberWithDouble:self.songData.interval] forKey:MPMediaItemPropertyPlaybackDuration];
    //设置当前时长
    [self.remoteDic setObject:[NSNumber numberWithDouble:0] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    //设置时间速度
    [self.remoteDic setObject:[NSNumber numberWithFloat:0.0] forKey:MPNowPlayingInfoPropertyPlaybackRate];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:self.remoteDic];
}

#pragma mark - 懒加载
- (AVPlayer *)myPlayer{
    if(!_myPlayer){
        _myPlayer = [[AVPlayer alloc] init];
        /*笔记
         添加每秒回调
         */
        __weak __typeof__(self) weakself = self;
        [_myPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:nil usingBlock:^(CMTime time){
            NSLog(@"%f",CMTimeGetSeconds(time));
            weakself.currentTime = CMTimeGetSeconds(time);
            //+0.5防止重复计数
            NSNumber *num = [NSNumber numberWithFloat:CMTimeGetSeconds(time) + 0.5];
            if([weakself.delegate respondsToSelector:@selector(getCurrentTime:isChange:)]){
                [weakself.delegate getCurrentTime:num isChange:weakself.isChange];
            }
        }];
    }
    return _myPlayer;
}

- (NSMutableArray <songData *>*)songListArray {
    if(_songListArray == nil){
        _songListArray = [NSMutableArray array];
    }
    return _songListArray;
}

- (NSMutableDictionary *)remoteDic {
    if(_remoteDic == nil){
        _remoteDic = [NSMutableDictionary dictionary];
    }
    return _remoteDic;
}
@end
