//
//  IMProjectVisaCell.h
//  hinabian
//
//  Created by 何松泽 on 2017/8/25.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMHomeProjModel.h"
#import "SingleProjVisaView.h"

static NSString *cellNib_IMProjectVisaCell = @"IMProjectVisaCell";

@interface IMProjectVisaCell : UITableViewCell

@property (nonatomic, strong) SingleProjVisaView *projVisaView;

- (void)setProjModel:(IMHomeProjModel *)model;

@end
