//
//  EmotionStoreManager.m
//  ql
//
//  Created by LazySnail on 14-8-21.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "EmotionStoreManager.h"
#import "NetManager.h"
#import "HttpRequest.h"
#import "emoticon_store_info_model.h"
#import "emoticon_list_model.h"
#import "emoticon_detail_info_model.h"
#import "emoticon_item_list_model.h"
#import "NSDictionary+URLJointExtension.h"
#import "SBJson.h"
#import "EmotionStoreData.h"

#import "ZipArchive.h"

typedef enum{
    CustomEmoticonModifySignDownload = 1,
    CustomEmoticonModifySignDelete = 2,
}CustomEmoticonModifySign;

@interface EmotionStoreManager () <HttpRequestDelegate,ZipArchiveDelegate>
{
    
}

@property (nonatomic,retain) NSMutableArray * downloadProgressArr;

@property (nonatomic,retain) EmotionStoreData *emoticonData;

@end

@implementation EmotionStoreManager

- (instancetype)init
{
    self =  [super init];
    if (self) {
    }
    return self;
}

- (void)getEmotionStoreDataDic
{
    NSString * requestStr = @"emoticon/list.do?param=";
    NSNumber * userIDNum = [[Global sharedGlobal]user_id];
    
    NSDictionary * latestStoreInfoDic =[emoticon_store_info_model getLatestData];
    NSNumber * timeSign = [latestStoreInfoDic objectForKey:@"ts"];
    if (timeSign == nil) {
        timeSign = [NSNumber numberWithInt:0];
    }

    NSMutableDictionary * requestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 userIDNum,@"user_id",
                                 timeSign,@"ts",
                                 nil];
    
    [[NetManager sharedManager]accessService:requestDic data:nil command:CHAT_EMOTION_STORE_GET_INFO_COMMAND_ID accessAdress:requestStr delegate:self withParam:nil];
}

- (void)getemotionDetailDataForEmotionID:(NSInteger)emotionID
{
    NSString * requestStr = @"emoticon/detail.do?param=";
    NSNumber * userIDNum = [[Global sharedGlobal]user_id];
    NSDictionary * detailInfoDic = [emoticon_detail_info_model getLatestDetailInfoDic];
    NSNumber * timeSign = [detailInfoDic objectForKey:@"ts"];
    if (timeSign.intValue == 0 || timeSign == nil) {
        timeSign = [NSNumber numberWithInt:0];
    }
    
    NSNumber * emotionIDNum = [NSNumber numberWithInt:emotionID];
    
    NSMutableDictionary * requestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        userIDNum,@"user_id",
                                        timeSign,@"ts",
                                        emotionIDNum,@"emoticon_id",
                                        nil];
    [[NetManager sharedManager]accessService:requestDic data:nil command:CHAT_EMOTION_DETAIL_COMMAND_ID accessAdress:requestStr delegate:self withParam:nil];
}

- (void)sendDownloadModifySign:(CustomEmoticonModifySign)theSign andEmotionID:(NSInteger)emoticonID
{
    NSString *requestStr = @"emoticon/ops.do?param=";
    NSNumber *modifySignNum = [NSNumber numberWithInt:theSign];
    NSNumber *userIDNum = [[Global sharedGlobal]user_id];
    NSMutableDictionary * requestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        userIDNum,@"user_id",
                                        modifySignNum,@"ops",
                                        [NSNumber numberWithInt:emoticonID],@"emoticon_id",
                                        nil];
    [[NetManager sharedManager]accessService:requestDic data:nil command:CHAT_EMOTICON_MODIFY_COMMAND_ID accessAdress:requestStr delegate:self withParam:requestDic];
}

- (BOOL)judgeFirstInstallAndLoadDownloadedEmoticon
{
    NSDictionary * emoticonDic = [emoticon_store_info_model getLatestData];
    NSNumber * timeStamp = [emoticonDic objectForKey:@"ts"];
    if (timeStamp.intValue == 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self getEmotionStoreDataDic];
        });
        return YES;
    }
    return NO;
}

- (BOOL)judgeShouldAndLoadDownloadedDetailEmoticonWithEmoticonID:(NSInteger)emoticonID;
{
     NSMutableArray * itemArr = [emoticon_item_list_model getAllItemWithEmoticonID:emoticonID];
    if (itemArr.count == 0) {
        [self getemotionDetailDataForEmotionID:emoticonID];
        return YES;
    }
    return NO;
}

#pragma mark - HttpRequestDelegate

