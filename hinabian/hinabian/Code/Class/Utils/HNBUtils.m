//
//  HNBUtils.m
//  hinabian
//
//  Created by 余坚 on 15/6/30.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "HNBUtils.h"
#import <Reachability/Reachability.h>
#import "HYFileManager.h"
#import <AFNetworking/AFNetworking.h>
//#import "NSDictionary+ValueForKey.h"
// KeyChain存储 - Rain
#import  <Security/Security.h>
#import "KeychainItemWrapper.h"
#import <NIMSDK/NIMSDK.h>
#import "DataFetcher.h"
#import "AppDelegate.h"

@interface HNBUtils ()


@end


@implementation HNBUtils
+ (NSString *)sizeFormattedOfCache
{
    return [HYFileManager sizeFormattedOfDirectoryAtPath:[HYFileManager cachesDir]];
}
// 清空Caches文件夹
+ (BOOL)clearCachesDirectory
{
    return [HYFileManager clearCachesDirectory];
}
+ (void)removeFile:(NSString *)filename
{
    NSString *thepath = [NSString stringWithFormat:@"%@/%@", [HYFileManager cachesDir],filename];
    [HYFileManager removeItemAtPath:thepath];
}
+ (void)writeToFile:(NSString *)data filename:(NSString *)name
{
    
    NSString *thepath = [NSString stringWithFormat:@"%@/%@", [HYFileManager cachesDir],name];
    
    BOOL isSuccess = FALSE;
    if ([[NSFileManager defaultManager] fileExistsAtPath:thepath]) {
        isSuccess = [HYFileManager writeFileAtPath:thepath content:data];
    }
    else
    {
        [HYFileManager createFileAtPath:thepath];
        isSuccess = [HYFileManager writeFileAtPath:thepath content:data];
    }
    
    
    if(!isSuccess)
    {
        NSLog(@"Failed to write File");
    }else{
        NSLog(@"write to File");
    }
}

/* XXX:XXXX:XXX 这种格式的JS解析参数 */
+(NSArray *) getAllParameterForJS:(NSString *)inputParameter
{
    NSArray * tmpArray = Nil;
    NSString *parameter = inputParameter;
    tmpArray = [parameter componentsSeparatedByString: @":"];
    
    return tmpArray;

}

+(void) canclAllRequestInAFNQueue
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.operationQueue cancelAllOperations];
}

/* 数字转换暂时支持到千万 */
+ (NSString *) numConvert:(NSString *) num
{
    NSString * tmpString;
    float num_float = [num floatValue];
    if(num_float > 9999999)
    {
        float a = num_float / 10000000.0;
        tmpString = [NSString stringWithFormat:@"%0.1fkw",a];
    }
    else if (num_float > 99999) //十万以上做处理
    {
        float a = num_float / 10000.0;
        tmpString = [NSString stringWithFormat:@"%0.0fw",a];
    }
    else if (num_float > 9999)    //五位数转换
    {
        float a = num_float / 10000.0;
        if (([num integerValue] % 10000) < 1000)  //能被整除
        {
            tmpString = [NSString stringWithFormat:@"%0.0fw",a];
        }
        else
        {
            tmpString = [NSString stringWithFormat:@"%0.1fw",a];
        }
        
    }
    else
    {
        tmpString = num;
    }
    
    return tmpString;
}

/* 跳去评价 */
+ (void) gotoAppStorePageRaisal
{
    NSURL *appUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id998252357?mt=8"]];
    //    [[UIApplication sharedApplication] openURL:appUrl];
    /*
     ios11新版的App Store 用上面的链接跳有问题
     ios10以下用下面方法也找不到方法
     因此要自行写一个兼容方法
     */
    //    [[UIApplication sharedApplication] openURL:appUrl];
    //    [[UIApplication sharedApplication] openURL:appUrl options:nil completionHandler:^(BOOL success) {
    //
    //    }];
    [HNBUtils openScheme:appUrl options:@{} complete:^(BOOL success) {
        NSLog(@"%d",success);
    }];
}

