//
//  QASearchManager.m
//  hinabian
//
//  Created by 余坚 on 16/7/22.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "QASearchManager.h"
#define  MAX_SEARCH_HISTORY 6

@implementation QASearchManager
- (instancetype)init
{
    self = [super init];
    if (self) {
        //        [self setSearchHistoryText:@"澳洲"];
        //        [self setSearchHistoryText:@"美国"];
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cacnleButtonPressed:) name:SEARCH_CANCLE_NOTIFICATION object:nil];
    }
    return self;
}

/* 取消按钮按下，直接返回 */
-(void) cacnleButtonPressed:(NSNotification*)notification
{
    [_superController.navigationController popViewControllerAnimated:NO];
}
-(NSArray *)getSearchHistoryArray
{
    return [HNBUtils sandBoxGetInfo:[NSArray class] forKey:qa_search_history];
}
//设置缓存搜索的数组
-(void)setSearchHistoryText :(NSString *)seaTxt
{
    
    //读取数组NSArray类型的数据
    NSArray *myArray = [HNBUtils sandBoxGetInfo:[NSArray class] forKey:qa_search_history];
    if (myArray.count > 0) {//先取出数组，判断是否有值，有值继续添加，无值创建数组
        
    }else{
        myArray = [NSArray array];
    }
    // NSArray --> NSMutableArray
    NSMutableArray *searTXT = [myArray mutableCopy];
    /* 检查重复 */
    if (![self isThesame:searTXT Words:seaTxt]) {
        [searTXT addObject:seaTxt];
    }
    
    if(searTXT.count > MAX_SEARCH_HISTORY)
    {
        [searTXT removeObjectAtIndex:0];
    }
    [HNBUtils sandBoxSaveInfo:searTXT forKey:qa_search_history];
    
    
}

-(BOOL) isThesame:(NSMutableArray *)array Words:(NSString *)word
{
    for(NSUInteger i = 0; i < array.count; i++) {
        NSString * tmp = array[i];
        if ([tmp isEqualToString:word]) {
            [array removeObjectAtIndex:i];
            [array addObject:word];
            return  YES;
        }
    }
    return NO;
    
}
//清除缓存数组
-(void)removeAllArray
{
    [HNBUtils sandBoxClearAllInfo:qa_search_history];
}

@end
