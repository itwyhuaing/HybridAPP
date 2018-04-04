//
//  ListGreatTalkCell.m
//  hinabian
//
//  Created by hnbwyh on 2017/10/30.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "ListGreatTalkCell.h"
#import "GreatTalkModel.h"

@interface ListGreatTalkCell ()

@property (nonatomic,strong) UIImageView *greatMasterIcon;
@property (nonatomic,strong) UILabel *talkTitle;
@property (nonatomic,strong) UILabel *greatMasterName;
@property (nonatomic,strong) UILabel *greatMasterDes;
@property (nonatomic,strong) UILabel *talkNum;
@property (nonatomic,strong) UILabel *talkDate;

@end

@implementation ListGreatTalkCell

#pragma mark ----- init

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setUpCell];
        //[self test];
    }
    return self;
}

- (void)setUpCell{
    _greatMasterIcon = [[UIImageView alloc] init];
    _talkTitle = [[UILabel alloc] init];
    _greatMasterName = [[UILabel alloc] init];
    _greatMasterDes = [[UILabel alloc] init];
    _talkNum = [[UILabel alloc] init];
    _talkDate = [[UILabel alloc] init];
    
    [self addSubview:_greatMasterIcon];
    [self addSubview:_talkTitle];
    [self addSubview:_greatMasterName];
    [self addSubview:_greatMasterDes];
    [self addSubview:_talkNum];
    [self addSubview:_talkDate];
    
    _greatMasterIcon.sd_layout
    .leftSpaceToView(self, 10.0 * SCREEN_WIDTHRATE_6)
    .topSpaceToView(self, 10.0 * SCREEN_WIDTHRATE_6)
    .heightIs(174.0/2.0 * SCREEN_WIDTHRATE_6)
    .widthIs(222.0/2.0 * SCREEN_WIDTHRATE_6);
    
    _talkTitle.sd_layout
    .leftSpaceToView(_greatMasterIcon, 11.0 * SCREEN_WIDTHRATE_6)
    .topSpaceToView(self, 15.0 * SCREEN_WIDTHRATE_6)
    .heightIs(18.0 * SCREEN_WIDTHRATE_6)
    .rightSpaceToView(self, 10.0 * SCREEN_WIDTHRATE_6);
    
    _greatMasterName.sd_layout
    .leftEqualToView(_talkTitle)
    .topSpaceToView(_talkTitle, 12.0 * SCREEN_WIDTHRATE_6)
    .widthIs(60.0 * SCREEN_WIDTHRATE_6)
    .heightIs(15.0 * SCREEN_WIDTHRATE_6);
    
    _greatMasterDes.sd_layout
    .leftSpaceToView(_greatMasterName, 10.0 * SCREEN_WIDTHRATE_6)
    .topEqualToView(_greatMasterName)
    .rightEqualToView(_talkTitle)
    .heightRatioToView(_greatMasterName, 1.0);
    
    _talkNum.sd_layout
    .leftEqualToView(_talkTitle)
    .topSpaceToView(_greatMasterName, 17.0 * SCREEN_WIDTHRATE_6)
    .widthIs(100.0 * SCREEN_WIDTHRATE_6)
    .heightIs(13.0 * SCREEN_WIDTHRATE_6);
    
    _talkDate.sd_layout
    .topEqualToView(_talkNum)
    .heightRatioToView(_talkNum, 1.0)
    .rightEqualToView(_talkTitle)
    .widthIs(100.0 * SCREEN_WIDTHRATE_6);
    
    // 属性设置
    _greatMasterIcon.contentMode = UIViewContentModeScaleAspectFill;
    _greatMasterIcon.clipsToBounds = TRUE;
    _talkTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONT_UI32PX];
    _talkTitle.textColor = [UIColor DDR51_G51_B51ColorWithalph:1.0];
    _greatMasterName.font = [UIFont systemFontOfSize:FONT_UI28PX];
    _greatMasterName.textColor = [UIColor DDR102_G102_B102ColorWithalph:1.0];
    _greatMasterDes.font = [UIFont systemFontOfSize:FONT_UI28PX];
    _greatMasterDes.textColor = [UIColor DDR102_G102_B102ColorWithalph:1.0];
    _talkNum.font = [UIFont systemFontOfSize:FONT_UI24PX];
    _talkNum.textColor = [UIColor DDR153_G153_B153ColorWithalph:1.0];
    _talkDate.font = [UIFont systemFontOfSize:FONT_UI24PX];
    _talkDate.textColor = [UIColor DDR153_G153_B153ColorWithalph:1.0];
    _talkDate.textAlignment = NSTextAlignmentRight;
    
}

#pragma mark ----- 数据回调刷新

- (void)setModel:(id)model{
    if (model) {
        GreatTalkModel *f = (GreatTalkModel *)model;
        // 头像显示
        if (f.greatMasterIcon != nil || f.greatMasterIcon.length > 0) {
            [_greatMasterIcon sd_setImageWithURL:[NSURL URLWithString:f.greatMasterIcon]];
        }else{
            [_greatMasterIcon sd_setImageWithURL:[NSURL URLWithString:f.greatImage_url]];
        }
        
        _talkTitle.text = f.title;
        _greatMasterName.text = f.greatMasterName;
        _greatMasterDes.text = f.greatMasterDes;
        _talkNum.text = f.talkNum;
        _talkDate.text = f.dateShow;
        
    }
}

#pragma mark ----- 点击交互

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)test{
    
    _talkTitle.backgroundColor = [UIColor greenColor];
    _greatMasterName.backgroundColor = [UIColor redColor];
    _greatMasterDes.backgroundColor = [UIColor redColor];
    _talkNum.backgroundColor = [UIColor purpleColor];
    _talkDate.backgroundColor = [UIColor greenColor];
    _greatMasterIcon.backgroundColor = [UIColor redColor];
    
}

@end
