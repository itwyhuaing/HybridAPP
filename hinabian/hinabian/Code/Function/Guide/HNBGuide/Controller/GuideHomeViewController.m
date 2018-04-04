//
//  GuideHomeViewController.m
//  hinabian
//
//  Created by 何松泽 on 2017/10/24.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "GuideHomeViewController.h"
#import "RDVTabBarController.h"
#import "HNBIMAssessButton.h"
#import "LoginViewController.h"
#import "GuideHomeView.h"
#import "DataFetcher.h"
#import "IMAssessItemsModel.h"
#import "IMNationCityModel.h"
#import "GuideVCodeView.h"
#import "HNBToast.h"
#import "GuideImassessViewController.h"
//#import "NSDictionary+ValueForKey.h"
//#import "MJExtension.h"
#import "HNBLoadingProgressView.h"
#import "HNBQuestionButtonView.h"

#define CanadaCode 12021000
#define AustraliaCode 11011000
#define HKCode 14011000

@interface GuideHomeViewController ()<GuideHomeViewDelegate>
{
    NSDictionary *uploadDic;
    
    HNBLoadingProgressView *loadProgress;
    UILabel *_countryLabel;
    UIView *loadView;
    NSArray *randomArr;
    NSTimer *timer;
    NSMutableAttributedString *countryAttributedString;
    NSMutableAttributedString *targetAttributedString;
}

@property (nonatomic, strong) GuideHomeView *mainView;
@property (nonatomic, strong) UIButton *rightNavBtn;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) NSDictionary *itemsDic;               /*题目*/
@property (nonatomic, strong) NSMutableDictionary *choseDic;        /*选项*/
@property (nonatomic, strong) NSTimer *codeTimer;
@property (nonatomic) NSUInteger timeCount;
@property (nonatomic) NSUInteger questionCount;
@property (nonatomic) NSUInteger currentPage;
@property (nonatomic) BOOL isShowSkip;

@property (nonatomic, strong) NSString *lastCountryID;

@end

