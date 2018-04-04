//
//  IMHomeVisaCell.h
//  hinabian
//
//  Created by 何松泽 on 2017/8/25.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMHomeVisaModel.h"
#import "SingleProjVisaView.h"

static NSString *cellNib_IMHomeVisaCell = @"IMHomeVisaCell";

@interface IMHomeVisaCell : UITableViewCell

@property (nonatomic, strong) SingleProjVisaView *projVisaView;

- (void)setVisaModel:(IMHomeVisaModel *)model;
@end
