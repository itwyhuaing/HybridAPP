//
//  UserinfoQAManager.m
//  hinabian
//
//  Created by hnbwyh on 16/7/27.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "UserinfoQAManager.h"
#import "DataFetcher.h"
#import "UserInfoHisQAPost.h"

@interface UserinfoQAManager ()

@property (nonatomic,strong) UIViewController *superVC;
@property (nonatomic,copy) NSString *personid;
@property (nonatomic,strong) NSArray *dataSource;

@end

@implementation UserinfoQAManager

-(void)setUserinfoQASuperControl:(UIViewController *)supercontroller personid:(NSString *)personid{

    _superVC = supercontroller;
    _personid = personid;
    
}

-(void)requestUserinfoQADataWithStart:(NSInteger)start getCount:(NSInteger)num{

    [DataFetcher doGetHisQADataWithPersonId:_personid start:start GetNum:num withSucceedHandler:^(id JSON) {
        
        _dataSource = (NSArray *)JSON;
        if (_delegate && [_delegate respondsToSelector:@selector(completeThenRefreshUserinfoQAWithDataSource:)]) {
            [_delegate completeThenRefreshUserinfoQAWithDataSource:_dataSource];
        }
        
    } withFailHandler:^(id error) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(failureThenFinishRefreshUserinfoQA)]) {
            [_delegate failureThenFinishRefreshUserinfoQA];
        }
        
    }];
    
    
}

@end
