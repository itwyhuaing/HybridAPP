//
//  IMAssessQuesnaireTableCellModel.h
//  hinabian
//
//  Created by wangyinghua on 16/4/11.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>
@class IMAssessQuesnaireContentModel;

#define HEIGHT_THEM 40
#define HEIGHT_EVERY_BTN 38
#define GAP_BETWEEN_BTNS 8
#define GAP_TITLE_LEADING 23
#define GAP_BTNAREA_BOTTOM 23
#define NUM_INPUT_LANGUAGE_ABILITY 4

@interface IMAssessQuesnaireTableCellModel : NSObject

@property (nonatomic,strong) NSMutableDictionary *resultInfoDicForCell;
// 每个选择项相对应的 编码（请求web参数）
@property (nonatomic,strong) NSArray *codesCorrespondToH5;
@property (nonatomic,strong) IMAssessQuesnaireContentModel *contentModel;
// 用于签证类型 subTitle 的文本高度自适应
@property (nonatomic) NSInteger indexForshowSubtitle;
@property (nonatomic) CGFloat cellHeight;
@property (nonatomic) CGFloat subTitleHeight;

@end
