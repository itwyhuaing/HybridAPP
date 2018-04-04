//
//  ReplyView.h
//  hinabian
//
//  Created by 余坚 on 15/9/2.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacialView.h"
#import "MIBadgeButton.h"

#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"

@protocol HNBReplyViewDelegate;

@interface ReplyView : UIView<facialViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UIPickerViewDelegate,UITextViewDelegate,UITextFieldDelegate,UIPopoverControllerDelegate,TZImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UITextView *inputTextField;
@property (strong, nonatomic) UIButton * sendButton;
@property (strong, nonatomic) UIButton * zanButton;
@property (strong, nonatomic) UIButton * jumpButton;
@property (strong, nonatomic) UIButton * collectButton;
@property (strong, nonatomic) MIBadgeButton * addButton;
@property (strong, nonatomic) UIButton * faceButton;
@property (strong, nonatomic) UIImageView *zanImageView;
@property (strong, nonatomic) UIImageView *collectImageView;
@property (strong, nonatomic) UILabel * uilabel;
@property (strong, nonatomic) UIScrollView *scrollView;//表情滚动视图
@property (strong, nonatomic) UIScrollView *picscrollView;//图片滚动视图
@property (strong, nonatomic) UIButton * addImageButton;
@property (nonatomic, strong) UIPopoverController *popover;
@property (nonatomic, weak) UIViewController * superViewController;
@property (nonatomic, weak) id<HNBReplyViewDelegate> delegate;
@property (nonatomic,copy) NSString *from; // 友盟统计 1-点击输入评论
@property (nonatomic,copy) NSString *curUrlStr; // 友盟统计时需要记录帖子id

-(void) fallAllView;
//-(void) becomeFirstResponder;
//-(void) registFirstResponder;
-(void) replyBecomeFirstResponder;
-(void) replyViewEnable:(BOOL)enable;
@end


@protocol HNBReplyViewDelegate <NSObject>
@optional
-(void) HNBReplyViewSendButtonPressed:(ReplyView*)view TEXT:(NSString*)text IMAGE:(NSArray*)imageList;
-(void) HNBReplyViewZanButtonPressed;
-(void) HNBReplyViewCollectButtonPressed;
-(void) HNBReplyViewJumpButtonPressed;
-(void) startReplyEditing;
-(void) hideMaskView:(BOOL)isHide;
-(void) endReplyEditing;
@end
