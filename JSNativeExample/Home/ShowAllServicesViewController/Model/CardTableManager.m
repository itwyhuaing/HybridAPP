//
//  CardTableManager.m
//  hinabian
//
//  Created by hnbwyh on 2018/3/28.
//  Copyright © 2018年 &#20313;&#22362;. All rights reserved.
//

#import "CardTableManager.h"
#import "DataFetcher.h"

@implementation CardTableManager

- (void)reqOverSeaServiceListWithType:(NSString *)type start:(NSInteger)start num:(NSInteger)num{
    
    [DataFetcher doGetOverSeaServiceListWithType:type start:start num:num succeedHandler:^(id JSON) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(cardTableData:)]) {
            [_delegate cardTableData:JSON];
        }
        
    } withFailHandler:^(id error) {
        
    }];
    
}

@end