/* 判断网络是否连接 */
+(BOOL) isConnectionAvailable
{
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            break;
    }
    return isExistenceNetwork;
}

/*===ios10 后废弃openURL方法===*/
//+(void) gotoAppStore
//{
//    NSString  * nsStringToOpen = [NSString  stringWithFormat: @"http://itunes.apple.com/cn/app/hai-na-bian-hu-lian-wang-yi/id998252357?mt=8"];
//    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:nsStringToOpen]];
//}
//
//+(void) gotoAppStoreWithUrl:(NSString *)url
//{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
//}

+(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}


+(NSMutableDictionary *) addGeneralKey:(NSMutableDictionary *) inputDictionary
{
    NSMutableDictionary * tmpDictionary = inputDictionary;
    
    
    NSString * appdate = [self getCruntTime];
    // 如果未从服务器拉取到时间则选择本地时间
    if(Nil == appdate)
    {
        NSDate * today = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate:today];
        NSDate *localeDate = [today dateByAddingTimeInterval:interval];
        // 时间转换成时间戳
        appdate = [NSString stringWithFormat:@"%ld",(long)[localeDate timeIntervalSince1970]];
    }
    [tmpDictionary setObject:appdate forKey:@"appkey"];
    
    NSString * encryptdate = [self md5TwoHexDigest:appdate];
    [tmpDictionary setObject:encryptdate forKey:@"encryptappkey"];

    return tmpDictionary;
}

+(NSMutableDictionary *) addPlatformKey:(NSMutableDictionary *) inputDictionary
{
    NSMutableDictionary * tmpDictionary = inputDictionary;
    
    [tmpDictionary setObject:@PORT_VERSION forKey:@"port_version"];

    [tmpDictionary setObject:@"ios"forKey:@"platform"];
    
    return tmpDictionary;
}

+(NSString *) md5HexDigest:(NSString*)str
{
    if (str == Nil) {
        return @"";
    }
    const char *original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

+(NSString *) md5TwoHexDigest:(NSString*)str
{
     NSString * firstMD5 = [self md5HexDigest:[NSString stringWithFormat:@"%@%s",str,YOU_DONT_KONW_ONE]];
     NSString * secondMD5 = [self md5HexDigest:[NSString stringWithFormat:@"%@%s",firstMD5,ALL_KNOW_TWO]];
     
    return secondMD5;
    
}

+(BOOL) isLogin
{
    NSString * isLogin = [[NSUserDefaults standardUserDefaults] stringForKey:personal_is_login];
    if (isLogin == nil) {
        isLogin = @"0";
    }
    if ([isLogin isEqualToString:@"0"]) {
        return FALSE;
    }
    return TRUE;
}

/* sha加密 */
+ (NSString *) sha1:(NSString *)inputStr {
    
    const char *cstr = [inputStr cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:inputStr.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *outputStr = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [outputStr appendFormat:@"%02x", digest[i]];
    }
    return outputStr;
    
}

+(NSString *) getCruntTime
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    // 1.创建一个网络路径
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.hinabian.com/tools/cgiKey"]];
    
    // 2.创建一个网络请求，分别设置请求方法、请求参数
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    [request setTimeoutInterval:10];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    __block NSString *str = @"";
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != 0 || error != nil) {
            
            /* 取本地时间 */
//            NSDate * today = [NSDate date];
//            NSTimeZone *zone = [NSTimeZone systemTimeZone];
//            NSInteger interval = [zone secondsFromGMTForDate:today];
//            NSDate *localeDate = [today dateByAddingTimeInterval:interval];
//            str = [NSString stringWithFormat:@"%ld",(long)[localeDate timeIntervalSince1970]];
            
            NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval timeInterval = [dat timeIntervalSince1970];
            str = [NSString stringWithFormat:@"%f",timeInterval];
            if ([str rangeOfString:@"."].location != NSNotFound) {
                NSArray *strArr = [str componentsSeparatedByString:@"."];
                if (strArr.count > 0) {
                    str = [NSString stringWithFormat:@"%@",strArr[0]];
                }
            }
            
//            NSLog(@" 88error %@   本地时间戳 :%@ ",error,str);
        }
        else
        {
            str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSLog(@" 网络获取时间戳 %@",str);
        }
        
        dispatch_semaphore_signal(semaphore);
        
    }];
    [sessionDataTask resume];
    dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);
    