@implementation GuideHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    BOOL isAssess = NO;
    uploadDic = @{@"value":[NSNumber numberWithBool:isAssess],};
    self.itemsDic = [[NSDictionary alloc] init];
    self.choseDic = [[NSMutableDictionary alloc] init];
    self.mainView = [[GuideHomeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.mainView.delegate = (id<GuideHomeViewDelegate>)self;
    [self.view addSubview:self.mainView];
    if (![HNBUtils isConnectionAvailable]) {
        [self readLocalItems];
    }else {
        [DataFetcher doGetIMAssessItemsWithSucceedHandler:^(id JSON) {
            if (JSON) {
                self.itemsDic = JSON;
            }else {
                [self readLocalItems];
            }
        } withFailHandler:^(id error) {
            [self readLocalItems];
        }];
    }
    
    //设置标题的Attributed
    countryAttributedString = [[NSMutableAttributedString alloc] initWithString:WANTIM_CountryString];
    targetAttributedString = [[NSMutableAttributedString alloc] initWithString:WANTIM_TargetString];
    NSDictionary * labAttributes = @{NSForegroundColorAttributeName:[UIColor DDR102_G102_B102ColorWithalph:1.0f], NSFontAttributeName:[UIFont boldSystemFontOfSize:18.f*SCREEN_WIDTHRATE_6]};
    [countryAttributedString setAttributes:labAttributes range:NSMakeRange(0, countryAttributedString.length)];
    
    NSMutableAttributedString *backAttributedString = [[NSMutableAttributedString alloc] initWithString:SubTitleString attributes:@{NSForegroundColorAttributeName:[UIColor DDR102_G102_B102ColorWithalph:1.0f], NSFontAttributeName:[UIFont systemFontOfSize:16.f*SCREEN_WIDTHRATE_6]}];
    [countryAttributedString appendAttributedString:backAttributedString];
    [targetAttributedString appendAttributedString:backAttributedString];
    
    //请求APP的各种配置：首页咨询按钮是否显示、引导页跳过是否显示、提示颜色等
    if (![HNBUtils sandBoxGetInfo:[NSString class] forKey:IMGuide_Show_Skip]) {
        //如果请求到了配置数据则不再请求
        [DataFetcher doGetConfigInfoHomeIndex:^(id JSON) {
            if (JSON) {
                if ([[HNBUtils sandBoxGetInfo:[NSString class] forKey:IMGuide_Show_Skip] isEqualToString:@"1"]) {
                    _isShowSkip = YES;
                }else {
                    _isShowSkip = NO;
                }
            }
        } withFailHandler:^(id error) {
            
        }];
    }else {
        if ([[HNBUtils sandBoxGetInfo:[NSString class] forKey:IMGuide_Show_Skip] isEqualToString:@"1"]) {
            _isShowSkip = YES;
        }else {
            _isShowSkip = NO;
        }
    }
    
    self.timeCount = 0;
    self.currentPage = 0;
    self.questionCount = gWithOutWorkPage; //默认6道题，假如选择的国家有香港、澳大利亚、加拿大的则有7道题
    self.rightNavBtn.hidden = NO;
    self.backBtn.hidden = YES;
    
    randomArr = [[NSArray alloc] init];
    randomArr = @[@"美国",@"加拿大",@"澳大利亚",@"香港地区",@"葡萄牙",@"西班牙",@"新西兰",@"马来西亚",@"马耳他",@"爱尔兰",@"安提瓜",@"圣基茨",@"美国"];
    
    //第一次进入引导页后先默认没有完成引导页
    [HNBUtils sandBoxSaveInfo:@"0" forKey:IMGuide_hasBeen_Finished];
}

- (void)setLoadingView {
    loadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    loadView.backgroundColor = [UIColor DDR51_G51_B51ColorWithalph:0.7f];
//    [[[UIApplication sharedApplication] keyWindow] addSubview:loadView];
    [self.view addSubview:loadView];
    
    loadProgress = [HNBLoadingProgressView progressView];
    loadProgress.frame = CGRectMake(0, 0, 150, 150);
    loadProgress.progress = 0.0;
    loadProgress.center = loadView.center;
    [loadView addSubview:loadProgress];
    
    _countryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    _countryLabel.textAlignment = NSTextAlignmentCenter;
    _countryLabel.textColor = [UIColor whiteColor];
    [_countryLabel setFont:[UIFont systemFontOfSize:FONT_UI32PX]];
    [loadView addSubview:_countryLabel];
    _countryLabel.center  = CGPointMake(loadView.centerX, loadView.centerY + 80);
    _countryLabel.text = @"正在匹配中...美国";
    
    timer= [NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(changeProgress:) userInfo:nil repeats:YES];
}

- (void)changeProgress:(NSTimer *)sender{
    NSInteger randX = arc4random()%randomArr.count; // 生成0-12的随机数
    CGFloat randF = (randX+1) * 0.01; // 生成0.01-0.13的随机数
    [loadProgress setProgress:loadProgress.progress +randF];
    if (randX <= randomArr.count - 1) {
        _countryLabel.text = [NSString stringWithFormat:@"正在匹配中...%@",randomArr[randX]];
    }
    //加载完后移除
    if (loadProgress.progress >= 0.95f) {
        [loadView removeFromSuperview];
        [loadProgress dismiss];
        [timer invalidate];
        timer = nil;
        //发起请求
        [self requestIMCase];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //显示原生的NavigationBar
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationItem hidesBackButton];
    [[self rdv_tabBarController] setTabBarHidden:TRUE animated:FALSE];

    if (self.currentPage == GuidePageCountry) {
        self.backBtn.hidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [HNBUtils sandBoxSaveInfo:nil forKey:IMGuide_Show_Skip];
    
    //防护 - 确保定时器完全关闭
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    if (_codeTimer) {
        [_codeTimer invalidate];
        _codeTimer = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark == 发起生成移民方案请求
-(void)requestIMCase {
    //成功生成移民方案
//    if (_questionCount == gWholePage) {
//        //包括工作年限的题目
//        
//    }
    [HNBClick event:@"200033" Content:uploadDic];
    
    GuideImassessViewController *vc = [[GuideImassessViewController alloc] init];
    NSString *URLString = [NSString stringWithFormat:@"%@/%@",H5APIURL,GuideImassessList];
    vc.URL = [vc.webManger configNativeNavWithURLString:URLString ctle:@"0" csharedBtn:@"0" ctel:@"0" cfconsult:@"0"];
    [self.navigationController pushViewController:vc animated:YES];
    //本地评估数据设空
    [HNBUtils sandBoxSaveInfo:nil forKey:IMAssess_Local_Data];
}

#pragma mark ====== GuideHomeViewDelegate =======

-(void)GuideHomeViewChoseIMState:(UIButton *)sender {
    
    _rightNavBtn.hidden = YES;
    
    if (sender.tag == IMState_ED_IM) {
        /*我已移民*/
        [HNBClick event:@"200003" Content:uploadDic];
        NSArray *itemsArr = [self.itemsDic valueForKey:GuideHome_Nation];
        /*重构*/
        self.mainView.allQuestionsArr = itemsArr;
        /*end*/
        [self.mainView setIMEDViewWithImageStr:Guide_Image_Logo title:IMED_CountryString page:0 wholePage:1];
        
    }else if (sender.tag == IMState_ING_IM) {
        /*我要移民*/
        [HNBClick event:@"200002" Content:uploadDic];
        NSArray *itemsArr = [self.itemsDic valueForKey:GuideHome_QuestionOptions];
//        NSMutableArray *optionsArr = [NSMutableArray new];
//        if (itemsArr && itemsArr.count > 0) {
//            IMAssessItemsModel *model = itemsArr[0];
//            optionsArr = [NSMutableArray arrayWithArray:model.option];
//        }
        /*重构*/
        self.mainView.allQuestionsArr = itemsArr;
        /*end*/
        [self.mainView setButtonsViewWithImageStr:Guide_Image_Logo attributtitle:countryAttributedString page:0 wholePage:_questionCount];
    }
}

-(void)GuideHomeViewNext {
    if (_currentPage == GuidePageCountry) {
        [HNBClick event:@"200005" Content:uploadDic];
    }else if (_currentPage == GuidePagePurpose) {
        [HNBClick event:@"200012" Content:uploadDic];
    }else if (_currentPage == GuidePageExpense) {
        [HNBClick event:@"200014" Content:uploadDic];
    }else if (_currentPage == GuidePageLiveTime) {
        [HNBClick event:@"200016" Content:uploadDic];
    }else if (_currentPage == GuidePageEducation) {
        [HNBClick event:@"200018" Content:uploadDic];
    }else if (_currentPage == GuidePageEnglish) {
        [HNBClick event:@"200020" Content:uploadDic];
    }else if (_currentPage == GuidePageWorkingLife) {
        [HNBClick event:@"200022" Content:uploadDic];
    }
    self.currentPage ++;
    if (_mainView.optionsBtnArr.count >= 1) {
        NSArray *tempArr = _mainView.optionsBtnArr[GuidePageCountry];
        for (HNBIMAssessButton *tempBtn in tempArr) {
            if ([tempBtn.idTag integerValue] == CanadaCode || [tempBtn.idTag integerValue] == AustraliaCode || [tempBtn.idTag integerValue] == HKCode) {
                self.questionCount = gWholePage;
                break;
            }else {
                self.questionCount = gWithOutWorkPage;
            }
        }
    }

    [self setUIInTheMainView];
}

- (void)GuideHomeViewIMEDNext {
    NSUInteger wholePage = 1;
    self.backBtn.hidden = NO;
    if (_currentPage != wholePage) {
        
        [HNBClick event:@"200007" Content:uploadDic];
        
        if (_mainView.optionsBtnArr.count >= 1) {
            NSArray *tempArr =_mainView.optionsBtnArr[0];
            HNBIMAssessButton *tempBtn =tempArr[0];
            for (IMNationCityModel *f in _mainView.allQuestionsArr) {
                if ([f.fID isEqualToString: tempBtn.idTag]) {
                    //选择国家后要默认先把城市设0（防止返回改国家后退出的情况）
                    [HNBUtils sandBoxSaveInfo:f.fID forKey:IMED_Local_Nation];
                    [HNBUtils sandBoxSaveInfo:@"0" forKey:IMED_Local_City];
                    //有城市跳到下一页
                    if (f.city.count > 0) {
                        self.currentPage ++;
                        [self.mainView setIMEDViewWithImageStr:@"GuideImassess_City" title:nil page:_currentPage wholePage:1];
                        
                        if(_lastCountryID && ![_lastCountryID isEqualToString:f.fID] && ![_lastCountryID isEqualToString:@""]){
                            //重新选择了别的国家
                            if (_mainView.optionsBtnArr.count > GuidePageIMEDCity) {
                                [_mainView.optionsBtnArr removeObjectAtIndex:GuidePageIMEDCity];
                                [_mainView observeNextBtn];
                            }
                            [self.mainView.HNBIMEDCityView refreshCityButtonWithArray:f.city];
                        }
                        
                        _lastCountryID = f.fID;
                        
                    }else {
                        //没有城市进入引导页并且设置为已完成题目
                        [HNBUtils sandBoxSaveInfo:@"1" forKey:IMGuide_hasBeen_Finished];
                        
                        LoginViewController *vc = [[LoginViewController alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    break;
                }
            }
        }
    }else {
        
        [HNBClick event:@"200009" Content:uploadDic];
        
        if (_mainView.optionsBtnArr.count >= 2) {
            NSArray *tempArr =_mainView.optionsBtnArr[1];
            HNBIMAssessButton *tempBtn =tempArr[0];
            [HNBUtils sandBoxSaveInfo:tempBtn.idTag forKey:IMED_Local_City];
        }
        //选择城市进入引导页并且设置为已完成题目
        [HNBUtils sandBoxSaveInfo:@"1" forKey:IMGuide_hasBeen_Finished];
        
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)GuideHomeViewGetIMCase {
    /*生成移民方案*/
    if ([HNBUtils evaluateIsPhoneNum:_mainView.vCodeView.phoneTextfield.text] && _mainView.vCodeView.vCodeTextField.text.length > 0 &&(_mainView.vCodeView.maleBtn.selected || _mainView.vCodeView.femaleBtn.selected)) {
        
        [self setDicFromeArr];
        //进入引导页并且完成了题目
        [HNBUtils sandBoxSaveInfo:@"1" forKey:IMGuide_hasBeen_Finished];
        
        [self.choseDic setValue:_mainView.vCodeView.phoneTextfield.text forKey:IMAssess_Mobile];
        [self.choseDic setValue:_mainView.vCodeView.vCodeTextField.text forKey:IMAssess_Vcode];
        [self.choseDic setValue:_mainView.vCodeView.nameTextfield.text forKey:IMAssess_Name];
        [self.choseDic setValue:@"mobile:collect" forKey:IMAssess_Type];
        if (_mainView.vCodeView.maleBtn.selected) {
            [self.choseDic setValue:@"MALE" forKey:IMAssess_Sex];
        }else if (_mainView.vCodeView.femaleBtn.selected) {
            [self.choseDic setValue:@"FEMALE" forKey:IMAssess_Sex];
        }
        
        [DataFetcher doGetIMAssessCaseWithUserInfoData:[_choseDic copy] SucceedHandler:^(id JSON) {
            int errCode = [[JSON valueForKey:@"state"] intValue];
            if (errCode == 0) {
                NSString *dataRes = [JSON valueForKey:@"data"];
                if ([dataRes isEqualToString:@"1"]) {
                    //请求成功再添加蒙版
                    [self setLoadingView];
                }
            }else if (errCode == 12001000 || errCode == 12001003 || errCode == 12001006 || errCode == 12001007 || errCode == 110001) {
                [HNBClick event:@"200032" Content:uploadDic];
            }
        } withFailHandler:^(id error) {
            
        }];
        
    }else {
        if (![HNBUtils evaluateIsPhoneNum:_mainView.vCodeView.phoneTextfield.text]) {
            [HNBClick event:@"200031" Content:uploadDic];
            [[HNBToast shareManager] toastWithOnView:nil msg:@"请输入正确的手机号" afterDelay:1.0 style:HNBToastHudFailure];
        }else if (_mainView.vCodeView.nameTextfield.text.length <= 0) {
            [HNBClick event:@"200030" Content:uploadDic];
            [[HNBToast shareManager] toastWithOnView:nil msg:@"请输入您的姓名" afterDelay:1.0 style:HNBToastHudFailure];
        }
    }
}

- (void)GuideHomeViewGetVCode:(id)sender vCodeView:(GuideVCodeView *)vCodeView {
    /*获取验证码*/
    if ([HNBUtils evaluateIsPhoneNum:vCodeView.phoneTextfield.text] && vCodeView.nameTextfield.text.length > 0 &&(vCodeView.femaleBtn.isSelected || vCodeView.maleBtn.isSelected)) {
        [HNBClick event:@"200028" Content:uploadDic];
        [DataFetcher doGetIMAssessVCodeWithmobilePhoneNum:vCodeView.phoneTextfield.text SucceedHandler:^(id JSON) {
            int errCode = [[JSON valueForKey:@"state"] intValue];
            if (errCode == 0) {
                _timeCount = 60;
                [_mainView.vCodeView.vCodeBtn setTitle:[NSString stringWithFormat:@"%lus后重试",(unsigned long)_timeCount] forState:UIControlStateDisabled];
                [_mainView.vCodeView.vCodeBtn setEnabled:NO];
                _mainView.vCodeView.vCodeBtn.layer.borderColor = [UIColor DDPlaceHoldGray].CGColor; // 204 204 204
                [_mainView.vCodeView.vCodeBtn setTitleColor:[UIColor DDPlaceHoldGray] forState:UIControlStateNormal];
                [[HNBToast shareManager] toastWithOnView:nil msg:@"验证码已发送,请查收" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
                _codeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                              target:self
                                                            selector:@selector(timeCountDown:)
                                                            userInfo:nil
                                                             repeats:YES];
            }else if (errCode == 110001){ // 可以直接重新获取验证码按钮
                
                [self invalidateCodeTimer];
                
            }
        } withFailHandler:^(id error) {
            
        }];
    }else {
        if (![HNBUtils evaluateIsPhoneNum:vCodeView.phoneTextfield.text]) {
            [[HNBToast shareManager] toastWithOnView:nil msg:@"请输入正确的手机号" afterDelay:1.0 style:HNBToastHudFailure];
        }else if (vCodeView.nameTextfield.text.length <= 0) {
            [[HNBToast shareManager] toastWithOnView:nil msg:@"请输入您的姓名" afterDelay:1.0 style:HNBToastHudFailure];
        }
    }
}

#pragma mark ====== GuideHomeDelegate END ======

- (void)timeCountDown:(NSTimer *)timers{
    _timeCount --;
    if (_timeCount <= 0) {
        [self invalidateCodeTimer];
    } else {
        [_mainView.vCodeView.vCodeBtn setTitle:[NSString stringWithFormat:@"%lus后重试",(unsigned long)_timeCount] forState:UIControlStateDisabled];
        [_mainView.vCodeView.vCodeBtn setEnabled:NO];
        _mainView.vCodeView.vCodeBtn.layer.borderColor = [UIColor DDPlaceHoldGray].CGColor; // 204 204 204
        [_mainView.vCodeView.vCodeBtn setTitleColor:[UIColor DDPlaceHoldGray] forState:UIControlStateNormal];
    }
}

//停止倒计时
- (void)invalidateCodeTimer{
    
    [_codeTimer invalidate];
    _codeTimer = nil;
    [_mainView.vCodeView.vCodeBtn setEnabled:YES];
    [_mainView.vCodeView.vCodeBtn setTitle:@"重发验证码" forState:UIControlStateNormal];
    [_mainView.vCodeView.vCodeBtn.layer setBorderColor:[UIColor DDR63_G162_B255ColorWithalph:1.0].CGColor];
    [_mainView.vCodeView.vCodeBtn setTitleColor:[UIColor DDR63_G162_B255ColorWithalph:1.0] forState:UIControlStateNormal];
    
}

- (void) back_prePage:(id)sender{
    [_mainView backLastedPage];
    if (!_mainView.isIM_ED) {
        if (_currentPage >= 1) {
            _currentPage --;
            [self setUIInTheMainView];
        }
    }else {
        if (_currentPage >= 1) {
            _currentPage --;
            if (_currentPage == 0) {
                self.backBtn.hidden = YES;
            }
            [self.mainView setIMEDViewWithImageStr:Guide_Image_Logo title:IMED_CountryString page:_currentPage wholePage:1];
        }else {
            self.backBtn.hidden = YES;
        }
    }
}

- (void)setUIInTheMainView {
    self.title = [NSString stringWithFormat:@"%ld/%lu",(long)_currentPage,(unsigned long)_questionCount];
    NSMutableAttributedString *title = nil;
    NSString *imageStr = [NSString stringWithFormat:@"GuideImassess_%ld",(long)_currentPage];
    
    if (_currentPage == GuidePageCountry) {
        /*第一题 - 国家*/
        title = countryAttributedString;
        imageStr = Guide_Image_Logo;
        _backBtn.hidden = YES;
        _rightNavBtn.hidden = YES;
        self.title = @"";
        
    }else if (_currentPage == GuidePagePurpose) {
        /*第二题 - 移民目的*/
        title = targetAttributedString;
        _backBtn.hidden = NO;
        if (_isShowSkip) {
            _rightNavBtn.hidden = NO;
            [_rightNavBtn setTitle:SKIP_String forState:UIControlStateNormal];
        }
    }else if (_currentPage == _questionCount - 1) {
        /*倒数第二题*/
        _rightNavBtn.hidden = YES;
        if (_currentPage == gWithOutWorkPage) { //如果有工作年限页
            imageStr = Guide_Image_Work;
        }
        [_mainView.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    }else if(_currentPage == _questionCount) {
        /*最后一题 - 用户信息*/
        _rightNavBtn.hidden = NO;
        [_rightNavBtn setTitle:SKIP_String forState:UIControlStateNormal];
        [HNBUtils sandBoxSaveInfo:@"1" forKey:USER_ASSESSED_IMMIGRANT]; // 引导- 最后一页
        imageStr = [NSString stringWithFormat:Guide_Image_Userinfo];
    }
    else {
        _rightNavBtn.hidden = YES;
    }
    [_mainView setButtonsViewWithImageStr:imageStr attributtitle:title page:_currentPage wholePage:_questionCount];
}

- (void)rightNavAction:(UIButton *)btn {
    if ([btn.titleLabel.text isEqualToString:SKIP_String]) {
        if (_currentPage == _questionCount) {
            [HNBClick event:@"200023" Content:uploadDic];
            //进入引导页并且完成了题目
            [HNBUtils sandBoxSaveInfo:@"1" forKey:IMGuide_hasBeen_Finished];
            /*最后一步跳过*/
            [self setDicFromeArr];
            [self.navigationController popViewControllerAnimated:NO];
        }else {
            [HNBClick event:@"200010" Content:uploadDic];
            [self.navigationController popViewControllerAnimated:NO];
        }
    }else {
        [HNBClick event:@"200001" Content:uploadDic];
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

#pragma mark == 将用户选项从数组抽取存为字典
- (void)setDicFromeArr {
    for (int i = 0; i<_mainView.optionsBtnArr.count; i++) {
        NSMutableArray *tempArr = _mainView.optionsBtnArr[i];
        NSString *dataStr = @"";
        for (int j = 0; j < tempArr.count; j++) {
            HNBIMAssessButton *tempBtn = tempArr[j];
            if (tempArr.count > 1) {
                if (j == tempArr.count - 1) {//最后一个元素
                    dataStr = [dataStr stringByAppendingString:tempBtn.idTag];
                }else {
                    dataStr = [dataStr stringByAppendingString:[NSString stringWithFormat:@"%@,",tempBtn.idTag]];
                }
            }else {
                dataStr = tempBtn.idTag;
            }
        }
        if (i == GuidePageCountry) {
            [self.choseDic setValue:dataStr forKey:IMAssess_Country];
        } else if (i == GuidePagePurpose) {
            [self.choseDic setValue:dataStr forKey:IMAssess_Purpose];
        } else if (i == GuidePageExpense) {
            [self.choseDic setValue:dataStr forKey:IMAssess_Expense];
        } else if (i == GuidePageEducation) {
            [self.choseDic setValue:dataStr forKey:IMAssess_Education];
        } else if (i == GuidePageEnglish) {
            [self.choseDic setValue:dataStr forKey:IMAssess_Ielts];
        } else if (i == GuidePageLiveTime) {
            [self.choseDic setValue:dataStr forKey:IMAssess_Overseas_Residence_Requirements];
        } else if (i == GuidePageWorkingLife) {
            NSString *countryStr = [self.choseDic valueForKey:IMAssess_Country];
            if ([countryStr rangeOfString:[NSString stringWithFormat: @"%d",AustraliaCode]].location != NSNotFound || [countryStr rangeOfString:[NSString stringWithFormat: @"%d",CanadaCode]].location != NSNotFound || [countryStr rangeOfString:[NSString stringWithFormat: @"%d",HKCode]].location != NSNotFound) {
                [self.choseDic setValue:dataStr forKey:IMAssess_Working_Life];
            }else {
                //如果不是加拿大、澳大利亚、香港这三个地区就不用带年限
                [self.choseDic setValue:@"" forKey:IMAssess_Working_Life];
            }
            
        }
    }
    //先将评估结果保存本地
    [HNBUtils sandBoxSaveInfo:self.choseDic forKey:IMAssess_Local_Data];
}

/*
 ** 用于无网络时读取工程中的本地题目
 */
- (void)readLocalItems {
    //读取本地的
    NSString *path = [[NSBundle mainBundle] pathForResource:IMAssess_Question_TXT ofType:nil];
    //读取修改后
    NSDictionary *dataJson = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *nationalArr = [dataJson returnValueWithKey:@"national_city"];
    NSArray *assessmentArr = [dataJson returnValueWithKey:@"assessment"];
    
    NSMutableArray *nationalResult   = [[NSMutableArray alloc] init];
    NSMutableArray *assessmentResult = [[NSMutableArray alloc] init];
    
    if (nationalArr && nationalArr.count > 0) {
        for (NSDictionary *nation in nationalArr) {
            [IMNationCityModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"icon"        : @"f_icon",
                         @"shortName"   : @"f_name_short_cn",
                         @"fID"         : @"f_id",
                         @"wholeName"   : @"f_name_cn",
                         };
            }];
            IMNationCityModel *f = [IMNationCityModel mj_objectWithKeyValues:nation];
            if (f) {
                [nationalResult addObject:f];
            }
        }
    }
    
    if (assessmentArr && assessmentArr.count > 0) {
        for (NSDictionary *item in assessmentArr) {
            IMAssessItemsModel *f = [IMAssessItemsModel mj_objectWithKeyValues:item];
            if (f) {
                [assessmentResult addObject:f];
            }
        }
    
    }
    
    self.itemsDic = @{
                                GuideHome_Nation            :nationalResult,
                                GuideHome_QuestionOptions   :assessmentResult,
                                };
}

#pragma mark == Lazy Load
- (UIButton *)rightNavBtn {
    if (!_rightNavBtn) {
        _rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 66)];
        [_rightNavBtn.titleLabel setFont:[UIFont systemFontOfSize:FONT_UI32PX]];
        [_rightNavBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [_rightNavBtn setTitleColor:[UIColor DDR153_G153_B153ColorWithalph:1.0f] forState:UIControlStateNormal];
        [_rightNavBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_rightNavBtn addTarget:self action:@selector(rightNavAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *tmpRightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightNavBtn];
        self.navigationItem.rightBarButtonItem = tmpRightItem;
    }
    return _rightNavBtn;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(-40, 0, 40, 60)];
        [_backBtn setImage:[UIImage imageNamed:@"login_nav_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(back_prePage:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *tmpRightItem = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
        self.navigationItem.leftBarButtonItem = tmpRightItem;
    }
    return _backBtn;
}

@end
