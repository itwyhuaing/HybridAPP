//
//  SWKQASearchView.h
//  hinabian
//
//  Created by hnbwyh on 16/8/17.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QASearchManager.h"

@interface SWKQASearchView : UIView

@property (strong, nonatomic) QASearchManager *searchManager;
@property (weak, nonatomic) UIViewController * superController;

@end
