//
//  TribeIndexMainManager.m
//  hinabian
//
//  Created by 余坚 on 16/6/8.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "TribeIndexMainManager.h"
#import "DataFetcher.h"
#import "RefreshControl.h"
#import "TribeIndexHotTribe.h"
#import "TribeIndexItem.h"
#import "LoginViewController.h"
#import "SWKTribeShowViewController.h"
#import "TribeDetailInfoViewController.h"
#import "TribeShowNewController.h"
#import "NetDataCacheHandler.h"
#import "HNBRichTextPostingVC.h" // 新版富文本
#import "TribeDetailController.h"

#define LOADNEWDATA_COUNT 20    //每次网络请求帖子数 20 (注：2.0版本该参数为10 , 2.1版本该参数应要求修改为20)

@interface TribeIndexMainManager ()
{
    NSInteger postAllCount;
    NSInteger postCount;
}

@property (nonatomic) BOOL hotTribesReqStatus;
@property (nonatomic) BOOL hotPostReqStatus;

@property (nonatomic,strong) NSMutableArray *hotTribes;
@property (nonatomic,strong) NSArray *hotPostes;

@end

@implementation TribeIndexMainManager
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _hotTribesReqStatus = YES;
        _hotPostReqStatus = YES;
        
        _hotTribes = [[NSMutableArray alloc] init];
        _hotPostes = [[NSArray alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewSelected:) name:TRIBE_INDEX_TABLE_CELL_SELECTED_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickHotTribe:) name:TRIBE_INDEX_HOT_TRIBE_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickTribeBtn:) name:TRIBE_INDEX_TRIBE_IN_CELL_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GotoPosting) name:TRIBE_INDEX_POST_NOTIFICATION object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TRIBE_INDEX_TABLE_CELL_SELECTED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TRIBE_INDEX_HOT_TRIBE_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TRIBE_INDEX_TRIBE_IN_CELL_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TRIBE_INDEX_POST_NOTIFICATION object:nil];
}

- (void)getAllInfoInTribeIndex:(RefreshControl *)refreshControll
{    
    postCount = 0;
    refreshControll.bottomEnabled = TRUE;
    dispatch_group_t indexLoads = dispatch_group_create();
    dispatch_queue_t indexQueue = dispatch_queue_create("tribeIndexQueue", DISPATCH_QUEUE_CONCURRENT);
    
    // 两种方式取数据
    _hotTribesReqStatus = YES;
    dispatch_group_enter(indexLoads);
    [NetDataCacheHandler readHotTribesInTribeIndexInfoWithCacheKey:tribe_index_hot_tribes_info completion:^(NSArray *info) {
        
        [_hotTribes removeAllObjects];
        [_hotTribes addObjectsFromArray:[TribeIndexHotTribe MR_findAllSortedBy:@"timestamp" ascending:YES]];
        
        if (_hotTribes.count <= 0) {
            [DataFetcher doGetHotTribesInTribeIndex:^(id JSON) {
                
                [_hotTribes removeAllObjects];
                [_hotTribes addObjectsFromArray:[TribeIndexHotTribe MR_findAllSortedBy:@"timestamp" ascending:YES]];
                dispatch_group_leave(indexLoads);
                
            } withFailHandler:^(id error) {
                
                _hotTribesReqStatus = NO;
                dispatch_group_leave(indexLoads);
                
            }];
        }else{
            dispatch_group_leave(indexLoads);
        }
        
    }];
    
    
    dispatch_group_enter(indexLoads);
    [DataFetcher doGetHotPostInTribeIndex:0 GetNum:LOADNEWDATA_COUNT withSucceedHandler:^(id JSON) {
        
        int errCode = [[JSON valueForKey:@"state"] intValue];
        if (errCode == 0) {
            _hotPostes = [TribeIndexItem MR_findAllSortedBy:@"timestamp" ascending:YES] ;
            //[self reqNetImages:_hotPostes];
            id jsonData = [JSON valueForKey:@"Data"];
            postAllCount = [[jsonData valueForKey:@"total"] intValue];
        }
        _hotPostReqStatus = YES;
        dispatch_group_leave(indexLoads);
        
    } withFailHandler:^(id error) {
        
        _hotPostReqStatus = NO;
        dispatch_group_leave(indexLoads);
    }];
    
    /* 所有请求都完成后处理 */
    dispatch_group_notify(indexLoads, indexQueue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 下拉刷新时关停
            if (refreshControll != nil && refreshControll.refreshingDirection == RefreshingDirectionTop) {
                [refreshControll finishRefreshingDirection:RefreshDirectionTop];
            }
            
//            if (_delegate && [_delegate respondsToSelector:@selector(completeDateThenReloadWithIndexPosts:totalPostCount:hotTribesReqStatus:hotPostReqStatus:)]) {
//                [_delegate completeDateThenReloadWithIndexPosts:nil totalPostCount:0 hotTribesReqStatus:_hotTribesReqStatus hotPostReqStatus:_hotPostReqStatus];
//            }
            if (_delegate && [_delegate respondsToSelector:@selector(completeDataThenReloadWithIndexTribes:tribePosts:hotTribesReqStatus:hotPostReqStatus:)]) {
                [_delegate completeDataThenReloadWithIndexTribes:_hotTribes tribePosts:_hotPostes hotTribesReqStatus:_hotTribesReqStatus hotPostReqStatus:_hotPostReqStatus];
            }
            
            // 及时更新
            // [self updateHotTribes];
            
        });
    });


}

