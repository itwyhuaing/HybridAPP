//
//  TribeShowProjectManager.m
//  hinabian
//
//  Created by hnbwyh on 17/4/17.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "TribeShowProjectManager.h"
#import "DataFetcher.h"

@interface TribeShowProjectManager ()
@property (nonatomic,strong) UIViewController *superVC;
@property (nonatomic,copy) NSString *tribeId;
@end

@implementation TribeShowProjectManager

- (void) setSuperControl:(UIViewController *)supercontroller tribe:(NSString *)tribeId{

    _superVC = supercontroller;
    _tribeId = tribeId;
    
}

- (void)requestTribeShowProjectViewDataWithStart:(NSInteger)start getCount:(NSInteger)num{

    [DataFetcher doGetTribeDetailInfoWithTribeID:_tribeId
                                        sortType:TRIBE_PROTHEM
                                           start:start
                                          GetNum:num
                              withSucceedHandler:^(id JSON) {
                                  
                                  //NSLog(@" 加载更多 -- TRIBE_PROTHEM -- ");
                                  if (_delegate && [_delegate respondsToSelector:@selector(completeThenRefreshViewWithDataSource:)]) {
                                      [_delegate completeThenRefreshViewWithDataSource:(NSArray *)JSON];
                                  }
                                  
                              } withFailHandler:^(id error) {
                                  
                                  if (_delegate && [_delegate respondsToSelector:@selector(failureThenFinishRefresh)]) {
                                      [_delegate failureThenFinishRefresh];
                                  }
                                  
                              }];
    
}

@end