//    NSURL *url = [NSURL URLWithString:@"https://www.hinabian.com/tools/cgiKey"];
//    //NSString *str = [[NSString alloc] initWithContentsOfURL:url usedEncoding:Nil error:Nil];
//    NSString *str = [[NSString alloc] initWithContentsOfURL:url
//                                                   encoding:NSUTF8StringEncoding
//                                                      error:nil];
//    
//    /*str = [str stringByReplacingOccurrencesOfString:@"T" withString:@" "];
//    str = [str stringByReplacingOccurrencesOfString:@"+01:00" withString:@""];
//    
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
//    NSDate *date = [dateFormat dateFromString:str];
//    NSTimeInterval time = [date timeIntervalSince1970];
//    
//    
//    long long dTime = [[NSNumber numberWithDouble:time] longLongValue]; // 将double转为long long型
//    NSString *curTime = [NSString stringWithFormat:@"%llu",dTime]; // 输出long long型
//
//    //NSString * dateTime = [dateFormat stringFromDate:[NSDate date]];*/
    
//    NSLog(@" return %@",str);
    
    return str;
}

+(BOOL)sandBoxSaveInfo:(id)info forKey:(NSString *)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:info forKey:key];
    BOOL isSaved = [userDefaults synchronize];
    return isSaved;
}

+(id)sandBoxGetInfo:(Class)cls forKey:(NSString *)key{
    NSString *ClsString = NSStringFromClass(cls);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    id rls = [[NSClassFromString(ClsString) alloc] init];
//    rls = [userDefaults valueForKey:key];
//    return rls;
    if ([ClsString isEqualToString:NSStringFromClass([NSString class])]) {
        NSString *str = [userDefaults stringForKey:key];
        return str;
    }else if ([ClsString isEqualToString:NSStringFromClass([NSArray class])]){
        NSArray *arr = [userDefaults arrayForKey:key];
        return arr;
    }else if ([ClsString isEqualToString:NSStringFromClass([NSDictionary class])]){
        NSDictionary *dic = [userDefaults dictionaryForKey:key];
        return dic;
    }else{
        id rls = [userDefaults valueForKey:key];
        return rls;
    }
}

+(void) sandBoxClearAllInfo:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)encodeCustomDataModel:(id)model toFile:(NSString *)fileName{

    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [docPath stringByAppendingPathComponent:fileName];
    [NSKeyedArchiver archiveRootObject:model toFile:filePath];
    
}

+(id)decodeCustomDataModelFromFilePath:(NSString *)fileName{

    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [docPath stringByAppendingPathComponent:fileName];
    id model = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return model;
    
}

+(BOOL)deleteFileAtTheFileName:(NSString *)fileName{

    NSFileManager *fileManeger = [NSFileManager defaultManager];
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [docPath stringByAppendingPathComponent:fileName];
    
    //NSLog(@" ====== %d",[fileManeger removeItemAtPath:filePath error:nil]);
    
    return [fileManeger removeItemAtPath:filePath error:nil];
    
}

/* 打电话 */
+(void) telThePhone:(NSString *)tel
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

/* 文本间距处 */
+ (NSMutableAttributedString *)setLabelLineSpacing:(CGFloat)spacing labelText:(NSString *)labelText{
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:spacing];
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    [text addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    return text;
    
}

