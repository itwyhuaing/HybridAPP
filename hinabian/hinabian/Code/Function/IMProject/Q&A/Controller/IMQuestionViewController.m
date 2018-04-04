//
//  IMQuestionViewController.m
//  hinabian
//
//  Created by 余坚 on 15/6/30.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import "IMQuestionViewController.h"
#import "RDVTabBarController.h"
#import "DataFetcher.h"
#import "PersonalInfo.h"
#import "ChoseLabelsViewController.h"
#import "Label.h"
#import "HNBToast.h"
#import "SWKQuestionShowViewController.h"


@interface IMQuestionViewController ()<UITextViewDelegate, UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITextView *QuestionTitleTextField;
@property (strong, nonatomic) UITextView *PlaceHolderQuestionTitle;
@property (strong, nonatomic) UITextView *QuestionDescribeTextField;
@property (strong, nonatomic) UITextView *PlaceHolderQuestionDescribe;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UITableView *relationTableView;
@property (strong, nonatomic) UILabel *QuestionLabelView;
@property (strong, nonatomic) NSMutableArray *relationArry;
@property (strong, nonatomic) ChoseLabelsViewController * c_vc;
@property (strong, nonatomic) UIScrollView *textScrollView;
@end

@implementation IMQuestionViewController
{
    UIFont *font;
    float contentOffsetWidth;
}

#define TITLE_LABEL_TO_TOP      5*SCREEN_SCALE
#define LABEL_ITEM_HEIGHT       34*SCREEN_SCALE
#define CELL_ITEM_HEIGHT        34*SCREEN_SCALE
#define QUESTION_TITLE_TEXT_ITEM_HEIGHT    34*SCREEN_SCALE
#define DISTANCE_FROM_EACH_ITEM    5*SCREEN_SCALE
#define QUESTION_DESCRIBE_TEXT_ITEM 150*SCREEN_SCALE
#define LABEL_DISTANCE_TO_LEFT  10*SCREEN_SCALE
#define BUTTON_DISTANCE_TO_LEFT 15*SCREEN_SCALE
#define ANSWER_LABEL_WIDTH      200*SCREEN_SCALE
#define TEXT_DISTANCE           10*SCREEN_SCALE
#define ARROW_DISTANCE          20*SCREEN_SCALE
#define LABEL_TEXT              @"标签可引导该领域专家来回复"
#define GET_DATA_NUM            6


enum IMQUESTIONCELL{
    QUESTION_TITLE = 0,
    QUESTION_DESCRIBE = 1,
    QUESTION_LABEL = 2,
    QUESTION_NONE = 3,
    QUESTION_SPECIALIST = 4
};

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _relationArry = [NSMutableArray array];//获取关联词数组
    
    self.title = @"提问";
    // Do any additional setup after loading the view.
    [self initLayout];
}

/* 初始化布局 */
- (void) initLayout
{
    /*提问界面排版tableView*/
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [_tableView setBackgroundColor:[UIColor DDNormalBackGround]];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = (id)self;
    _tableView.dataSource = (id)self;
    _tableView.scrollEnabled = NO;
    
    /*关联词tableView*/
    _relationTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, QUESTION_TITLE_TEXT_ITEM_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [_relationTableView setBackgroundColor:[UIColor DDTextWhite]];
    _relationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _relationTableView.delegate = (id)self;
    _relationTableView.dataSource = (id)self;
    _relationTableView.scrollEnabled = NO;
    _relationTableView.hidden = YES;
    
    /*字体排版*/
    font = [UIFont systemFontOfSize:FONT_UI28PX*SCREEN_SCALE];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:font,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };

    _QuestionDescribeTextField = [[UITextView alloc] initWithFrame:CGRectMake(LABEL_DISTANCE_TO_LEFT - 5, 2, SCREEN_WIDTH - LABEL_DISTANCE_TO_LEFT, QUESTION_DESCRIBE_TEXT_ITEM - 2)];
    _QuestionDescribeTextField.delegate = (id)self;
    _QuestionDescribeTextField.backgroundColor = [UIColor clearColor];
    [_QuestionTitleTextField setReturnKeyType:UIReturnKeyDefault];
    _QuestionDescribeTextField.attributedText = [[NSAttributedString alloc]initWithString:@"" attributes:attributes];
    _QuestionDescribeTextField.font = font;
    
    _PlaceHolderQuestionDescribe= [[UITextView alloc]initWithFrame:self.QuestionDescribeTextField.frame];
    _PlaceHolderQuestionDescribe.backgroundColor = [UIColor clearColor];
    _PlaceHolderQuestionDescribe.attributedText = [[NSAttributedString alloc]initWithString:@"描述（可选）\n加上问题背景等信息获得的回答越准确" attributes:attributes];
    _PlaceHolderQuestionDescribe.textColor = [UIColor black75PercentColor];
    _PlaceHolderQuestionDescribe.font = font;

    [self.view addSubview:_tableView];
    [self.view addSubview:_relationTableView];
}

