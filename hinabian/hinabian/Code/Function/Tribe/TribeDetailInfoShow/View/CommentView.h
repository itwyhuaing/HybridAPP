//
//  CommentView.h
//  TextImageDemo
//
//  Created by hnbwyh on 16/10/9.
//  Copyright © 2016年 hnbwyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FloorCommentReplyModel;
@class YYLabel;

typedef void(^ClickEventForCommentViewBlock)(id eventSource,id info);

@interface CommentView : UIView

@property (nonatomic,copy) ClickEventForCommentViewBlock eventBlock;

@property (nonatomic,strong) UILabel *userName;
@property (nonatomic,strong) UILabel *date;
@property (nonatomic,strong) YYLabel *content;

- (void)setContentsWithFloorCommentReplyModel:(FloorCommentReplyModel *)model;

@end
