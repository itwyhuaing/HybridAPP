//
//  IMAssessQuesnaireTableCell.m
//  hinabian
//
//  Created by wangyinghua on 16/4/9.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "IMAssessQuesnaireTableCell.h"
#import "IMAssessQuesnaireTableCellModel.h"
#import "IMAssessQuesnaireContentModel.h"

@interface IMAssessQuesnaireTableCell () <UITextFieldDelegate>

@property (nonatomic,strong) UILabel *redFlag;
@property (nonatomic,strong) UILabel *titleLable;
@property (nonatomic,strong) UILabel *noteLable;
@property (nonatomic,strong) UILabel *subLable;

@property (nonatomic,strong) NSArray *choices;
@property (nonatomic,strong) NSArray *codes;

@end

@implementation IMAssessQuesnaireTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
    }
    return self;
}


- (void)setCellModel:(IMAssessQuesnaireTableCellModel *)cellModel{
    _cellModel = cellModel;
    NSString *redFlag = _cellModel.contentModel.redFlag;
    NSString *title = _cellModel.contentModel.title;
    NSString *note = _cellModel.contentModel.note;
    NSArray *subTitles = _cellModel.contentModel.subTitles;
    NSString *subTitle = subTitles[_cellModel.indexForshowSubtitle];
    _currentSection = [self handleTitle:title];
    _choices = _cellModel.contentModel.choices;
    _codes = cellModel.codesCorrespondToH5;
   
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    CGFloat widthRatio = SCREEN_WIDTH / SCREEN_WIDTH_6;
    CGFloat heightRatio = SCREEN_HEIGHT / SCREEN_HEIGHT_6;
    CGRect rect = CGRectZero;
    rect.origin.x = GAP_TITLE_LEADING;
    rect.size.height = HEIGHT_THEM * heightRatio;
    rect.size.width = (140 + (title.length - 8)* 20) *widthRatio;
    _titleLable = [[UILabel alloc] initWithFrame:rect];
    _titleLable.font = [UIFont systemFontOfSize:18];
    if (SCREEN_WIDTH < SCREEN_WIDTH_6) {
        _titleLable.font = [UIFont systemFontOfSize:17];
    }
    [_titleLable setText:title];
    [self addSubview:_titleLable];
    rect.size = CGSizeMake(10*widthRatio, 10*heightRatio);
    rect.origin.x = CGRectGetMinX(_titleLable.frame) - rect.size.width;
    rect.origin.y = CGRectGetMidY(_titleLable.frame)-rect.size.height/2.0;
    _redFlag = [[UILabel alloc] initWithFrame:rect];
    if ([redFlag isEqualToString:@"1"]) {
        [_redFlag setText:@"*"];
        [_redFlag setTextColor:[UIColor redColor]];
    }
    [self addSubview:_redFlag];
    rect.size.height = CGRectGetHeight(_titleLable.frame)/2.0;
    rect.size.width = SCREEN_WIDTH - CGRectGetMaxX(_titleLable.frame) - CGRectGetMinX(_titleLable.frame);
    rect.origin.x = CGRectGetMaxX(_titleLable.frame);
    rect.origin.y = CGRectGetMidY(_titleLable.frame)-rect.size.height/2.0;
    _noteLable = [[UILabel alloc] initWithFrame:rect];
    _noteLable.font = [UIFont systemFontOfSize:13];
    if (SCREEN_WIDTH < SCREEN_WIDTH_6) {
        _noteLable.font = [UIFont systemFontOfSize:12];
    }
    if (![note isEqualToString:@""]) {
        [_noteLable setText:[NSString stringWithFormat:@"(%@)",note]];
    }
    [self addSubview:_noteLable];
    
    NSString *showSubTitle = subTitle;
    _subLable = [[UILabel alloc] init];
    [self addSubview:_subLable];
    _subLable.numberOfLines = 0;
    _subLable.font = [UIFont systemFontOfSize:13.0];
    if (SCREEN_WIDTH < SCREEN_WIDTH_6) {
        _subLable.font = [UIFont systemFontOfSize:12.0];
    }
    [_subLable setText:showSubTitle];
    
    rect.origin.x = CGRectGetMinX(_titleLable.frame);
    rect.origin.y = CGRectGetMaxY(_titleLable.frame);
    rect.size.width = SCREEN_WIDTH - rect.origin.x * 2.0;
    if (![subTitle isEqualToString:@""]) {
        rect.size.height = _cellModel.subTitleHeight;
    } else {
        rect.size.height = 0;
    }
    [_subLable setFrame:rect];
    // 文本颜色
    [_titleLable setTextColor:[UIColor DDIMAssessQuestionnaireTitleColor]];
    [_noteLable setTextColor:[UIColor DDIMAssessQuestionnaireNoteColor]];
    [_subLable setTextColor:[UIColor DDIMAssessQuestionnaireNoteColor]];
    // cell 样式
    if(_currentSection == 5){
        [self setUpInputForIMBudgetWithTitle:title choices:_choices];
    }else if(_currentSection == 7){
        [self setUpUIForLanguageAbiityWithTitle:title subTitles:subTitles choices:_choices];
    }else{
        [self setUpUIWithBtnsWithTitle:title choices:_choices];
    }
}

