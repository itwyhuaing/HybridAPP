//
//  IMAssessQuesnaireTableCell.h
//  hinabian
//
//  Created by wangyinghua on 16/4/9.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IMAssessQuesnaireTableCellModel;

typedef void(^CallBackForIMAssessQuesnaireTableCell)(id clickEvent,NSInteger index);
typedef void(^CallBackForEndEditing)(id event);

@interface IMAssessQuesnaireTableCell : UITableViewCell

@property (nonatomic,strong) IMAssessQuesnaireTableCellModel *cellModel;
@property (nonatomic) NSInteger currentSection;
@property (nonatomic,copy) CallBackForIMAssessQuesnaireTableCell callBack; // 文本自适应回调
@property (nonatomic,copy) CallBackForEndEditing callBackForEndEditing; // 点击按钮回调结束编辑状态

@end
