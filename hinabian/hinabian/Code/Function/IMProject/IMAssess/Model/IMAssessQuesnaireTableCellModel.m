//
//  IMAssessQuesnaireTableCellModel.m
//  hinabian
//
//  Created by wangyinghua on 16/4/11.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "IMAssessQuesnaireTableCellModel.h"
#import "IMAssessQuesnaireContentModel.h"

@implementation IMAssessQuesnaireTableCellModel

// 重写 set , 处理相关数据
- (void)setContentModel:(IMAssessQuesnaireContentModel *)contentModel{
    _contentModel = contentModel;
    
    NSArray *choices = _contentModel.choices;
    NSInteger btnNum = choices.count;
    NSString *title = _contentModel.title;
    // 处理副标题的高度自适应
    NSString *subTitle = self.contentModel.subTitles[_indexForshowSubtitle];
    if ([subTitle isEqualToString:@""]) {
        _subTitleHeight = 0;
    }else{
        CGRect frame = [subTitle boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - GAP_TITLE_LEADING*2, 10000)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:13]
                                                                                  forKey:NSFontAttributeName]
                                              context:nil];
        _subTitleHeight = frame.size.height;
    }
    // 区分高度
    if([title isEqualToString:@"5.您将用于移民预算"]){
        _cellHeight = HEIGHT_THEM + _subTitleHeight + GAP_BETWEEN_BTNS + HEIGHT_EVERY_BTN + GAP_BTNAREA_BOTTOM;
    }else if([title isEqualToString:@"7.您的外语能力"]){
        CGFloat btnAreaH = (HEIGHT_EVERY_BTN + GAP_BETWEEN_BTNS) * btnNum;
        CGFloat languageAbilityTitleH = HEIGHT_THEM/2.0;
        CGFloat languageAbilityAreaH = (HEIGHT_EVERY_BTN + GAP_BETWEEN_BTNS) * NUM_INPUT_LANGUAGE_ABILITY;
        _cellHeight = HEIGHT_THEM + _subTitleHeight + btnAreaH + GAP_BETWEEN_BTNS + languageAbilityTitleH + languageAbilityAreaH + GAP_BTNAREA_BOTTOM;
    }else{
        CGFloat btnAreaH = 0;
        CGFloat couNumPerRow = 2.0;// 每行个数
        if ([title isEqualToString:@"1.移民意向国家"]) {
            couNumPerRow = 4.0;
        }
        NSInteger couNumPerRank = (NSInteger)(ceil(btnNum / couNumPerRow)); // 每列个数
        btnAreaH = (HEIGHT_EVERY_BTN + GAP_BETWEEN_BTNS) * couNumPerRank + GAP_BETWEEN_BTNS;
        _cellHeight = HEIGHT_THEM + _subTitleHeight + btnAreaH + GAP_BTNAREA_BOTTOM;
    }
}

@end