- (void)didFinishCommand:(NSMutableArray *)resultArray cmd:(int)commandid withVersion:(int)ver
{
    
    ParseMethod method = ^(){
        NSLog(@"%@",resultArray);
        NSDictionary * resultDic = [resultArray firstObject];
        switch (commandid) {
            case CHAT_EMOTION_STORE_GET_INFO_COMMAND_ID:
            {
               
                NSMutableDictionary * emoticonStoreInfoDic = [NSMutableDictionary dictionaryWithDictionary:resultDic];
                NSArray * emoticonsArr = [emoticonStoreInfoDic objectForKey:@"emoticons"];
                [emoticonStoreInfoDic removeObjectForKey:@"emoticons"];
                
                NSString * resPath = [emoticonStoreInfoDic objectForKey:@"res_path"];
                NSArray * thumbnailsArr = [emoticonStoreInfoDic objectForKey:@"thumbnails"];
                NSMutableArray * wholeThumbnailsArr = [[NSMutableArray alloc]initWithCapacity:3];
                for (NSString * thumbnailStr in thumbnailsArr) {
                    NSString * wholeThumbnailStr = [NSString stringWithFormat:@"%@%@",resPath,thumbnailStr];
                    [wholeThumbnailsArr addObject:wholeThumbnailStr];
                }
                [emoticonStoreInfoDic removeObjectForKey:@"thumbnails"];
                [emoticonStoreInfoDic setObject:[wholeThumbnailsArr JSONRepresentation]forKey:@"thumbnails"];
                [emoticon_store_info_model insertDataWithDic:emoticonStoreInfoDic];
                
                for (NSDictionary * emoticonDic in emoticonsArr) {
                    NSMutableDictionary * wholeUrlDic = [emoticonDic jointUrlHeadStr:resPath forDicKeys:@"chat_icon",@"icon",@"packet_path",nil];
                    [emoticon_list_model insertOrUpdateListWithDic:wholeUrlDic];
                }
                
                if (self.delegate != nil && [self.delegate respondsToSelector:@selector(getEmotionStoreDataSuccessWithDic:sender:)]) {
                    [self.delegate getEmotionStoreDataSuccessWithDic:resultDic sender:self];
                }
            }
                break;
            case CHAT_EMOTION_DETAIL_COMMAND_ID:
            {
                NSLog(@"%@",resultArray);
                NSDictionary * resultDic = [resultArray firstObject];
                NSString * resPath = [resultDic objectForKey:@"res_path"];
                
                NSMutableDictionary * emoticonDic = [NSMutableDictionary dictionaryWithDictionary:[resultDic objectForKey:@"emoticon"]];
                
                if ([emoticonDic objectForKey:@"thumbnail"] != nil) {
                    NSMutableDictionary * wholeUrlDic = [emoticonDic jointUrlHeadStr:resPath forDicKeys:@"thumbnail",@"thumbnail1",@"thumbnail2",nil];
                    
                    NSMutableArray * thumbnails = [NSMutableArray arrayWithCapacity:3];
                    NSString * thumbnail0 = [wholeUrlDic objectForKey:@"thumbnail"];
                    [wholeUrlDic removeObjectForKey:@"thumbnail"];
                    NSString * thumbnail1 = [wholeUrlDic objectForKey:@"thumbnail1"];
                    [wholeUrlDic removeObjectForKey:@"thumbnail1"];
                    NSString * thumbnail2 = [wholeUrlDic objectForKey:@"thumbnail2"];
                    [wholeUrlDic removeObjectForKey:@"thumbnail2"];
                    
                    
                    if (thumbnail0 != nil && ![thumbnail0 isEqualToString:@""]) {
                        [thumbnails addObject:thumbnail0];
                    }
                    
                    if (thumbnail1 != nil && ![thumbnail1 isEqualToString:@""]) {
                        [thumbnails addObject:thumbnail1];
                    }
                    
                    if (thumbnail2 != nil && ![thumbnail2 isEqualToString:@""]) {
                        [thumbnails addObject:thumbnail2];
                    }
                    
                    [wholeUrlDic setObject:[thumbnails JSONRepresentation] forKey:@"thumbnails"];
                    [wholeUrlDic setObject:resPath forKey:@"res_path"];
                    [wholeUrlDic setObject:[resultDic objectForKey:@"ts"] forKey:@"ts"];
                    [emoticon_detail_info_model insertEmoticonDetailInfoWithDic:wholeUrlDic];
                    
                    NSMutableArray * emoticonItemList = [NSMutableArray arrayWithArray:[resultDic objectForKey:@"list"]];
                    
                    for (NSDictionary *itemDic in emoticonItemList) {
                        
                        NSMutableDictionary * wholeDic =[itemDic jointUrlHeadStr:resPath forDicKeys:@"preview_icon",@"emoticon_path",nil];
                        [emoticon_item_list_model insertOrUpdateItemWithDic:wholeDic];
                    }
                    /**
                     * 测试用仿造数据
                     */
//                    NSDictionary *debugItem = [emoticonItemList firstObject];
//                    NSMutableDictionary *debugInsertDic = [NSMutableDictionary dictionaryWithDictionary:debugItem];
//                    [debugInsertDic removeObjectForKey:@"id"];
//                    [debugInsertDic setObject:[NSNumber numberWithInt:9] forKey:@"id"];
//                    [emoticon_item_list_model insertOrUpdateItemWithDic:debugInsertDic];                    
                }
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(getEmoticonDetailDataSuccessWithSender:)]) {
                    [self.delegate getEmoticonDetailDataSuccessWithSender:self];
                }
                [self.downloadProgressArr addObject:@"downloadDetailItem"];
                [self checkDownloadProgress];
                
                if (self.emoticonData != nil) {
                    [self sendDownloadModifySign:CustomEmoticonModifySignDownload andEmotionID:self.emoticonData.emoticonID];
                }
            }
                break;
            case CHAT_EMOTICON_MODIFY_COMMAND_ID:
            {
                if ([[resultDic objectForKey:@"ret"]intValue] == 1) {
                    [self.downloadProgressArr addObject:@"SendModifySignSuccess"];
                    [self checkDownloadProgress];
                } else {
                    [Common checkProgressHUDShowInAppKeyWindow:@"下载自定义表情异常" andImage:nil];
                }
               
            }
                break;
            default:
                break;
        }
    };
    
    [Common securelyparseHttpResultArr:resultArray andMethod:method];
}