- (void)updateHotTribes{
    
    [DataFetcher doGetHotTribesInTribeIndex:^(id JSON) {
        
        NSNumber *jsonValue = (NSNumber *)JSON;
        BOOL isChanged = [jsonValue boolValue];
        if (isChanged && _delegate && [_delegate respondsToSelector:@selector(updateHotTribesWithHotTribesReqStatus:)]) {
            
            [_delegate updateHotTribesWithHotTribesReqStatus:YES];
            [_hotTribes removeAllObjects];
            [_hotTribes addObjectsFromArray:[TribeIndexHotTribe MR_findAllSortedBy:@"timestamp" ascending:YES]];
            
        }
        
    } withFailHandler:^(id error) {
        
        _hotTribesReqStatus = NO;
        
    }];
    
}


- (void)getDataThenReload:(RefreshControl *)refreshControll
{
    //NSInteger postCount = 0;
    if (_hotPostes != NULL) {
        //postCount = _hotPostes.count;
        //postCount += 20;
        postCount += LOADNEWDATA_COUNT;
    }
    //NSLog(@" postCount --- > %ld  postAllCount --- > %ld",postCount,postAllCount);
    if ((postCount < postAllCount) || postAllCount == 0) {
        NSInteger tmpNum = 0;
        if (LOADNEWDATA_COUNT < (postAllCount - postCount) || postAllCount == 0) {
            tmpNum = LOADNEWDATA_COUNT;
        }
        else
        {
            tmpNum = LOADNEWDATA_COUNT;//postAllCount - postCount;
        }
        [DataFetcher doGetHotPostInTribeIndex:postCount GetNum:tmpNum withSucceedHandler:^(id JSON) {
            int errCode = [[JSON valueForKey:@"state"] intValue];
            if (errCode == 0) {
                _hotPostes = [TribeIndexItem MR_findAllSortedBy:@"timestamp" ascending:YES];
                //[self reqNetImages:_hotPostes];
                id jsonData = [JSON valueForKey:@"data"];
                postAllCount = [[jsonData valueForKey:@"total"] intValue];
                _hotPostReqStatus = YES;
                if ([_delegate respondsToSelector:@selector(completePostDateThenReloadWithBottomPostsWithReqStatus:)]) {
                    [_delegate completePostDateThenReloadWithBottomPostsWithReqStatus:_hotPostReqStatus];
                }
                /* 判断是否到底 */
                if (postAllCount <= postCount + tmpNum) {
                    refreshControll.bottomEnabled = FALSE;
                }
                else
                {
                    refreshControll.bottomEnabled = TRUE;
                }
            }
            if (_hotPostes != nil) {
                if (_hotPostes.count >= postAllCount) {
                    [refreshControll finishRefreshingDirection:RefreshDirectionBottom isEmpty:TRUE];
                }
                else
                {
                    [refreshControll finishRefreshingDirection:RefreshDirectionBottom];
                }
            }
            
            
        } withFailHandler:^(NSError* error) {
            _hotPostReqStatus = NO;
            if (_delegate && [_delegate respondsToSelector:@selector(failReqDataTribeThenEndRefreshWithReqStatus:)]) {
                [_delegate failReqDataTribeThenEndRefreshWithReqStatus:_hotPostReqStatus];
            }
            [refreshControll finishRefreshingDirection:RefreshDirectionBottom isEmpty:TRUE];
        }];
    }
}

/*  跳转发帖页面  */
-(void) GotoPosting
{
    [HNBClick event:@"101030" Content:nil];
    if (![HNBUtils isLogin]) {

        LoginViewController *vc = [[LoginViewController alloc] init];
        [_superController.navigationController pushViewController:vc animated:YES];
        
        HNBRichTextPostingVC *postingVC = [[HNBRichTextPostingVC alloc] init];
        NSArray *tmpvcs = [_superController.navigationController viewControllers];
        _superController.navigationController.viewControllers = [HNBUtils operateNavigationVCS:tmpvcs index:tmpvcs.count -1 vc:postingVC];
        
        return;
    }
    HNBRichTextPostingVC *vc = [[HNBRichTextPostingVC alloc] init];
    [_superController.navigationController pushViewController:vc animated:NO];

}

