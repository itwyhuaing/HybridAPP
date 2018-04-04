//
//  TribeDetailRelatedThem.h
//  hinabian
//
//  Created by hnbwyh on 16/12/26.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *cellNib_TribeDetailRelatedThem = @"TribeDetailRelatedThem";
@interface TribeDetailRelatedThem : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *relativedThemLabel;

- (void)configContentsForCellWithDic:(NSDictionary *)infoDic;

@end
