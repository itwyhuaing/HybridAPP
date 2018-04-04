//
//  ReplyDetailInfoView.h
//  hinabian
//
//  Created by hnbwyh on 16/11/14.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#define INPUT_HEIGHT 44.0
#define REPLY_INPUT_DISTANCE_TO_EDGE  10
#define SEND_BUTTON_HEIGHT 23
#define SEND_BUTTON_WIDTH 48
#define TEXTVIEW_LINE     5
#define INPUT_FONT          16

#import <UIKit/UIKit.h>
@class TribeDetailInfoCellManager;

@class ReplyDetailInfoView;
@protocol ReplyDetailInfoViewDelegate <NSObject>
- (void)replyDetailInfoView:(ReplyDetailInfoView *)view didClickEvent:(id)eventSource info:(id)info;

@end

@interface ReplyDetailInfoView : UIView

@property (nonatomic,weak) id<ReplyDetailInfoViewDelegate> delegate;

- (void)reFreshViewWithData:(TribeDetailInfoCellManager *)manager;

- (void)SuccessedSendInfo;
- (void)failedSendInfo;
@end