+ (NSArray *)operateNavigationVCS:(NSArray *)vcs index:(NSInteger)index vc:(UIViewController *)vc{
    
    NSMutableArray *tmp = [NSMutableArray arrayWithArray:vcs];
    if (vc != nil) { // 插入
        
        [tmp insertObject:vc atIndex:index];
        
    } else { // 删除
        
        [tmp removeObjectAtIndex:index];
        
    }
    
    return tmp;
    
}

#pragma mark -- 弹框逻辑与IM聊天限制时间共用，若有一边时间更改，需要另行写方法
+ (NSString *)compareDateWithGivedDateString:(NSString *)givedDateString{

    if (givedDateString == nil) {
        return @"1";
    }
    
    // 获取当前时间
    NSDateFormatter *formtter = [[NSDateFormatter alloc] init];
    [formtter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentDate = [NSDate date];
    
    NSDate *tmpDate = [formtter dateFromString:givedDateString];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    //

    NSInteger day = kCFCalendarUnitDay;
    NSDateComponents *compsDay = [calendar components:day
    fromDate:tmpDate
    toDate:currentDate
    options:0];
    
    
    // 7 天 -- 修改 -- > 1 天
    if ([compsDay day] >= 1) {
    //NSLog(@"日期差值 ： 不小于1天");
        return @"1";
    }
    return @"0";

    
    // 5分钟 - 测试用
//    NSInteger minute = kCFCalendarUnitMinute;
//    NSDateComponents *compsMinite = [calendar components:minute
//                                                fromDate:tmpDate
//                                                  toDate:currentDate
//                                                 options:0];
// 
//     if ([compsMinite minute] >= 5) {
//         return @"1";
//     }
//     return @"0";
    
}


+ (void) resetPersonalityNotice
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[dat timeIntervalSince1970];
    NSString * tmpLastTime = [HNBUtils sandBoxGetInfo:[NSString class] forKey:home_personality_notice_cancletime];
    if (!tmpLastTime) {
        tmpLastTime = @"0";
    }
    NSTimeInterval lasttime = [tmpLastTime doubleValue];
    //86400为24小时转换为毫秒
    if ([HNBUtils isNationOrINtentionEmpty] && (time - lasttime > 86400) && [[HNBUtils sandBoxGetInfo:[NSString class] forKey:home_personality_notice_countformonth] integerValue] < 3) {
        
        [HNBUtils sandBoxSaveInfo:@"1" forKey:home_personality_notice];
    }
    else
    {
        [HNBUtils sandBoxSaveInfo:@"0" forKey:home_personality_notice];
    }

}

+ (BOOL) isNationOrINtentionEmpty
{
    NSString * tmpPersonalNation = [HNBUtils sandBoxGetInfo:[NSString class] forKey:IM_NATION_LOCAL];
    NSString * tmpPersonalIntention = [HNBUtils sandBoxGetInfo:[NSString class] forKey:IM_INTENTION_LOCAL];
    if (tmpPersonalNation == nil || tmpPersonalIntention == nil) {
        return TRUE;
    }
    else if([tmpPersonalNation isEqualToString:@""] || [tmpPersonalIntention isEqualToString:@""])
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
    return FALSE;
}

+ (BOOL) isBindingPhoneNumAlertShow
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[dat timeIntervalSince1970];
    NSString * tmpLastTime = [HNBUtils sandBoxGetInfo:[NSString class] forKey:BINDING_PHONENUM_CANCEL_TIME];
    if (!tmpLastTime) {
        tmpLastTime = @"0";
    }
    NSTimeInterval lasttime = [tmpLastTime doubleValue];
    
    if (time - lasttime > 86400) {
        return TRUE;
    }
    return FALSE;

//    return [HNBUtils isMoreThanLastedTime:[HNBUtils sandBoxGetInfo:[NSString class] forKey:BINDING_PHONENUM_CANCEL_TIME] RangeDays:nil RangeMours:nil RangeMinutes:@"1"];
}

