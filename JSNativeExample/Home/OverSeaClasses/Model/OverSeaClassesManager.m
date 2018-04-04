//
//  OverSeaClassesManager.m
//  hinabian
//
//  Created by hnbwyh on 2018/4/3.
//  Copyright © 2018年 &#20313;&#22362;. All rights reserved.
//

#import "OverSeaClassesManager.h"
#import "DataFetcher.h"


@implementation OverSeaClassesManager

-(void)reqNetDataWithType:(NSString *)type page:(NSString *)page num:(NSString *)num{
    
    [DataFetcher doGetListOverSeaClassWithLocalCachedHandler:^(id JSON) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(OverSeaClassesWithType:curPage:data:isCache:)]) {
            [_delegate OverSeaClassesWithType:type curPage:page data:JSON isCache:TRUE];
        }
        
    } type:type page:page num:num WithSucceedHandler:^(id JSON) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(OverSeaClassesWithType:curPage:data:isCache:)]) {
            [_delegate OverSeaClassesWithType:type curPage:page data:JSON isCache:FALSE];
        }
        
    } withFailHandler:^(id error) {
    }];
    
}

-(NSArray *)filterDataSource:(NSArray<OverSeaClassModel *> *)ds extraData:(NSArray<OverSeaClassModel *> *)ed{
    NSMutableArray *rltArr = [NSMutableArray arrayWithArray:ds];
    if (ds != nil && ed != nil) {
        for (OverSeaClassModel *f in ed) {
            //NSLog(@" \n id : %@  ,title :%@\n \n \n",f.f_id,f.title);
            BOOL isAdd = TRUE;
            for (OverSeaClassModel *t in ds) {
                if ([f.f_id isEqualToString:t.f_id]) {
                    isAdd = FALSE;
                }
            }
            if (isAdd) {
                [rltArr addObject:f];
            }
        }
    }
    return rltArr;
}

@end
