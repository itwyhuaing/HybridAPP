//
//  TribeDetailFunctionEntryCell.h
//  hinabian
//
//  Created by hnbwyh on 16/12/26.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *cellNib_TribeDetailFunctionEntryCell = @"TribeDetailFunctionEntryCell";
@interface TribeDetailFunctionEntryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *functionEntryLabel;

- (void)configContentsForCellWithString:(NSString *)string;

@end
