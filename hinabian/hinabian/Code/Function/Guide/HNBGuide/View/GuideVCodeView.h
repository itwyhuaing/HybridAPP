//
//  GuideVCodeView.h
//  hinabian
//
//  Created by 何松泽 on 2017/10/26.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GuideVCodeViewDelegate<NSObject>

@optional
- (void)GuideVCodeViewGetVCode:(id)sender;

@end

@interface GuideVCodeView : UIView

@property (nonatomic, strong)UITextField *nameTextfield;
@property (nonatomic, strong)UITextField *phoneTextfield;
@property (nonatomic, strong)UITextField *vCodeTextField;
@property (nonatomic, strong)UIButton *maleBtn;
@property (nonatomic, strong)UIButton *femaleBtn;
@property (nonatomic, strong)UIButton *vCodeBtn;

@property (nonatomic, weak)id<GuideVCodeViewDelegate> delegate;

- (void)showVCodeView;
- (void)hideVCodeView;

@end
