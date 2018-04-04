//
//  IMAssessQuestionnaireView.h
//  hinabian
//
//  Created by wangyinghua on 16/4/8.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IMASSESSQUESNAIRETATBLECELL_TITLE_HEIGHT 140
#define IMASSESSQUESNAIRETATBLECELL_HEADER_HEIGHT 10
#define IMASSESSQUESNAIREVIEW_SUBMMITBTN_HEIGHT 50
typedef enum : NSUInteger {
    ConfirmBtnTag = 1 << 0,
    ConsultPhoneBtnTag = 1 << 1,
    ConsultOnlineBtnTag = 1 << 2,
    ConsultAppointmentBtnTag = 1 << 3
} IMAssessQuestionnaireViewBtnTag;
typedef void(^SendInfo)(id clickEvent , NSURL *reqUrl);

@interface IMAssessQuestionnaireView : UIView

@property (nonatomic,copy) SendInfo callBackToController;

-(void)reqListData:(id)data;

@end
