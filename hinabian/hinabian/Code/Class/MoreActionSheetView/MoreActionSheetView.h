//
//  MoreActionSheetView.h
//  MoreActionSheet
//
//  Created by 何松泽 on 2018/3/22.
//  Copyright © 2018年 何松泽. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *MoreActionSheet_Title = @"MoreActionSheet_Title";
static NSString *MoreActionSheet_Image = @"MoreActionSheet_Image";
static NSString *MoreActionSheet_Func  = @"MoreActionSheet_Func";

@interface MoreBtnWithImage : UIView

@property (nonatomic, strong)UIButton   *MBtn;
@property (nonatomic, strong)UILabel    *MLabel;
@property (nonatomic, strong)UIView     *bottomLine;
@property (nonatomic, strong)UIImageView*MImageView;

@property (nonatomic, copy)void (^didselect)(void);

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                        image:(UIImage *)image;

@end


@interface MoreActionSheetView : UIView
/*
 ** btnArr: 数组处理如下:
 ** 数组数据: 内部元素为字典，字典Key值为:
 ** MoreActionSheet_Title - 按钮标题
 ** MoreActionSheet_Image - 按钮图片
 ** MoreActionSheet_Func  - 按钮响应事件
 */
- (void)setBtnArray:(NSArray *)btnArr;

@end
