//
//  TribeDetailCommonCell.m
//  hinabian
//
//  Created by 何松泽 on 2018/4/4.
//  Copyright © 2018年 &#20313;&#22362;. All rights reserved.
//

#import "TribeDetailCommonCell.h"

@interface TribeDetailCommonCell ()

@property (nonatomic , strong) UIImageView *avatarImg;

@property (nonatomic , strong) UIImageView *avatarBk;

/**
 身份标记 -- 楼主
 */
@property (nonatomic , strong) UIImageView *tipImg;

@property (nonatomic , strong) UILabel *nameLab;

@property (nonatomic , strong) UILabel *firstTipLab;

@property (nonatomic , strong) UILabel *secondTipLab;

@property (nonatomic , strong) UILabel *thirdTipLab;

/**
 回复按钮
 */
@property (nonatomic , strong) UIButton *repBtn;

/**
 内容
 */
@property (nonatomic , strong) UILabel *contentLab;

/**
 回复背景
 */
@property (nonatomic , strong) UIImageView *repBkImgView;

/**
 回复对象名
 */
@property (nonatomic , strong) UILabel *repNameLab;

/**
 回复对象原始内容
 */
@property (nonatomic , strong) UILabel *repContentLab;

/**
 描述 -- 楼层、时间
 */
@property (nonatomic , strong) UILabel *desLab;

@end

@implementation TribeDetailCommonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initialView];
        [self makeConstraints];
    }
    return self;
}

- (void)initialView {
    _avatarImg = [[UIImageView alloc]init];
    _avatarImg.backgroundColor = [UIColor redColor];
    _avatarImg.contentMode = UIViewContentModeScaleAspectFit;
    _avatarImg.layer.cornerRadius = 31.0/2.0;
    _avatarImg.layer.masksToBounds = YES;
    [self.contentView addSubview:_avatarImg];
    
    _avatarBk = [[UIImageView alloc]init];
    [self.contentView addSubview:_avatarBk];
    
    _tipImg = [[UIImageView alloc]init];
    _tipImg.image = [UIImage imageNamed:@"tribe_avatar_tip"];
    [self.contentView addSubview:_tipImg];
    
    _nameLab = [[UILabel alloc]init];
    _nameLab.textColor = [UIColor colorWithHexString:@"#6882B0"];
    _nameLab.textAlignment = NSTextAlignmentLeft;
    _nameLab.font = [UIFont systemFontOfSize:13];
    _nameLab.text = @"三涵妈妈";
    [self.contentView addSubview:_nameLab];
    
    _firstTipLab = [[UILabel alloc]init];
    _firstTipLab.backgroundColor = [UIColor colorWithHexString:@"#3FA2FF"];
    _firstTipLab.textColor = [UIColor whiteColor];
    _firstTipLab.textAlignment = NSTextAlignmentCenter;
    _firstTipLab.font = [UIFont systemFontOfSize:8];
    _firstTipLab.text = @"版主";
    _firstTipLab.layer.cornerRadius = 4;
    _firstTipLab.layer.masksToBounds = YES;
    [self.contentView addSubview:_firstTipLab];
    
    _secondTipLab = [[UILabel alloc]init];
    _secondTipLab.textColor = [UIColor colorWithHexString:@"#3FA2FF"];
    _secondTipLab.textColor = [UIColor whiteColor];
    _secondTipLab.textAlignment = NSTextAlignmentCenter;
    _secondTipLab.font = [UIFont systemFontOfSize:8];
    _secondTipLab.text = @"海外达人";
    _secondTipLab.layer.cornerRadius = 4;
    _secondTipLab.layer.masksToBounds = YES;
    [self.contentView addSubview:_secondTipLab];
    
    _thirdTipLab = [[UILabel alloc]init];
    _thirdTipLab.textColor = [UIColor colorWithHexString:@"#3FA2FF"];
    _thirdTipLab.textColor = [UIColor whiteColor];
    _thirdTipLab.textAlignment = NSTextAlignmentCenter;
    _thirdTipLab.font = [UIFont systemFontOfSize:8];
    _thirdTipLab.text = @"作者";
    _thirdTipLab.layer.cornerRadius = 4;
    _thirdTipLab.layer.masksToBounds = YES;
    [self.contentView addSubview:_thirdTipLab];
    
    _repBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_repBtn setTitle:@"回复" forState:UIControlStateNormal];
    [_repBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    _repBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_repBtn setImage:[UIImage imageNamed:@"tribe_common_rep"] forState:UIControlStateNormal];
    [_repBtn addTarget:self action:@selector(repBtnIsTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_repBtn];
}

- (void)repBtnIsTouch {
    
}

- (void)makeConstraints {
    _avatarImg.sd_layout
    .topSpaceToView(self.contentView, 22)
    .leftSpaceToView(self.contentView, 22)
    .widthIs(31)
    .heightIs(31);
    
    _avatarBk.sd_layout
    .topSpaceToView(self.contentView, 22)
    .leftSpaceToView(self.contentView, 22)
    .widthIs(31)
    .heightIs(31);
    
    _tipImg.sd_layout
    .bottomSpaceToView(_avatarImg, -6)
    .leftSpaceToView(_avatarImg, -12)
    .widthIs(19)
    .heightIs(9);
    
    _repBtn.sd_layout
    .rightSpaceToView(self.contentView, 14)
    .centerYEqualToView(_avatarImg)
    .widthIs(60)
    .heightIs(25);
    
    _nameLab.sd_layout
    .leftSpaceToView(_avatarImg, 6)
    .bottomSpaceToView(_avatarBk, -15)
    .rightSpaceToView(_repBtn, 5)
    .heightIs(13);
    
    _firstTipLab.sd_layout
    .leftEqualToView(_nameLab)
    .topSpaceToView(_nameLab, 4)
    .widthIs(29)
    .heightIs(13);
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