+ (BOOL) isMoreThanLastedTime:(NSString *)lastedTime
                      RangeDays:(NSString *)day RangeMours:(NSString *)hour RangeMinutes:(NSString *)minute
{
    if (!day) {
        day = @"0";
    }
    if (!hour) {
        hour = @"0";
    }
    if (!minute) {
        minute = @"0";
    }
    if (!lastedTime) {
        lastedTime = @"0";
    }
    
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time = [dat timeIntervalSince1970];        //现在的时间
    NSTimeInterval tmplastedTime = [lastedTime doubleValue];//最后一次的时间
    NSTimeInterval rangeTime = [day doubleValue] *86400 + [hour doubleValue] *3600 + [minute doubleValue] *60;//需要大于的时间
    
    if (time - tmplastedTime > rangeTime) {
        return TRUE;
    }
    
    
    return FALSE;
}


+(NSArray *)sortedObjects:(NSArray *)data withKey:(NSString *)key{

    NSMutableArray *relt = [[NSMutableArray alloc] init];
    NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:key ascending:YES];
    NSArray *desArr = [NSArray arrayWithObjects:sd, nil];
    [relt addObjectsFromArray:[data sortedArrayUsingDescriptors:desArr]];
    return relt;
    
}

+ (NSString *)calculateTimeGapFromGivedDateString:(NSString *)givedDateString{
    
    // 获取当前时间
    NSDateFormatter *formtter = [[NSDateFormatter alloc] init];
    [formtter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentDate = [NSDate date];
    NSLog(@"calculate - currentDate ：%@",currentDate);
    
    NSDate *tmpDate = [formtter dateFromString:givedDateString];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    
    NSInteger sec = kCFCalendarUnitSecond;
    NSDateComponents *compsSec = [calendar components:sec
                                             fromDate:tmpDate
                                               toDate:currentDate
                                              options:0];

    NSString *gapTime = [NSString stringWithFormat:@"%ld",[compsSec second]];
    
    NSLog(@"计算时间差：%@",gapTime);
    
    return gapTime;

}

+ (NSString *)returnCurrentLocalDateString{

    NSDateFormatter *formtter = [[NSDateFormatter alloc] init];
    [formtter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentDate = [NSDate date];
    NSString *curentDateString = [formtter stringFromDate:currentDate];
    NSLog(@"return - currentDate ：%@",currentDate);
    return curentDateString;
}

+ (NSString *)returnTimestamp{

    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval timeInterval = [dat timeIntervalSince1970];
    NSString *tmpString = [NSString stringWithFormat:@"%.f",timeInterval];
    return tmpString;
    
}

+(NSInteger)returnTimestampBaseCount{
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval timeInterval = [dat timeIntervalSince1970];
    NSString *tmpString = [NSString stringWithFormat:@"%.0f",timeInterval];
    NSInteger tmpCount = [tmpString integerValue];
    return tmpCount;
}

+ (int)returnRandomFrom:(int)from to:(int)to{
    int tmp = (int)(from + (arc4random() % (to - from + 1)));
    return tmp;
}

+(int)returnRandomNum{
    int tmp = (int)(10 + (arc4random() % (90000000 - 9)));
    return tmp;
}

+ (NSString *)returnCurrentEquipmentNetStatus{

    NSString *netStatus = @"获取网络状态失败";
    
    UIApplication *application = [UIApplication sharedApplication];
    if (application.statusBarHidden) {
        netStatus = @"未获取到网络状态";
        return netStatus;
    }
    NSArray *children;
    /*适配X取网络状态*/
    if ([[application valueForKeyPath:@"_statusBar"] isKindOfClass:NSClassFromString(@"UIStatusBar_Modern")]) {
        children = [[[[application valueForKeyPath:@"_statusBar"] valueForKeyPath:@"_statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    } else {
        children = [[[application valueForKeyPath:@"_statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    }
//    = [[[app valueForKey:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    int type = 0;
    for (UIView *v in children) {
        if ([v isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            type = [[v valueForKeyPath:@"dataNetworkType"] intValue];
        }
    }
    
    switch (type) {
        case 0:
            netStatus = @"unreachable";
            break;
        case 1:
            netStatus = @"2G";
            break;
        case 2:
            netStatus = @"3G";
            break;
        case 3:
            netStatus = @"4G";
            break;
        case 4:
            netStatus = @"LTE";
            break;
        case 5:
            netStatus = @"wifi";
            break;
        default:
            break;
    }
    
    return netStatus;
}


+ (void)upLoadErrortype:(NSString *)type
                    API:(NSString *)errorAPI
                   netError:(NSError *)error
{
    NSInteger errorCode = error.code;
    if (errorCode == -1005 || errorCode == -1011 || errorCode == 3840 || errorCode == -1001 || errorCode == -1002 || errorCode == -1003 || errorCode == -1004 || errorCode == -1200 || errorCode == 54) {
        /*用户自身环境问题不上报
         -1001  :   请求超时
         -1002  :   不支持的 URL 地址
         -1003  :   找不到服务器
         -1004  :   连接不上服务器
         -1005  :   网络连接异常
         -1011  :   服务器响应异常
         -1200  :   安全链接失败
            54  :   网络忙
          3840  :   解析出错
         
         */
    }else{
        /*返回码不正常，上报错误接口*/
        NSString *upErrorStr = [NSString stringWithFormat:@"%@/stat/errorApp",DATAURL];
        NSDictionary *contentDic = @{
                                     @"platform"    : [UIDevice currentDevice].systemName,
                                     @"type"        : type,
                                     @"method"      : errorAPI,
                                     @"netError"    : [NSString stringWithFormat:@"%@",error],
                                     @"errorCode"   : [NSString stringWithFormat:@"%ld",(long)errorCode],
                                     @"app_version" : [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
                                     @"iphone_name" : [UIDevice currentDevice].name,
                                     @"model"       : [UIDevice currentDevice].model,
                                     @"system"      : [UIDevice currentDevice].systemVersion
                                     };
        NSDictionary *exceptionDic = @{
                                       @"id" : errorAPI,
                                       @"content" : contentDic};
        NSArray *exceptionArr = [NSArray arrayWithObject:exceptionDic];
        NSMutableDictionary *parametersForError = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                   exceptionArr,@"exception",
                                                   [HNBUtils returnTimestamp],@"uploadingTime",
                                                   nil];
        
        AFHTTPSessionManager *errorManager = [AFHTTPSessionManager manager];
        
        errorManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        errorManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        errorManager.requestSerializer  = [AFJSONRequestSerializer serializer];
        [errorManager POST:upErrorStr parameters:parametersForError progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            //        NSData * data = [result dataUsingEncoding:NSUTF8StringEncoding];
            //        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            //        if ([[jsonDict returnValueWithKey:@"state"] integerValue] == 0) {
            //            NSLog(@"------>上报错误码成功,%@",jsonDict);
            //        }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error.code == -1009) {
                //            [[HNBToast shareManager] toastWithOnView:nil msg:@"无网络,请稍后重试" afterDelay:1.0 style:HNBToastHudFailure];
                
            } else {
                NSLog(@"Error: %@", error);
                
            }
        }];
    }
    
}

+(void)uploadAssessRlt{
    
    NSDictionary *dataDict = [self sandBoxGetInfo:[NSDictionary class] forKey:IMAssess_Local_Data];
    
    if (dataDict != nil) {
        
        [DataFetcher doGetIMAssessCaseWithUserInfoData:dataDict SucceedHandler:^(id JSON) {
            int errCode = [[JSON valueForKey:@"state"] intValue];
            if (errCode == 0) {
                NSString *dataRes = [JSON valueForKey:@"data"];
                if ([dataRes isEqualToString:@"1"]) {
                    //成功后本地设空
                    [self sandBoxSaveInfo:nil forKey:IMAssess_Local_Data];
                }
            }
        } withFailHandler:^(id error) {
            
        }];
        
    }
    
}

+ (NSString *)reqCurrentCookie{
    
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesData];
    NSMutableString *cookieString = [[NSMutableString alloc] init];
    for (NSHTTPCookie *cookie in cookies) {
        [cookieString appendFormat:@"%@=%@;",cookie.name,cookie.value];
    }
    //NSLog(@" %s ====== > HNBSESSIONID-reqCurrentCookie:%@",__FUNCTION__,cookieString);
    return cookieString;
}

#pragma mark - 保存和读取UUID
+(void)saveUUIDToKeyChain{
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *account = [appInfo objectForKey:@"CFBundleIdentifier"];
    NSString *md5Account = [self md5HexDigest:account];
    NSString *md5Ser = [self md5HexDigest:@"HiNaBian"];
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithAccount:md5Account service:md5Ser accessGroup:nil];
    NSString *string = [keychainItem objectForKey: (__bridge id)kSecAttrGeneric];
    if([string isEqualToString:@""] || !string){
        [keychainItem setObject:[self getUUIDString] forKey:(__bridge id)kSecAttrGeneric];
    }
}

+(NSString *)readUUIDFromKeyChain{
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *account = [appInfo objectForKey:@"CFBundleIdentifier"];
    NSString *md5Account = [self md5HexDigest:account];
    NSString *md5Ser = [self md5HexDigest:@"HiNaBian"];
    KeychainItemWrapper *keychainItemm = [[KeychainItemWrapper alloc] initWithAccount:md5Account service:md5Ser accessGroup:nil];
    NSString *UUID = [keychainItemm objectForKey: (__bridge id)kSecAttrGeneric];
    return UUID;
}

+(NSString *)readMD5UUIDFromKeyChain{
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *account = [appInfo objectForKey:@"CFBundleIdentifier"];
    NSString *md5Account = [self md5HexDigest:account];
    NSString *md5Ser = [self md5HexDigest:@"HiNaBian"];
    KeychainItemWrapper *keychainItemm = [[KeychainItemWrapper alloc] initWithAccount:md5Account service:md5Ser accessGroup:nil];
    NSString *UUID = [keychainItemm objectForKey: (__bridge id)kSecAttrGeneric];
    NSString *md5UUID = [self md5HexDigest:UUID];
    return md5UUID;
}

+ (NSString *)getUUIDString
{
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef strRef = CFUUIDCreateString(kCFAllocatorDefault , uuidRef);
    NSString *uuidString = [(__bridge NSString*)strRef stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(strRef);
    CFRelease(uuidRef);
    return uuidString;
}

#pragma mark - 自定义 UUID

+ (NSString *)createCustomUUID:(NSDictionary *)infoDictionary{
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time = [dat timeIntervalSince1970];
    NSMutableString *curDateString = [[NSMutableString alloc] initWithFormat:@"%f",time];
    for (NSInteger cou = 0; cou < 9; cou ++) {
        [curDateString appendFormat:@"%d",arc4random()];
        //NSLog(@" \n \n 当前的字符串 curDateString :%@ \n \n",curDateString);
    }
    [curDateString appendString:[NSString stringWithFormat:@"%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"]]];
    NSString *customUUID = [self md5HexDigest:curDateString];
    return customUUID;
}

+ (BOOL)evaluateIsPhoneNum:(NSString *)mobileNum {
    NSString *MOBILE = @"^1(3[0-9]|4[0-9]|5[0-9]|8[0-9]|7[0-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:mobileNum];
}


#pragma mark - 解析用户扩展字段ext（实际为json字符串）
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

#pragma mark url 参数组合成一个dict
+ (NSDictionary *)dictionaryWithURLStringParameterAnalysis:(NSString *)URLString{
    // https://www.hinabian.com/tribe.html?a=1&b=2&c=6
    NSMutableDictionary * tmpDic = [[NSMutableDictionary alloc] init];
    NSString *tmpString = [URLString lowercaseString];
    tmpString = [tmpString stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([tmpString rangeOfString:@"?"].location != NSNotFound) {
        NSArray *qArr = [tmpString componentsSeparatedByString: @"?"];
        NSString *paraString = [qArr lastObject];
        if (paraString != nil){
            NSArray * parameterArray = [paraString componentsSeparatedByString: @"&"];
            for(NSString *tmpString in parameterArray){
                NSArray *tmpArray = [tmpString componentsSeparatedByString:@"="];
                if (tmpArray != nil) {
                    if (tmpArray.count >= 2) {
                        NSString * value = tmpArray[1];
                        NSString * key = tmpArray[0];
                        [tmpDic setObject:value forKey:key];
                    }
                    else if (tmpArray.count >= 1)
                    {
                        [tmpDic setObject:@"" forKey:tmpArray[0]];
                    }
                }
            }
        }
    }
    NSLog(@" \n URL 参数字典组装: %@ \n ",tmpDic);
    return tmpDic;
}


//+ (void)loginNetEaseIMWithLoginAcount:(NSString *)loginAccount loginToken:(NSString *)loginToken completion:(NETEaseLoginComplete)completion{
//
//    [[[NIMSDK sharedSDK] loginManager] login:loginAccount
//                                       token:loginToken
//                                  completion:^(NSError *error) {
//                                      if (error == nil)
//                                      {
//                                          NSLog(@"成功");
//                                      }
//                                      completion(error);
//                                  }];
//}

+ (void)setIMLocalLimited {
    //设置IM限制数的数据
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    dataArr = [HNBUtils sandBoxGetInfo:[NSMutableArray class] forKey:NETEASE_LIMITED_ARRAY];

    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
    NSArray *recentSessions = [[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
    NSInteger todayWholeNum = recentSessions.count;
    
    [tempDic setObject:[NIMSDK sharedSDK].loginManager.currentAccount forKey:NETEASE_LIMITED_ID];
    [tempDic setObject:@"0" forKey:NETEASE_TODAY_CHATNUM];
    [tempDic setObject:[NSString stringWithFormat:@"%ld",(long)todayWholeNum] forKey:NETEASE_TODAY_WHOLE];
    [tempDic setObject:@"" forKey:NETEASE_FIRST_CHATTIME];
    
    NSArray *tempArr = [[NSArray alloc] initWithObjects:tempDic, nil];
    if (dataArr) {
        dataArr = [[dataArr arrayByAddingObjectsFromArray:tempArr] mutableCopy];
    }else {
        dataArr = [[NSMutableArray alloc] initWithObjects:tempDic, nil];
    }
    
    [HNBUtils sandBoxSaveInfo:dataArr forKey:NETEASE_LIMITED_ARRAY];
    
}

+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    =[timeString doubleValue];
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString       = [formatter stringFromDate: date];

    return dateString;
}

+ (void)exitApplication {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *window = app.window;
    //增加收起动画，让杀死APP不显得过于突兀
    [UIView animateWithDuration:0.5f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
}

#pragma mark - 兼容ios10以下无openURL新方法，顺便回调了
+ (void)openScheme:(NSURL *)schemeURL options:(NSDictionary *)option complete:(void(^)(BOOL success))complete
{
    UIApplication *application = [UIApplication sharedApplication];
    if (@available(iOS 10.0, *)) {
        [application openURL:schemeURL options:option completionHandler:^(BOOL success) {
            if (complete) {
                complete(success);
            }
        }];
    } else {
        // Fallback on earlier versions
        [application openURL:schemeURL];
        BOOL success = [application canOpenURL:schemeURL];
        if (complete) {
            complete(success);
        }
    }
    
}

@end
