//
//  HinabianEditorTopicTableViewCell.h
//  hinabian
//
//  Created by hnbwyh on 2017/10/20.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *cell_HinabianEditorTopicTableViewCell = @"HinabianEditorTopicTableViewCell";
@interface HinabianEditorTopicTableViewCell : UITableViewCell

- (void)setModel:(id)model;

- (void)reSetUnderLineDisplayWithState:(BOOL)state;

@end
