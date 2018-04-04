//
//  TribeDetailWebCell.m
//  hinabian
//
//  Created by 何松泽 on 2018/4/3.
//  Copyright © 2018年 &#20313;&#22362;. All rights reserved.
//

#import "TribeDetailWebCell.h"

@interface TribeDetailWebCell ()

@end

@implementation TribeDetailWebCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initialView];
    }
    return self;
}

- (void)initialView {
    
}

- (void)makeConstraints {
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
