//
//  HotIMProjectManager.m
//  hinabian
//
//  Created by hnbwyh on 2017/11/6.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "HotIMProjectManager.h"
#import "DataFetcher.h"

@implementation HotIMProjectManager

- (void)reqHotIMProjectData{
    
    [DataFetcher doGetHotImmigrantProjectsWithSucceedHandler:^(id JSON) {
        
        if ([JSON isKindOfClass:[NSArray class]]) {
            
            if (_delegate && [_delegate respondsToSelector:@selector(hotIMProjectManagerReqNetSucWithDataSource:reqStatus:)]) {
                [_delegate hotIMProjectManagerReqNetSucWithDataSource:JSON reqStatus:TRUE];
            }
            
        }
        
    } withFailHandler:^(id error) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(hotIMProjectManagerReqNetFailWithError:reqStatus:)]) {
            [_delegate hotIMProjectManagerReqNetFailWithError:error reqStatus:FALSE];
        }
        
    }];
    
}

@end