#pragma mark - btnStyle

- (void)setUpUIWithBtnsWithTitle:(NSString *)title choices:(NSArray *)choices{
    CGRect rect = CGRectZero;
    // 按钮区域
    CGFloat btnsAreaW = CGRectGetWidth(_subLable.frame);
    CGFloat btnHeight = HEIGHT_EVERY_BTN;
    NSInteger btnNum = choices.count;
    CGFloat couNumPerRow = 2.0;// 每行个数
    if ([title isEqualToString:@"1.移民意向国家"]) {
        couNumPerRow = 4.0;
    }
    CGFloat btnWidth = (btnsAreaW - ((NSInteger)couNumPerRow - 1) * GAP_BETWEEN_BTNS) / (NSInteger)couNumPerRow;
    CGFloat startPoint_Y = CGRectGetMaxY(_subLable.frame) + GAP_BETWEEN_BTNS;
    CGFloat startPoint_X = CGRectGetMinX(_titleLable.frame);
    rect.size.height = btnHeight;
    rect.size.width =  btnWidth;
    NSInteger section = [self handleTitle:title];
    NSInteger btnTag = 0;
    for (NSInteger cou = 0;cou < btnNum;cou ++) {
        btnTag = cou + 100 * section;
        rect.origin.x = startPoint_X + (btnWidth + GAP_BETWEEN_BTNS) * (cou%(NSInteger)couNumPerRow);
        rect.origin.y = startPoint_Y + (btnHeight + GAP_BETWEEN_BTNS) * (cou/(NSInteger)couNumPerRow);
        NSString *text = choices[cou];
        [self createBtn:rect text:text tag:btnTag];
    }
    
}