#pragma mark TABLEVIEW_DELEGATE

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *returnCell = [[UITableViewCell alloc]init];
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (tableView == _tableView) {/*有标签的tableView*/
        if (indexPath.row == QUESTION_TITLE) {
            cell.backgroundColor = [UIColor whiteColor];
            [self initScrollView];
            
        }else if (indexPath.row == QUESTION_DESCRIBE){
            UIView * QuestionDescribeView = [[UIView alloc] initWithFrame:CGRectMake(-1,0, SCREEN_WIDTH + 2, QUESTION_DESCRIBE_TEXT_ITEM + 1)];
            QuestionDescribeView.backgroundColor = [UIColor whiteColor];
            QuestionDescribeView.layer.borderWidth = 0.5;
            QuestionDescribeView.layer.borderColor = [UIColor black75PercentColor].CGColor;
            
            cell.backgroundColor = [UIColor whiteColor];
            [cell addSubview:QuestionDescribeView];
            [cell addSubview:_PlaceHolderQuestionDescribe];
            [cell addSubview:_QuestionDescribeTextField];
            
        }else if (indexPath.row == QUESTION_LABEL){
            UIView * QuestionLabelmaskingView = [[UIView alloc] initWithFrame:CGRectMake(-1,  0, SCREEN_WIDTH + 2, LABEL_ITEM_HEIGHT + 1)];
            QuestionLabelmaskingView.backgroundColor = [UIColor clearColor];
            QuestionLabelmaskingView.layer.borderWidth = 0.5;
            QuestionLabelmaskingView.layer.borderColor = [UIColor black75PercentColor].CGColor;
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(LABEL_DISTANCE_TO_LEFT, 0, 100, LABEL_ITEM_HEIGHT)];
            label.text = @"选择标签";
            label.textColor = [UIColor DDIMHundredQuestionLabelColor];
            label.font = font;
            
            UIImageView *arrowImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_content_forward"]];
            [arrowImg setFrame:CGRectMake(SCREEN_WIDTH - ARROW_DISTANCE, (LABEL_ITEM_HEIGHT - 14*SCREEN_SCALE)/2, 8*SCREEN_SCALE, 14*SCREEN_SCALE)];
            
            CGSize size = [LABEL_TEXT sizeWithAttributes:@{NSFontAttributeName:font}];
            _QuestionLabelView = [[UILabel alloc] initWithFrame:CGRectMake(arrowImg.frame.origin.x - (SCREEN_WIDTH - SCREEN_WIDTH/2 + 30) - 12*SCREEN_SCALE,0, size.width, LABEL_ITEM_HEIGHT - 2)];
            _QuestionLabelView.backgroundColor = [UIColor clearColor];
            [_QuestionLabelView setTextColor:[UIColor black75PercentColor]];
            _QuestionLabelView.font = font;
            _QuestionLabelView.text = LABEL_TEXT;
            _QuestionLabelView.center = CGPointMake(SCREEN_WIDTH - size.width + size.width/2 - arrowImg.frame.size.width - ARROW_DISTANCE, _QuestionLabelView.center.y);
            _QuestionLabelView.textAlignment = NSTextAlignmentRight;
            
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.backgroundColor = [UIColor whiteColor];
            [cell addSubview:QuestionLabelmaskingView];
            [cell addSubview:label];
            [cell addSubview:_QuestionLabelView];
            [cell addSubview:arrowImg];
            
        }else if (indexPath.row == QUESTION_NONE){
            cell.backgroundColor = [UIColor clearColor];
            
        }else if (indexPath.row == QUESTION_SPECIALIST){
            
            if (self.answererName != Nil && ![self.answererName isEqualToString:@""]) {
                UIView * QuestionLabelmaskingView = [[UIView alloc] initWithFrame:CGRectMake(-1, 0 , SCREEN_WIDTH + 2, LABEL_ITEM_HEIGHT)];
                QuestionLabelmaskingView.backgroundColor = [UIColor clearColor];
                QuestionLabelmaskingView.layer.borderWidth = 0.5;
                QuestionLabelmaskingView.layer.borderColor = [UIColor black75PercentColor].CGColor;
                
                UILabel * QuestionAnswerLabel = [[UILabel alloc] initWithFrame:CGRectMake(LABEL_DISTANCE_TO_LEFT, 0 , ANSWER_LABEL_WIDTH - LABEL_DISTANCE_TO_LEFT, LABEL_ITEM_HEIGHT)];
                QuestionAnswerLabel.text = [NSString stringWithFormat:@"@%@",self.answererName];
                QuestionAnswerLabel.textAlignment = NSTextAlignmentLeft;
                QuestionAnswerLabel.font = font;
                [QuestionAnswerLabel setTextColor:[UIColor DDIMHundredQuestionLabelColor]];
                
                cell.backgroundColor = [UIColor DDTextWhite];
                [cell addSubview:QuestionLabelmaskingView];
                [cell addSubview:QuestionAnswerLabel];
            }else{
                cell.backgroundColor = [UIColor clearColor];
            }
        }
    }else if (tableView == _relationTableView){
        /*联想的tableView*/
        if (![_QuestionTitleTextField.text isEqualToString:@""] && _relationArry.count > 0) {
            if (indexPath.row < _relationArry.count) {
                //分割线
                if (indexPath.row == _relationArry.count - 1 || indexPath.row == GET_DATA_NUM-1) {
                    UIView * separatorLine = [[UIView alloc] initWithFrame:CGRectMake(-1, CELL_ITEM_HEIGHT , SCREEN_WIDTH + 2, 0.5)];
                    separatorLine.backgroundColor = [UIColor clearColor];
                    separatorLine.layer.borderWidth = 0.5;
                    separatorLine.layer.borderColor = [UIColor black75PercentColor].CGColor;
                    [cell addSubview:separatorLine];
                }
                UIView * separatorLine = [[UIView alloc] initWithFrame:CGRectMake(-1, 0 , SCREEN_WIDTH + 2, 0.5)];
                separatorLine.backgroundColor = [UIColor clearColor];
                separatorLine.layer.borderWidth = 0.5;
                separatorLine.layer.borderColor = [UIColor black75PercentColor].CGColor;
                [cell addSubview:separatorLine];
                
                UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_content_search"]];
                [imageView setFrame:CGRectMake(LABEL_DISTANCE_TO_LEFT, (CELL_ITEM_HEIGHT -15)/2, 15, 15)];
                
                UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(LABEL_DISTANCE_TO_LEFT + 15 + 5, 0, SCREEN_WIDTH, CELL_ITEM_HEIGHT)];
                titleLabel.text = [_relationArry[indexPath.row] valueForKey:@"title"];
                titleLabel.textColor = [UIColor blackColor];
                titleLabel.font = font;
                
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CELL_ITEM_HEIGHT)];
                [btn setTitle:titleLabel.text forState:UIControlStateNormal];
                [btn setTag:indexPath.row];
                [btn setBackgroundColor:[UIColor clearColor]];
                [btn addTarget:self action:@selector(toQuestionShow:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                
                [cell addSubview:btn];
                [cell addSubview:imageView];
                [cell addSubview:titleLabel];
                
                /*隐藏<em>,</em>字段*/
                if ([titleLabel.text rangeOfString:@"<em>"].location != NSNotFound || [titleLabel.text rangeOfString:@"</em>"].location != NSNotFound) {
                    NSMutableString *tempStr = [NSMutableString stringWithString:titleLabel.text];
                    NSMutableString *labelStr = [NSMutableString stringWithString:[tempStr stringByReplacingOccurrencesOfString:@"<em>" withString:@""]];
                    titleLabel.text = [labelStr stringByReplacingOccurrencesOfString:@"</em>" withString:@""];
                }
                
                /*包含题目关键字变蓝色*/
                NSMutableAttributedString *tmpStr = [[NSMutableAttributedString alloc] initWithString:titleLabel.text];
                for (int i = 0; i < titleLabel.text.length; i++) {
                    for (int l = 0; l <_QuestionTitleTextField.text.length; l++) {
                        NSString *tStr = [_QuestionTitleTextField.text substringWithRange:NSMakeRange(l, 1)];
                        NSString *str = [titleLabel.text substringWithRange:NSMakeRange(i, 1)];
                        if ([tStr isEqualToString:str]) {
                            NSRange range = NSMakeRange(i, 1);
                            [tmpStr addAttribute:NSForegroundColorAttributeName value:[UIColor DDNavBarBlue] range:range];
                            titleLabel.attributedText = tmpStr;
                        }
                    }
                }
            }
        }
    }
