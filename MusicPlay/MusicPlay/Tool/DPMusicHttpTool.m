//
//  DPMusicHttpTool.m
//  MusicPlay
//
//  Created by 朱力珅 on 2019/4/25.
//  Copyright © 2019 朱力珅. All rights reserved.
//

#import "DPMusicHttpTool.h"
#import "DPRealmOperation.h"
#import <MJExtension/MJExtension.h>

@interface DPMusicHttpTool()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation DPMusicHttpTool

+ (id)shareTool {
    return [[self alloc] init];
}

static DPMusicHttpTool *instace = nil;
static dispatch_once_t token;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    dispatch_once(&token, ^{
        instace = [super allocWithZone:zone];
        if(instace){
  
        }
    });
    return instace;
}

//销毁单例
+ (void)destroyInstance{
    token = 0;
    instace = nil;
}

- (void)searchMusicWithKeyWord:(NSString *)keyWord pageCount:(NSInteger)page success:(void(^)(NSArray<songData *> *songDataArray, BOOL noData))success failure:(void(^)(NSError *error))failure {
    //错误1
    NSString *searchStr = [NSString stringWithFormat:@"https://c.y.qq.com/soso/fcgi-bin/client_search_cp?aggr=1&cr=1&flag_qc=0&p=%ld&n=30&w=%@",page, keyWord];
    //进行编码
    NSString *encodeSearchStr = [searchStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"%@",encodeSearchStr);
    //  application/x-javascript
    //错误3
    //要点: 进行数据解析。
    [self.manager GET:encodeSearchStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray<songData *> *songDataArray = [NSMutableArray array];
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSError *err;
        string = [string substringWithRange:NSMakeRange(0, string.length - 1)];
        string = [string substringFromIndex:9];
        id dict = [NSJSONSerialization  JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&err];
        BOOL noData = YES;
        if(!err){
            NSArray *baseArray = dict[@"data"][@"song"][@"list"];
            if(baseArray.count > 0){
                noData = NO;
            }
            for(NSDictionary *dataDic in baseArray){
                songData *data = [songData mj_objectWithKeyValues:dataDic];
                if(![data.songmid isEqualToString:@""] && data.songmid != nil){
                    DPLocalMusicObject *obj = [[DPRealmOperation shareOperation] queryWithSongid:data.songid];
                    data.isDownload = obj.isDownload;
                    data.playURL = obj.playURL;
                    if(obj.isDownload){
                        data.localFileURL = obj.localFileURL;
                        if(obj.lyricObject){
                            [DPMusicPlayTool encodQQLyric:obj.lyricObject.baseLyricl complete:^(NSArray * _Nonnull timeArray, NSArray * _Nonnull lyricArray, NSString * _Nonnull baseLyric, BOOL isRoll) {
                                lyricModel *model = [[lyricModel alloc] initWithTimeArray:timeArray lyricArray:lyricArray baseLyric:obj.lyricObject.baseLyricl isRoll:isRoll lyricConect:obj.lyricObject.lyricConnect lyricID:data.songid];
                                data.lyricObject = model;
                            }];
                        }
                    }
                    [songDataArray addObject:data];
                }
            }
        }else{
            NSLog(@"出现错误:%@",err);
        }
        success(songDataArray, noData);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        failure(error);
    }];
}

