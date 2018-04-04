//
//  TribeShowMainManager.m
//  hinabian
//
//  Created by hnbwyh on 16/6/12.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "TribeShowMainManager.h"
#import "DataFetcher.h"
#import "DetailTribeHotestitem.h"
#import "DetailTribeLatestitem.h"
#import "TribeShowQAModel.h"
//#import "PostingViewController.h"
#import "HNBRichTextPostingVC.h" // 新版富文本发帖
#import "LoginViewController.h"
#import "SWKTribeShowViewController.h" // 帖子详情 - Web
#import "SWKIMProjectShowController.h" // 项目详情 - web
#import "TribeDetailInfoViewController.h" // 帖子详情 - 回复部分原生化

#import "TribeShowBriefInfo.h"
#import "UserInfoController2.h"
#import "SWKQuestionShowViewController.h"

@interface TribeShowMainManager ()

@property (nonatomic) BOOL tribeInfoReqStatus; // 圈子详情
@property (nonatomic) BOOL hotestPostInfoReqStatus; // 最热帖子

@property (nonatomic,strong) UIViewController *superVC;
@property (nonatomic,copy) NSString *tribeId;

@property (nonatomic,strong) TribeShowBriefInfo *briefInfoModel;
@property (nonatomic,strong) NSArray *dataSource;

@end

#pragma  mark ------ init

@implementation TribeShowMainManager

- (instancetype)init
{
    self = [super init];
    if (self) {
     
        _tribeInfoReqStatus = YES;
        _hotestPostInfoReqStatus = YES;
        
    }
    return self;
}

-(void)setSuperControl:(UIViewController *)supercontroller entryTribe:(NSString *)tribeId{

    _superVC = supercontroller;
    _tribeId = tribeId;
    
}

#pragma  mark ------ requestData

-(void)requestDataWithGetCount:(NSInteger)num tribeId:(NSString *)tribeID{

    dispatch_group_t loadGroup = dispatch_group_create();
    dispatch_queue_t loadQueue = dispatch_queue_create("loadQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_enter(loadGroup);
    [DataFetcher doGetTribeInfoWithTribeID:tribeID
                        withSucceedHandler:^(id JSON) {
                            
                            _briefInfoModel = (TribeShowBriefInfo *)JSON;
                            _tribeInfoReqStatus = YES;
                            dispatch_group_leave(loadGroup);
                        } withFailHandler:^(id error) {
                            
                            _tribeInfoReqStatus = NO;
                            dispatch_group_leave(loadGroup);
                        }];
    
    dispatch_group_enter(loadGroup);
    [DataFetcher doGetTribeDetailInfoWithTribeID:tribeID
                                        sortType:TRIBE_HOTEST
                                           start:0
                                          GetNum:num
                              withSucceedHandler:^(id JSON) {
                                  
                                      
                                  NSPredicate *filter = [NSPredicate predicateWithFormat:@"tribe_id IN %@", @[tribeID]];
                                  _dataSource = [DetailTribeHotestitem MR_findAllSortedBy:@"timestamp" ascending:YES withPredicate:filter];

                                  //_dataSource = [DetailTribeHotestitem MR_findAllSortedBy:@"timestamp" ascending:YES];
                                  //[self reqNetImages:_dataSource];
                                  
                                  _hotestPostInfoReqStatus = YES;
                                  dispatch_group_leave(loadGroup);
                              } withFailHandler:^(id error) {
                                  
                                  _hotestPostInfoReqStatus = NO;
                                  dispatch_group_leave(loadGroup);
                              }];
    
    
    dispatch_group_notify(loadGroup, loadQueue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (_delegate && [_delegate respondsToSelector:@selector(completeDateThenRefreshViewWithHeadModel:dataSource:tribeInfoReqStatus:hotestPostInfoReqStatus:)]) {
                [_delegate completeDateThenRefreshViewWithHeadModel:_briefInfoModel dataSource:_dataSource tribeInfoReqStatus:_tribeInfoReqStatus hotestPostInfoReqStatus:_hotestPostInfoReqStatus];
            }
            
            // 第一屏数据请求完之后 加载最新 问答 项目 第一页数据
            [self reqHomeFirstPageWithTribeID:tribeID pageNum:num];
            
            
        });
        
    });



}

- (void)requestHeaderDataWithTribeId:(NSString *)tribeID{

    [DataFetcher doGetTribeInfoWithTribeID:tribeID
                        withSucceedHandler:^(id JSON) {
                            
                            _briefInfoModel = (TribeShowBriefInfo *)JSON;
                            //NSLog(@" _briefInfoModel ---- > %@",_briefInfoModel.tribe_id);
                            _tribeInfoReqStatus = YES;
                            if (_delegate && [_delegate respondsToSelector:@selector(completeDateThenRefreshHeaderViewWithHeadModel:tribeInfoReqStatus:)]) {
                                [_delegate completeDateThenRefreshHeaderViewWithHeadModel:_briefInfoModel tribeInfoReqStatus:_tribeInfoReqStatus];
                            }
                            
                        } withFailHandler:^(id error) {
                            
                            _tribeInfoReqStatus = NO;
                            if (_delegate && [_delegate respondsToSelector:@selector(failReqHeaderViewDataWithTribeInfoReqStatus:)]) {
                                [_delegate failReqHeaderViewDataWithTribeInfoReqStatus:_tribeInfoReqStatus];
                            }
                        }];

    
}


