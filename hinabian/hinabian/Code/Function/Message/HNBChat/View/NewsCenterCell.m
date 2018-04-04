//
//  NewsCenterCell.m
//  hinabian
//
//  Created by hnbwyh on 16/6/3.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "NewsCenterCell.h"
#import "NewsCenterModel.h"

@implementation NewsCenterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self modifyCell];
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self modifyCell];
    
    //[self setColor];
}


- (void)modifyCell{

    self.itemImageView.clipsToBounds = YES;
    self.itemImageView.layer.cornerRadius = CGRectGetHeight(self.itemImageView.frame) / 2.0;
    
    self.time.textAlignment = NSTextAlignmentRight;
    [self.time setTextColor:[UIColor DDR153_G153_B153ColorWithalph:1.0]];
    self.time.font = [UIFont systemFontOfSize:FONT_UI20PX];
    
    self.newsNum.textAlignment = NSTextAlignmentCenter;
    self.newsNum.backgroundColor = [UIColor redColor];
    [self.newsNum setTextColor:[UIColor whiteColor]];
    self.newsNum.font = [UIFont boldSystemFontOfSize:FONT_UI24PX];
    self.newsNum.layer.cornerRadius = CGRectGetHeight(self.newsNum.frame) / 2.0;
    self.newsNum.clipsToBounds = YES;
    
    self.itemTitle.textAlignment= NSTextAlignmentLeft;
    [self.itemTitle setTextColor:[UIColor DDR0_G0_B0ColorWithalph:1.0]];
    self.itemTitle.font = [UIFont systemFontOfSize:FONT_UI32PX];
    
    self.newsDesc.textAlignment= NSTextAlignmentLeft;
    [self.newsDesc setTextColor:[UIColor DDR153_G153_B153ColorWithalph:1.0]];
    self.newsDesc.font = [UIFont systemFontOfSize:FONT_UI28PX];
    
}


-(void)setCellItemWithInfoModel:(NewsCenterModel *)infoModel{

    //NSLog(@" infoModel.title ------ > %@",infoModel.title);
    [self.itemImageView setImage:[UIImage imageNamed:infoModel.imgName]];
    [self.itemTitle setText:infoModel.title];
    [self.newsDesc setText:infoModel.desc];
    [self.time setText:infoModel.formated_time];

    // 消息数处理
    NSInteger newsCount = [infoModel.noctice_num integerValue];
    NSString *newsCountString = infoModel.noctice_num;
    if (newsCount > 99) {
        
        newsCountString = @"99+";
        self.newsNum.hidden = NO;
        
    }else if (newsCount >= 1 && newsCount <= 99){
        
        self.newsNum.hidden = NO;
        
    }else{
        
        self.newsNum.hidden = YES;
        return;
    }
    
    [self.newsNum setText:newsCountString];
    // 拿到消息数 更新长度
    if (newsCountString.length == 1) {
        self.newsNumWidth.constant = CGRectGetHeight(self.newsNum.frame);
    } else {
        
        CGSize labelSize = [self.newsNum.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_UI18PX]}];
        self.newsNumWidth.constant = labelSize.width + CGRectGetHeight(self.newsNum.frame)/2.0;
        
        //NSLog(@"labelSize.width  ------ > %f",labelSize.width);
    }
        
    
    
}



- (void)setColor{

    self.itemTitle.backgroundColor = [UIColor redColor];
    self.time.backgroundColor = [UIColor greenColor];
    self.newsNum.backgroundColor = [UIColor blueColor];
    self.newsDesc.backgroundColor = [UIColor orangeColor];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