- (void)getTopMusicSuccess:(void(^)(NSArray<songData *> *songDataArray, BOOL noData))success failure:(void(^)(NSError *error))failure {
    NSString *url = @"https://c.y.qq.com/v8/fcg-bin/fcg_v8_toplist_cp.fcg?g_tk=5381&uin=0&format=json&inCharset=utf-8&outCharset=utf-8¬ice=0&platform=h5&needNewCode=1&tpl=3&page=detail&type=top&topid=27&_=1519963122923";
    NSString *encodeStr = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self.manager GET:encodeStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray<songData *> *songDataArray = [NSMutableArray array];
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSError *err;
        id dict = [NSJSONSerialization  JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&err];
        BOOL noData = YES;
        if(!err){
            NSArray *baseArray = dict[@"songlist"];
            if(baseArray.count > 0){
                noData = NO;
            }
            for(NSDictionary *dataDic in baseArray){
                songData *data = [songData mj_objectWithKeyValues:dataDic[@"data"]];
                if(![data.songmid isEqualToString:@""] && data.songmid != nil){
                    DPLocalMusicObject *obj = [[DPRealmOperation shareOperation] queryWithSongid:data.songid];
                    data.isDownload = obj.isDownload;
                    data.playURL = obj.playURL;
                    if(obj.isDownload){
                        data.localFileURL = obj.localFileURL;
                        if(obj.lyricObject){
                            [DPMusicPlayTool encodQQLyric:obj.lyricObject.baseLyricl complete:^(NSArray * _Nonnull timeArray, NSArray * _Nonnull lyricArray, NSString * _Nonnull baseLyric, BOOL isRoll) {
                                lyricModel *model = [[lyricModel alloc] initWithTimeArray:timeArray lyricArray:lyricArray baseLyric:obj.lyricObject.baseLyricl isRoll:isRoll lyricConect:obj.lyricObject.lyricConnect lyricID:data.songid];
                                data.lyricObject = model;
                            }];
                        }
                    }
                    [songDataArray addObject:data];
                }
            }
        }else{
            NSLog(@"出现错误:%@",err);
        }
        success(songDataArray, noData);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        failure(error);
    }];
}

- (void)getRandomMusicSuccess:(void(^)(NSArray<songData *> *songDataArray, BOOL noData))success failure:(void(^)(NSError *error))failure {
    NSString *url = @"https://c.y.qq.com/v8/fcg-bin/fcg_v8_toplist_cp.fcg?g_tk=5381&uin=0&format=json&inCharset=utf-8&outCharset=utf-8¬ice=0&platform=h5&needNewCode=1&tpl=3&page=detail&type=top&topid=36&_=1520777874472";
    NSString *encodeStr = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self.manager GET:encodeStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray<songData *> *songDataArray = [NSMutableArray array];
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSError *err;
        id dict = [NSJSONSerialization  JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&err];
        BOOL noData = YES;
        if(!err){
            NSArray *baseArray = dict[@"songlist"];
            if(baseArray.count > 0){
                noData = NO;
            }
            for(NSDictionary *dataDic in baseArray){
                songData *data = [songData mj_objectWithKeyValues:dataDic[@"data"]];
                if(![data.songmid isEqualToString:@""] && data.songmid != nil){
                    DPLocalMusicObject *obj = [[DPRealmOperation shareOperation] queryWithSongid:data.songid];
                    data.isDownload = obj.isDownload;
                    data.playURL = obj.playURL;
                    if(obj.isDownload){
                        data.localFileURL = obj.localFileURL;
                        if(obj.lyricObject){
                            [DPMusicPlayTool encodQQLyric:obj.lyricObject.baseLyricl complete:^(NSArray * _Nonnull timeArray, NSArray * _Nonnull lyricArray, NSString * _Nonnull baseLyric, BOOL isRoll) {
                                lyricModel *model = [[lyricModel alloc] initWithTimeArray:timeArray lyricArray:lyricArray baseLyric:obj.lyricObject.baseLyricl isRoll:isRoll lyricConect:obj.lyricObject.lyricConnect lyricID:data.songid];
                                data.lyricObject = model;
                            }];
                        }
                    }
                    [songDataArray addObject:data];
                }
            }
        }else{
            NSLog(@"出现错误:%@",err);
        }
        success(songDataArray, noData);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        failure(error);
    }];
}