//    returnCell = cell;
//    
//    return returnCell;
    return cell;
}

-(void)initScrollView
{
    _textScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(LABEL_DISTANCE_TO_LEFT - 5, 0 , SCREEN_WIDTH - LABEL_DISTANCE_TO_LEFT, CELL_ITEM_HEIGHT)];
    _textScrollView.contentSize = CGSizeMake(SCREEN_WIDTH - LABEL_DISTANCE_TO_LEFT,QUESTION_TITLE_TEXT_ITEM_HEIGHT - 2);
    _textScrollView.showsHorizontalScrollIndicator = YES;
    _textScrollView.bounces = NO;
    [self.view addSubview:_textScrollView];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:font,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 ,NSForegroundColorAttributeName:[UIColor black75PercentColor]};
    
    _QuestionTitleTextField = [[UITextView alloc]initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH - LABEL_DISTANCE_TO_LEFT, CELL_ITEM_HEIGHT)];
    _QuestionTitleTextField.text = @"";
    _QuestionTitleTextField.textColor = [UIColor blackColor];
    _QuestionTitleTextField.backgroundColor = [UIColor clearColor];
    [_QuestionTitleTextField setReturnKeyType:UIReturnKeyDone];
    _QuestionTitleTextField.font = font;
    _QuestionTitleTextField.delegate = (id)self;
    _QuestionTitleTextField.textContainer.maximumNumberOfLines = 1; //textview限制一行，避免自动调整
    
    _PlaceHolderQuestionTitle= [[UITextView alloc]initWithFrame:_QuestionTitleTextField.frame];
    _PlaceHolderQuestionTitle.backgroundColor = [UIColor clearColor];
    _PlaceHolderQuestionTitle.attributedText = [[NSAttributedString alloc]initWithString:@"标题（清晰的标题可以快速获得回答）" attributes:attributes];
    _PlaceHolderQuestionTitle.textColor = [UIColor black75PercentColor];
    _PlaceHolderQuestionTitle.font = font;
    
    [_textScrollView addSubview:_PlaceHolderQuestionTitle];
    [_textScrollView addSubview:_QuestionTitleTextField];
}

