//
//  HinabianEditorTopicTableViewCell.m
//  hinabian
//
//  Created by hnbwyh on 2017/10/20.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "HinabianEditorTopicTableViewCell.h"
#import "HnbEditorTalkModel.h"

@interface HinabianEditorTopicTableViewCell ()

@property (nonatomic,strong) UIImageView *imageV;
@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UILabel *editor;
@property (nonatomic,strong) UILabel *time;
@property (nonatomic,strong) UILabel *line;

@end

@implementation HinabianEditorTopicTableViewCell

#pragma mark ----- init

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setUpCell];
    }
    return self;
}

- (void)setUpCell{
    
    _imageV = [[UIImageView alloc] init];
    _title = [[UILabel alloc] init];
    _editor = [[UILabel alloc] init];
    _time = [[UILabel alloc] init];
    _line = [[UILabel alloc] init];
    [self addSubview:_imageV];
    [self addSubview:_title];
    [self addSubview:_editor];
    [self addSubview:_time];
    [self addSubview:_line];
    
    
    _imageV.sd_layout
    .leftSpaceToView(self, 10 * SCREEN_WIDTHRATE_6)
    .topSpaceToView(self, 17 * SCREEN_WIDTHRATE_6)
    .heightIs(80 * SCREEN_WIDTHRATE_6) // (222 - 212)/2 = 5
    .widthIs(80.0/81.0 * 112 * SCREEN_WIDTHRATE_6);
    
    _line.sd_layout
    .leftEqualToView(_imageV)
    .rightSpaceToView(self, 0)
    .bottomSpaceToView(self, 0)
    .heightIs(0.6);
    
    _time.sd_layout
    .rightSpaceToView(self, 34 * SCREEN_WIDTHRATE_6)
    .bottomSpaceToView(_line, 15 * SCREEN_WIDTHRATE_6)
    .heightIs(16)
    .widthIs(80);
    
    _editor.sd_layout
    .leftSpaceToView(_imageV, 16.0 * SCREEN_WIDTHRATE_6)
    .bottomSpaceToView(_line, 15 * SCREEN_WIDTHRATE_6)
    .heightIs(16)
    .rightSpaceToView(_time, 0);
    
    _title.sd_layout
    .leftEqualToView(_editor)
    .rightSpaceToView(self, 29 * SCREEN_WIDTHRATE_6)
    .topSpaceToView(self, 22 * SCREEN_WIDTHRATE_6)
    .bottomSpaceToView(_editor, 20 * SCREEN_WIDTHRATE_6);
    
    _imageV.contentMode = UIViewContentModeScaleAspectFill;
    _imageV.clipsToBounds = YES;
    _title.textColor = [UIColor DDR51_G51_B51ColorWithalph:1.0];
    _title.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONT_UI28PX];
    _title.numberOfLines = 0;
    _editor.textColor = [UIColor DDR102_G102_B102ColorWithalph:1.0];
    _editor.font = [UIFont systemFontOfSize:FONT_UI26PX];
    _time.textColor = [UIColor DDR153_G153_B153ColorWithalph:1.0];
    _time.font = [UIFont systemFontOfSize:FONT_UI22PX];
    _time.textAlignment = NSTextAlignmentRight;
    _line.backgroundColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor];
    
    //[self test];
}

#pragma mark ----- 数据回调刷新

- (void)setModel:(id)model{
    if (model) {
        HnbEditorTalkModel *f = (HnbEditorTalkModel *)model;
        [_title setAttributedText:[self modifyLineSpaceWithContent:f.title]];
        _editor.text = f.author;
        _time.text = f.dateEndShow;
        [_imageV sd_setImageWithURL:[NSURL URLWithString:f.editorImage_url]];
    }
}

-(void)reSetUnderLineDisplayWithState:(BOOL)state{
    self.line.hidden = state;
}

- (NSAttributedString *)modifyLineSpaceWithContent:(NSString *)cnt{
    NSMutableAttributedString *mutableAttribetedString = [[NSMutableAttributedString alloc] initWithString:cnt];
    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
    [para setLineSpacing:5.f];
    [mutableAttribetedString addAttribute:NSParagraphStyleAttributeName
                                    value:para
                                    range:NSMakeRange(0, cnt.length)];
    return mutableAttribetedString;
}

#pragma mark ----- 点击交互

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)test{
//    _imageV.backgroundColor = [UIColor greenColor];
//    _title.backgroundColor = [UIColor purpleColor];
//    _editor.backgroundColor = [UIColor redColor];
//    _time.backgroundColor = [UIColor yellowColor];
//    _line.backgroundColor = [UIColor blackColor];
    
    _title.text = @"小编说第1期手里又100万到到底该往哪里移民？";
    _editor.text = @"小边说";
    _time.text = @"2017-10-11";
    [_imageV sd_setImageWithURL:[NSURL URLWithString:@"https://cache.hinabian.com/images/release/3/6/3f7f426b1c60c87fcce618a21c50c216.jpeg"]];

    NSLog(@" _imageV :%@ ",_imageV);
}

@end