- (void)reqHomeFirstPageWithTribeID:(NSString *)tribeID pageNum:(NSInteger)num{

    [DataFetcher doGetTribeDetailInfoWithTribeID:tribeID
                                        sortType:TRIBE_LATEST
                                           start:0
                                          GetNum:num
                              withSucceedHandler:^(id JSON) {
                                  
//                                  NSLog(@" -- TRIBE_LATEST -- ");
                                  NSPredicate *filter = [NSPredicate predicateWithFormat:@"tribe_id IN %@", @[_tribeId]];
                                  NSArray *tmpData = [DetailTribeLatestitem MR_findAllSortedBy:@"timestamp" ascending:YES withPredicate:filter];
                                  if (_delegate && [_delegate respondsToSelector:@selector(reqFirstPageDagta:reqStatus:tabIndex:)]) {
                                      [_delegate reqFirstPageDagta:tmpData reqStatus:YES tabIndex:TRIBE_LATEST];
                                  }
                                  
                              } withFailHandler:^(id error) {
                                  
                              }];
    
    
    /* v2.9.1 需求移除问答与项目
     [DataFetcher doGetTribeDetailInfoWithTribeID:tribeID
     sortType:TRIBE_QATHEM
     start:0
     GetNum:num
     withSucceedHandler:^(id JSON) {
     
     //NSLog(@" -- TRIBE_QATHEM -- ");
     if (_delegate && [_delegate respondsToSelector:@selector(reqFirstPageDagta:reqStatus:tabIndex:)]) {
     [_delegate reqFirstPageDagta:(NSArray *)JSON reqStatus:YES tabIndex:TRIBE_QATHEM];
     }
     
     } withFailHandler:^(id error) {
     
     }];
     
     [DataFetcher doGetTribeDetailInfoWithTribeID:tribeID
     sortType:TRIBE_PROTHEM
     start:0
     GetNum:num
     withSucceedHandler:^(id JSON) {
     
     //NSLog(@" -- TRIBE_PROTHEM -- ");
     if (_delegate && [_delegate respondsToSelector:@selector(reqFirstPageDagta:reqStatus:tabIndex:)]) {
     [_delegate reqFirstPageDagta:(NSArray *)JSON reqStatus:YES tabIndex:TRIBE_PROTHEM];
     }
     
     } withFailHandler:^(id error) {
     
     }];
     */
    
}



#pragma  mark ------ 点击事件处理

- (void)theTribeCare:(NSNotification *)info{
    
    NSDictionary *dic = [info object];
    TribeShowBriefInfo *model = [dic valueForKey:@"model"];
    UIButton *btn = [dic valueForKey:@"btn"];
    NSString *is_followed = model.is_followed;
    
    if (![HNBUtils isLogin]){
        NSDictionary *dict = @{@"tribe_name" : model.tribe_name,@"state" : @"3"};
        [HNBClick event:@"103011" Content:dict];
        LoginViewController *vc = [[LoginViewController alloc] init];
        [_superVC.navigationController pushViewController:vc animated:YES];
        return;
    }
    

    
    if ([is_followed isEqualToString:@"1"]) { // 已关注，此时取消关注
        
        NSDictionary *dict = @{@"tribe_name" : model.tribe_name,@"state" : @"0"};
        [HNBClick event:@"103011" Content:dict];
        [DataFetcher removeFollowTribeWithParameter:_tribeId withSucceedHandler:^(id JSON) {
            
            [btn setTitle:@"关注" forState:UIControlStateNormal];
            model.is_followed = @"0";
            
        } withFailHandler:^(id error) {
            
            
        }];
    }
    else if ([is_followed isEqualToString:@"0"]){ // 非关注状态，此时添加关注
        NSDictionary *dict = @{@"tribe_name" : model.tribe_name,@"state" : @"1"};
        [HNBClick event:@"103011" Content:dict];
        [DataFetcher addFollowTribeWithParameter:_tribeId withSucceedHandler:^(id JSON) {
            [btn setTitle:@"已关注" forState:UIControlStateNormal];
            model.is_followed = @"1";
            
        } withFailHandler:^(id error) {
            
            
        }];
        
    }
    
}


- (void)theTribeHost:(NSNotification *)info{


    NSString *id_str = (NSString *)[info object];
    UserInfoController2 * vc = [[UserInfoController2 alloc] init];
    vc.personid = id_str;
    [_superVC.navigationController pushViewController:vc animated:YES];
    
}

