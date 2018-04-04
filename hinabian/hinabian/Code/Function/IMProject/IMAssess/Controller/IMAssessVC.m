//
//  IMAssessVC.m
//  hinabian
//
//  Created by 何松泽 on 2017/11/1.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "IMAssessVC.h"
#import "RDVTabBarController.h"
#import "HNBIMAssessButton.h"
#import "LoginViewController.h"
#import "IMAssessHomeView.h"
#import "DataFetcher.h"
#import "IMAssessItemsModel.h"
#import "IMNationCityModel.h"
#import "GuideVCodeView.h"
#import "HNBToast.h"
#import "GuideImassessViewController.h"
//#import "NSDictionary+ValueForKey.h"
//#import "MJExtension.h"
#import "HNBLoadingProgressView.h"

#define CanadaCode 12021000
#define AustraliaCode 11011000
#define HKCode 14011000

@interface IMAssessVC ()<IMAssessHomeViewDelegate,UIGestureRecognizerDelegate>
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

@property (nonatomic, strong) IMAssessHomeView *mainView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) NSDictionary *itemsDic;               /*题目（包含已移民）*/
@property (nonatomic, strong) NSArray *itemsArr;                    /*题目（仅仅想移民）*/
@property (nonatomic, strong) NSMutableDictionary *choseDic;        /*选项*/
@property (nonatomic, strong) NSTimer *codeTimer;
@property (nonatomic) NSUInteger timeCount;
@property (nonatomic) NSUInteger questionCount;
@property (nonatomic) NSUInteger currentPage;

@end

