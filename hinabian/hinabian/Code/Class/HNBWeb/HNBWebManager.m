//
//  HNBWebManager.m
//  hinabian
//
//  Created by hnbwyh on 2017/12/15.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#define INFO_DIC_DEFAULT_VALUE @"default"

#import "HNBWebManager.h"
// 数据解析
#import "RSADataSigner.h"
// 分享
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>

#import "LoginViewController.h"
#import "DataFetcher.h"
#import "WXApi.h"
#import "SWKQuestionShowViewController.h"
#import "QuestionListByLabelsViewController.h"
#import "IMQuestionViewController.h"
#import "PublicViewController.h"
#import "MyOnedayViewController.h"
#import "PersonalInfo.h"
#import "SWKIMProjectShowController.h"
#import "UserInfoController2.h"
#import "TribeShowNewController.h"
#import "IMAssessViewController.h"
#import "QuestionReplyDetailViewController.h"
#import "CouponViewController.h"
#import "HNBRichTextPostingVC.h" // 新版富文本发帖
#import "QAIndexViewController.h"
#import "Order.h"
#import "SWKSingleReplyViewController.h"
#import "TribeDetailInfoViewController.h"
#import "CouponViewController.h"
#import "SpecialActivityViewController.h"
#import "QASearchViewController.h"
#import "SWKVisaShowViewController.h"
#import "SWKTransactViewController.h"
#import "CardTableVC.h"
#import "IMAssessVC.h"
#import "RcmSpecialListVC.h"
#import "FunctionIMProjHomeController.h"


@interface HNBWebManager ()
{
    NSURL *selfURL;
    UINavigationController *navPara;
}


@end

@implementation HNBWebManager

#pragma mark  ------------------------------------ publick method

#pragma mark init
- (instancetype)init
{
    self = [super init];
    if (self) {
        _configIndictor = WebConfigIndictorDefault; // 测试参数
    }
    return self;
}

+(instancetype)defaultInstance{
    static HNBWebManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HNBWebManager alloc] init];
    });
    return instance;
}

#pragma mark url 解析及原生方法跳转

- (BOOL)decideToHandleBusinessWithURL:(NSString *)httpsurl nav:(UINavigationController *)nav{
    navPara = nav;
    return [self handleURLString:httpsurl jumpIntoAPP:FALSE];
}

-(void)jumpHandleWithURL:(NSString *)httpsurl nav:(UINavigationController *)nav jumpIntoAPP:(BOOL)isJump{
    navPara = nav;
    BOOL isHandle = [self handleURLString:httpsurl jumpIntoAPP:isJump];
    if (!isHandle) {
        
 
        
        SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
        vc.URL = [[NSURL alloc] withOutNilString:httpsurl];
        [nav pushViewController:vc animated:FALSE];

        
        
    }
    
}

#pragma mark 内链检测
- (BOOL)isHinabianSiteWithURLString:(NSString *)URLString{
    
    BOOL rlt = FALSE;
    NSRange mRange = [URLString rangeOfString:@"m.hinabian.com"];
    NSRange wRange = [URLString rangeOfString:@"www.hinabian.com"];
    if (mRange.location != NSNotFound || wRange.location != NSNotFound) {
        rlt = TRUE;
    }
    return rlt;
    
}

#pragma mark 帖子详情检测
- (BOOL)isHinabianThemeDetailWithURLString:(NSString *)URLString{
    
    BOOL rlt = FALSE;
    BOOL isHnb = [self isHinabianSiteWithURLString:URLString];
    NSRange detailRange = [URLString rangeOfString:@"theme/detail"];
    if (detailRange.location != NSNotFound && isHnb) {
        rlt = TRUE;
    }
    return rlt;
    
}

- (BOOL)isHinabianComWithURLString:(NSString *)URLString{
    BOOL rlt = TRUE;
    NSRange hnbRange = [URLString rangeOfString:@".hinabian.com"];
    if (hnbRange.location == NSNotFound && [URLString hasPrefix:@"http"]) {
        rlt = FALSE;
    }
    return rlt;
}

#pragma mark 判断当前加载的URL是否需要 push 跳转

- (BOOL)shouldPushNativeCtrlFromCurCtrlUTLString:(NSString *)urlstring url:(NSURL *)url{
    selfURL = url;
    
    BOOL isSameTribeID = [self isSameTribeId:urlstring];
    BOOL isSameURLString = [self isSameURL:urlstring];
    BOOL isSameIMProID = [self isSameIMProjectID:urlstring];
    //BOOL rtl = NO;
    
    
//    if ([urlstring rangeOfString:@"project/detail"].location != NSNotFound || [urlstring rangeOfString:@"visa/detail"].location != NSNotFound) {
//        // 项目详情、签证详情、涉及新旧
//        rtl = !isSameIMProID;
//    }else{
//        rtl = !isSameTribeID && !isSameURLString;
//    }
    
    BOOL rtl = !isSameURLString && !isSameIMProID && !isSameTribeID;
    
    return rtl;
    
}

