//
//  GreatTalksListManager.m
//  hinabian
//
//  Created by hnbwyh on 2017/10/30.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "GreatTalksListManager.h"
#import "DataFetcher.h"

@implementation GreatTalksListManager

- (void)reqGreatTalksListData{
    
//    [DataFetcher doGetListGreatTalkWithSucceedHandler:^(id JSON) {
//        if ([JSON isKindOfClass:[NSArray class]]) {
//            if (_delegate && [_delegate respondsToSelector:@selector(greatTalksListManagerReqNetSucWithDataSource:reqStatus:)]) {
//                [_delegate greatTalksListManagerReqNetSucWithDataSource:JSON reqStatus:TRUE];
//            }
//        }
//    } withFailHandler:^(id error) {
//        if (_delegate && [_delegate respondsToSelector:@selector(greatTalksListManagerReqNetFailWithError:reqStatus:)]) {
//            [_delegate greatTalksListManagerReqNetFailWithError:error reqStatus:FALSE];
//        }
//    }];
    
    [DataFetcher doGetListGreatTalkWithLocalCachedHandler:^(id JSON) {
        if ([JSON isKindOfClass:[NSArray class]] && _delegate &&
            [_delegate respondsToSelector:@selector(greatTalksListManagerReqNetSucWithDataSource:reqStatus:)]) {
            [_delegate greatTalksListManagerReqNetSucWithDataSource:JSON reqStatus:TRUE];
        }
    } succeedHandler:^(id JSON) {
        if ([JSON isKindOfClass:[NSArray class]] && _delegate &&
            [_delegate respondsToSelector:@selector(greatTalksListManagerReqNetSucWithDataSource:reqStatus:)]) {
                [_delegate greatTalksListManagerReqNetSucWithDataSource:JSON reqStatus:TRUE];
        }
    } withFailHandler:^(id error) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(greatTalksListManagerReqNetFailWithError:reqStatus:)]) {
            [_delegate greatTalksListManagerReqNetFailWithError:error reqStatus:FALSE];
        }
        
    }];
}

@end