- (void)createBtn:(CGRect)rect text:(NSString *)text tag:(NSInteger)tag{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btn];
    [btn setFrame:rect];
    btn.layer.borderWidth = 0.6;
    [btn setTitle:text forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    if (SCREEN_WIDTH < SCREEN_WIDTH_6) {
        [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    }
    btn.tag = tag;
    [btn addTarget:self action:@selector(clickBtnForChoice:) forControlEvents:UIControlEventTouchUpInside];
    rect.size = CGSizeMake(10, 10);
    rect.origin.x = CGRectGetWidth(btn.frame) - rect.size.width;
    rect.origin.y = CGRectGetHeight(btn.frame) - rect.size.height;
    UIImageView *flagImgView = [[UIImageView alloc] initWithFrame:rect];
    flagImgView.image = [UIImage imageNamed:@"imassessIndex_questionnaire_btn_selected"];
    flagImgView.tag = tag + 50;
    [btn addSubview:flagImgView];
    [self showBtnStyleNormal:btn];
    
    NSArray *values = [_cellModel.resultInfoDicForCell allValues];
    if (_currentSection != 7) {
        for (NSString *value in values) {
            NSString *selectedBtnTag = [[value componentsSeparatedByString:@"&"] lastObject];
            NSInteger theBtnTag = [selectedBtnTag integerValue];
            UIButton *theBtn = (UIButton *)[self viewWithTag:theBtnTag];
            [self showBtnStyleSelected:theBtn];
        }
    } else { // 第 7 题 － 遍历数组，查询按钮并设置
        NSInteger maxTag = 700 + _cellModel.contentModel.choices.count;
        for (NSString *value in values) {
            NSString *selectedBtnTag = [[value componentsSeparatedByString:@"&"] lastObject];
            NSInteger theBtnTag = [selectedBtnTag integerValue];
            if ((theBtnTag >= 700) && (theBtnTag < maxTag)) {
                UIButton *theBtn = (UIButton *)[self viewWithTag:theBtnTag];
                [self showBtnStyleSelected:theBtn];
            }
        }
        
    }
}

- (void)showBtnStyleNormal:(UIButton *)btn{
    btn.selected = NO;
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.borderColor = [UIColor DDIMAssessQuestionnaireBtnBorderColor].CGColor;
    [btn setTitleColor:[UIColor DDIMAssessQuestionnaireBtnTextColor] forState:UIControlStateNormal];
    
    UIImageView *flagImgView = (UIImageView *)[btn viewWithTag:btn.tag + 50];
    flagImgView.hidden = YES;
}

- (void)showBtnStyleSelected:(UIButton *)btn{
    btn.selected = YES;
    btn.layer.borderColor = [UIColor DDNavBarBlue].CGColor;
    [btn setTitleColor:[UIColor DDNavBarBlue] forState:UIControlStateNormal];
    UIImageView *flagImgView = (UIImageView *)[btn viewWithTag:btn.tag + 50];
    flagImgView.hidden = NO;
}

#pragma mark - inputStyle
- (void)setUpInputForIMBudgetWithTitle:(NSString *)title choices:(NSArray *)choices{
    NSString *unit = choices[0];
    NSInteger section = [self handleTitle:title];
    CGRect rect = CGRectZero;
    rect.origin.x = CGRectGetMinX(_titleLable.frame);
    rect.origin.y = CGRectGetMaxY(_subLable.frame) + GAP_BETWEEN_BTNS;
    rect.size.width = SCREEN_WIDTH - rect.origin.x * 2;
    rect.size.height = HEIGHT_EVERY_BTN;
    UIView *bgView = [[UIView alloc] initWithFrame:rect];
    bgView.layer.borderColor = [UIColor DDIMAssessQuestionnaireBtnBorderColor].CGColor;
    bgView.layer.borderWidth = 0.6;
    [self addSubview:bgView];
    CGFloat inputViewLeading = GAP_TITLE_LEADING;
    CGFloat inputViewTail = GAP_TITLE_LEADING + 18;
    rect.origin.y = 0;
    rect.origin.x = inputViewLeading;
    rect.size.width = CGRectGetWidth(bgView.frame) - inputViewLeading - inputViewTail;
    NSInteger inputTag = section * 100;
    NSString *placeHolder = @"点击输入您的移民预算";
    UITextField *inputField = [self createTextFieldFrame:rect placeHolder:placeHolder tag:inputTag];
    inputField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [bgView addSubview:inputField];
    rect.origin.x = CGRectGetMaxX(inputField.frame);
    rect.size.width = inputViewTail;
    UILabel *unitLable = [[UILabel alloc] initWithFrame:rect];
    unitLable.text = unit;
    [unitLable setFont:[UIFont systemFontOfSize:15]];
    [unitLable setTextColor:[UIColor DDIMAssessQuestionnaireTitleColor]];
    [bgView addSubview:unitLable];
    
    NSArray *keys = [_cellModel.resultInfoDicForCell allKeys];
    if (keys.count == 1) {
        NSString *text = [keys firstObject];
        inputField.text = text;
    }
}

#pragma mark - input+btnStyle
- (void)setUpUIForLanguageAbiityWithTitle:(NSString *)title subTitles:(NSArray *)subTitles choices:(NSArray *)choices{
    NSString *secondSubTitle = [subTitles lastObject];
    NSInteger section = [self handleTitle:title];
    CGRect rect = CGRectZero;
    CGFloat startPoint_X = CGRectGetMinX(_titleLable.frame);
    CGFloat startPoint_Y = CGRectGetMaxY(_subLable.frame);
    rect.size.width = SCREEN_WIDTH - startPoint_X* 2.0;
    rect.size.height = HEIGHT_EVERY_BTN;
    for (NSInteger cou = 0; cou < choices.count; cou ++) {
        rect.origin.x = startPoint_X;
        rect.origin.y = startPoint_Y + (rect.size.height + GAP_BETWEEN_BTNS) * cou;
        NSInteger tag = section * 100 + cou;
//        NSLog(@"生成 777777 tag ------ > %ld",tag);
        [self createBtn:rect text:choices[cou] tag:tag];
    }
    
    rect.origin.y = startPoint_Y + (rect.size.height + GAP_BETWEEN_BTNS) * choices.count;
    rect.size.height = HEIGHT_THEM/2.0;
    UILabel *lable = [[UILabel alloc] initWithFrame:rect];
    [lable setFont:[UIFont systemFontOfSize:13]];
    [lable setText:secondSubTitle];
    [lable setTextColor:[UIColor DDIMAssessQuestionnaireNoteColor]];
    [self addSubview:lable];
    
    NSArray *placeHodlers = @[@"点击输入听力成绩",
                              @"点击输入口语成绩",
                              @"点击输入阅读成绩",
                              @"点击输入写作成绩"];
    NSArray *flags = @[@"听",@"说",@"读",@"写"];
    for (NSInteger cou = 0; cou < NUM_INPUT_LANGUAGE_ABILITY; cou ++) {
        rect.origin.x = startPoint_X;
        startPoint_Y = CGRectGetMaxY(lable.frame);
        rect.size.width = SCREEN_WIDTH - startPoint_X * 2.0;
        rect.size.height = HEIGHT_EVERY_BTN;
        rect.origin.y = startPoint_Y + (HEIGHT_EVERY_BTN + GAP_BETWEEN_BTNS) * cou;
        // 背景 view
        UIView *bgView = [[UIView alloc] initWithFrame:rect];
        bgView.layer.borderColor = [UIColor DDIMAssessQuestionnaireBtnBorderColor].CGColor;
        bgView.layer.borderWidth = 0.6;
        [self addSubview:bgView];
        UILabel *flag = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  39*SCREEN_WIDTH/SCREEN_WIDTH_6,
                                                                  CGRectGetHeight(bgView.frame))];
        // 标记
        [flag setText:flags[cou]];
        flag.textAlignment = NSTextAlignmentCenter;
        [flag setFont:[UIFont systemFontOfSize:15]];
        [flag setTextColor:[UIColor DDIMAssessQuestionnaireTitleColor]];
        [bgView addSubview:flag];
        // 输入框
        rect.origin.x = CGRectGetMaxX(flag.frame);
        rect.origin.y = 0;
        rect.size.width = CGRectGetWidth(bgView.frame) - CGRectGetWidth(flag.frame);
        NSInteger inputTag = section * 100 + cou + choices.count;
        UITextField *input = [self createTextFieldFrame:rect placeHolder:placeHodlers[cou] tag:inputTag];
        [bgView addSubview:input];
    }
    
}

