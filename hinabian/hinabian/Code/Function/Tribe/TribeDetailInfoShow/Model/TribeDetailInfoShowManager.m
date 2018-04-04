//
//  TribeDetailInfoShowManager.m
//  hinabian
//
//  Created by hnbwyh on 16/10/20.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "TribeDetailInfoShowManager.h"
#import "DataFetcher.h"
#import "PersonInfoModel.h"
#import "LoginViewController.h"
#import "UserInfoController2.h"

@interface TribeDetailInfoShowManager ()

@end


@interface TribeDetailInfoShowManager ()

@property (nonatomic,copy) NSString *themId;

@end

@implementation TribeDetailInfoShowManager

- (instancetype)initWithThemId:(NSString *)themId
                       superVC:(UIViewController *)superVC
{
    self = [super init];
    if (self) {
        
        _themId = themId;
    }
    return self;
}


#pragma mark page

- (void)reqNetDataPage:(NSInteger)page withSucceedHandler:(ReturnDataForCardViewBlock)suceedHandler{

    [DataFetcher doGetCommentInDetailThemPageWithThemID:_themId pageNum:page withSucceedHandler:^(id JSON) {
        
        NSArray *tmp = (NSArray *)JSON;
        suceedHandler(tmp);
        
    } withFailHandler:^(id error) {
        
        
        
    }];
    
}

- (void)reqLZNetDataPage:(NSInteger)page withSucceedHandler:(ReturnDataForCardViewBlock)suceedHandler{
    
    [DataFetcher doGetLZCommentInDetailThemPageWithThemID:_themId pageNum:page withSucceedHandler:^(id JSON) {
        
        NSArray *tmp = (NSArray *)JSON;
        suceedHandler(tmp);
        
    } withFailHandler:^(id error) {
        
        
        
    }];
    
}

- (void)reportWithType:(NSString *)reportType reportId:(NSString *)reportId desc:(NSString *)desc{


    [DataFetcher doReportWithType:reportType reportId:reportId desc:desc withSucceedHandler:^(id JSON) {
        
        
        
    } withFailHandler:^(id error) {
        
        
        
    }];
    
}

@end