#pragma mark 解析 URL 配置参数并组装字典返回

- (NSDictionary *)parserConfigDataURLString:(NSString *)URLString{
    /*
     // 1
     https://m.hinabian.com/native/project/detail?project_id=12021055&_is_show_native_top_menu=0&_is_show_native_top_menu_return=0&_is_show_native_top_menu_title=0&_is_show_native_top_menu_share=0&_is_show_native_float_consult=1
     
     // 2
     https://m.hinabian.com/estate.html?_is_show_native_float_consult=1
     
     */
    NSString  *theString = [NSString stringWithFormat:@"%@",URLString];
    NSString *anserFlag = @"?";
    NSString *andFlag= @"&";
    //NSLog(@" URLString - parserConfigDataURLString - willAppear :%@",theString);
    // 1. 解析参数
    NSMutableDictionary *rltDic = [[NSMutableDictionary alloc] initWithDictionary:[self defaultInfoDic]];
    if ([theString rangeOfString:anserFlag].location != NSNotFound) {
        NSArray *configDatas_anser = [theString componentsSeparatedByString:anserFlag];
        NSString *last = [configDatas_anser lastObject];
        NSMutableArray *configDatas_and = [[NSMutableArray alloc] init];
        if ([last rangeOfString:andFlag].location != NSNotFound) {
            NSArray *tmpData = [last componentsSeparatedByString:andFlag];
            [configDatas_and addObjectsFromArray:tmpData];
        }else{
            [configDatas_and addObject:last];
        }
        
        NSString *rlt_navbar = [self parserConfigWithKey:IS_NATIVE_NAVBAR searchData:configDatas_and];
        NSString *rlt_nav_backBtn = [self parserConfigWithKey:IS_NATIVE_BACKBTN searchData:configDatas_and];
        NSString *rlt_nav_showTitle = [self parserConfigWithKey:IS_NATIVE_SHOWTITLE searchData:configDatas_and];
        NSString *rlt_nav_showSharedBtn = [self parserConfigWithKey:IS_NATIVE_SHOWSHAREDBTN searchData:configDatas_and];
        NSString *rlt_nav_ShowTelBtn = [self parserConfigWithKey:IS_NATIVE_SHOWTELBTN searchData:configDatas_and];
        NSString *rlt_nav_ShowConsult = [self parserConfigWithKey:IS_NATIVE_SHOWCONSULT searchData:configDatas_and];
        NSString *rlt_canRefresh_whenBack = [self parserConfigWithKey:IS_NATIVE_CANREFRESH_WHENBACK searchData:configDatas_and];
        
        [rltDic setObject:rlt_navbar forKey:IS_NATIVE_NAVBAR];
        [rltDic setObject:rlt_nav_backBtn forKey:IS_NATIVE_BACKBTN];
        [rltDic setObject:rlt_nav_showTitle forKey:IS_NATIVE_SHOWTITLE];
        [rltDic setObject:rlt_nav_showSharedBtn forKey:IS_NATIVE_SHOWSHAREDBTN];
        [rltDic setObject:rlt_nav_ShowTelBtn forKey:IS_NATIVE_SHOWTELBTN];
        [rltDic setObject:rlt_nav_ShowConsult forKey:IS_NATIVE_SHOWCONSULT];
        [rltDic setObject:rlt_canRefresh_whenBack forKey:IS_NATIVE_CANREFRESH_WHENBACK];
        
    }
    
    return rltDic;
    
}


#pragma mark 手动添加配置参数

- (NSURL *)configDefaultNativeNavWithURLString:(NSString *)string{
    return [self compoundNeededParametersWithURLString:string
                                                  cnav:@"1"
                                                  ctle:@"1"
                                            csharedBtn:@"1"
                                                  ctel:@"0"
                                             cfconsult:@"0"];
}

- (NSURL *)configNativeNavWithURLString:(NSString *)string
                                   ctle:(NSString *)ctle
                             csharedBtn:(NSString *)cs
                                   ctel:(NSString *)ct
                              cfconsult:(NSString *)cf{
    return [self compoundNeededParametersWithURLString:string
                                                  cnav:@"1"
                                                  ctle:ctle
                                            csharedBtn:cs
                                                  ctel:ct
                                             cfconsult:cf];
}

- (NSURL *)configWebNavWithURLString:(NSString *)string
                           cfconsult:(NSString *)cf{
    return [self compoundNeededParametersWithURLString:string
                                                  cnav:@"0"
                                                  ctle:@"0"
                                            csharedBtn:@"0"
                                                  ctel:@"0"
                                             cfconsult:cf];
}

#pragma mark ------ 直接加载 web
- (void)directLoadWebWithURLString:(NSString *)URLString nav:(UINavigationController *)dnav{
    SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
    vc.isDirectAllow = TRUE;
    vc.URL = [self configNativeNavWithURLString:URLString ctle:@"1" csharedBtn:@"0" ctel:@"0" cfconsult:@"0"];
    [dnav pushViewController:vc animated:TRUE];
}

