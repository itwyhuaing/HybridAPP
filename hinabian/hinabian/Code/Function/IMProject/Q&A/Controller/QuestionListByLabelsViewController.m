//
//  QuestionListByLabelsViewController.m
//  hinabian
//
//  Created by 余坚 on 16/8/3.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "QuestionListByLabelsViewController.h"
#import "QAHomeQuestionCell.h"
#import "DataFetcher.h"
#import "RefreshControl.h"
#import "QuestionInfo.h"
#import "RDVTabBarController.h"
#import "SWKQuestionShowViewController.h"
#import "UserInfoController2.h"
#import "Label.h"
#import "AppointmentButton.h"
#import "SWKConsultOnlineViewController.h"

@interface QuestionListByLabelsViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,RefreshControlDelegate>
{
    NSString *labelsNameString;
}
@property (nonatomic) NSInteger num;
@property (nonatomic) NSInteger allPost;
@property (nonatomic) NSInteger start;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) RefreshControl *refreshControl;
@property (nonatomic, strong) AppointmentButton *appointmentBtn;
@end

@implementation QuestionListByLabelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray * tmpArray = [_labelsString componentsSeparatedByString: @","];
    NSString * titleString = nil;
    labelsNameString = [[NSString alloc] init];
    for (NSString * f in tmpArray) {
        NSArray *labelname = [Label MR_findByAttribute:@"value" withValue:f andOrderBy:@"timestamp" ascending:YES];
        for (Label * i in labelname) {
            if (!titleString) {
                titleString = [NSString stringWithFormat:@"%@等相关问题",i.name];
            }
            labelsNameString = [labelsNameString stringByAppendingString:[NSString stringWithFormat:@"%@  ",i.name]];
        }
        
    }
    //NSArray *labelname = [Label MR_findByAttribute:@"value" withValue:f.catename andOrderBy:@"timestamp" ascending:YES];
    self.title = titleString;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _dataSource = [[NSMutableArray alloc] init];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 66) style:UITableViewStylePlain];
    _tableView.delegate = (id)self;
    _tableView.dataSource = (id)self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerNib:[UINib nibWithNibName:cellNilName_QAHomeQuestionCell bundle:nil] forCellReuseIdentifier:cellNilName_QAHomeQuestionCell];
    [self.view addSubview:_tableView];
    
    _refreshControl=[[RefreshControl alloc] initWithScrollView:_tableView delegate:(id)self];
    _refreshControl.bottomEnabled=YES;
    
    [[HNBLoadingMask shareManager] loadingMaskWithSuperView:self.view loadingMaskType:LoadingMaskTypeExtendTabBar yoffset:0.0];
    /* 数据获取 */
    _start = 0;
    _num = 20;
    [DataFetcher doGetQAQuestionListByLabels:_labelsString shoudInDatabase:FALSE Start:_start GetNum:_num withSucceedHandler:^(id JSON) {
        /* 读数据 */
        [self questionDataHandle:JSON];
        _start += _num;
        id datajson = [JSON valueForKey:@"data"];
        NSString * tmptotalNum = [datajson valueForKey:@"totleNum"];
        _allPost = [tmptotalNum integerValue];
        [_tableView reloadData];
        [[HNBLoadingMask shareManager] dismiss];
        
    } withFailHandler:^(id error) {
        [[HNBLoadingMask shareManager] dismiss];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(answerButtonPressed:) name:QA_LABELS_SELECT_ANSWER_ID object:nil];
    
    if (!_appointmentBtn) {
        //预约按钮
        float scale = SCREEN_WIDTH/SCREEN_WIDTH_6;
        float btnWidth = 53.0f*scale;
        float btnHeight = 53.0f*scale;
        
        _appointmentBtn = [[AppointmentButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - btnWidth - 15*scale, SCREEN_HEIGHT - btnHeight - 128, btnWidth, btnHeight)];
        _appointmentBtn.delegate = (id)self;
        [self.view addSubview:_appointmentBtn];
    }

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QA_LABELS_SELECT_ANSWER_ID object:nil];
}

- (void)answerButtonPressed:(NSNotification *)notification
{
    NSString * id = [notification object];
    NSDictionary *dict = @{@"url" : id};
    [HNBClick event:@"125002" Content:dict];
    UserInfoController2 * vc = [[UserInfoController2 alloc] init];
    vc.personid = id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) questionDataHandle:(id)responseObject
{
    id qustionList = [responseObject valueForKey:@"data"];
    NSMutableArray * QuestionIndexItemArray = [qustionList valueForKey:@"questionList"];
    NSInteger countQuestionIndexItem = [QuestionIndexItemArray count];
    for(int i =0; i<countQuestionIndexItem; i++)
    {
        id tmpJson = QuestionIndexItemArray[i];
        QuestionInfo * f = [[QuestionInfo alloc] init];
        f.collect = [tmpJson valueForKey:@"collect"];
        f.imageurl = [tmpJson valueForKey:@"imageurl"];
        f.ishot = [tmpJson valueForKey:@"ishot"];
        f.labels = [tmpJson valueForKey:@"labels"];
        f.questionid = [tmpJson valueForKey:@"questionid"];
        f.time = [tmpJson valueForKey:@"time"];
        f.title = [tmpJson valueForKey:@"title"];
        f.type = [tmpJson valueForKey:@"type"];
        f.view_num = [tmpJson valueForKey:@"view_num"];
        //特殊字段处理
        f.qadescription = [tmpJson valueForKey:@"description"];
        id answerInfo = [tmpJson valueForKey:@"answerInfo"];
        if ([answerInfo isKindOfClass:[NSDictionary class]]) {
            f.answername = [answerInfo valueForKey:@"name"];
            f.answerid = [answerInfo valueForKey:@"uid"];
        }
        else
        {
            f.answername = @"";
            f.answerid = @"";
        }
        id userInfo = [tmpJson valueForKey:@"userInfo"];
        id levelInfo = [userInfo valueForKey:@"levelInfo"];
        f.level = [levelInfo valueForKey:@"level"];
        f.username = [userInfo valueForKey:@"name"];
        f.userid = [userInfo valueForKey:@"uid"];
        f.userhead_url = [userInfo valueForKey:@"head_url"];
        f.certified = [userInfo valueForKey:@"certified"];
        f.certified_type = [userInfo valueForKey:@"certified_type"];
        
        [_dataSource addObject:f];
    }

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"btn_fanhui"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back_main);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
}