@implementation IMAssessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    BOOL isAssess = YES;
    uploadDic = @{@"value":[NSNumber numberWithBool:isAssess],};
    self.itemsDic = [[NSDictionary alloc] init];
    self.itemsArr = [[NSArray alloc] init];
    self.choseDic = [[NSMutableDictionary alloc] init];
    self.mainView = [[IMAssessHomeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.mainView.delegate = (id<IMAssessHomeViewDelegate>)self;
    [self.view addSubview:self.mainView];
    self.timeCount = 0;
    self.currentPage = 0;
    self.questionCount = gWithOutWorkPage; //默认6道题，假如选择的国家有香港、澳大利亚、加拿大的则有7道题
    
    //设置标题的Attributed
    countryAttributedString = [[NSMutableAttributedString alloc] initWithString:WANTIM_CountryString];
    targetAttributedString = [[NSMutableAttributedString alloc] initWithString:WANTIM_TargetString];
    NSDictionary * labAttributes = @{NSForegroundColorAttributeName:[UIColor DDR102_G102_B102ColorWithalph:1.0f], NSFontAttributeName:[UIFont boldSystemFontOfSize:18.f*SCREEN_WIDTHRATE_6]};
    [countryAttributedString setAttributes:labAttributes range:NSMakeRange(0, countryAttributedString.length)];
    
    NSMutableAttributedString *backAttributedString = [[NSMutableAttributedString alloc] initWithString:SubTitleString attributes:@{NSForegroundColorAttributeName:[UIColor DDR102_G102_B102ColorWithalph:1.0f], NSFontAttributeName:[UIFont systemFontOfSize:16.f*SCREEN_WIDTHRATE_6]}];
    [countryAttributedString appendAttributedString:backAttributedString];
    [targetAttributedString appendAttributedString:backAttributedString];
    
    [self readLocalItems];
    self.itemsArr = [self.itemsDic valueForKey:GuideHome_QuestionOptions];
    if ([self.itemsDic count] == 0 || !_itemsArr || _itemsArr.count <= 0) {
        //如果本地还未保存数据
        [DataFetcher doGetIMAssessItemsWithSucceedHandler:^(id JSON) {
            if (JSON) {
                self.itemsDic = JSON;
                
                self.itemsArr = [self.itemsDic valueForKey:GuideHome_QuestionOptions];
                NSMutableArray *optionsArr = [NSMutableArray new];
                if (_itemsArr && _itemsArr.count > 0) {
                    IMAssessItemsModel *model = _itemsArr[0];
                    optionsArr = [NSMutableArray arrayWithArray:model.option];
                }
                [self.mainView setButtonsViewWithData:[optionsArr copy] imageStr:Guide_Image_Logo attributtitle:countryAttributedString page:0 wholePage:_questionCount];
            }
        } withFailHandler:^(id error) {
            
        }];
    }else {
        IMAssessItemsModel *model = _itemsArr[0];
        NSMutableArray *optionsArr = [NSMutableArray arrayWithArray:model.option];
        [self.mainView setButtonsViewWithData:[optionsArr copy] imageStr:Guide_Image_Logo attributtitle:countryAttributedString page:0 wholePage:_questionCount];

        [DataFetcher doGetIMAssessItemsWithSucceedHandler:^(id JSON) {

        } withFailHandler:^(id error) {

        }];
    }
    randomArr = [[NSArray alloc] init];
    randomArr = @[@"美国",@"加拿大",@"澳大利亚",@"香港地区",@"葡萄牙",@"西班牙",@"新西兰",@"马来西亚",@"马耳他",@"爱尔兰",@"安提瓜",@"圣基茨",@"美国"];
}

- (void)setLoadingView {
    loadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    loadView.backgroundColor = [UIColor DDR51_G51_B51ColorWithalph:0.8f];
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
    
    timer= [NSTimer scheduledTimerWithTimeInterval:0.25f target:self selector:@selector(changeProgress:) userInfo:nil repeats:YES];
}

- (void)changeProgress:(NSTimer *)sender{
    //加载完后移除
    if (loadProgress.progress >= 1.0f) {
        [loadView removeFromSuperview];
        [loadProgress dismiss];
        [timer invalidate];
        timer = nil;
        
        [self requestIMCase];//发起请求
        return;
    }
    NSInteger randX = arc4random()%13; // 生成0-12的随机数
    CGFloat randF = (randX+1) * 0.01; // 生成0.01-0.13的随机数
    [loadProgress setProgress:loadProgress.progress +randF];
    if (randX <= randomArr.count - 1) {
        _countryLabel.text = [NSString stringWithFormat:@"正在匹配中...%@",randomArr[randX]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.backBtn.hidden = NO;
    //隐藏原生的NavigationBar
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationItem setHidesBackButton:YES];
    [[self rdv_tabBarController] setTabBarHidden:TRUE animated:FALSE];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
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
//    if (![HNBUtils isLogin]) {
//        if (_questionCount == gWholePage) {
//            //包括工作年限的题目
//        }
//    }else {
//        if (_questionCount == gWholePage - 1) {
//            //包括工作年限的题目
//        }
//        [HNBClick event:@"200033" Content:uploadDic];
//    }
    [HNBClick event:@"200033" Content:uploadDic];
    
    GuideImassessViewController *vc = [[GuideImassessViewController alloc] init];
    NSString *URLString = [NSString stringWithFormat:@"%@/%@",H5APIURL,GuideImassessList];
    vc.URL = [vc.webManger configNativeNavWithURLString:URLString ctle:@"0" csharedBtn:@"0" ctel:@"0" cfconsult:@"0"];
    [self.navigationController pushViewController:vc animated:YES];
    //本地评估数据设空
    [HNBUtils sandBoxSaveInfo:nil forKey:IMAssess_Local_Data];
}

#pragma mark ======IMAssessHomeViewDelegate ======

-(void)IMAssessHomeViewNext:(id)sender {
    if (sender) {
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
        
        UIButton *pageBtn = sender;
        self.currentPage = pageBtn.tag + 1;
        NSMutableAttributedString *title = nil;
        NSString *imageStr = [NSString stringWithFormat:@"GuideImassess_%ld",(long)_currentPage];
//        NSArray *itemsArr = [self.itemsDic valueForKey:GuideHome_QuestionOptions];
        NSMutableArray *optionsArr = [NSMutableArray new];
        if (_itemsArr && _itemsArr.count > _currentPage) {
            IMAssessItemsModel *model = _itemsArr[_currentPage];
            optionsArr = [NSMutableArray arrayWithArray:model.option];
        }
        if (_mainView.optionsBtnArr.count >= 1) {
            NSArray *tempArr = _mainView.optionsBtnArr[gChoseCountryPage];
            for (HNBIMAssessButton *tempBtn in tempArr) {
                if ([tempBtn.idTag integerValue] == CanadaCode || [tempBtn.idTag integerValue] == AustraliaCode || [tempBtn.idTag integerValue] == HKCode) {
                    if ([HNBUtils isLogin]) {
                        self.questionCount = gWholePage - 1;
                    }else {
                        self.questionCount = gWholePage;
                    }
                    break;
                }else {
                    if ([HNBUtils isLogin]) {
                        self.questionCount = gWithOutWorkPage - 1;
                    }else {
                        self.questionCount = gWithOutWorkPage;
                    }
                }
            }
        }
        
        self.title = [NSString stringWithFormat:@"%ld/%lu",(long)_currentPage,(unsigned long)_questionCount];
        if (_currentPage == gChoseTargetPage) {
            title = targetAttributedString;
        }else if (self.questionCount - 1 == gWithOutWorkPage && _currentPage == gWithOutWorkPage) {
            imageStr = [NSString stringWithFormat:Guide_Image_Work];
        }else if(_currentPage == self.questionCount) {
            if (![HNBUtils isLogin]) {
                [HNBUtils sandBoxSaveInfo:@"1" forKey:USER_ASSESSED_IMMIGRANT];
                imageStr = [NSString stringWithFormat:Guide_Image_Userinfo];
            }else {
                if (_questionCount  == gWithOutWorkPage) {
                    imageStr = [NSString stringWithFormat:Guide_Image_Work];
                }
            }
        }
        [self.mainView setButtonsViewWithData:[optionsArr copy] imageStr:imageStr attributtitle:title page:_currentPage wholePage:_questionCount];
    }
}

#pragma mark == 未登录 - 点击生成移民方案
- (void)IMAssessHomeViewGetIMCase {
    
    /*生成移民方案*/
    if ([HNBUtils evaluateIsPhoneNum:_mainView.vCodeView.phoneTextfield.text] && _mainView.vCodeView.vCodeTextField.text.length > 0) {
        
        [self setDicFromeArr];
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
                    //添加蒙版
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
//    NSLog(@"%@",self.choseDic);
}

#pragma mark == 已登录 - 点击生成移民方案
- (void)IMAssessHomeViewGetIMCaseWithLogin {
    
    [self setDicFromeArr];
    /*生成移民方案*/
    [DataFetcher doGetIMAssessCaseWithUserInfoData:[_choseDic copy] SucceedHandler:^(id JSON) {
        int errCode = [[JSON valueForKey:@"state"] intValue];
        if (errCode == 0) {
            NSString *dataRes = [JSON valueForKey:@"data"];
            if ([dataRes isEqualToString:@"1"]) {
                //成功后再添加蒙版
                [self setLoadingView];
                
            }
        }else if (errCode == 12001000 || errCode == 12001003 || errCode == 12001006 || errCode == 12001007 || errCode == 110001) {
            [HNBClick event:@"200032" Content:uploadDic];
        }
    } withFailHandler:^(id error) {
        
    }];
    
    [HNBUtils sandBoxSaveInfo:@"1" forKey:USER_ASSESSED_IMMIGRANT];
}

#pragma mark == 点击获取验证码（未登录才会调用）
- (void)IMAssessHomeViewGetVCode:(id)sender vCodeView:(GuideVCodeView *)vCodeView {
    /*获取验证码*/
    if ([HNBUtils evaluateIsPhoneNum:vCodeView.phoneTextfield.text] && vCodeView.nameTextfield.text.length > 0) {
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

- (void)timeCountDown:(NSTimer *)timer{
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
    _mainView.vCodeView.vCodeBtn.layer.borderColor = [UIColor DDR63_G162_B255ColorWithalph:1.0].CGColor;
    [_mainView.vCodeView.vCodeBtn setTitleColor:[UIColor DDR63_G162_B255ColorWithalph:1.0] forState:UIControlStateNormal];
    
}

#pragma mark == 点击返回
- (void) back_prePage:(id)sender{
    [self.mainView backLastedPage];
    if (_currentPage >= 1) {
        _currentPage --;
        self.title = [NSString stringWithFormat:@"%ld/%lu",(long)_currentPage,(unsigned long)_questionCount];
        NSMutableAttributedString *title = nil;
        NSString *imageStr = [NSString stringWithFormat:@"GuideImassess_%ld",(long)_currentPage];
        if (_currentPage == 0) {
            self.title = @"";
            title = countryAttributedString;
            imageStr = Guide_Image_Logo;
        }else if (_currentPage == 1) {
            title = targetAttributedString;
        }else if (_currentPage == _questionCount - 1) {
            if (_currentPage == gWithOutWorkPage) {
                imageStr = Guide_Image_Work;
            }
            [self.mainView.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        }
        [self.mainView setButtonsViewWithData:nil imageStr:imageStr attributtitle:title page:_currentPage wholePage:_questionCount];

    }else {
        [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark == 读取本地题目
- (void)readLocalItems {
    //首先读取本地保存的题目
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileDicPath = [docPath stringByAppendingPathComponent:IMAssess_Question_TXT];
    NSDictionary *dataJson = [NSDictionary dictionaryWithContentsOfFile:fileDicPath];
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

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 50, 50)];
        [_backBtn setImage:[UIImage imageNamed:@"login_nav_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(back_prePage:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backBtn];
    }
    return _backBtn;
}

@end

