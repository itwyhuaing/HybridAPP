//
//  ConditionTestManager.m
//  hinabian
//
//  Created by hnbwyh on 17/6/9.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "ConditionTestManager.h"
#import "DataFetcher.h"

@implementation ConditionTestManager

-(void)reqConditionTestDataSource{

    if ([HNBUtils isConnectionAvailable]) {
        
        [DataFetcher doGetContryAndProject:^(id JSON) {
            
            if (_delegate && [_delegate respondsToSelector:@selector(fetchNetState:data:)]) {
                NSArray *tmpArr = (NSArray *)JSON;
                [_delegate fetchNetState:TRUE data:tmpArr];
            }
            
        } withFailHandler:^(id error) {
            if (_delegate && [_delegate respondsToSelector:@selector(fetchNetState:error:)]) {
                [_delegate fetchNetState:FALSE error:error];
            }
        }];

        
    } else {
        
        if (_delegate && [_delegate respondsToSelector:@selector(fetchNetState:error:)]) {
            [_delegate fetchNetState:FALSE error:nil];
        }
        
    }
}

@end
