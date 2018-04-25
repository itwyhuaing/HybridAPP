//
//  UserinfoHisReplyManager.m
//  hinabian
//
//  Created by 何松泽 on 16/12/20.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "UserinfoHisReplyManager.h"
#import "DataFetcher.h"
#import "UserInfoHisTribePost.h"

@interface UserinfoHisReplyManager ()

@property (nonatomic,strong) UIViewController *superVC;
@property (nonatomic,copy) NSString *personid;
@property (nonatomic,strong) NSArray *dataSource;

@end

@implementation UserinfoHisReplyManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)setUserinfoHisReplyViewSuperControl:(UIViewController *)supercontroller personid:(NSString *)personid{
    
    _superVC = supercontroller;
    _personid = personid;
    
}

-(void)requestUserinfoHisReplyViewDataWithStart:(NSInteger)start getCount:(NSInteger)num{
    
    [DataFetcher doGetHisReplyDataWithPersonId:_personid start:start GetNum:num withSucceedHandler:^(id JSON) {
        
        _dataSource = (NSArray *)JSON;
        // 图片请求
        //[self reqImagesWithData:_dataSource];
        if (_delegate && [_delegate respondsToSelector:@selector(completeThenRefreshUserinfoHisReplyViewWithDataSource:)]) {
            [_delegate completeThenRefreshUserinfoHisReplyViewWithDataSource:_dataSource];
        }
        
    } withFailHandler:^(id error) {
        
        
        if (_delegate && [_delegate respondsToSelector:@selector(failureThenFinishRefreshUserinfoHisReplyView)]) {
            [_delegate failureThenFinishRefreshUserinfoHisReplyView];
        }
        
    }];
    
}

#pragma mark ------ 网络图片预加载

- (void)reqImagesWithData:(NSArray *)data{
    
    SDWebImageDownloader *mgr = [SDWebImageDownloader sharedDownloader];
    for (UserInfoHisTribePost *f in data) {
        
        NSString *imgUrl = f.ess_img;
        
        if (imgUrl.length != 0) {
            
            //NSLog(@" %ld ------ > %@",data.count,imgUrl);
            
            [mgr downloadImageWithURL:[NSURL URLWithString:imgUrl]
                                     options:0
                                    progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                                        
                                    }completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                                        
                                    }];
            
        }
        
    }
    
}

@end