//
//  UserinfoHisPostManager.m
//  hinabian
//
//  Created by 何松泽 on 16/12/20.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "UserinfoHisPostManager.h"
#import "DataFetcher.h"
#import "UserInfoHisTribePost.h"

@interface UserinfoHisPostManager ()

@property (nonatomic,strong) UIViewController *superVC;
@property (nonatomic,copy) NSString *personid;
@property (nonatomic,strong) NSArray *dataSource;

@end

@implementation UserinfoHisPostManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)setUserinfoHisPostViewSuperControl:(UIViewController *)supercontroller personid:(NSString *)personid{
    
    _superVC = supercontroller;
    _personid = personid;
    
}

-(void)requestUserinfoHisPostViewDataWithStart:(NSInteger)start getCount:(NSInteger)num{
    
    [DataFetcher doGetHisPostDataWithPersonId:_personid start:start GetNum:num withSucceedHandler:^(id JSON) {
        
        _dataSource = (NSArray *)JSON;
        // 图片请求
        //[self reqImagesWithData:_dataSource];
        if (_delegate && [_delegate respondsToSelector:@selector(completeThenRefreshUserinfoHisPostViewWithDataSource:)]) {
            [_delegate completeThenRefreshUserinfoHisPostViewWithDataSource:_dataSource];
        }
        
    } withFailHandler:^(id error) {
        
        
        if (_delegate && [_delegate respondsToSelector:@selector(failureThenFinishRefreshUserinfoHisPostView)]) {
            [_delegate failureThenFinishRefreshUserinfoHisPostView];
        }
        
    }];
    
}

#pragma mark ------ 网络图片预加载

- (void)reqImagesWithData:(NSArray *)data{
    
    SDWebImageDownloader *imgManager = [SDWebImageDownloader sharedDownloader];
    for (UserInfoHisTribePost *f in data) {
        
        NSString *imgUrl = f.ess_img;
        
        if (imgUrl.length != 0) {
            
            //NSLog(@" %ld ------ > %@",data.count,imgUrl);
            
            [imgManager downloadImageWithURL:[NSURL URLWithString:imgUrl]
                                     options:0
                                    progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                                        
                                    }completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                                        
                                    }];
            
        }
        
    }
    
}

@end