#pragma mark  ------------------------------------ private method

#pragma mark  剔除 native

- (NSString *)deleteNativeFromURLString:(NSString *)URLString{
    if ([URLString rangeOfString:@"com/native/"].location != NSNotFound) {
        URLString = [URLString stringByReplacingOccurrencesOfString:@"native/" withString:@""];
    }
    return URLString;
}

#pragma mark  添加 native

- (NSString *)addNativeToURLString:(NSString *)URLString{
    if ([URLString rangeOfString:@"com/native/"].location == NSNotFound) {
        URLString = [URLString stringByReplacingOccurrencesOfString:@"hinabian.com" withString:@"hinabian.com/native"];
    }
    return URLString;
}

#pragma mark 设置 url 默认参数
- (NSDictionary *)defaultInfoDic{
    return @{IS_NATIVE_NAVBAR:INFO_DIC_DEFAULT_VALUE,
             IS_NATIVE_BACKBTN:INFO_DIC_DEFAULT_VALUE,
             IS_NATIVE_SHOWTITLE:INFO_DIC_DEFAULT_VALUE,
             IS_NATIVE_SHOWSHAREDBTN:INFO_DIC_DEFAULT_VALUE,
             IS_NATIVE_SHOWTELBTN:INFO_DIC_DEFAULT_VALUE,
             IS_NATIVE_SHOWCONSULT:INFO_DIC_DEFAULT_VALUE,
             IS_NATIVE_CANREFRESH_WHENBACK:INFO_DIC_DEFAULT_VALUE,
                 };
}


