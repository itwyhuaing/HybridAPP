//
//  HnbEditorTalksListManager.m
//  hinabian
//
//  Created by hnbwyh on 2017/10/27.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "HnbEditorTalksListManager.h"
#import "DataFetcher.h"

@implementation HnbEditorTalksListManager

- (void)reqHnbEditorTalksListData{
    
//    [DataFetcher doGetListHnbEditorTalkWithSucceedHandler:^(id JSON) {
//
//        if ([JSON isKindOfClass:[NSArray class]]) {
//            if (_delegate && [_delegate respondsToSelector:@selector(hnbEditorTalksListReqNetSucWithDataSource:reqStatus:)]) {
//                [_delegate hnbEditorTalksListReqNetSucWithDataSource:JSON reqStatus:TRUE];
//            }
//        }
//
//    } withFailHandler:^(id error) {
//
//        if (_delegate && [_delegate respondsToSelector:@selector(hnbEditorTalksListReqNetFailWithError:reqStatus:)]) {
//            [_delegate hnbEditorTalksListReqNetFailWithError:error reqStatus:FALSE];
//        }
//
//    }];
    
    [DataFetcher doGetListHnbEditorTalkWithLocalCachedHandler:^(id JSON) {
        
        if ([JSON isKindOfClass:[NSArray class]]) {
            if (_delegate && [_delegate respondsToSelector:@selector(hnbEditorTalksListReqNetSucWithDataSource:reqStatus:)]) {
                [_delegate hnbEditorTalksListReqNetSucWithDataSource:JSON reqStatus:TRUE];
            }
        }
        
    } succeedHandler:^(id JSON) {
        
        if ([JSON isKindOfClass:[NSArray class]]) {
            if (_delegate && [_delegate respondsToSelector:@selector(hnbEditorTalksListReqNetSucWithDataSource:reqStatus:)]) {
                [_delegate hnbEditorTalksListReqNetSucWithDataSource:JSON reqStatus:TRUE];
            }
        }
        
    } withFailHandler:^(id error) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(hnbEditorTalksListReqNetFailWithError:reqStatus:)]) {
            [_delegate hnbEditorTalksListReqNetFailWithError:error reqStatus:FALSE];
        }
        
    }];
    
}

@end
