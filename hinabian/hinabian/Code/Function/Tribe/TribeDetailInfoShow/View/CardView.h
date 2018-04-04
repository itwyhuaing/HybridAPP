//
//  CardView.h
//  CardSlide
//
//  Created by Rahul Pant on 03/09/15.
//  Copyright (c) 2015 Rahul Pant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "TribeInfoByThemeIdModel.h"
#import "PersonInfoModel.h"

@class CardView;

@protocol CardViewDelegate <NSObject>

@optional

/**
 View 点击事件
 
 @param view        点击事件发生在 该 view 上或其子 view 上
 @param eventSource 接收点击事件的控件 - UIButton 、UIImageView 、UILabel 等
 @param info        伴随点击事件传递的数据信息 - 可以携带 ID
 */
- (void)replyTableView:(CardView *)view didClickEvent:(id)eventSource info:(id)info;
- (void)handlePanGestureTop:(UIPanGestureRecognizer *)recognizer;
- (void)handlePanGestureBottom:(UIPanGestureRecognizer *)recognizer;
- (void)tapMaskView;
- (void)textViewResign;
- (void)refreshLastPage;
- (void)tribeButtonPress;
- (void)attentionButtonPress;
-(BOOL)isKeyboardShow;
@end

@interface CardView : UIView
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UITextField *noticeTextField;
@property (nonatomic) UIColor * backGroundColor;
@property (nonatomic) BOOL isBottomOutControl;
@property (nonatomic) BOOL isTopOutControl;
@property (nonatomic) BOOL isFirstPage;
@property (nonatomic) BOOL isLastPage;
@property (nonatomic,weak) id<CardViewDelegate>delegate;
@property (nonatomic)TribeInfoByThemeIdModel * tribInfo;
@property (nonatomic)PersonInfoModel *lzInfo;

/**< V2.6 新增入口及相关内容>*/
@property (nonatomic,strong) NSDictionary *funcDic;
@property (nonatomic,strong) NSMutableArray *relContents;


- (void) tableViewToTop;
- (void) tableViewToBottom;

/**
 * 显示帖子详情web的高度
 */
@property (nonatomic) CGFloat heightForWeb;

/**
 * 显示帖子详情web的视图
 */
@property (nonatomic,strong) WKWebView *wkWebForTribe;

/**
 创建 view
 
 @param frame    坐标及尺寸
 @param delegate 代理 : 视图上的点击事件传递出去
 
 @return 返回创建的实例对象
 */
//-(instancetype)initWithFrame:(CGRect)frame delegate:(id<CardViewDelegate>)delegate;

/**
 为创建的 view 实例对象传递数据
 
 @param data 显示所需数据
 */
- (void)reqSourceDataWithData:(NSArray *)data;

/**
 刷新视图
 */
- (void)refreshViewWithData;
@end

