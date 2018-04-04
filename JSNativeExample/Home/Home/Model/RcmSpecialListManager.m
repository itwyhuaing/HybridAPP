//
//  RcmSpecialListManager.m
//  hinabian
//
//  Created by hnbwyh on 2017/10/30.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "RcmSpecialListManager.h"
#import "DataFetcher.h"

@implementation RcmSpecialListManager

- (void)reqRcmSpecialListData{
    
//    [DataFetcher doGetListSpecialWithSucceedHandler:^(id JSON) {
//        if ([JSON isKindOfClass:[NSArray class]]) {
//            if (_delegate && [_delegate respondsToSelector:@selector(rcmSpecialListManagerReqNetSucWithDataSource:reqStatus:)]) {
//                [_delegate rcmSpecialListManagerReqNetSucWithDataSource:JSON reqStatus:TRUE];
//            }
//
//        }
//    } withFailHandler:^(id error) {
//        if (_delegate && [_delegate respondsToSelector:@selector(rcmSpecialListManagerReqNetFailWithError:reqStatus:)]) {
//            [_delegate rcmSpecialListManagerReqNetFailWithError:error reqStatus:FALSE];
//        }
//    }];
    
    [DataFetcher doGetListSpecialWithLocalCachedHandler:^(id JSON) {
        
        if ([JSON isKindOfClass:[NSArray class]] && _delegate &&
            [_delegate respondsToSelector:@selector(rcmSpecialListManagerReqNetSucWithDataSource:reqStatus:)]) {
            [_delegate rcmSpecialListManagerReqNetSucWithDataSource:JSON reqStatus:TRUE];
        }
        
    } succeedHandler:^(id JSON) {
        
        if ([JSON isKindOfClass:[NSArray class]] && _delegate &&
            [_delegate respondsToSelector:@selector(rcmSpecialListManagerReqNetSucWithDataSource:reqStatus:)]) {
            [_delegate rcmSpecialListManagerReqNetSucWithDataSource:JSON reqStatus:TRUE];
        }
        
    } withFailHandler:^(id error) {
    }];
    
}

@end