- (void)hotestTableViewSelected:(NSNotification *)info{
    
    
    NSString *link = [info object];
    NSDictionary *dict;
    if (link) {
        dict = @{@"url" : link};
    }else{
        dict = @{@"url" : @""};
    }
    [HNBClick event:@"103023" Content:dict];
    if (link == nil) {
        return;
    }
    
    NSString *isNativeString = [HNBUtils sandBoxGetInfo:[NSString class] forKey:TRIBEDETAILTHEME_NATIVEUI_WEB];
    if ([isNativeString isEqualToString:@"1"]) {
        
        TribeDetailInfoViewController *vc = [[TribeDetailInfoViewController alloc] init];
        vc.URL = [[NSURL alloc] withOutNilString:link];
        [_superVC.navigationController pushViewController:vc animated:YES];
        
    } else {
        
        SWKTribeShowViewController *vc = [[SWKTribeShowViewController alloc] init];
        vc.URL = [[NSURL alloc] withOutNilString:link];
        [_superVC.navigationController pushViewController:vc animated:YES];
        
    }

}


- (void)latestTableViewSelected:(NSNotification *)info{
    NSString *link = [info object];
    NSDictionary *dict = @{@"url" : link};
    [HNBClick event:@"103024" Content:dict];
    if (link == nil) {
        return;
    }
    
    NSString *isNativeString = [HNBUtils sandBoxGetInfo:[NSString class] forKey:TRIBEDETAILTHEME_NATIVEUI_WEB];
    if ([isNativeString isEqualToString:@"1"]) {
        
        TribeDetailInfoViewController *vc = [[TribeDetailInfoViewController alloc] init];
        vc.URL = [[NSURL alloc] withOutNilString:link];
        [_superVC.navigationController pushViewController:vc animated:YES];
        
    } else {

        SWKTribeShowViewController *vc = [[SWKTribeShowViewController alloc] init];
        vc.URL = [[NSURL alloc] withOutNilString:link];
        [_superVC.navigationController pushViewController:vc animated:YES];
        
    }
    
}

- (void)questionTableViewSelected:(NSNotification *)info{

    NSLog(@" questionTableViewSelected :%@",info);
    TribeShowQAModel *f = (TribeShowQAModel *)[info object];
    SWKQuestionShowViewController *vc = [[SWKQuestionShowViewController alloc] init];
    NSString *tmpurl = [NSString stringWithFormat:@"https://m.hinabian.com/qa_question/detail/%@",f.questionid];
    vc.URL = [[NSURL alloc] withOutNilString:tmpurl];
    [_superVC.navigationController pushViewController:vc animated:YES];
    
}

- (void)projectTableViewSelected:(NSNotification *)info{
    // https://m.hinabian.com/project/detail.html?project_id=12021067
    
    NSLog(@" projectTableViewSelected :%@",info);
    NSString *proID = [info object];
    NSString *urlString = [NSString stringWithFormat:@"%@/project/detail.html?project_id=%@",H5URL,proID];
    SWKIMProjectShowController * vc = [[SWKIMProjectShowController alloc] init];
    vc.URL = [NSURL URLWithString:urlString];
    [_superVC.navigationController pushViewController:vc animated:YES];
    
}

- (void)writingInTribe:(NSNotification *)info{

    [HNBClick event:@"103030" Content:nil];
    
    NSDictionary *tribeInfo = (NSDictionary *)[info object];
    
    NSString *tribeID = [tribeInfo objectForKey:@"tribeID"];
    NSString *tribeName = [tribeInfo objectForKey:@"tribeName"];

    if (![HNBUtils isLogin]) {
        
        LoginViewController *vc = [[LoginViewController alloc] init];
        [_superVC.navigationController pushViewController:vc animated:YES];
        
        HNBRichTextPostingVC *postingvc = [[HNBRichTextPostingVC alloc] init];
        postingvc.choseTribeCode = tribeID;
        postingvc.chosedTribeName = tribeName;
        postingvc.entryOrigin = PostingEntryOriginTribeDetailNewThem;
        NSArray *tmpvcs = [_superVC.navigationController viewControllers];        
        _superVC.navigationController.viewControllers = [HNBUtils operateNavigationVCS:tmpvcs index:tmpvcs.count - 1 vc:postingvc];

        return;
    }
    
    HNBRichTextPostingVC *vc = [[HNBRichTextPostingVC alloc] init];
    vc.choseTribeCode = tribeID;
    vc.chosedTribeName = tribeName;
    vc.entryOrigin = PostingEntryOriginTribeDetailNewThem;
    [_superVC.navigationController pushViewController:vc animated:YES];

}

- (void)answerNamePressed:(NSNotification *)notification{
    
    NSString * idString = [notification object];
    UserInfoController2 * vc = [[UserInfoController2 alloc] init];
    vc.personid = idString;
    [_superVC.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark ------ reqNetImage

- (void)reqNetImages:(NSArray *)data{

//    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    SDWebImageDownloader *mgr = [SDWebImageDownloader sharedDownloader];
    for (DetailTribeHotestitem *f in data) {
        
        NSString *iconURLString = f.head_url;
        NSString *img_url_string = f.img_list;
        NSArray *img_url_arr = [img_url_string componentsSeparatedByString:@"&"];
        NSString *img_url= [img_url_arr firstObject];

        // icon
        if (![iconURLString isEqualToString:@""]) {
            [mgr downloadImageWithURL:[NSURL URLWithString:iconURLString]
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                                 
                             }completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                                
                            }];
        }
        
        // 大图片
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
