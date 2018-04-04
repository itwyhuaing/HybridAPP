//
//  IMAssessQuestionnaireView.m
//  hinabian
//
//  Created by wangyinghua on 16/4/8.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "IMAssessQuestionnaireView.h"
#import "AppointmentButton.h"
#import "IMAssessQuesnaireTableCell.h"
#import "IMAssessQuesnaireTableCellModel.h"
#import "IMAssessQuesnaireContentModel.h"
#import "NationCode.h"

@interface IMAssessQuestionnaireView () <AppointmentButtonDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) CGFloat widthRatio;
@property (nonatomic) CGFloat heightRatio;
@property (nonatomic,strong) AppointmentButton *appointmentBtn;
@property (nonatomic,strong) UIButton *confirmBtn;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *listData;

@property (nonatomic,strong) NSDictionary *country;
@property (nonatomic,strong) NSDictionary *purpose;
@property (nonatomic,strong) NSDictionary *visa_type;
@property (nonatomic,strong) NSDictionary *expense;
@property (nonatomic,strong) NSDictionary *education;
@property (nonatomic,strong) NSDictionary *ielts;
@property (nonatomic,strong) NSDictionary *overseas_residence_requirements;

@property (nonatomic) NSInteger scrollToSection;
@end

@implementation IMAssessQuestionnaireView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGRect rect = frame;
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        _tableView.bounces = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        
        _widthRatio = SCREEN_WIDTH / SCREEN_WIDTH_6;
        _heightRatio = SCREEN_HEIGHT / SCREEN_HEIGHT_6;
        rect.size.height = (IMASSESSQUESNAIRETATBLECELL_HEADER_HEIGHT * 2+ IMASSESSQUESNAIREVIEW_SUBMMITBTN_HEIGHT) * _heightRatio;
        rect.origin.y = CGRectGetHeight(frame) - rect.size.height;
        UIView *bgView = [UIButton buttonWithType:UIButtonTypeCustom];
        [bgView setFrame:rect];
        [self addSubview:bgView];
        rect.origin.x = 8 * _widthRatio;
        rect.origin.y = IMASSESSQUESNAIRETATBLECELL_HEADER_HEIGHT * _heightRatio;
        rect.size.width = CGRectGetWidth(bgView.frame) - rect.origin.x * 2;
        rect.size.height = CGRectGetHeight(bgView.frame) - rect.origin.y * 2;
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmBtn.tag = ConfirmBtnTag;
        [_confirmBtn setFrame:rect];
        [bgView addSubview:_confirmBtn];
        [_confirmBtn addTarget:self action:@selector(touchConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
        bgView.backgroundColor = [UIColor whiteColor];
        _confirmBtn.backgroundColor = [UIColor DDNavBarBlue];
        [_confirmBtn setTitle:@"确认提交" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        _confirmBtn.layer.borderColor = [UIColor DDNavBarBlue].CGColor;
        _confirmBtn.layer.cornerRadius = 6;
        
        float scale = SCREEN_WIDTH/SCREEN_WIDTH_6;
        float btnWidth = 53.0f*scale;
        float btnHeight = 53.0f*scale;
        
        _appointmentBtn = [[AppointmentButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - btnWidth - 15*scale, SCREEN_HEIGHT - btnHeight - 128, btnWidth, btnHeight)];
        _appointmentBtn.delegate = (id)self;
        [self addSubview:_appointmentBtn];
        
    }
    return self;
}

-(void)reqListData:(id)data{
    _listData = [[NSMutableArray alloc] initWithArray:(NSArray *)data];
    [_tableView reloadData];
   
}

- (void)touchConfirmBtn:(UIButton *)sendBtn{
    
    BOOL reqWebView = YES;
    NSString *country = @"";
    NSString *purpose = @"";
    NSString *visa_type = @"";
    NSString *expense = @"";
    NSString *budget = @"";
    NSString *education = @"";
    NSString *ielts = @"";
    NSString *tef_listen = @"";
    NSString *tef_speak = @"";
    NSString *tef_read = @"";
    NSString *tef_write = @"";
    NSString *overseas_residence_requirements = @"";
    
    for (NSInteger cou = 0; cou < _listData.count; cou ++) {
        IMAssessQuesnaireTableCellModel *cellModel = _listData[cou];
        NSDictionary *results = cellModel.resultInfoDicForCell;
        NSArray *keys_code = [results allKeys];
        NSInteger topicNum = cou + 1;
        // 数据保存沙盒
        [HNBUtils sandBoxSaveInfo:results forKey:[NSString stringWithFormat:@"NSRA%ld",topicNum]];
        
        
        if (topicNum == 1) {
            
            if (keys_code.count == 1) {
                country = [NSString stringWithFormat:@"%@",keys_code[0]];
            }else if(keys_code.count == 2){
                country = [NSString stringWithFormat:@"%@%@%@",keys_code[0],@"%2C",keys_code[1]];
            }else if(keys_code.count == 3){
                country = [NSString stringWithFormat:@"%@%@%@%@%@",keys_code[0],@"%2C",keys_code[1],@"%2C",keys_code[2]];
            }else{ // 0
                country = @"";
            }
            
        } else if(topicNum == 2){
            if (keys_code.count == 1) {
                purpose = [NSString stringWithFormat:@"%@",keys_code[0]];
            }else if(keys_code.count == 2){
                purpose = [NSString stringWithFormat:@"%@%@%@",keys_code[0],@"%2C",keys_code[1]];
            }else if(keys_code.count == 3){
                purpose = [NSString stringWithFormat:@"%@%@%@%@%@",keys_code[0],@"%2C",keys_code[1],@"%2C",keys_code[2]];
            }else{
                [self scrollViewToThePosition:cou];
                reqWebView = NO;
                break;
            }
        } else if(topicNum == 3){
            if (keys_code.count <= 0) {
                [self scrollViewToThePosition:cou];
                reqWebView = NO;
                break;
            }else{
                visa_type = [NSString stringWithFormat:@"%@",keys_code[0]];
            }
        }else if(topicNum == 4){
            if (keys_code.count <= 0) {
                [self scrollViewToThePosition:cou];
                reqWebView = NO;
                break;
            }else{
                expense = [NSString stringWithFormat:@"%@",keys_code[0]];
            }
        } else if(topicNum == 5){
            NSString *inputText = [keys_code firstObject];
//            NSLog(@"inputText ------ %@",inputText);
            if (inputText.length <= 0) {
                [self scrollViewToThePosition:cou];
                reqWebView = NO;
                break;
            }else{
                budget = inputText;
//                NSLog(@"topicNum == 5 ------ %@",inputText);
            }
        } else if(topicNum == 6){
            if (keys_code.count <= 0) {
                [self scrollViewToThePosition:cou];
                reqWebView = NO;
                break;
            } else {
                education = [NSString stringWithFormat:@"%@",keys_code[0]];
            }
        } else if(topicNum == 7){
//            NSLog(@"---- 存第七题 ----- %@",results);
            NSArray *valuesArr = [results allValues];
            for (NSString *valueStr in valuesArr) {
                NSString *inputText = [[valueStr componentsSeparatedByString:@"&"] firstObject];
                NSString *tagStr = [[valueStr componentsSeparatedByString:@"&"] lastObject];
                NSInteger btnTag = [tagStr integerValue];
                if ((btnTag >= 700) && (btnTag <= 705)) { // 按钮
                    ielts = cellModel.codesCorrespondToH5[btnTag-700];
//                    NSLog(@"语言能力ielts ====== > %@",ielts);
                } else if (btnTag == 706){
                    tef_listen = inputText;
                }else if (btnTag == 707){
                    tef_speak = inputText;
                }else if (btnTag == 708){
                    tef_read = inputText;
                }else if (btnTag == 709){
                    tef_write = inputText;
                }
//                NSLog(@"btnTag ---> %ld inputText------> %@",btnTag,inputText);
            }
            
            if (ielts.length <= 0) { //
                [self scrollViewToThePosition:cou];
                reqWebView = NO;
                break;
            }
            
        } else if(topicNum == 8){
            if (keys_code.count <= 0) {
                [self scrollViewToThePosition:cou];
                reqWebView = NO;
                break;
            } else {
                overseas_residence_requirements = [NSString stringWithFormat:@"%@",keys_code[0]];
            }
        }
    }
    
    
    if (self.callBackToController && reqWebView) {
        NSString *urlString = [NSString stringWithFormat:@"https://m.hinabian.com/assess/list.html?country=%@&purpose=%@&visa_type=%@&expense=%@&budget=%@&education=%@&ielts=%@&tef_listen=%@&tef_speak=%@&tef_read=%@&tef_write=%@&overseas_residence_requirements=%@",country,purpose,visa_type,expense,budget,education,ielts,tef_listen,tef_speak,tef_read,tef_write,overseas_residence_requirements];
//        NSLog(@"urlString === > %@",urlString);
        NSURL *reqUrl = [NSURL URLWithString:urlString];
        self.callBackToController(sendBtn,reqUrl);
    }
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _listData.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headView = nil;
    
    if (section == 0) {
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor];
        headView = bgView;
        
        CGRect rect = CGRectZero;
        rect.origin.y = 33 * _heightRatio;
        rect.size.width = self.frame.size.width;
        rect.size.height = 25 * _heightRatio;
        UILabel *questionnaireTitleLable = [[UILabel alloc] initWithFrame:rect];
        [bgView addSubview:questionnaireTitleLable];
        rect.origin.y = CGRectGetMaxY(questionnaireTitleLable.frame) + 15 * _heightRatio;
        rect.size.height = 15 * _heightRatio;
        UILabel *noteLable = [[UILabel alloc] initWithFrame:rect];
        [bgView addSubview:noteLable];
        rect.origin.x = 16 * _widthRatio;
        rect.origin.y = CGRectGetMaxY(noteLable.frame) + 32 * _heightRatio;
        UILabel *subTitleLable = [[UILabel alloc] initWithFrame:rect];
        [bgView addSubview:subTitleLable];
        questionnaireTitleLable.text = @"匹配合适您的移民项目";
        noteLable.text = @"(全球41个移民项目)";
        subTitleLable.text = @"完成以下评估问卷，立即匹配适合我的移民项目：";
        [questionnaireTitleLable setFont:[UIFont systemFontOfSize:19]];
        [noteLable setFont:[UIFont systemFontOfSize:14]];
        [subTitleLable setFont:[UIFont systemFontOfSize:14]];
        [questionnaireTitleLable setTextColor:[UIColor blackColor]];
        [noteLable setTextColor:[UIColor DDIMAssessQuestionnaireBtnTextColor]];
        [subTitleLable setTextColor:[UIColor DDIMAssessQuestionnaireBtnTextColor]];
        questionnaireTitleLable.textAlignment = NSTextAlignmentCenter;
        noteLable.textAlignment = NSTextAlignmentCenter;
        subTitleLable.textAlignment = NSTextAlignmentLeft;
        
//        subTitleLable.backgroundColor = [UIColor greenColor];
//        noteLable.backgroundColor = [UIColor blueColor];
//        questionnaireTitleLable.backgroundColor = [UIColor greenColor];
//        bgView.backgroundColor = [UIColor redColor];
    } else {
        
    }
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return IMASSESSQUESNAIRETATBLECELL_TITLE_HEIGHT * _heightRatio;
    }
    return IMASSESSQUESNAIRETATBLECELL_HEADER_HEIGHT * _heightRatio;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == _listData.count - 1) {
        return (IMASSESSQUESNAIRETATBLECELL_HEADER_HEIGHT * 3+ IMASSESSQUESNAIREVIEW_SUBMMITBTN_HEIGHT) * _heightRatio;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    IMAssessQuesnaireTableCellModel *cellModel = _listData[indexPath.section];
    return cellModel.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"IMAssessQuesnaireTableCell";
    IMAssessQuesnaireTableCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[IMAssessQuesnaireTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
//    IMAssessQuesnaireTableCell *cell = [[IMAssessQuesnaireTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    IMAssessQuesnaireTableCellModel *cellModel = _listData[indexPath.section];
    // 回调修改高度 － 自适应高度
    cell.callBack = ^(id clickEvent,NSInteger index){
        [_tableView reloadData];
    };
    cell.cellModel = cellModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.callBackForEndEditing = ^(id event){
        [_tableView endEditing:YES];
    };
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

//    NSLog(@" ------ > %f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y > 1950) {
        [_tableView endEditing:YES];
    }
    
}

#pragma mark - handleAnswersMethod

- (void)scrollViewToThePosition:(NSInteger)section{
    // 提示
    UIAlertView *tipView = [[UIAlertView alloc] initWithTitle:nil
                                                      message:@"带*为必选项,请填写完整"
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"确认", nil];
    [tipView show];
    _scrollToSection = section;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:_scrollToSection];
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
}


#pragma mark - 

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_tableView endEditing:YES];
}

#pragma mark - AppointmentButtonDelegate

- (void)consultPhoneEvent:(AppointmentButton *)appointmentButton{
    appointmentButton.tag = ConsultPhoneBtnTag;
    if (self.callBackToController) {
        self.callBackToController(appointmentButton,nil);
    }
}

- (void)consultOnlineEvent:(AppointmentButton *)appointmentButton{
    appointmentButton.tag = ConsultOnlineBtnTag;
    if (self.callBackToController) {
        self.callBackToController(appointmentButton,nil);
    }
}


@end
