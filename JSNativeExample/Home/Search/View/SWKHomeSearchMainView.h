//
//  SWKHomeSearchMainView.h
//  hinabian
//
//  Created by hnbwyh on 16/8/17.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeSearchManager.h"

@interface SWKHomeSearchMainView : UIView

@property (strong, nonatomic) HomeSearchManager *searchManager;
@property (weak, nonatomic) UIViewController * superController;

@end
