//
//  TribeDetailInfoCellManager.m
//  hinabian
//
//  Created by hnbwyh on 16/10/24.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "TribeDetailInfoCellManager.h"
#import "FloorCommentModel.h"
#import "FloorCommentReplyModel.h"
#import "YYLabel.h"
#import "YYImage.h"
#import "YYText.h"
#import "HTMLContentModel.h"

@interface TribeDetailInfoCellManager ()

@property (nonatomic,strong) NSMutableArray *locations;
@property (nonatomic,strong) NSMutableArray *contents;

@end

@implementation TribeDetailInfoCellManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _floorStaticHeight = GAP_S + ICON_WH + GAP_S + GAP_S + BUTTON_BIG_H + GAP_S + 5.f;
        _replyFloorStaticHeight = 50.f;
        _replyFloorCommentHeights = [[NSMutableArray alloc] init];
        
        _locations = [[NSMutableArray alloc] init];
        _contents = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setModel:(FloorCommentModel *)model{
    
    _seeMoreHeight = 0.f;
    [_replyFloorCommentHeights removeAllObjects];
    
    /**< 楼层评论高度计算 - 文本或图片 >*/
    _floorCommentSize = [self caculateHeightForFloorContents:model.floorContentArr font:FLOOR_TEXT_FONT size:CGSizeMake(SCREEN_WIDTH - GAP_S * 2.0, 260)];
    
    /**< 回复楼层评论的高度计算 - 文本 >*/
    CGFloat replyH = 0.f;
    for (NSInteger cou = 0; cou < model.reply_infoArr.count; cou ++) {
        FloorCommentReplyModel *f = model.reply_infoArr[cou];
        NSArray *replyContents = f.replyContentArr;
        CGSize size = [self caculateHeightForFloorContents:replyContents font:REPLY_FLOOR_TEXT_FONT size:CGSizeMake(SCREEN_WIDTH - GAP_S * 4.0, 30)];
        size.height += _replyFloorStaticHeight;
        [_replyFloorCommentHeights addObject:[NSValue valueWithCGSize:size]];
        if (cou < 5) {
            replyH += size.height; // 布局的固定高度 + 文本的动态高度
        }
    }
    /**< 是否显示查看更多 - 按钮 高度 = 20 >*/
    if (model.reply_infoArr.count > DISPLAY_REPLY_MAXNUM) {
        // 帖子详情中只显示5个 - 点击查看更多进入回复详情查看全部
        _seeMoreHeight = 20.f + GAP_S;
    }else{
        _seeMoreHeight = 0.f;
    }
    replyH += _seeMoreHeight;
    
    /**< 高度计算 - 楼层评论的固定高度 + 楼层评论高度 + 回复楼层评论的高度 >*/
    _cellHeight = _floorStaticHeight + _floorCommentSize.height + replyH;
    /**< 赋值 >*/
    _model = model;
}

#pragma mark ------ 计算 YYLabel 高度

- (CGSize)caculateHeightForFloorContents:(NSArray *)contents font:(UIFont *)font size:(CGSize)size{
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    /**< 楼层评论高度计算 - 文本或图片 >*/
    for (NSInteger cou = 0; cou < contents.count; cou ++) {
        HTMLContentModel *f = contents[cou];
        switch (f.tagType) {
            case HTMLContentModelTagPText:
            {
                NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:f.textString];
                one.yy_font = font;
                one.yy_color = [UIColor DDR51_G51_B51ColorWithalph:1.0];
                one.yy_kern = [NSNumber numberWithFloat:KERN_SPACE];
                one.yy_lineSpacing = LINE_SPACE;
                [text appendAttributedString:one];
            }
                break;
            case HTMLContentModelTagImg:
            {
                if (f.imgWidth <= DIFFER_BIG_SMALL_IMAGE) { // 小图
                    UIImageView *imgView = [[UIImageView alloc] init];
                    imgView.clipsToBounds = YES;
                    imgView.contentMode = UIViewContentModeScaleAspectFill;
                    imgView.size = CGSizeMake(f.imgWidth, f.imgHeight);
                    [imgView setImage:[UIImage imageNamed:@"homePage_tribe_post"]];
                    //[imgView startAnimating];
                    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imgView
                                                                                                          contentMode:UIViewContentModeScaleAspectFill
                                                                                                       attachmentSize:CGSizeMake(f.imgWidth, f.imgHeight)
                                                                                                          alignToFont:font
                                                                                                            alignment:YYTextVerticalAlignmentCenter];
                    [text appendAttributedString:attachText];
                } else {
                    // 图片宽度大于屏幕预设宽度处理
                    CGFloat ratio = f.imgHeight / f.imgWidth;
                    f.imgWidth = f.imgWidth > (SCREEN_WIDTH - GAP_S * 2.0) ? (SCREEN_WIDTH - GAP_S * 2.0) : f.imgWidth;
                    f.imgHeight = f.imgWidth * ratio;
                    [text appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n"]];
                    UIImageView *imgView = [[UIImageView alloc] init];
                    imgView.clipsToBounds = YES;
                    imgView.contentMode = UIViewContentModeScaleAspectFill;
                    imgView.size = CGSizeMake(f.imgWidth, f.imgHeight);
                    [imgView setImage:[UIImage imageNamed:@"homePage_tribe_post"]];
                    //[imgView startAnimating];
                    NSMutableAttributedString *attatchText = [NSMutableAttributedString yy_attachmentStringWithContent:imgView
                                                                                                           contentMode:UIViewContentModeScaleAspectFill
                                                                                                        attachmentSize:CGSizeMake(f.imgWidth, f.imgHeight)
                                                                                                           alignToFont:font
                                                                                                             alignment:YYTextVerticalAlignmentCenter];
                    [text appendAttributedString:attatchText];
                    [text appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n"]];
                    [text appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n"]];
                }

            }
                break;
            case HTMLContentModelTagHref:
            {
                // 超链接
                NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:f.hyperTitle];
                one.yy_font = font;
                one.yy_lineSpacing = LINE_SPACE;
                //one.yy_underlineStyle = NSUnderlineStyleSingle;
                [text appendAttributedString:one];
            }
                break;
            case HTMLContentModelTagBr:
            {
                [text appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n"]];
            }
                break;
            default:
                break;
        }
    }
    YYLabel *label = [YYLabel new];
    label.userInteractionEnabled = YES;
    label.numberOfLines = 0;
    label.textVerticalAlignment = YYTextVerticalAlignmentTop;
    label.size = size;
    label.attributedText = text;
    [label sizeToFit];
    return label.size;
    
}

@end