#pragma mark 解析 url 参数
- (NSString *)parserConfigWithKey:(NSString *)key searchData:(NSArray *)data{
    NSString *rlt = INFO_DIC_DEFAULT_VALUE;
    for (NSInteger cou = 0; cou < data.count; cou ++) {
        // 剔出空格
        NSString *curString = [data[cou] stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *checkKey = [NSString stringWithFormat:@"%@=",key];
        if ([curString rangeOfString:checkKey].location != NSNotFound) {
            NSArray *configDatas_equal = [curString componentsSeparatedByString:@"="];
            if (configDatas_equal != nil && configDatas_equal.count > 0) {
                
                NSString *configString = [configDatas_equal lastObject];
                if (configString != nil && configString.length > 0) {
                    rlt = configString;
                }
                
            }
        }
    }
    return rlt;
}

#pragma mark ------ URL 参数解析
- (BOOL)isJumpNativeUIAccordingString:(NSString *)URLString{
    BOOL rlt = FALSE;
    NSDictionary *paraDic = [HNBUtils dictionaryWithURLStringParameterAnalysis:URLString];
    NSString *rltString = paraDic != nil ? [paraDic returnValueWithKey:IS_JUMP_NATIVE] : @"";
    if ([rltString isEqualToString:@"1"]) {
        rlt = TRUE;
    }
    return rlt;
}

- (NSString *)parameterAnalysisWithString:(NSString *)URLString key:(NSString *)key{
    
    /*parameterString = [parameterString lowercaseString];
    parameterString = [parameterString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *qArr = [parameterString componentsSeparatedByString: @"?"];
    if (qArr != nil && qArr.count > 0) {
        NSString *tmpPara = [qArr lastObject];
        NSArray * parameterArray = [tmpPara componentsSeparatedByString:@"&"];
        if (parameterArray != nil && parameterArray.count > 0) {
            
            for(NSString *tmpString in parameterArray)
            {
                NSArray *tmpArray = [tmpString componentsSeparatedByString:@"="];
                if (tmpArray.count >= 2 && [[tmpArray firstObject] isEqualToString:key]) {
                    rltString = [NSString stringWithFormat:@"%@",[tmpArray lastObject]];
                }
            }
            
        }
    } */
    NSDictionary *paraDic = [HNBUtils dictionaryWithURLStringParameterAnalysis:URLString];
    NSString *rltString = paraDic != nil ? [paraDic returnValueWithKey:key] : @"default";
    return rltString;
}


- (BOOL)isInsideThePageWithURLString:(NSString *)URLString{
    //_is_inside_the_page - 默认值 0
    /*BOOL rlt = FALSE;
    NSString *tmpString = [URLString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *strs = [tmpString componentsSeparatedByString:@"_is_inside_the_page="];
    if (strs != nil && strs.count > 0) {
        NSString *lastString = [strs lastObject];
        if (lastString != nil && [lastString isEqualToString:@"1"]) {
            rlt = TRUE;
        }
    }*/
    BOOL rlt = FALSE;
    NSDictionary *paraDic = [HNBUtils dictionaryWithURLStringParameterAnalysis:URLString];
    NSString *rltString = paraDic != nil ? [paraDic returnValueWithKey:@"_is_inside_the_page"] : @"";
    if ([rltString isEqualToString:@"1"]) {
        rlt = TRUE;
    }
    return rlt;
}

-(BOOL)isOverseasHouseConsultWithURLString:(NSString *)URLString{
    //_jump_overseas_house_consult - 默认值 0
    /*BOOL rlt = FALSE;
    NSString *tmpString = [URLString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *strs = [tmpString componentsSeparatedByString:@"_jump_overseas_house_consult="];
    if (strs != nil && strs.count > 0) {
        NSString *lastString = [strs lastObject];
        if (lastString != nil && [lastString isEqualToString:@"1"]) {
            rlt = TRUE;
        }
    }*/
    BOOL rlt = FALSE;
    NSDictionary *paraDic = [HNBUtils dictionaryWithURLStringParameterAnalysis:URLString];
    NSString *rltString = paraDic != nil ? [paraDic returnValueWithKey:@"_jump_overseas_house_consult"] : @"";
    if ([rltString isEqualToString:@"1"]) {
        rlt = TRUE;
    }
    return rlt;
}

- (BOOL)isInterceptWithURLString:(NSString *)URLString{
    // _is_intercept 默认值: 1
    /*BOOL rlt = TRUE;
    NSString *tmpString = [URLString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *strs = [tmpString componentsSeparatedByString:@"_is_intercept="];
    if (strs != nil && strs.count > 0) {
        NSString *lastString = [strs lastObject];
        if (lastString != nil && [lastString isEqualToString:@"0"]) {
            rlt = FALSE;
        }
    }*/
    BOOL rlt = TRUE;
    NSDictionary *paraDic = [HNBUtils dictionaryWithURLStringParameterAnalysis:URLString];
    NSString *rltString = paraDic != nil ? [paraDic returnValueWithKey:@"_jump_overseas_house_consult"] : @"";
    if ([rltString isEqualToString:@"0"]) {
        rlt = FALSE;
    }
    return rlt;
}


#pragma mark native 跳转 web , url 参数手动配置

- (NSURL *)compoundNeededParametersWithURLString:(NSString *)string cnav:(NSString *)cnav ctle:(NSString *)ctle csharedBtn:(NSString *)cs ctel:(NSString *)ct cfconsult:(NSString *)cf{
    /* @"_is_show_native_top_menu=1&_is_show_native_top_menu_return=1&_is_show_native_top_menu_title=1&_is_show_native_top_menu_share=1&_is_show_native_top_menu_tel=0&_is_show_native_float_consult=0&_is_return_refresh=1&_is_jump_native=0&_jump_native_obj=jumpProject&_jump_native_obj_value="
     */
    NSLog(@" webTest 处理前 urlstring :%@",string);
    // 1.
    if ([string hasSuffix:@"html"]) {
        [string stringByReplacingOccurrencesOfString:@".html" withString:@""];
    }
    
    // 2.
    NSString *rlt = @"";
    NSString *tmp = [NSString stringWithFormat:@"_is_show_native_top_menu=%@&_is_show_native_top_menu_title=%@&_is_show_native_top_menu_share=%@&_is_show_native_top_menu_tel=%@&_is_show_native_float_consult=%@",cnav,ctle,cs,ct,cf];
    
    // 3.
    if ([string rangeOfString:@"?"].location != NSNotFound) {
        rlt = [NSString stringWithFormat:@"%@&%@",string,tmp];
    }else{
        rlt = [NSString stringWithFormat:@"%@?%@",string,tmp];
    }
    NSLog(@" webTest 解析后 rlt :%@",rlt);
    return [NSURL URLWithString:rlt];
    
}

#pragma mark isSameIMProjectID
- (BOOL)isSameIMProjectID:(NSString *)impreojecturl{
    
    NSString *tmpString = [self tidyURLString:impreojecturl];
    NSString *tmpSelfString = [self tidyURLString:[selfURL absoluteString]];
    
    tmpString = [self deleteNativeFromURLString:impreojecturl];
    tmpSelfString = [self deleteNativeFromURLString:[selfURL absoluteString]];

    if ([tmpString rangeOfString:@"m.hinabian.com/project/detail"].location != NSNotFound &&
        [tmpSelfString rangeOfString:@"m.hinabian.com/project/detail"].location != NSNotFound) {
        NSString *tmpID = [[tmpString componentsSeparatedByString:@"project_id="] lastObject];
        NSString *seID = [[tmpSelfString componentsSeparatedByString:@"project_id="] lastObject];
        if ([tmpID isEqualToString:seID]) {
            return TRUE;
        }
    }
    if ([tmpString rangeOfString:@"m.hinabian.com/visa/detail"].location != NSNotFound &&
        [tmpSelfString rangeOfString:@"m.hinabian.com/visa/detail"].location != NSNotFound) {
        NSString *tmpID = [[tmpString componentsSeparatedByString:@"project_id="] lastObject];
        NSString *seID = [[tmpSelfString componentsSeparatedByString:@"project_id="] lastObject];
        if ([tmpID isEqualToString:seID]) {
            return TRUE;
        }
    }
    return FALSE;
}

#pragma mark isSameTribeId

- (BOOL) isSameTribeId:(NSString *)tribeUrl{
    
    // https://m.hinabian.com/theme/detail/6789476731788417832.html
    NSString *tmpString = [self tidyURLString:tribeUrl];
    NSString *tmpSelfString = [self tidyURLString:selfURL.absoluteString];
    
    if ([tmpString rangeOfString:@"m.hinabian.com/theme/detail/"].location != NSNotFound &&
        [tmpSelfString rangeOfString:@"m.hinabian.com/theme/detail/"].location != NSNotFound) {
        NSString *tmpID = [[tmpString componentsSeparatedByString:@"/"] lastObject];
        NSString *seID = [[tmpSelfString componentsSeparatedByString:@"/"] lastObject];
        if ([tmpID isEqualToString:seID]) {
            return TRUE;
        }
    }
    return FALSE;
}

#pragma mark 判断是否是同一个URL
- (BOOL)isSameURL:(NSString *)httpString{
    
    // 1. 整理规范样式
    NSString *mSelfUrlString = [self tidyURLString:selfURL.absoluteString];
    NSString *mHttpUrlString = [self tidyURLString:httpString];
    
    // 2. 新旧页面兼容
    mSelfUrlString = [self deleteNativeFromURLString:mSelfUrlString];
    mHttpUrlString = [self deleteNativeFromURLString:mHttpUrlString];

    if ([mSelfUrlString isEqualToString:mHttpUrlString]) {
        return YES;
    }else{
        return NO;
    }
}

- (NSString *)tidyURLString:(NSString *)URLString{
    
    /**
     1. 由于处理过 HTTP 转 HTTPS ,所以这里判断时可忽略协议头的差异
     2. native/project/detail?project_id=12021074 有些浏览器会默认添加一些 "/" 变成 native/project/detail/?project_id=12021074
     */
    // 1. 转https 及 m. 格式
    NSString *rltString = [self returnMHTTPSTransformHTTPString:URLString];
    
    // 2. 去除 .html
    rltString = [rltString stringByReplacingOccurrencesOfString:@".html" withString:@""];
    
    // 3. 替换 "／？" -> "?"
    rltString = [rltString stringByReplacingOccurrencesOfString:@"/?" withString:@"?"];
    
    return rltString;
}

#pragma mark 将URL字符创转换为站内的HTTPS：https://m.

- (NSString *)returnMHTTPSTransformHTTPString:(NSString *)httpstring{
    
    NSString *returnString = [httpstring stringByReplacingOccurrencesOfString:@"www" withString:@"m"];
    if (![httpstring hasPrefix:@"https"]) {
        returnString = [httpstring stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
    }
    return returnString;
}

#pragma mark push - > vc

- (BOOL)pushVCWith:(NSString *)URLString{
    SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
    vc.URL = [[NSURL alloc] withOutNilString:URLString];
    [navPara pushViewController:vc animated:FALSE];
    return TRUE;
}

#pragma mark ----------------------- 模块处理

#pragma mark 解析跳转

// 路由 - 依据 URL
//- (void)routerPathAccordingURLString:(NSString *)URLString{
//    BOOL isJumpNative = [self isJumpNativeUIAccordingString:URLString];
//    NSString *methodString = [NSString stringWithFormat:@"%@:",[self parameterAnalysisWithString:URLString
//                                                                                             key:JUMP_NATIVEMETHOD_OBJ]];
//    SEL selector = NSSelectorFromString(methodString);
//    if (isJumpNative && [self respondsToSelector:selector]) {
//        [self performSelector:selector withObject:URLString];
//    }else{
//        [self pushVCWith:URLString];
//    }
//    
//}

// 路由 - 拦截 Web-URL
- (BOOL)handleURLString:(NSString *)httpsurl jumpIntoAPP:(BOOL)isJump{
    BOOL rlt = FALSE;
    NSString *sourceHttpURLString = [NSString stringWithFormat:@"%@",httpsurl];
    httpsurl = [self deleteNativeFromURLString:httpsurl];
    
    // linkme - 相关业务处理 ： 如果是从H5或者从微信跳转进来，对URL进行解析替换
    if ([httpsurl rangeOfString:@"stat.hinabian.com"].location != NSNotFound && isJump) {//==========>stat域名
        httpsurl = [httpsurl stringByReplacingOccurrencesOfString:@"stat.hinabian.com/?p=" withString:@""];
    }

    NSString *methodString = [NSString stringWithFormat:@"%@:",[self parameterAnalysisWithString:sourceHttpURLString
                                                                                             key:JUMP_NATIVEMETHOD_OBJ]];
    SEL selector = NSSelectorFromString(methodString);
    if ([self respondsToSelector:selector]) {
        NSLog(@" =================================> 分流:特殊处理");
        rlt = [self performSelector:selector withObject:sourceHttpURLString];
    }else{
        NSLog(@" =================================> 分流:公共处理 ");
        rlt = [self pushVCWith:sourceHttpURLString];
    }
    return rlt;
    
}

#pragma mark ----------------------- V3.0.1 重构

#pragma mark 圈子详情板块
- (BOOL)tribe:(NSString *)httpsurl{
    BOOL handleRlt = FALSE;
    /* 解析Tribeid
     https://m.hinabian.com/tribe/detail/6193234633117899024.html
     https://m.hinabian.com/tribe/detail/6193234633117899024
     */
    NSString * idString = [httpsurl substringToIndex:[httpsurl rangeOfString:@".html"].location];
    NSUInteger startIndex = 0;
    startIndex = [idString rangeOfString:@"detail/"].location + @"detail/".length;
    idString = [idString substringFromIndex:startIndex];
    
    TribeShowNewController * vc = [[TribeShowNewController alloc] init];
    vc.tribeId = idString;
    [navPara pushViewController:vc animated:FALSE];
    handleRlt = TRUE;
    return handleRlt;
}

#pragma mark 帖子板块
//帖子详情
- (BOOL)theme:(NSString *)httpsurl{
    TribeDetailInfoViewController *vc = [[TribeDetailInfoViewController alloc] init];
    vc.URL = [[NSURL alloc] withOutNilString:httpsurl];
    [navPara pushViewController:vc animated:FALSE];
    return TRUE;
}

// 发帖
- (BOOL)post_theme:(NSString *)httpsurl{
    if ([HNBUtils isLogin]) {
        
        NSArray *tmpArr = [httpsurl componentsSeparatedByString:@"?title"];
        NSString *cspString = [NSString stringWithFormat:@"title%@",[tmpArr lastObject]];
        NSArray *strsArr = [cspString componentsSeparatedByString:@"&"];
        NSString *title = @"";
        NSString *tribeId = @"";
        NSString *tribeName = @"";
        NSString *topicId = @"";
        for (NSString *str in strsArr) {
            if ([str hasPrefix:@"title="]) {
                title = [[str componentsSeparatedByString:@"="] lastObject];
            }
            if ([str hasPrefix:@"tribeId="]) {
                tribeId = [[str componentsSeparatedByString:@"="] lastObject];
            }
            if ([str hasPrefix:@"tribeName="]) {
                tribeName = [[str componentsSeparatedByString:@"="] lastObject];
            }
            if ([str hasPrefix:@"topicId="]) {
                topicId = [[str componentsSeparatedByString:@"="] lastObject];
            }
            
        }
        // 中文转码
        NSString *tmpTitle =(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)title, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
        NSString *tmptribeName =(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)tribeName, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
        
        HNBRichTextPostingVC *vc = [[HNBRichTextPostingVC alloc] init];
        if (title.length > 0
            && tribeId.length > 0
            && tribeName.length > 0
            && topicId.length > 0) { // V3.0 话题参与
            
            vc.entryOrigin = PostingEntryOriginJoinTopicDiscuss;
            [vc setHTML:@"" title:tmpTitle];
            vc.choseTribeCode = tribeId;
            vc.chosedTribeName = tmptribeName;
            vc.topicID = topicId;
            
        }else{
            vc.choseTribeCode = @"";
        }
        [navPara pushViewController:vc animated:FALSE];
        
    }else{
        LoginViewController *vc = [[LoginViewController alloc] init];
        [navPara pushViewController:vc animated:FALSE];
    }
    return TRUE;
}

// 回复详情
- (BOOL)commentDetail:(NSString *)httpsurl{
    NSURL * URL = [[NSURL alloc] withOutNilString:httpsurl];
    SWKSingleReplyViewController *vc = [[SWKSingleReplyViewController alloc] init];
    vc.URL = URL;
    [navPara pushViewController:vc animated:FALSE];
    return TRUE;
}

#warning 帖子详情举报
// 帖子详情举报
- (BOOL)theme_report:(NSString *)httpsurl{
    /**<该模块存在于帖子详情专有控制器 ：TribeDetailInfoViewController >*/
    return FALSE;
}
 
#pragma mark 签证板块
// 签证详情
- (BOOL)visa:(NSString *)httpsurl{
    SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
    vc.URL = [NSURL URLWithString:httpsurl];
    [navPara pushViewController:vc animated:FALSE];
    return TRUE;
}

// 立即办理
- (BOOL)visa_rightNow_manage:(NSString *)httpsurl{
    
    if (![HNBUtils isLogin]) {
        
        LoginViewController *vc = [[LoginViewController alloc] init];
        [navPara pushViewController:vc animated:FALSE];
        
        SWKVisaShowViewController *materialVC = [[SWKVisaShowViewController alloc] init];
        materialVC.URL = [NSURL URLWithString:httpsurl];
        NSArray *tmpvcs = [navPara viewControllers];
        navPara.viewControllers = [HNBUtils operateNavigationVCS:tmpvcs index:tmpvcs.count -1 vc:materialVC];
        
    }else{
        SWKVisaShowViewController * vc = [[SWKVisaShowViewController alloc] init];
        vc.URL = [NSURL URLWithString:httpsurl];
        [navPara pushViewController:vc animated:FALSE];
    }
    return TRUE;
    
}


#pragma mark 移民项目板块

#warning 项目页
// 预约页、项目详情页 、项目列表、预约页、项目材料清单、条件测试
- (BOOL)project:(NSString *)httpsurl{
    SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
    vc.URL = [[NSURL alloc] withOutNilString:httpsurl];
    [navPara pushViewController:vc animated:FALSE];
    return TRUE;
}

- (BOOL)nationproject:(NSString *)httpsurl{
    FunctionIMProjHomeController *vc = [[FunctionIMProjHomeController alloc] init];
    [navPara pushViewController:vc animated:FALSE];
    return TRUE;
}


#pragma mark 评估板块
- (BOOL)assess:(NSString *)httpsurl{
    
    if([[HNBUtils sandBoxGetInfo:[NSString class] forKey:im_assess_type] isEqualToString:@"1"])    //原生
    {
        IMAssessVC * vc = [[IMAssessVC alloc] init];           // 原生化
        [navPara pushViewController:vc animated:FALSE];
    }
    else
    {
        IMAssessViewController * vc = [[IMAssessViewController alloc] init]; // skiplow － web页
        vc.URL = [NSURL URLWithString:httpsurl];
        [navPara pushViewController:vc animated:FALSE];
    }
    return TRUE;
    
}


#pragma mark (他人)个人中心
- (BOOL)personal_userinfo:(NSString *)httpsurl{
    BOOL handleRlt = FALSE;
    
    /* 示例 todo 解析userid https://m.hinabian.com/personal_userinfo/user/2007949.html
    https://m.hinabian.com/personal_userinfo/user/2000241.html?_is_jump_native=1&_jump_native_obj=personal_userinfo&_jump_native_obj_value=2000241
     */
    if ([httpsurl rangeOfString:@"personal_userinfo/user/"].location == NSNotFound){
        handleRlt=  FALSE;
    }else{
        
        // 解析参数
        NSString *idString = [self parameterAnalysisWithString:httpsurl key:JUMP_NATIVEMETHOD_OBJ_VALUE];
        
        // 登陆用户信息
        NSArray * tmpPersonalInfoArry = [PersonalInfo MR_findAll];
        PersonalInfo * UserInfo = nil;
        if (tmpPersonalInfoArry.count != 0) {
            UserInfo = tmpPersonalInfoArry[0];
        }
        
        if (![UserInfo.id isEqualToString:idString] || UserInfo == NULL) {
            UserInfoController2 *vc = [[UserInfoController2 alloc] init];
            vc.personid = idString;
            [navPara pushViewController:vc animated:FALSE];
            NSDictionary *dic = @{@"idForUser":vc.personid};
            [MobClick event:@"clickIcon" attributes:dic];
            handleRlt = TRUE;
        }
    }
    return handleRlt;
}

#pragma mark 优惠券
- (BOOL)coupon:(NSString *)httpsurl{
    BOOL handleRlt = FALSE;
    
    if (![HNBUtils isLogin]){
        
        LoginViewController *vc = [[LoginViewController alloc] init];
        [navPara pushViewController:vc animated:YES];
        handleRlt=  TRUE;
        
    }else if ([httpsurl rangeOfString:@"list"].location != NSNotFound){
        CouponViewController* vc = [[CouponViewController alloc] init];
        [navPara pushViewController:vc animated:YES];
        handleRlt=  TRUE;
    }else{
        handleRlt=  FALSE;
    }
    return handleRlt;
    
}

#pragma mark 移民攻略
- (BOOL)immigration_plan:(NSString *)httpsurl{
    BOOL handleRlt = FALSE;
    handleRlt = [self pushVCWith:httpsurl];
    return handleRlt;
}

#pragma mark 登陆
- (BOOL)user_login:(NSString *)httpsurl{
    LoginViewController *vc = [[LoginViewController alloc] init];
    [navPara pushViewController:vc animated:FALSE];
    return TRUE;
}

#pragma mark 返回
- (BOOL)goback:(NSString *)httpsurl{
    [navPara popViewControllerAnimated:FALSE];
    return TRUE;
}

#pragma mark 打电话
- (BOOL)call_phone:(NSString *)httpsurl{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",DEFAULT_TELNUM];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    return TRUE;
}

#pragma mark 私信页面
- (BOOL)personal_chat:(NSString *)httpsurl{
    return [self pushVCWith:httpsurl];
}

#warning app 端使用 web 播放
#pragma mark 播放视频
- (BOOL)video:(NSString *)httpsurl{
    BOOL handleRlt = FALSE;
    return handleRlt;
}

#pragma mark 活动
- (BOOL)hnbactivity:(NSString *)httpsurl{
    return [self pushVCWith:httpsurl];
}

#pragma mark V3.2 版本新增  海外公司注册、海外银行开户

- (BOOL)overseacompanyrgt:(NSString *)httpsurl{
    CardTableVC *vc = [[CardTableVC alloc] init];
    vc.linkString = httpsurl;
    [navPara pushViewController:vc animated:TRUE];    
    return TRUE;
}

- (BOOL)overseabanknewact:(NSString *)httpsurl{
    CardTableVC *vc = [[CardTableVC alloc] init];
    vc.linkString = httpsurl;
    [navPara pushViewController:vc animated:TRUE];
    return TRUE;
}

#pragma mark ----------------------- 旧版测试可使用

#pragma mark ------ 走进 xx wikiHandle:
- (BOOL)wikiHandle:(NSString *)httpsurl{
    NSString *tmpURLString = [NSString stringWithFormat:@"%@",httpsurl];
    NSString *lowerString = [tmpURLString lowercaseString];
    if ([lowerString rangeOfString:@"wiki/country"].location != NSNotFound
        && [lowerString rangeOfString:@"?countryid="].location != NSNotFound
        && [lowerString rangeOfString:@"&countryname="].location != NSNotFound) {
        // 走进 xx
        SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
        vc.URL = [[NSURL alloc] withOutNilString:httpsurl];
        [navPara pushViewController:vc animated:YES];
        return TRUE;
    }
    return FALSE;
}

#pragma mark ------ 投资项目
-(BOOL)topic_us_projectHandle:(NSString *)httpsurl{
    //投资项目
    SWKTransactViewController *vc = [[SWKTransactViewController alloc] init];
    vc.URL = [NSURL URLWithString:httpsurl];
    [navPara pushViewController:vc animated:YES];
    
    return FALSE;
}

#pragma mark ------  签约办理模块处理
-(BOOL)transactHandle:(NSString *)httpsurl
{
    if (![HNBUtils isLogin]) {
        
        LoginViewController *vc = [[LoginViewController alloc] init];
        [navPara pushViewController:vc animated:YES];
        
        SWKTransactViewController *materialVC = [[SWKTransactViewController alloc] init];
        materialVC.URL = [NSURL URLWithString:httpsurl];
        NSArray *tmpvcs = [navPara viewControllers];
        navPara.viewControllers = [HNBUtils operateNavigationVCS:tmpvcs index:tmpvcs.count -1 vc:materialVC];
        
        return TRUE;
    }
    SWKTransactViewController *vc = [[SWKTransactViewController alloc] init];
    vc.URL = [NSURL URLWithString:httpsurl];
    [navPara pushViewController:vc animated:YES];
    
    return TRUE;
}

#pragma mark ------  华人一天模块处理
-(BOOL)cndHandle:(NSString *)httpsurl
{
    if ([httpsurl rangeOfString:@"detail"].location != NSNotFound)
    {
        /* todo 参数问题  */
    }
    return FALSE;
}

#pragma mark ------ 国家锦囊模块处理
-(BOOL)nationalHandle:(NSString *)httpsurl
{
    if ([httpsurl rangeOfString:@"detail"].location != NSNotFound)
    {
        PublicViewController * vc = [[PublicViewController alloc] init];
        [vc setshoudApperaReload:FALSE];
        vc.URL = [[NSURL alloc] withOutNilString:httpsurl];
        [navPara pushViewController:vc animated:NO];
        return TRUE;
    }
    return FALSE;
}

#pragma mark ------ 专题活动模块处理

-(BOOL)raidersHandle:(NSString *)httpsurl
{
    /**
     https://m.hinabian.com/raiders/list/seminar.html
     */
    
    if ([httpsurl rangeOfString:@"class"].location != NSNotFound)
    {
        SpecialActivityViewController *vc = [[SpecialActivityViewController alloc]init];
        [vc setSegmentIndex:1];
        [navPara pushViewController:vc animated:YES];
        return TRUE;
    }
    else if ([httpsurl rangeOfString:@"interview"].location != NSNotFound)
    {
        SpecialActivityViewController *vc = [[SpecialActivityViewController alloc]init];
        [vc setSegmentIndex:2];
        [navPara pushViewController:vc animated:YES];
        return TRUE;
    }
    else if ([httpsurl rangeOfString:@"campaign"].location != NSNotFound)
    {
        SpecialActivityViewController *vc = [[SpecialActivityViewController alloc]init];
        [vc setSegmentIndex:3];
        [navPara pushViewController:vc animated:YES];
        return TRUE;
        
    }else{
        
        SpecialActivityViewController *vc = [[SpecialActivityViewController alloc]init];
        [vc setSegmentIndex:0];
        [navPara pushViewController:vc animated:YES];
        return TRUE;
        
    }
    
    return FALSE;
}

@end
