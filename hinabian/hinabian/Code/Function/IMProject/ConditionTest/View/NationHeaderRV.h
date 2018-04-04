//
//  NationHeaderRV.h
//  hinabian
//
//  Created by hnbwyh on 17/6/9.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *reuseV_NationHeaderRV = @"NationHeaderRV";
@interface NationHeaderRV : UICollectionReusableView

- (void)configNationHeaderRVContentsWithAreaName:(NSString *)areaName;

- (void)setTitleLabelHide:(BOOL)isHiden;

@end