- (void)getPlayURLWith:(songData *)data success:(void(^)(NSString *playURL))success failure:(void(^)(NSError *error))failure {
    NSString *songMid = data.songmid;
    NSString *playTokenURL = [NSString stringWithFormat:@"https://c.y.qq.com/base/fcgi-bin/fcg_music_express_mobile3.fcg?format=json205361747&platform=yqq&cid=205361747&songmid=%@&filename=C400%@.m4a&guid=126548448",songMid,songMid];
    NSString *fileName = [NSString stringWithFormat:@"C400%@.m4a",songMid];
    [self.manager GET:playTokenURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *playString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",playString);
        NSError *err2;
        id dict2 = [NSJSONSerialization  JSONObjectWithData:[playString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&err2];
        NSString *playKey = dict2[@"data"][@"items"][0][@"vkey"];
        if(playKey){
            NSString *playkeyUrl = [NSString stringWithFormat:@"http://ws.stream.qqmusic.qq.com/%@?fromtag=0&guid=126548448&vkey=%@",fileName,playKey];
            success(playkeyUrl);
        }else{
            success(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)getLyricWithSongData:(songData *)data complete:(void (^)(lyricModel *lyric))complete {
     NSString *lyricStr = [NSString stringWithFormat:@"https://c.y.qq.com/lyric/fcgi-bin/fcg_query_lyric_new.fcg?callback=MusicJsonCallback_lrc&pcachetime=1494070301711&songmid=%@&g_tk=5381&jsonpCallback=MusicJsonCallback_lrc&loginUin=0&hostUin=0&format=jsonp&inCharset=utf8&outCharset=utf-8¬ice=0&platform=yqq&needNewCode=0",data.songmid];
       NSString *encodeStr = [lyricStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self.manager GET:encodeStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        string = [string substringWithRange:NSMakeRange(22, string.length - 23)];
        id dict2 = [NSJSONSerialization  JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        [DPMusicPlayTool encodQQLyric:[dict2 objectForKey:@"lyric"] complete:^(NSArray * _Nonnull timeArray, NSArray * _Nonnull lyricArray, NSString * _Nonnull baseLyric, BOOL isRoll) {
            lyricModel *model = [[lyricModel alloc] initWithTimeArray:timeArray lyricArray:lyricArray baseLyric:baseLyric isRoll:isRoll lyricConect:YES lyricID:data.songid];
            complete(model);
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *lyricStr = @"未找到歌词";
        NSString *timeStr = @"0";
        lyricModel *model = [[lyricModel alloc] initWithTimeArray:@[timeStr] lyricArray:@[lyricStr] baseLyric:@"" isRoll:NO lyricConect:NO lyricID:data.songid];
        complete(model);
    }];
}

//懒加载
- (AFHTTPSessionManager *)manager {
    if(!_manager){
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = 10;
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
        //错误2
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/javascript",@"application/json",@"text/json",@"text/plain",@"application/x-javascript",nil];
        [manager.requestSerializer setValue:@"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.110 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
        [manager.requestSerializer setValue:@"*/*" forHTTPHeaderField:@"Accept"];
        [manager.requestSerializer setValue:@"https://y.qq.com/portal/player.html" forHTTPHeaderField:@"Referer"];
        [manager.requestSerializer setValue:@"zh-CN,zh;q=0.8" forHTTPHeaderField:@"Accept-Language"];
        [manager.requestSerializer setValue:@"pgv_pvid=8455821612; ts_uid=1596880404; pgv_pvi=9708980224; yq_index=0; pgv_si=s3191448576; pgv_info=ssid=s8059271672; ts_refer=ADTAGmyqq; yq_playdata=s; ts_last=y.qq.com/portal/player.html; yqq_stat=0; yq_playschange=0; player_exist=1; qqmusic_fromtag=66; yplayer_open=1" forHTTPHeaderField:@"Cookie"];
        [manager.requestSerializer setValue:@"c.y.qq.com" forHTTPHeaderField:@"Host"];
        _manager = manager;
    }
    return _manager;
}

@end
