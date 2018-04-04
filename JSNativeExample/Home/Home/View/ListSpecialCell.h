//
//  ListSpecialCell.h
//  hinabian
//
//  Created by hnbwyh on 2017/10/30.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SpecialConsult)(id info);

static NSString *cell_ListSpecialCell = @"ListSpecialCell";
@interface ListSpecialCell : UITableViewCell

@property (nonatomic,copy) SpecialConsult consultBlock;

- (void)setModel:(id)model;

@end
