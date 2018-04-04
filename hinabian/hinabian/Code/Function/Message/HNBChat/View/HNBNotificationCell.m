//
//  HNBNotificationCell.m
//  hinabian
//
//  Created by 何松泽 on 2018/1/25.
//  Copyright © 2018年 &#20313;&#22362;. All rights reserved.
//

#import "HNBNotificationCell.h"
#import "IMNotificationModel.h"

#define ImageRadius         50
#define TopDistance         10
#define LeftDistance        7.5
#define BorderTopDistance   3

@interface HNBNotificationCell()

@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *describeLabel;

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIImageView *likeImageView;

@end

@implementation HNBNotificationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.headImageView.sd_layout
        .topSpaceToView(self.contentView,TopDistance)
        .leftSpaceToView(self.contentView,10)
        .heightIs(ImageRadius)
        .widthIs(ImageRadius);
        
        self.userNameLabel.sd_layout
        .topSpaceToView(self.contentView, TopDistance)
        .leftSpaceToView(self.headImageView, LeftDistance)
        .heightIs(17)
        .widthIs(LabelWidth);
        
        self.describeLabel.sd_layout
        .topSpaceToView(self.userNameLabel, 0)
        .leftSpaceToView(self.headImageView, LeftDistance)
        .bottomSpaceToView(self.contentView, 30)
        .widthIs(LabelWidth);
        
        self.likeImageView.sd_layout
        .topSpaceToView(self.userNameLabel, BorderTopDistance)
        .leftSpaceToView(self.headImageView, LeftDistance)
        .heightIs(14)
        .widthIs(15);
        
        self.timeLabel.sd_layout
        .topSpaceToView(self.describeLabel, BorderTopDistance)
        .leftSpaceToView(self.headImageView, LeftDistance)
        .heightIs(13)
        .widthIs(LabelWidth);
        
        self.titleLabel.sd_layout
        .topSpaceToView(self.contentView, TopDistance/2)
        .rightSpaceToView(self.contentView, 10)
        .heightIs(70)
        .widthIs(40);
    }
    return self;
}

- (void)setCellModel:(IMNotificationModel *)model
{
    if ([model.f_type isEqualToString:@"1"]) {
        //回复
        self.describeLabel.hidden = NO;
        self.likeImageView.hidden = YES;
        //移除imageView添加的所有头像
        NSArray *views = [self.headImageView subviews];
        for(UIView *view in views)
        {
            [view removeFromSuperview];
        }
        //设置参数
        NSDictionary *userDic = [model.users firstObject];
        [self.headImageView sd_setImageWithURL:userDic[@"head_url"]];
        self.userNameLabel.text = userDic[@"name"];
        self.describeLabel.text = model.f_content;
        self.timeLabel.text     = model.f_create_time;
        self.titleLabel.text    = model.f_title;
        
    }else if([model.f_type isEqualToString:@"2"]) {
        //点赞
        self.describeLabel.hidden = YES;
        self.likeImageView.hidden = NO;
        
        //四种样式 - 一个人点赞、两个人点赞、三个人点赞、大于三个人点赞
        if (model.users.count == 1) {
            NSDictionary *userDic = [model.users firstObject];
            [self.headImageView sd_setImageWithURL:userDic[@"head_url"]];
            self.userNameLabel.text =userDic[@"name"];
        }else {
            NSString *usersNameText = @"";
            [self.headImageView setImage:nil];
//            self.userNameLabel.text = @"";
            for (int index = 0; index < model.users.count ; index ++) {
                NSDictionary *userDic = model.users[index];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
                CGFloat imageHeight = (ImageRadius-7.5)/3;
                imageView.layer.cornerRadius = imageHeight;
                imageView.layer.masksToBounds = YES;
                imageView.clipsToBounds = YES;
                imageView.layer.shouldRasterize = YES;
                imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
                [imageView sd_setImageWithURL:userDic[@"head_url"]];
                [self.headImageView addSubview:imageView];
                
                if (index == 0) {
                    usersNameText = userDic[@"name"];
                }else if (index == 1) {
                    usersNameText = [usersNameText stringByAppendingString:[NSString stringWithFormat:@" %@ 等%@人",userDic[@"name"],model.total]];
                }
                
                if (model.users.count == 2) {
                    imageView.sd_layout
                    .topSpaceToView(self.headImageView,5 + index * imageHeight)
                    .leftSpaceToView(self.headImageView, 5 + index * imageHeight)
                    .widthIs(imageHeight * 2)
                    .heightIs(imageHeight * 2);
                }else if (model.users.count == 3) {
                    if (index <= 1) {
                        imageView.sd_layout
                        .topSpaceToView(self.headImageView,5)
                        .leftSpaceToView(self.headImageView, 5 + index * imageHeight)
                        .widthIs(imageHeight * 2)
                        .heightIs(imageHeight * 2);
                    }else {
                        imageView.sd_layout
                        .topSpaceToView(self.headImageView,5 + imageHeight)
                        .centerXEqualToView(self.headImageView)
                        .widthIs(imageHeight * 2)
                        .heightIs(imageHeight * 2);
                    }
                }else {
                    if (index <= 1) {
                        imageView.sd_layout
                        .topSpaceToView(self.headImageView,5)
                        .leftSpaceToView(self.headImageView, 5 + index * imageHeight)
                        .widthIs(imageHeight * 2)
                        .heightIs(imageHeight * 2);
                    }else if(index <= 3){
                        imageView.sd_layout
                        .topSpaceToView(self.headImageView,5 + imageHeight)
                        .leftSpaceToView(self.headImageView, 5 + (index-2) * imageHeight)
                        .widthIs(imageHeight * 2)
                        .heightIs(imageHeight * 2);
                    }
                }
            }
            self.userNameLabel.text = usersNameText;
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 设置行间距，暂时没有使用
- (NSMutableAttributedString *)setContent:(NSString *)content
{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10]; //设置行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    
    return attributedString;
}

- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _headImageView.layer.cornerRadius = ImageRadius/2;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.clipsToBounds = YES;
        _headImageView.layer.shouldRasterize = YES;
        _headImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        [self.contentView addSubview:_headImageView];
    }
    return _headImageView;
}

- (UIImageView *)likeImageView
{
    if (!_likeImageView) {
        _likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        [_likeImageView setImage:[UIImage imageNamed:@"IMEase_like_icon"]];
        _likeImageView.hidden = YES;
        [self.contentView addSubview:_likeImageView];
    }
    return _likeImageView;
}

- (UILabel *)userNameLabel
{
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _userNameLabel.font = [UIFont boldSystemFontOfSize:FONT_UI30PX];
        _userNameLabel.textColor = [UIColor DDR51_G51_B51ColorWithalph:1.f];
        [self.contentView addSubview:_userNameLabel];
    }
    return _userNameLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _titleLabel.font = [UIFont systemFontOfSize:FONT_UI26PX];
        _titleLabel.textColor = [UIColor DDR50_G50_B50ColorWithalph:0.4f];
        _titleLabel.numberOfLines = 4;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)describeLabel
{
    if (!_describeLabel) {
        _describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _describeLabel.font = [UIFont systemFontOfSize:FONT_UI26PX];
        _describeLabel.textColor = [UIColor DDR50_G50_B50ColorWithalph:0.8f];
        _describeLabel.numberOfLines = 0;  //自动换行
        [self.contentView addSubview:_describeLabel];
    }
    return _describeLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _timeLabel.font = [UIFont systemFontOfSize:FONT_UI24PX];
        _timeLabel.textColor = [UIColor DDR50_G50_B50ColorWithalph:0.5f];
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

@end