/* 帖子列表中的帖子被点击 */
- (void) tableViewSelected:(NSNotification*)notification
{
    NSInteger  index = [[notification object] intValue];
    
    if (index == EN_TRIBE_INDEX_TRIBE_TITLE) {
        [HNBClick event:@"101010" Content:nil];
        /* 我关注的圈子 */
        if (![HNBUtils isLogin]) {
            LoginViewController *vc = [[LoginViewController alloc] init];
            [_superController.navigationController pushViewController:vc animated:YES];
            return;
        }
        NSString *tmpString = @"https://m.hinabian.com/tribe/tribeListByJoiner.html";
        SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
        vc.URL = [vc.webManger configDefaultNativeNavWithURLString:tmpString];
        [_superController.navigationController pushViewController:vc animated:YES];
    }
    else if (index >= EN_TRIBE_INDEX_POST)
    {
        /* 点击帖子 */
        
        TribeIndexItem *f = _hotPostes[index - EN_TRIBE_INDEX_POST];
        
        //
        TribeDetailController *controller = [[TribeDetailController alloc]init];
        controller.URL = [[NSURL alloc] withOutNilString:f.link];
        [_superController.navigationController pushViewController:controller animated:YES];
        return;
        NSString *isNativeString = [HNBUtils sandBoxGetInfo:[NSString class] forKey:TRIBEDETAILTHEME_NATIVEUI_WEB];
        if ([isNativeString isEqualToString:@"1"]) {
            
            if(f.link)
            {
                TribeDetailInfoViewController *vc = [[TribeDetailInfoViewController alloc] init];
                vc.URL = [[NSURL alloc] withOutNilString:f.link];
                [_superController.navigationController pushViewController:vc animated:YES];
            }
            
        } else {
            
            SWKTribeShowViewController *vc = [[SWKTribeShowViewController alloc] init];
            vc.URL = [[NSURL alloc] withOutNilString:f.link];
            [_superController.navigationController pushViewController:vc animated:YES];
            
        }
        
        if ([f.type isEqualToString:@"1"]) {
            if ((index - EN_TRIBE_INDEX_POST) == 0) {
                NSDictionary *dict = @{@"url" : f.link};
                [HNBClick event:@"101021" Content:dict];
            }
            else if ((index - EN_TRIBE_INDEX_POST) == 1)
            {
                NSDictionary *dict = @{@"url" : f.link};
                [HNBClick event:@"101022" Content:dict];
            }
        }
        else
        {
            if (f.link) {
                NSDictionary *dict = @{@"url" : f.link};
                [HNBClick event:@"101023" Content:dict];
            }

        }
    }
}

- (void)clickTribeBtn:(NSNotification *)notify{
    NSArray *tmpArray = [notify object];
    if (tmpArray == nil) {
        return;
    }
    if (tmpArray.count < 2) {
        return;
    }
    NSString *type = tmpArray[0];
    NSString *id = tmpArray[1];
    if ([type isEqualToString:@"tribe_index"]) {
        TribeShowNewController * vc = [[TribeShowNewController alloc] init];
        vc.tribeId = id;
        [_superController.navigationController pushViewController:vc animated:YES];
    }

}

/* 点击圈子首页的热门圈子 */
- (void)clickHotTribe:(NSNotification *)notification{
    NSInteger  index = [[notification object] intValue];
    NSInteger  showHotNum = 5;//热门圈子最大显示个数
    
    if (index >=0 && index < _hotTribes.count && index != showHotNum) {
        TribeIndexHotTribe *f = _hotTribes[index];
        TribeShowNewController * vc = [[TribeShowNewController alloc] init];
        vc.tribeId = f.id;
        [_superController.navigationController pushViewController:vc animated:YES];
        NSString *index_id = [NSString stringWithFormat:@"10101%ld",(index+1)];
        if (f.name) {
            NSDictionary *dict = @{@"trieb_name" : f.name};
            [HNBClick event:index_id Content:dict];
        }
    }
    else if (index == _hotTribes.count || index == showHotNum)    //查看更多
    {
 
        NSString *tmpString = @"https://m.hinabian.com/tribe/index.html";
        SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
        vc.URL = [vc.webManger configDefaultNativeNavWithURLString:tmpString];
        [_superController.navigationController pushViewController:vc animated:YES];
        [HNBClick event:@"101016" Content:nil];
    }
}

#pragma mark ------ 请求网络图片

- (void)reqNetImages:(NSArray *)data{

    SDWebImageDownloader *mgr = [SDWebImageDownloader sharedDownloader];
    for (TribeIndexItem *f in data) {
        
        NSString *iconUrlString = f.head_url;
        NSString *img_url_string = f.img_list;
        NSArray *img_url_arr = [img_url_string componentsSeparatedByString:@"&"];
        NSString *img_url= [img_url_arr firstObject];
        // icon
        if (![iconUrlString isEqualToString:@""]) {
            
            [mgr downloadImageWithURL:[NSURL URLWithString:iconUrlString]
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                                 
                             }completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                                 
                             }];
            
        }
        
        // 大图
        if (![img_url isEqualToString:@""]) {
            
            [mgr downloadImageWithURL:[NSURL URLWithString:img_url]
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                                 
                             }completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                                 
                             }];
            
        }
        
        
    }
    
}

@end