- (UITextField *)createTextFieldFrame:(CGRect)rect placeHolder:(NSString *)placeHolder tag:(NSInteger)tag{
    UITextField *inputField = [[UITextField alloc] initWithFrame:rect];
    inputField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    inputField.delegate = self;
    inputField.tag = tag;
    inputField.placeholder = placeHolder;
    [inputField setTextColor:[UIColor DDIMAssessQuestionnaireBtnTextColor]];
    [inputField setFont:[UIFont systemFontOfSize:15]];
    // 第 7 题 遍历数组，若有输入框 取其对应的值
    NSArray *values = [_cellModel.resultInfoDicForCell allValues];
    for (NSString *value in values) {
        NSString *selectedText = [[value componentsSeparatedByString:@"&"] firstObject];
        NSString *selectedTagStr = [[value componentsSeparatedByString:@"&"] lastObject];
        NSInteger selectedTag = [selectedTagStr integerValue];
        if (selectedTag == tag) {
            inputField.text = selectedText;
        }
    }
    return inputField;
}


#pragma mark - click Btn

- (void)clickBtnForChoice:(UIButton *)clickedBtn{
    
        if (self.callBackForEndEditing) {
            self.callBackForEndEditing(clickedBtn);
        }
        // 单选处理
        if (_currentSection == 3 || _currentSection == 4 || _currentSection == 6 || _currentSection == 8 || _currentSection == 7) {
            [self handleClickEventForSingleChoice:clickedBtn];
        }
        // 多选处理
        if (_currentSection == 1 || _currentSection == 2) {
            [self handleClickEventForMoreChoice:clickedBtn];
        }

}

