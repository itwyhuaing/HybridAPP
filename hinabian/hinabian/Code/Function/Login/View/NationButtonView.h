//
//  NationButtonView.h
//  hinabian
//
//  Created by 何松泽 on 17/4/13.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol NationButtonViewDelegate <NSObject>
@optional
- (void) clickNationButton;
- (void) clickMoreButton;

@end

@interface NationButtonView : UIView
{
    float currentTime;
    BOOL isShowAll;
}

-(id)initAllShowWithFrame:(CGRect)frame andSelectedNation:(NSArray *)IdArray;

@property (nonatomic, strong) id<NationButtonViewDelegate> delegate;
@property (nonatomic, assign) float             newHeight;
@property (nonatomic, strong) UIButton          *moreBtn;
@property (nonatomic, strong) NSMutableArray    *selectedNationsCode;
@property (nonatomic, strong) NSMutableArray    *selectedNationString;
@property (nonatomic, strong) NSMutableArray    *nationButtonArray;
@property (nonatomic, strong) NSMutableArray    *inputNationIDArray;
@property (nonatomic, strong) NSMutableArray    *nationArray;

@end
