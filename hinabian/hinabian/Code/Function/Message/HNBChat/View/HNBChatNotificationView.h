//
//  HNBChatNotificationView.h
//  hinabian
//
//  Created by 何松泽 on 2018/1/22.
//  Copyright © 2018年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IMNotificationModel;

@protocol HNBChatNotificationDelegate<NSObject>

- (void)lookTribe:(NSString *)url;

@end

@interface HNBChatNotificationView : UIView

@property(nonatomic, weak) id <HNBChatNotificationDelegate>delegate;
@property (nonatomic, strong) UITableView *tableView;


/**
 *  获取数据数组和新数据的条数
 *
 *  @param count    消息条数
 *  @param datas    数据数组
 */
- (void)getData:(NSArray *)datas andNewsNum:(NSString *)countStr;

/**
 *  加载数据数组
 *
 *  @param datas    数据数组
 */
- (void)loadData:(NSArray *)datas;

@end