-(void)toQuestionShow:(id)sender
{
    //统计代码
    [HNBClick event:@"122003" Content:nil];
    
    UIButton *btn = sender;
    NSString *questionID = [_relationArry[btn.tag] valueForKey:@"questionid"];
    [self jumpIntoQuestion:questionID];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _tableView) {
        if (indexPath.row == QUESTION_LABEL) {
            [self lableViewClicked];
            [tableView deselectRowAtIndexPath:indexPath animated:FALSE];
        }
    }else if(tableView == _relationTableView){
        [tableView deselectRowAtIndexPath:indexPath animated:FALSE];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        if (indexPath.row == QUESTION_TITLE) {
            return QUESTION_TITLE_TEXT_ITEM_HEIGHT;
        }else if (indexPath.row == QUESTION_DESCRIBE){
            return QUESTION_DESCRIBE_TEXT_ITEM;
        }else if (indexPath.row == QUESTION_LABEL){
            return LABEL_ITEM_HEIGHT;
        }else if (indexPath.row == QUESTION_NONE){
            return 10;
        }else if (indexPath.row == QUESTION_SPECIALIST){
            return LABEL_ITEM_HEIGHT;
        }
    }else if (tableView == _relationTableView){
        return CELL_ITEM_HEIGHT;
//        return LABEL_ITEM_HEIGHT;
    }
    
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        return 5;
    }else if (tableView == _relationTableView){
        if (_relationArry.count < GET_DATA_NUM && _relationArry.count != 0) {
            return _relationArry.count;
        }else if (_relationArry.count >= GET_DATA_NUM){
            return GET_DATA_NUM;
        }else{
            return 0;
        }
        
    }
    return 20;
}

