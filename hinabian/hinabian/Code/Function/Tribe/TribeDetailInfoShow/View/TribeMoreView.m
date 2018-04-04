////
////  TribeMoreView.m
////  hinabian
////
////  Created by 何松泽 on 2017/8/16.
////  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
////
//
//#import "TribeMoreView.h"
//
//@interface TribeMoreView()
//{
//    /*弹框View*/
//    UIView *_alertView;
//    
//    /*底层背景*/
//    UIImageView *_BgImage1;
//    
//    /*分享*/
//    MoreBtnWithImage *_shareBtn;
//    
//    /*编辑*/
//    MoreBtnWithImage *_editorBtn;
//    
//    /*删除*/
//    MoreBtnWithImage *_deleteBtn;
//    
//    /*背景按钮*/
//    UIButton *_disMissBtn;
//}
//
//@end
//
//@implementation TribeMoreView
//
//- (instancetype)initWithFrame:(CGRect)frame
//                      isShare:(BOOL)isShare
//                     isEditor:(BOOL)isEditor
//                     isDelete:(BOOL)isDelete {
//    
//    if (self = [super initWithFrame:frame]) {
//        
//        [self setBackgroundColor:[UIColor clearColor]];
//        
//        UIButton *disMissBtn = [[UIButton alloc] initWithFrame:frame];
//        [disMissBtn setBackgroundColor:[UIColor clearColor]];
//        [disMissBtn addTarget:self action:@selector(dismissFromSuper) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:disMissBtn];
//        _disMissBtn = disMissBtn;
//        
//        CGFloat bgHeight;
//        if (isShare && isEditor && isDelete) {
//            bgHeight = 170.f;
//        }else {
//            bgHeight = 115.f;
//        }
//        
//        CGRect rect = CGRectZero;
//        rect.origin.x = SCREEN_WIDTH - 155;
//        rect.origin.y = 55;
//        rect.size = CGSizeMake(150, bgHeight);
//        _alertView = [[UIView alloc] initWithFrame:rect];
//        [self addSubview:_alertView];
//        
//        rect = CGRectZero;
//        rect.size = CGSizeMake(150, bgHeight);
//        _BgImage1 = [[UIImageView alloc] initWithFrame:rect];
//        _BgImage1.image = [UIImage imageNamed:@"Tribe_Editor_Bg1"];
//        [_alertView addSubview:_BgImage1];
//        
//        /*允许分享*/
//        if (isShare) {
//            CGRect rect = CGRectZero;
//            rect.origin.y = 10.f;
//            rect.size = CGSizeMake(150, 50);
//            MoreBtnWithImage *shareBtn = [[MoreBtnWithImage alloc] initWithFrame:rect title:@"分享" image:[UIImage imageNamed: @"Tribe_Editor_Share"]];
//            __weak typeof(self) weakSelf = self;
//            [shareBtn setDidselect:^{
//                [weakSelf dismissFromSuper];
//                if (self.shareContent) {
//                    self.shareContent();
//                }
//            }];
//            [_alertView addSubview:shareBtn];
//            _shareBtn = shareBtn;
//        }
//        
//        /*允许编辑*/
//        if (isEditor) {
//            CGRect rect = CGRectZero;
//            rect.size = CGSizeMake(150, 50);
//            
//            if (isShare) {
//                rect.origin.y = CGRectGetMaxY(_shareBtn.frame);
//            }
//            MoreBtnWithImage *editorBtn = [[MoreBtnWithImage alloc] initWithFrame:rect title:@"编辑" image:[UIImage imageNamed: @"Tribe_Editor_Write"]];
//            __weak typeof(self) weakSelf = self;
//            [editorBtn setDidselect:^{
//                [weakSelf dismissFromSuper];
//                if (self.editorContent) {
//                    self.editorContent();
//                }
//            }];
//            [_alertView addSubview:editorBtn];
//            _editorBtn = editorBtn;
//            /*编辑是最后一个隐藏底部的线*/
//            if (!isDelete) {
//                editorBtn.bottomLine.hidden = YES;
//            }
//        }
//        
//        /*允许删除*/
//        if (isDelete) {
//            CGRect rect = CGRectZero;
//            rect.size = CGSizeMake(150, 58);
//            
//            if (isEditor) {
//                rect.origin.y = CGRectGetMaxY(_editorBtn.frame) - 5.f;
//            }else if (isShare) {
//                rect.origin.y = CGRectGetMaxY(_shareBtn.frame) - 5.f;
//            }
//            MoreBtnWithImage *deleteBtn = [[MoreBtnWithImage alloc] initWithFrame:rect title:@"删除" image:[UIImage imageNamed: @"Tribe_Editor_Delete"]];
//            __weak typeof(self) weakSelf = self;
//            [deleteBtn setDidselect:^{
//                [weakSelf dismissFromSuper];
//                if (self.deleteContent) {
//                    self.deleteContent();
//                }
//            }];
//            deleteBtn.bottomLine.hidden = YES;
//            [_alertView addSubview:deleteBtn];
//            _deleteBtn = deleteBtn;
//        }
//        
//    }
//    
//    return self;
//    
//}
//
//#pragma mark - 外部设置Button
//- (void)setBtnImage:(NSString *)imageStr title:(NSString *)title index:(HNBTribeMoreBtn)index {
//    
//}
//
//- (void)dismissFromSuper {
//    [self removeFromSuperview];
////    self.hidden = YES;
//}
//
//@end
//
//@implementation MoreBtnWithImage
//
//- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image {
//    
//    if (self = [super initWithFrame:frame]) {
//        CGRect rect = CGRectZero;
//        rect.origin.x = 35.f;
//        rect.origin.y = (frame.size.height - 25.f) /2;
//        rect.size.width = 25.f;
//        rect.size.height = 25.f;
//        _MImageView = [[UIImageView alloc] initWithFrame:rect];
//        [_MImageView setImage:image];
//        [self addSubview:_MImageView];
//        
//        rect.origin.x = CGRectGetMaxX(self.MImageView.frame) + 16;
//        rect.origin.y += 2.f;
//        rect.size.width = 40.f;
//        _MLabel = [[UILabel alloc] initWithFrame:rect];
//        [_MLabel setFont:[UIFont systemFontOfSize:16.f]];
//        [_MLabel setTextColor:[UIColor blackColor]];
//        [_MLabel setText:title];
//        [self addSubview:_MLabel];
//        
//        float dis = 20.f;
//        rect.origin.x = dis;
//        rect.origin.y = frame.size.height - 1.f;
//        rect.size.width = frame.size.width - dis*2;
//        rect.size.height = 0.5f;
//        _bottomLine = [[UIView alloc] initWithFrame:rect];
//        _bottomLine.layer.borderColor = [UIColor DDR51_G51_B51ColorWithalph:0.5f].CGColor;
//        _bottomLine.layer.borderWidth = 0.5f;
//        [self addSubview:_bottomLine];
//        
//        rect = CGRectZero;
//        rect.size = frame.size;
//        _MBtn = [[UIButton alloc] initWithFrame:rect];
//        [_MBtn addTarget:self action:@selector(clickMBtn) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_MBtn];
//    }
//    
//    return self;
//}
//
//- (void)clickMBtn {
//    if (self.didselect) {
//        self.didselect();
//    }
//}
//
//@end
//
//
//
