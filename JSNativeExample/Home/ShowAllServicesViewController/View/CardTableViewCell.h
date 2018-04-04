//
//  CardTableViewCell.h
//  hinabian
//
//  Created by hnbwyh on 2018/3/28.
//  Copyright © 2018年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardTableDataModel.h"

#define kCARDTABLEVIEWCELLHEIGHT (249.0*SCREEN_WIDTHRATE_6)


static NSString *cell_CardTableViewCell = @"CardTableViewCell";
@interface CardTableViewCell : UITableViewCell

- (void)modifyCellWithModel:(CardTableDataModel *)f;

@end
