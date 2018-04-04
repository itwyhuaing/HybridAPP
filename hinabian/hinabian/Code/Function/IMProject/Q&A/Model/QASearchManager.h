//
//  QASearchManager.h
//  hinabian
//
//  Created by 余坚 on 16/7/22.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QASearchManager : NSObject
@property (weak, nonatomic) UIViewController * superController;

//获取缓存搜索的数组
-(NSArray *)getSearchHistoryArray;
//设置缓存搜索的数组
-(void)setSearchHistoryText :(NSString *)seaTxt;
//清除缓存数组
-(void)removeAllArray;
@end