// 1. 2.多选
- (void)handleClickEventForMoreChoice:(UIButton *)clickedBtn{
    clickedBtn.selected = !clickedBtn.selected;
    NSInteger index = clickedBtn.tag - 100 * _currentSection;
    
    NSString *keyText = _codes[index];
    NSString *btnText = _choices[index];
    NSString *tagStr = [NSString stringWithFormat:@"%ld",clickedBtn.tag];
    NSString *v = [NSString stringWithFormat:@"%@&%@",btnText,tagStr];
    NSString *k = [NSString stringWithFormat:@"%@",keyText];
//    NSLog(@" %@ === 点击封装的v - k ====%@",v,k);
    NSArray *values = [_cellModel.resultInfoDicForCell allValues];
    if (clickedBtn.selected) {
        if (values.count < 3) { // 封装添加
            [_cellModel.resultInfoDicForCell setValue:v forKey:k];
            [self showBtnStyleSelected:clickedBtn];
        } else { // 提示
            [self showBtnStyleNormal:clickedBtn];
            [self showTip];
        }
        
    }else{ // 取消
        [self showBtnStyleNormal:clickedBtn];
        [_cellModel.resultInfoDicForCell removeObjectForKey:k];
    }
    
}

// 3. 4. 6. 8. 单选 + 7
- (void)handleClickEventForSingleChoice:(UIButton *)clickedBtn{
    NSMutableArray *btnValues = [[NSMutableArray alloc] init];
    if (_currentSection == 7) {
        NSArray *rvalues = [_cellModel.resultInfoDicForCell allValues];
        for (NSString *str in rvalues) {
            NSString *tagStr = [[str componentsSeparatedByString:@"&"] lastObject];
            NSInteger tag = [tagStr integerValue];
            if (tag >= 700 && tag <= 705) {
                [btnValues addObject:str];
            }
        }
    }else{
        [btnValues addObjectsFromArray:[_cellModel.resultInfoDicForCell allValues]];
    }
    clickedBtn.selected = !clickedBtn.selected;
    NSInteger index = clickedBtn.tag - 100 * _currentSection;
    NSString *keyText = _codes[index];
    NSString *btnText = _choices[index];
    NSString *tagStr = [NSString stringWithFormat:@"%ld",clickedBtn.tag];
    NSString *v = [NSString stringWithFormat:@"%@&%@",btnText,tagStr];
    NSString *k = [NSString stringWithFormat:@"%@",keyText];
    if (clickedBtn.selected) {
        [self showBtnStyleSelected:clickedBtn];
        if (btnValues.count < 1) { // 封装添加
            [_cellModel.resultInfoDicForCell setValue:v forKey:k];
        } else { // 清空 － 封装添加
            NSString *selectedValue = [btnValues firstObject];
            NSString *secTagStr = [[selectedValue componentsSeparatedByString:@"&"] lastObject];
            NSInteger selectedTag = [secTagStr integerValue];
            NSString *selectedKey = _codes[selectedTag-_currentSection*100];
            UIButton *selectedBtn = (UIButton *)[self viewWithTag:selectedTag];
            [self showBtnStyleNormal:selectedBtn];
            [_cellModel.resultInfoDicForCell removeObjectForKey:selectedKey];
            [_cellModel.resultInfoDicForCell setValue:v forKey:k];
        }
    } else { // 清空
         NSString *selectedKey = _codes[clickedBtn.tag-_currentSection*100];
        [_cellModel.resultInfoDicForCell removeObjectForKey:selectedKey];
        [self showBtnStyleNormal:clickedBtn];
    }
    
    switch (clickedBtn.tag) { // 更新数据
        case 300:
        {
            if (self.callBack) {
                NSInteger index = 1;
                _cellModel.indexForshowSubtitle = index;
                IMAssessQuesnaireContentModel *contentModelCallBack = _cellModel.contentModel;
                _cellModel.contentModel = contentModelCallBack;
                self.callBack(clickedBtn,index);
            }
        }
            break;
        case 301:
        {

            if (self.callBack) {
                NSInteger index = 2;
                _cellModel.indexForshowSubtitle = index;
                IMAssessQuesnaireContentModel *contentModelCallBack = _cellModel.contentModel;
                _cellModel.contentModel = contentModelCallBack;
                self.callBack(clickedBtn,index);
            }
        }
            break;
        case 302:
        {

            if (self.callBack) {
                NSInteger index = 3;
                _cellModel.indexForshowSubtitle = index;
                IMAssessQuesnaireContentModel *contentModelCallBack = _cellModel.contentModel;
                _cellModel.contentModel = contentModelCallBack;
                self.callBack(clickedBtn,index);
            }
        }
            break;
        case 303:
        {
            
            if (self.callBack) {
                NSInteger index = 4;
                _cellModel.indexForshowSubtitle = index;
                IMAssessQuesnaireContentModel *contentModelCallBack = _cellModel.contentModel;
                _cellModel.contentModel = contentModelCallBack;
                self.callBack(clickedBtn,index);
            }
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - toolMethod
- (NSInteger)handleTitle:(NSString *)title{
    NSArray *results = [title componentsSeparatedByString:@"."];
    NSString *numStr = results[0];
    NSInteger section = [numStr integerValue];
    return section;
}

- (void)showTip{
    UIAlertView *tipView = [[UIAlertView alloc] initWithTitle:nil
                                                      message:@"请选择你意向最强的国家，可选择0-3个"
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"确认", nil];
    [tipView show];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    NSLog(@"shouldChangeCharactersInRange ====== > %@",textField.text);
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{ // 每结束编辑先删然后封装字典
    NSString *textFieldTagStr = [NSString stringWithFormat:@"%ld",textField.tag];
    NSString *texFieldText = textField.text;
    NSString *v = [NSString stringWithFormat:@"%@&%@",texFieldText,textFieldTagStr];
//    NSString *k = [NSString stringWithFormat:@"%@",texFieldText];
    NSString *k = [NSString stringWithFormat:@"%@",textFieldTagStr];
    if (_currentSection == 5) {
        [_cellModel.resultInfoDicForCell removeAllObjects];
    } else { // 第 7 题 输入内容限制

        NSArray *vs = [_cellModel.resultInfoDicForCell allValues];
        for (NSString *str in vs) {
            NSString *oldText = [[str componentsSeparatedByString:@"&"] firstObject];
            NSString *tagStr = [[str componentsSeparatedByString:@"&"] lastObject];
            NSInteger tag = [tagStr integerValue];
            if (tag == textField.tag) {
                [_cellModel.resultInfoDicForCell removeObjectForKey:oldText];
            }
        }
        
    }
    // v: text&tag  k:tag
    [_cellModel.resultInfoDicForCell setObject:v forKey:k];
//    NSLog(@"textFieldDidEndEditing------v:%@ ---------k:%@",v,k);
}

#pragma mark - sysMethod
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