-(void) back_main
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return (_dataSource.count + 1);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 44.0f;
    }
    
    return 148.0f;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *returnCellPtr = [[UITableViewCell alloc] init];
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        UIImageView * tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, (44-16)/2, 16, 16)];
        [tmpImageView setImage:[UIImage imageNamed:@"answer_content_list1_ic_default"]];
        
        UILabel * tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(12*2+19, 0, SCREEN_WIDTH, 44)];
        tmpLabel.text = labelsNameString;
        tmpLabel.font = [UIFont systemFontOfSize:FONT_UI32PX];
        tmpLabel.textColor = [UIColor colorWithRed:102.0/255.0f green:102.0/255.0f blue:102.0/255.0f alpha:1.0f];
        [cell addSubview:tmpImageView];
        [cell addSubview:tmpLabel];
        //cell.textLabel.text = labelsNameString;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        returnCellPtr = cell;
    }
    else
    {
        if (indexPath.row  <= _dataSource.count) {  /*保证数组不为空且不会越界*/
            QAHomeQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNilName_QAHomeQuestionCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.layer.borderWidth = 0.5;
            cell.layer.borderColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
            [cell setCellItemWithModel:_dataSource[indexPath.row - 1] indexPath:indexPath Type:EN_QA_LABELS_QUESTION_ANSWER];
            returnCellPtr = cell;
        }
        
    }

    
    return returnCellPtr;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row <= _dataSource.count && indexPath.row > 0) {
        QuestionInfo * f = _dataSource[indexPath.row - 1];
        SWKQuestionShowViewController *vc = [[SWKQuestionShowViewController alloc] init];
        NSString *tmpurl = [NSString stringWithFormat:@"https://m.hinabian.com/qa_question/detail/%@",f.questionid];
        NSDictionary *dict = @{@"url" : tmpurl};
        [HNBClick event:@"125001" Content:dict];
        vc.URL = [[NSURL alloc] withOutNilString:tmpurl];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    return nil;
    
}

-(void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction{
    
    //NSLog(@" 刷新");
    
    if (direction == RefreshDirectionBottom){ // 底部上拉加载 且 有数据
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [DataFetcher doGetQAQuestionListByLabels:_labelsString shoudInDatabase:FALSE Start:_start GetNum:_num withSucceedHandler:^(id JSON) {
                [self questionDataHandle:JSON];
                _start += _num;
               // _questionFilterItemArray = [QuestionFilterItem MR_findAllSortedBy:@"timestamp" ascending:YES];
                //[_mainView reloadQAIndexFilterData];
                id datajson = [JSON valueForKey:@"data"];
                NSString * tmptotalNum = [datajson valueForKey:@"totleNum"];
                _allPost = [tmptotalNum integerValue];
                if (_start >= _allPost) {
                    /* 取消下拉刷新 */
                    refreshControl.bottomEnabled = FALSE;
                }
                else
                {
                    refreshControl.bottomEnabled = TRUE;
                }
                [_tableView reloadData];
                
            } withFailHandler:^(id error) {
                
            }];
            [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
            
        });
        
    }else{
        
        [refreshControl finishRefreshingDirection:direction isEmpty:YES];
        
    }
    
}

#pragma mark CONSULT_BUTTON_DELEGATE
- (void)consultOnlineEvent:(AppointmentButton *)appointmentButton
{
    NSString *str = [NSString stringWithFormat:@"https://eco-api.meiqia.com/dist/standalone.html?eid=1875"];
    
    SWKConsultOnlineViewController *vc = [[SWKConsultOnlineViewController alloc]init];
    vc.URL = [[NSURL alloc] withOutNilString:str];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)consultPhoneEvent:(AppointmentButton *)appointmentButton
{
    NSString *tmpTel = [NSString stringWithFormat:@"%@",DEFAULT_TELNUM];
    if ([tmpTel isEqualToString:@""] || Nil == tmpTel) {
        tmpTel = DEFAULT_TELNUM;
    }
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",tmpTel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}


-(void)touchConsultEvent:(AppointmentButton *)appointmentButton
{
    //问答专题页快速咨询上报事件
    [HNBClick event:@"125003" Content:nil];
}

@end