- (void)jumpIntoQuestion:(NSString *)questionID
{
    NSLog(@"jumpIntoQuestion");
//    NSString *url;
    SWKQuestionShowViewController *vc = [[SWKQuestionShowViewController alloc] init];
    vc.URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://m.hinabian.com/qa_question/detail/%@.html",questionID]];
    vc.Q_ID = questionID;
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(void)lableViewClicked
{
    //统计代码
    [HNBClick event:@"122002" Content:nil];
    
    _c_vc = [[ChoseLabelsViewController alloc] init];
    if (self.QuestionLabelView != nil && ![self.QuestionLabelView.text isEqualToString:LABEL_TEXT]) {
        NSArray * tmpLabels = [self.QuestionLabelView.text componentsSeparatedByString: @","];
        _c_vc.labelsArray = tmpLabels;
    }
    [self.navigationController pushViewController:_c_vc animated:YES];
}

/* 提交问题 */
- (void)touchSubmitButton
{
    // 统计代码
    [HNBClick event:@"122001" Content:nil];
    
    NSArray * tmpPersonalInfoArry = [PersonalInfo MR_findAll];
    PersonalInfo * UserInfo = nil;
    NSMutableArray *tmpMutableArry = [[NSMutableArray alloc] init];
    if (self.QuestionLabelView != nil && ![self.QuestionLabelView.text isEqualToString:LABEL_TEXT]) {
        NSArray * tmpArry = [self.QuestionLabelView.text componentsSeparatedByString: @","];
        for (int index = 0; index < tmpArry.count; index++) {
            Label * f = [Label MR_findFirstByAttribute:@"name" withValue:tmpArry[index]];
            [tmpMutableArry addObject:f.value];
            
        }
    }

    
    /* 为空条件判断 */
    if (self.QuestionTitleTextField.text.length < 5 || self.QuestionTitleTextField.text.length > 55) {
        //显示HUD
        [[HNBToast shareManager] toastWithOnView:nil msg:@"标题需要5-55个字" afterDelay:1.0 style:HNBToastHudFailure];
        return;
    }
    else if(tmpMutableArry.count == 0)
    {
        //显示HUD
        [[HNBToast shareManager] toastWithOnView:nil msg:@"请选择标签" afterDelay:1.0 style:HNBToastHudFailure];
        return;
    }
    
    if (tmpPersonalInfoArry.count != 0) {
        UserInfo = tmpPersonalInfoArry[0];
        [DataFetcher doSubmitQuestion:UserInfo.id Title:self.QuestionTitleTextField.text content:self.QuestionDescribeTextField.text Label:tmpMutableArry AnswerId:self.answererUid SubjectId:@"" withSucceedHandler:^(id JSON) {
            
            int errCode = [[JSON valueForKey:@"state"] intValue];
            NSLog(@"errCode = %d",errCode);
            /* 跳回前向页面 */
            if (errCode == 0) {
//                [self.navigationController popViewControllerAnimated:YES];
                id josnMain = [JSON valueForKey:@"data"];
                SWKQuestionShowViewController *vc = [[SWKQuestionShowViewController alloc] init];
                vc.URL = [NSURL URLWithString:[NSString  stringWithFormat:@"%@/qa_question/detail/%@.html",H5URL,[josnMain valueForKey:@"id"]]];
                vc.Q_ID = [josnMain valueForKey:@"id"];
                
                [self removeTopAndPushViewController:vc];
            }
        } withFailHandler:^(NSError* error) {
            NSLog(@"errCode = %ld",(long)error.code);
        }];
    }
}

//移除上层栈
- (void)removeTopAndPushViewController:(UIViewController *)viewController {
    NSMutableArray *viewControllers = self.navigationController.viewControllers.mutableCopy;
    [viewControllers removeObject:self.navigationController.topViewController];
    [viewControllers addObject:viewController];
    [self.navigationController setViewControllers:viewControllers.copy animated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
    [_QuestionTitleTextField resignFirstResponder];
    [_QuestionDescribeTextField resignFirstResponder];
}

-(void) back_main
{
    if ([_QuestionTitleTextField.text length] > 0 || [_QuestionDescribeTextField.text length] > 0 || ![_QuestionLabelView.text isEqualToString:LABEL_TEXT]) {
        UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:@"确定要放弃编辑"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
        alterview.delegate = (id)self;
        [alterview show];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark ALERTVIEW_DELEGATE
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [_QuestionTitleTextField resignFirstResponder];
        [_QuestionDescribeTextField resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] init];
//    backButtonItem.title = @"返回";
//    self.navigationItem.backBarButtonItem = backButtonItem;
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"btn_fanhui"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back_main);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    
    UIButton *v  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
    [v setBackgroundImage:[UIImage imageNamed:@"detail_nav_submit_btn_default"] forState:UIControlStateNormal];
    v.backgroundColor = [UIColor clearColor];
    [v setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [v setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [v addTarget:self action:@selector(touchSubmitButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:v];
    self.navigationItem.rightBarButtonItem = barButton;

    
    [self.navigationItem hidesBackButton];
    
    if (_c_vc.labelsString) {//有标签变黑色
        _QuestionLabelView.textColor = [UIColor blackColor];
        _QuestionLabelView.text = _c_vc.labelsString;
    }
    if([_QuestionLabelView.text isEqualToString:@""])
    {
        _QuestionLabelView.textColor = [UIColor black75PercentColor];
        _QuestionLabelView.text = LABEL_TEXT;
    }
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
    [MobClick beginLogPageView:@"PostQ&A"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"PostQ&A"];
}

#pragma mark - TextView Delegate

- (void)textViewDidChange:(UITextView *)textView
{
    
    if (textView == _QuestionTitleTextField) {
        if ([textView.text isEqualToString:@""]) {
            _PlaceHolderQuestionTitle.hidden = NO;
            _relationTableView.hidden = YES;
            
        }else{
            _PlaceHolderQuestionTitle.hidden = YES;
            
            [DataFetcher doGetQAQustionRelationWords:_QuestionTitleTextField.text withSucceedHandler:^(id JSON) {
                _relationArry = [JSON valueForKey:@"data"];
                if (_relationArry.count != 0 && ![textView.text isEqualToString:@""]) {
                    _relationTableView.hidden = NO;
                    [_relationTableView reloadData];
                }else{
                    [_relationTableView reloadData];
                    _relationTableView.hidden = YES;
                }
            } withFailHandler:^(id error) {
                
            }];
            
        }
        float contentWidth = [_QuestionTitleTextField.text sizeWithAttributes:@{NSFontAttributeName:_QuestionTitleTextField.font}].width;
        
        if (contentWidth  >= SCREEN_WIDTH - 19) {
            
            CGSize size = [_QuestionTitleTextField sizeThatFits:CGSizeMake(MAXFLOAT,_QuestionTitleTextField.frame.size.height)];
            _QuestionTitleTextField.frame =CGRectMake(0, 0, size.width + 13*SCREEN_SCALE, CELL_ITEM_HEIGHT);
            _textScrollView.contentSize =CGSizeMake(size.width+15*SCREEN_SCALE,CELL_ITEM_HEIGHT);
            if (_QuestionTitleTextField.selectedRange.location == _QuestionTitleTextField.text.length) {
                //如果光标在最后自动调整ContentOffse
                [_textScrollView setContentOffset:CGPointMake(CGRectGetWidth(_QuestionTitleTextField.bounds) -CGRectGetWidth(_textScrollView.bounds) +2*SCREEN_SCALE, 0) animated:NO];
            }else{
                //如果光标不在最后一位，不调整
            }
        }
        else {
            _QuestionTitleTextField.frame =CGRectMake(0, 0, SCREEN_WIDTH - LABEL_DISTANCE_TO_LEFT, CELL_ITEM_HEIGHT);
            
            _textScrollView.contentSize = CGSizeMake(CGRectGetWidth(_QuestionTitleTextField.bounds),CELL_ITEM_HEIGHT);
            [_textScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
            
        }
        if (_QuestionTitleTextField.text.length > 55) {
            _QuestionTitleTextField.text = [_QuestionTitleTextField.text substringToIndex:55];
        }
        
    }else if (textView == _QuestionDescribeTextField){
        if (![textView.text isEqualToString:@""]) {
            _PlaceHolderQuestionDescribe.hidden = YES;
        }else{
            _PlaceHolderQuestionDescribe.hidden = NO;
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView == _QuestionTitleTextField) {
        if ([text isEqualToString:@"\n"]) {//按下return键
            //换到描述textview
            [_QuestionDescribeTextField becomeFirstResponder];
            _relationTableView.hidden = YES;
            return NO;
        }else {
            if ([textView.text length] < 55) {//判断字符个数
                return YES;
            }
        }
    }else if(textView == _QuestionDescribeTextField){
        if ([text isEqualToString:@"\n"]) {//按下return键
            //这里不隐藏键盘，不做任何处理
            return YES;
        }else {
            if ([textView.text length] < 500) {//判断字符个数
                return YES;
            }
        }
    }
    if (1 == range.length) {//按下回格键
        return YES;
    }
    return NO;
}


@end
