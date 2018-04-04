//
//  LatestNewsListManager.m
//  hinabian
//
//  Created by hnbwyh on 2017/10/18.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "LatestNewsListManager.h"
#import "DataFetcher.h"
//#import "NSDictionary+ValueForKey.h"

@implementation LatestNewsListManager

-(void)reqLatestNewsListDataStart:(NSInteger)start count:(NSInteger)count{
    
    [DataFetcher doGetListLatestNewsWithParameterStart:start count:count withSucceedHandler:^(id JSON) {
        
        NSArray *listData = [JSON returnValueWithKey:@"listData"];
        NSString *isSameString = [JSON returnValueWithKey:@"isSame"];
        NSString *totalString = [JSON returnValueWithKey:@"total"];
        NSInteger total = [totalString integerValue];
        BOOL isSame = [isSameString boolValue];
        BOOL br = start <= 0 ? FALSE : TRUE;
        
        if(_delegate && [_delegate respondsToSelector:@selector(latestNewsListReqNetSucWithDataSource:total:isSame:isBottomRefresh:)]){
            [_delegate latestNewsListReqNetSucWithDataSource:listData
                                                       total:total
                                                      isSame:isSame
                                             isBottomRefresh:br];
        }
        
    } withFailHandler:^(id error) {
       
        if (_delegate && [_delegate respondsToSelector:@selector(latestNewsListReqNetFailWithError:reqStatus:)]) {
            [_delegate latestNewsListReqNetFailWithError:error reqStatus:FALSE];
        }
        
    }];
    
    
}

@end
