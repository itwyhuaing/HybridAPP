//
//  TribeShowNewView.h
//  hinabian
//
//  Created by hnbwyh on 16/6/6.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TribeShowMainManager;

@interface TribeShowNewView : UIView

@property (nonatomic,strong) TribeShowMainManager *manager;

-(instancetype)initWithFrame:(CGRect)frame tribeID:(NSString *)tribeID superVC:(UIViewController *)superVC;


@end
