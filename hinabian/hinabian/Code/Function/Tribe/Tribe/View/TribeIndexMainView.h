//
//  TribeIndexMainView.h
//  hinabian
//
//  Created by 余坚 on 16/6/6.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TribeIndexMainManager.h"
//#import "HNBTipMask.h"
#import "FunctionTipView.h"

@interface TribeIndexMainView : UIView
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) TribeIndexMainManager *tribeManager;
@property (weak, nonatomic) UIViewController * superController;

//@property (nonatomic,strong) HNBTipMask *postMask;
@property (nonatomic,strong) FunctionTipView *postMask;
//@property (nonatomic,strong) UIImageView *writingImgV;

@end