-(void) downLoadEmotionWithParam:(EmotionStoreData *)data andBlock:(ProgressBlock)block progress:(UIProgressView *)pv
{
    self.emoticonData = data;
    self.downloadProgressArr = [[[NSMutableArray alloc]initWithCapacity:3]autorelease];
    
    ASIHTTPRequest* request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:data.packetPath]];
    request.delegate = self;
    request.downloadDestinationPath = [self getEmotionPath:[NSString stringWithFormat:@"%@.zip",data.packetName]];
    request.downloadProgressDelegate = pv;
    request.showAccurateProgress = YES;
    [request startAsynchronous];
    RELEASE_SAFE(request);
    block();
    
    //加载对应的详情数据
    [self getemotionDetailDataForEmotionID:data.emoticonID];
}

#pragma mark - asihttp
-(void) requestFinished:(ASIHTTPRequest *)request{
    [self unzipEmoticonPath:[self getEmotionPath:self.emoticonData.packetName]];
    
}

-(void) requestFailed:(ASIHTTPRequest *)request{
    if (_delegate && [_delegate respondsToSelector:@selector(dowmLoadEmotionFailed)]) {
        [_delegate dowmLoadEmotionFailed];
        
        [self updateEmotionListStatus:0];
    }
}

//更改list表的status状态
-(void) updateEmotionListStatus:(int) status{
    [emoticon_list_model insertOrUpdateListWithDic:[NSDictionary dictionaryWithObjectsAndKeys:
                                                    [NSNumber numberWithInteger:self.emoticonData.emoticonID],@"emoticon_id",
                                                    [NSNumber numberWithInt:status],@"status",
                                                    nil]];
}

//获取路径
-(NSString*) getEmotionPath:(NSString*) emoticonPath{
    NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [documentPath stringByAppendingPathComponent:emoticonPath];
}

//解压zip包
-(void) unzipEmoticonPath:(NSString*) path{
    ZipArchive *za = [[ZipArchive alloc] init];
    za.delegate = self;
    
    //在内存中解压缩文件
    if ([za UnzipOpenFile:[NSString stringWithFormat:@"%@.zip",path]]) {
        //将解压缩的内容写到缓存目录中
        BOOL ret = [za UnzipFileTo:path overWrite: YES];
        if (NO == ret){} [za UnzipCloseFile];
    }
}

#pragma mark - ZipArchiveDelegate

- (void)zipArchiveSuccess
{
    NSFileManager *fileManger = [[NSFileManager alloc]init];
    [fileManger removeItemAtPath:[self getEmotionPath:[NSString stringWithFormat:@"%@.zip",self.emoticonData.packetName]] error:nil];
    RELEASE_SAFE(fileManger);
    
    [self.downloadProgressArr addObject:@"unZipSuccess"];
    [self checkDownloadProgress];
}

- (void)checkDownloadProgress
{
    if (self.downloadProgressArr.count == 3) {
        [self updateEmotionListStatus:1];
        self.emoticonData = nil;
        self.downloadProgressArr = nil;

        if (self.delegate && [self.delegate respondsToSelector:@selector(downLoadEmotionSuccess)]) {
            [self.delegate downLoadEmotionSuccess];
     
        }
    }
}

#pragma mark - Dealloc

- (void)dealloc
{
    LOG_RELESE_SELF;
    self.delegate = nil;
    self.emoticonData = nil;
    self.downloadProgressArr = nil;
    [super dealloc];
}

@end
