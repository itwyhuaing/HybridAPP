
//
//  UserinfoHisTribeManager.m
//  hinabian
//
//  Created by hnbwyh on 16/7/27.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "UserinfoHisTribeManager.h"
#import "DataFetcher.h"
#import "UserInfoHisTribePost.h"

@interface UserinfoHisTribeManager ()

@property (nonatomic,strong) UIViewController *superVC;
@property (nonatomic,copy) NSString *personid;
@property (nonatomic,strong) NSArray *dataSource;

@end

@implementation UserinfoHisTribeManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)setUserinfoHisTribeViewSuperControl:(UIViewController *)supercontroller personid:(NSString *)personid{

    _superVC = supercontroller;
    _personid = personid;
    
}

-(void)requestUserinfoHisTribeViewDataWithStart:(NSInteger)start getCount:(NSInteger)num{

    [DataFetcher doGetHisTribeDataWithPersonId:_personid start:start GetNum:num withSucceedHandler:^(id JSON) {
        
        _dataSource = (NSArray *)JSON;
        // 图片请求 
        //[self reqImagesWithData:_dataSource];
        if (_delegate && [_delegate respondsToSelector:@selector(completeThenRefreshUserinfoHisTribeViewWithDataSource:)]) {
            [_delegate completeThenRefreshUserinfoHisTribeViewWithDataSource:_dataSource];
        }
        
    } withFailHandler:^(id error) {
        
        
        if (_delegate && [_delegate respondsToSelector:@selector(failureThenFinishRefreshUserinfoHisTribeView)]) {
            [_delegate failureThenFinishRefreshUserinfoHisTribeView];
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
