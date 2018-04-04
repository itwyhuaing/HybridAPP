//
//  ActivityManager.m
//  hinabian
//
//  Created by 何松泽 on 17/1/11.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "ActivityManager.h"
#import "CODActivityClassifyInfo.h"
#import "DataFetcher.h"

@interface ActivityManager ()

@property (nonatomic,strong) UIViewController *superVC;
@property (nonatomic,copy) NSString *type;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation ActivityManager

-(instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

-(void)setSuperControl:(UIViewController *)supercontroller type:(NSString *)type
{
    _superVC = supercontroller;
    _type = type;
    
}

//-(void)requestDataInFirstTimeByType:(NSString *)type
//{
//    [DataFetcher doGetActivityIndexwithType:type SucceedHandler:^(id JSON) {
//        _dataSource = (NSArray *)JSON;
//        if (_delegate && [_delegate respondsToSelector:@selector(completeThenRefreshSeminarWithData:)]) {
//            [_delegate completeThenRefreshSeminarWithData:_dataSource];
//        }
//    } withFailHandler:^(id error) {
//        if (_delegate && [_delegate respondsToSelector:@selector(failedThenFinishRefreshSeminarView)]) {
//            [_delegate failedThenFinishRefreshSeminarView];
//        }
//    }];
//}

-(void)reqiestSeminarFirstDataFrom:(NSInteger)start getCount:(NSInteger)num
{
    [DataFetcher dogetActivityIndexFirstWithType:_type start:start GetNum:num withSucceedHandler:^(id JSON) {
        _dataSource = (NSArray *)JSON;
        if (_delegate && [_delegate respondsToSelector:@selector(completeThenRefreshSeminarWithData:)]) {
            [_delegate completeThenRefreshSeminarWithData:_dataSource];
        }
    } withFailHandler:^(id error) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(failedThenFinishRefreshSeminarView)]) {
            [_delegate failedThenFinishRefreshSeminarView];
        }
        
    }];
}

-(void)requestSeminarDataFrom:(NSInteger)start getCount:(NSInteger)num
{
    
    
    [DataFetcher doGetActivityIndexWithType:_type start:start GetNum:num withSucceedHandler:^(id JSON) {
        _dataSource = (NSArray *)JSON;
        if (_delegate && [_delegate respondsToSelector:@selector(completeThenRefreshSeminarWithData:)]) {
            [_delegate completeThenRefreshSeminarWithData:_dataSource];
        }
    } withFailHandler:^(id error) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(failedThenFinishRefreshSeminarView)]) {
            [_delegate failedThenFinishRefreshSeminarView];
        }

    }];

}

#pragma mark ------ 网络图片预加载

- (void)reqImagesWithData:(NSArray *)data{
    
    SDWebImageDownloader *imgManager = [SDWebImageDownloader sharedDownloader];
    for (CODActivityClassifyInfo *f in data) {
        
        NSString *imgUrl = f.image_url;
        
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
