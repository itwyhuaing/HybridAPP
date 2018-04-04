//
//  DataFetcher.m
//  hinabian
//
//  Created by 余坚 on 15/6/15.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "DataFetcher.h"
#import <AFNetworking/AFNetworking.h>
#import "HNBAFNetTool.h"
#import <Security/Security.h>
#import "DataHandler.h"
#import "HNBFileManager.h"
#import "HNBToast.h"
#import "RSAEncryptor.h"
#import "PersonalInfo.h"
#import "HNBAssetModel.h"
#import <NIMSDK/NIMSDK.h>

@implementation DataFetcher


+(void)cancleAllRequest
{
    [HNBAFNetTool cancleAllRequest];
}
/* 登录接口 */
//+ (void)doLogin:(NSString*)account password:(NSString*)password withSucceedHandler:(DataFetchSucceedHandler)suceedHandler im_state:(NSString *)im_state withFailHandler:(DataFetchFailHandler)failHandler
+ (void)doLogin:(NSString*)account password:(NSString*)password im_state:(NSString *)im_state withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{

    RSAEncryptor *rsa = [[RSAEncryptor alloc] init];
    NSString *publicKeyPath = [[NSBundle mainBundle] pathForResource:@"public_ios" ofType:@"der"];
    [rsa loadPublicKeyFromFile:publicKeyPath];
    
    NSString* AccountEncode = [account stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* PWDEncode = [password stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * appdate = [HNBUtils getCruntTime];
    NSString * finalString = [NSString stringWithFormat:@"%@:%@:%@",AccountEncode,PWDEncode,appdate];
    NSString *encryptedFinalString = [rsa rsaEncryptString:finalString];

    NSString *deviceToken = [HNBUtils sandBoxGetInfo:[NSString class] forKey:personal_device_token];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                encryptedFinalString,@"log_key",
                                deviceToken,@"devicetoken",
                                @PORT_VERSION ,@"port_version",
                                nil];
    // v3.0 新增参数 - 本地选择的移民状态、移民国家、移民城市
    NSString *cityID = [HNBUtils sandBoxGetInfo:[NSString class] forKey:IMED_Local_City];
    NSString *nationID = [HNBUtils sandBoxGetInfo:[NSString class] forKey:IMED_Local_Nation];
    if (im_state != nil && im_state.length > 0) {
        [parameters setObject:im_state forKey:@"im_state"];
    }
    if (nationID != nil && nationID.length > 0) {
        [parameters setObject:nationID forKey:@"country_id"];
    }
    if (cityID != nil && cityID.length > 0) {
        [parameters setObject:cityID forKey:@"city_id"];
    }
    parameters = [HNBUtils addPlatformKey:parameters];
    //显示HUD
    [[HNBToast shareManager] toastWithOnView:nil msg:@"请稍后" afterDelay:0.f style:HNBToastHudWaiting];
    
    NSString *URLString = [NSString  stringWithFormat:@"%@/%@",APIURL,@"user_login/loginSafe"];
    [HNBAFNetTool POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0){
            [self saveCookies];
            [DataHandler doLoginHandleData:responseObject complete:^(id info) {
                [self loginNetEaseIMWithCompletion:nil];
            }];
            [[HNBToast shareManager] toastWithOnView:nil msg:@"登录成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
        }else{
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
        [[HNBToast shareManager] toastWithOnView:nil msg:@"登录失败,请稍后重试" afterDelay:DELAY_TIME style:HNBToastHudFailure];
    }];

}

/* qq登录 */
+ (void)doLoginWithQQ: (NSString*)access_token Open_id:(NSString*)openid  withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    RSAEncryptor *rsa = [[RSAEncryptor alloc] init];
    NSString *publicKeyPath = [[NSBundle mainBundle] pathForResource:@"public_ios" ofType:@"der"];
    [rsa loadPublicKeyFromFile:publicKeyPath];
    
    NSString* AccessTokenEncode = [access_token stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* OpenIdEncode = [openid stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * appdate = [HNBUtils getCruntTime];
    NSString * finalString = [NSString stringWithFormat:@"%@:%@:%@",AccessTokenEncode,OpenIdEncode,appdate];
    
    NSString *encryptedFinalString = [rsa rsaEncryptString:finalString];

     NSString * deviceToken = [HNBUtils sandBoxGetInfo:[NSString class] forKey:personal_device_token];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                encryptedFinalString,@"log_key",
                                deviceToken,@"devicetoken",
                                nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    
    NSString *URLString = [NSString  stringWithFormat:@"%@/%@",APIURL,@"user_login/appLogInQQSafe"];
    [HNBAFNetTool POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0){
            [self saveCookies];
            [DataHandler doLoginWithQQHandleData:responseObject complete:^(id info) {
                [self loginNetEaseIMWithCompletion:nil];
            }];
            [[HNBToast shareManager] toastWithOnView:nil msg:@"登录成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
        } else{
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
    
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
        [[HNBToast shareManager] toastWithOnView:nil msg:@"出现错误" afterDelay:DELAY_TIME style:HNBToastHudFailure];
    }];

}

/* 微信登录接口 - 已废弃 */
+ (void)doLoginWithWX: (NSString*)access_token Open_id:(NSString*)openid  withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
//    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    [config setHTTPAdditionalHeaders:@{ @"User-Agent" : @"App_IOS_Hinabian"}];

    
    
    RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
    NSString *publicKeyPath = [[NSBundle mainBundle] pathForResource:@"public_ios" ofType:@"der"];
    [rsa loadPublicKeyFromFile:publicKeyPath];
    
    
    NSString* AccessTokenEncode = [access_token stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* OpenIdEncode = [openid stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * appdate = [HNBUtils getCruntTime];
    NSString * finalString = [NSString stringWithFormat:@"%@:%@:%@",AccessTokenEncode,OpenIdEncode,appdate];
    NSString *encryptedFinalString = [rsa rsaEncryptString:finalString];
    NSString *deviceToken = [HNBUtils sandBoxGetInfo:[NSString class] forKey:personal_device_token];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                encryptedFinalString,@"log_key",
                                deviceToken,@"devicetoken",
                                nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    
    NSString *URLString = [NSString  stringWithFormat:@"%@/%@",APIURL,@"user_login/appLogInWeixinSafe"];
    [HNBAFNetTool POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
//        NSLog(@"%@",[responseObject valueForKey:@"data"]);
        if(errCode == 0)
        {
            //NSLog(@" %s ",__FUNCTION__);
            [self saveCookies];
            [DataHandler doLoginWithWXHandleData:responseObject complete:^(id info) {
                [self loginNetEaseIMWithCompletion:nil];
            }];
            [[HNBToast shareManager] toastWithOnView:nil msg:@"登录成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
        }
        else
        {
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
        [[HNBToast shareManager] toastWithOnView:nil msg:@"出现错误" afterDelay:DELAY_TIME style:HNBToastHudFailure];
    }];

}

/* 退出登录接口 */
+ (void)doLogOff:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{

    //显示HUD
    [[HNBToast shareManager] toastWithOnView:nil msg:@"请稍后" afterDelay:0.f style:HNBToastHudWaiting];
    
    NSString *deviceToken = [HNBUtils sandBoxGetInfo:[NSString class] forKey:personal_device_token];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       deviceToken,@"devicetoken",
                                       nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",APIURL,@"user_login/logoutApp"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            [[HNBToast shareManager] toastWithOnView:nil msg:@"退出成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
            /* 清除cookie */
            [self deleteCookieWithKey];
            [DataFetcher logOutNetEaseIMWitCompletion:nil];
            [DataHandler doLogOffHandleData:responseObject complete:nil];
        }
        else
        {
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
        [[HNBToast shareManager] toastWithOnView:nil msg:@"退出失败" afterDelay:DELAY_TIME style:HNBToastHudFailure];
    }];
 
}

/* 发送验证码到手机 */
+ (void)doVcodeWithMobile: (NSString*)mobile vcode_type:(NSString*)type withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    

    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                @"mobile",@"login_type",
                                mobile,@"mobile_num",
                                type,@"vcode_type",
                                nil];
    parameters = [HNBUtils addGeneralKey:parameters];
    parameters = [HNBUtils addPlatformKey:parameters];
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",APIURL,@"user_register/vcodeSafe"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //成功
        int errCode= [[responseObject valueForKey:@"state"] intValue];

        if(errCode == 0){
//            NSLog(@"successed");
        }else{
            //显示HUD
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
        //显示HUD
        [[HNBToast shareManager] toastWithOnView:nil msg:@"注册出现错误" afterDelay:DELAY_TIME style:HNBToastHudFailure];
    }];

}
/* 邮箱注册接口 */
+ (void)doRegisterWithMail: (NSString*)mail verifyCode:(NSString*)code password:(NSString*)password withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    
    
    RSAEncryptor *rsa = [[RSAEncryptor alloc] init];
    NSString *publicKeyPath = [[NSBundle mainBundle] pathForResource:@"public_ios" ofType:@"der"];
    [rsa loadPublicKeyFromFile:publicKeyPath];
    
    NSString *encryptedMail = [rsa rsaEncryptString:mail];
    NSString *encryptedPassword = [rsa rsaEncryptString:password];
    NSString *deviceToken = [HNBUtils sandBoxGetInfo:[NSString class] forKey:personal_device_token];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"email",@"login_type",
                                       encryptedMail,@"email",
                                       code,@"vcode",
                                       encryptedPassword,@"password",
                                       deviceToken,@"devicetoken",
                                       @PORT_VERSION ,@"port_version",
                                       nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    
    
    //显示HUD
    [[HNBToast shareManager] toastWithOnView:nil msg:@"请稍后" afterDelay:0.f style:HNBToastHudWaiting];
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",APIURL,@"user_register/registerSafe"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果注册成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        //int state = [[responseObject valueForKey:@"state"] intValue];
        //NSLog(@"%@",[responseObject valueForKey:@"data"]);
        if(errCode == 0)
        {
            //NSLog(@" %s ",__FUNCTION__);
            [self saveCookies];
            [DataHandler doRegisterWithMailHandleData:responseObject complete:^(id info) {
                [self loginNetEaseIMWithCompletion:nil];
            }];
            //修改成功
            [[HNBToast shareManager] toastWithOnView:nil msg:@"注册成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
        }
        else
        {
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
         [[HNBToast shareManager] toastWithOnView:nil msg:@"注册出现错误" afterDelay:DELAY_TIME style:HNBToastHudFailure];
    }];
    
}

/* 发送验证码到邮箱 */
+ (void)doVcodeWithMail: (NSString*)mail vcode_type:(NSString*)type withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"email",@"login_type",
                                       mail,@"email",
                                       type,@"vcode_type",
                                       nil];
    parameters = [HNBUtils addGeneralKey:parameters];
    parameters = [HNBUtils addPlatformKey:parameters];
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",APIURL,@"user_register/vcodeSafe"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //成功
        int errCode= [[responseObject valueForKey:@"state"] intValue];
        
        if(errCode == 0)
        {
            
//            NSLog(@"successed");
            
        }
        else
        {
            //显示HUD
             [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
        //显示HUD
        [[HNBToast shareManager] toastWithOnView:nil msg:@"注册出现错误" afterDelay:DELAY_TIME style:HNBToastHudFailure];
    }];
}

/* 注册后完善用户信息 */
+ (void)doCompleteUserInfo: (NSString*)NickName  IMNation:(NSArray*)IMNation IMState:(NSString*)IMState   withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    [HNBUtils sandBoxSaveInfo:IMState forKey:IM_INTENTION_LOCAL];
    [HNBUtils sandBoxSaveInfo:IMNation forKey:IM_NATION_LOCAL];
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                NickName,@"username",
                                IMNation,@"im_nation",
                                IMState,@"im_state",
                                nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    [self loadCookies];
    
    //显示HUD
    [[HNBToast shareManager] toastWithOnView:nil msg:@"正在提交" afterDelay:0.f style:HNBToastHudWaiting];
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",APIURL,@"user_register/appendMoreInfo"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            
//            NSLog(@"successed");
            //修改成功
            [[HNBToast shareManager] toastWithOnView:nil msg:@"提交成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
        }
        else
        {
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }

        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
        [[HNBToast shareManager] toastWithOnView:nil msg:@"提交出现错误" afterDelay:DELAY_TIME style:HNBToastHudFailure];
    }];

}

+(void)loginNetEaseIMWithCompletion:(NETEaseLoginORLogOutComplete)completion{
    
    NSArray *tmpPersonalInfoArry = [PersonalInfo MR_findAll];
    PersonalInfo * pf = nil;
    if (tmpPersonalInfoArry != nil && tmpPersonalInfoArry.count > 0) {
        pf = tmpPersonalInfoArry[0];
        [[[NIMSDK sharedSDK] loginManager] login:pf.netease_im_id
                                           token:pf.netease_im_token
                                      completion:^(NSError *error) {
                                          if(completion){
                                              completion(error);
                                          }
                                      }];
    }
}

+(void)logOutNetEaseIMWitCompletion:(NETEaseLoginORLogOutComplete)completion{
    if ([[NIMSDK sharedSDK].loginManager isLogined]) {
        //处于登录状态
        [[NIMSDK sharedSDK].loginManager logout:^(NSError * _Nullable error) {
            if (completion) {
                completion(error);
            }
        }];
    }
}

+ (void)doUpdateUserInfo:(NSString*) userid NickName:(NSString *)nickNameString Motto:(NSString *)mottoString Indroduction:(NSString *)indroductionString Hobby:(NSString *)hobbyString Im_state:(NSString *)imStateString Im_nation:(NSArray *)imNationarry withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    
    

    NSMutableDictionary *parameters =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      userid,@"id",
                                      nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    if (nickNameString != Nil) {
        [parameters setObject:nickNameString forKey:@"username"];
    }
    if (mottoString != Nil) {
        [parameters setObject:mottoString forKey:@"motto"];
    }
    if (indroductionString != Nil) {
        [parameters setObject:indroductionString forKey:@"indroduction"];
    }
    if (hobbyString != Nil) {
        [parameters setObject:hobbyString forKey:@"hobby"];
    }
    if (imStateString != Nil) {
        [parameters setObject:imStateString forKey:@"im_state"];
    }
    if (imNationarry != Nil) {
        [parameters setObject:imNationarry forKey:@"im_nation"];
    }
    
    [self loadCookies];
    
    //显示HUD
    [[HNBToast shareManager] toastWithOnView:nil msg:@"正在提交" afterDelay:0.f style:HNBToastHudWaiting];
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"personal_userinfo/updateUserInfo"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            
//            NSLog(@"successed");
            //修改成功
            [[HNBToast shareManager] toastWithOnView:nil msg:@"提交成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
        }
        else
        {
             [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
        [[HNBToast shareManager] toastWithOnView:nil msg:@"提交出现错误" afterDelay:DELAY_TIME style:HNBToastHudFailure];
    }];

}

//更改用户头像
+(void) updateUserImage:(UIImage*)userImage WithSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSData *imageData = UIImageJPEGRepresentation(userImage, 0.5);
    //NSMutableDictionary *parameters = @{@"avatar":imageData};
    
    //显示HUD
    [[HNBToast shareManager] toastWithOnView:nil msg:@"请稍后" afterDelay:0.f style:HNBToastHudWaiting];

    [manager POST:[NSString stringWithFormat:@"%@/%@",APIURL,@"personal_userinfo/saveHeadImg"] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"upfile" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            //修改成功
            [[HNBToast shareManager] toastWithOnView:nil msg:@"修改成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
            [DataHandler updateUserImageHandleData:responseObject complete:nil];
        }else
        {
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"errmsg"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        
        suceedHandler(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"修改失败" afterDelay:DELAY_TIME style:HNBToastHudFailure];
        failHandler(error);
        
    }];
    
    
    
    
}

/* 发帖上传图片 */
+(void) updatePostImage:(UIImage*)userImage WithSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSData *imageData = UIImageJPEGRepresentation(userImage, 0.1);
    //NSMutableDictionary *parameters = @{@"avatar":imageData};
    
    /*显示HUD*/
//    [[HNBToast shareManager] toastWithOnView:nil msg:@"正在提交" afterDelay:0.f style:HNBToastHudWaiting];
    
    [manager POST:@"https://imgupload.hinabian.com/image/saveWithCommonReturn" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"upfile" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
//            [[HNBToast shareManager] toastWithOnView:nil msg:@"提交成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
            
        }else
        {
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"errmsg"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        
        suceedHandler(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"上传失败" afterDelay:DELAY_TIME style:HNBToastHudFailure];
        failHandler(error);
        
    }];

}

+(void) hnbRichTextUpdatePostImage:(HNBAssetModel *)info WithSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler{


    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //超时30s
    manager.requestSerializer.timeoutInterval = 30.f;
    UIImage *curImage = (UIImage *)info.image;
    //图片压缩率为最低
    NSData *imageData = UIImageJPEGRepresentation(curImage, 0.1);
    //NSMutableDictionary *parameters = @{@"avatar":imageData};
    
    /*显示HUD*/
    //    [[HNBToast shareManager] toastWithOnView:nil msg:@"正在提交" afterDelay:0.f style:HNBToastHudWaiting];
    
    [manager POST:@"https://imgupload.hinabian.com/image/saveWithCommonReturn" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"upfile" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            //            [[HNBToast shareManager] toastWithOnView:nil msg:@"提交成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
            
        }else
        {
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"errmsg"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        
        suceedHandler(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 传图已有进度条提示
        /**[[HNBToast shareManager] toastWithOnView:nil msg:@"上传失败" afterDelay:DELAY_TIME style:HNBToastHudFailure];**/
        failHandler(error);
        
    }];


}


/* 获取首页主要信息 */
+ (void)doGetIndexMainInfo:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    

    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                @"1",@"shuffling_info",
                                @"1",@"activity_info",
                                @"1",@"house_info",
                                nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",APIURL,@"app_index/mainInfo"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            [DataHandler doGetIndexMainInfoHandleData:responseObject complete:nil];
//            NSLog(@"successed");
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];

}

/* 首页获取热门帖子 */
+ (void)doGetPopularPost: (int)start  GetNum:(int)num withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;
{
    
    
    NSString *tmpStart = [NSString stringWithFormat:@"%d",start];
    NSString *tmpNum = [NSString stringWithFormat:@"%d",num];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                tmpStart,@"start",
                                tmpNum,@"num",
                                nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",APIURL,@"index/getHomeThemeForApp"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            [DataHandler doGetPopularPostHandleData:responseObject complete:nil];
//            NSLog(@"successed");
        }
        else
        {
            NSLog(@"%@",[responseObject valueForKey:@"data"]);
        }
   
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];

}

/* 回答问题接口 */
+ (void)doAnswerQuestion:(NSString *) userid QID:(NSString *)qID AID:(NSString *)aID content:(NSString *)contentString withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    
    //显示HUD
    [[HNBToast shareManager] toastWithOnView:nil msg:@"正在提交" afterDelay:0.f style:HNBToastHudWaiting];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                userid,@"id",
                                qID,@"question_id",
                                aID,@"answer_id",
                                contentString,@"content",
                                nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"qa_answer/save"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            [[HNBToast shareManager] toastWithOnView:nil msg:@"回复成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
//            NSLog(@"successed");
        }
        else
        {
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
         [[HNBToast shareManager] toastWithOnView:nil msg:@"提交失败" afterDelay:DELAY_TIME style:HNBToastHudFailure];
        failHandler(error);
    }];

}

/* 提交提问接口 */
+ (void)doSubmitQuestion:(NSString *) userid Title:(NSString *)title content:(NSString *)contentString Label:(NSArray *)labels AnswerId:(NSString *)answerId  SubjectId:(NSString *)subject_id withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    
    //显示HUD
    [[HNBToast shareManager] toastWithOnView:nil msg:@"正在提交" afterDelay:0.f style:HNBToastHudWaiting];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                userid,@"id",
                                title,@"t",
                                contentString,@"c",
                                labels,@"label",
                                answerId,@"s",
                                subject_id,@"subject_id",
                                nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"qa_question/save"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
             [[HNBToast shareManager] toastWithOnView:nil msg:@"发布成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
        }
        else
        {
             [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"发布失败" afterDelay:DELAY_TIME style:HNBToastHudFailure];
        failHandler(error);
    }];

}


/* 获取所有标签 */
+ (void)doGetAllLabels:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5URL,@"qa_question/tag"] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            [DataHandler doGetAllLabelsHandleData:responseObject complete:nil];
        }
        else
        {
            NSLog(@"%@",[responseObject valueForKey:@"data"]);
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}

/* 获取所有圈子 */
+ (void)doGetAllTribes:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    
    
    
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5URL,@"tribe/getTribeList"] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            [DataHandler doGetAllTribesHandleData:responseObject complete:nil];
        }
        else
        {
            NSLog(@"%@",[responseObject valueForKey:@"data"]);
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];

}

/* 获取所有提示 */
+ (void)doGetAllNotices:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    
    
    
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5URL,@"qa_question/notice.html"] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            //NSLog(@"%@",[responseObject objectForKey:@"data"]);
//            NSLog(@"successed");
        }
        else
        {
            NSLog(@"%@",[responseObject valueForKey:@"data"]);
        }
        
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}
/* 发帖接口 */
+ (void)doPostTribe:(NSString *) userid TID:(NSString *)TID Title:(NSString *)titleString content:(NSString *)contentString ImageList:(NSArray*)imageArry  withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    
    //显示HUD
    [[HNBToast shareManager] toastWithOnView:nil msg:@"正在提交" afterDelay:0.f style:HNBToastHudWaiting];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                userid,@"id",
                                TID,@"tribe_id",
                                titleString,@"title",
                                contentString,@"content",
                                imageArry,@"img_list",
                                nil];
    
    parameters = [HNBUtils addGeneralKey:parameters];
    parameters = [HNBUtils addPlatformKey:parameters];

    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"theme/saveSafe"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
          [[HNBToast shareManager] toastWithOnView:nil msg:@"发帖成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
        }
        else
        {
             [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"发帖失败" afterDelay:DELAY_TIME style:HNBToastHudFailure];
        failHandler(error);
    }];
    

}

+(void)hnbRichTextPostTribeID:(NSString *)tribeID themID:(NSString *)themID title:(NSString *)titleString content:(NSString *)contentString topicID:(NSString *)topicID withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    
    //显示HUD
    [[HNBToast shareManager] toastWithOnView:nil msg:@"正在提交" afterDelay:0.f style:HNBToastHudWaiting];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       titleString,@"title",
                                       contentString,@"content",
                                       nil];
    if (themID != nil || (themID.length > 0 && ![themID isEqualToString:@"null"])) {
        [parameters setObject:themID forKey:@"id"];
    }
    
    if (tribeID != nil || (tribeID.length > 0 && ![tribeID isEqualToString:@"null"])) {
        [parameters setObject:tribeID forKey:@"tribe_id"];
    }
    
    if (topicID != nil || (topicID.length > 0 && ![topicID isEqualToString:@"null"])) {
        [parameters setObject:topicID forKey:@"topic_id"];
    }
    
    parameters = [HNBUtils addGeneralKey:parameters];
    parameters = [HNBUtils addPlatformKey:parameters];
    NSString *URLString = [NSString  stringWithFormat:@"%@/%@",APIURL,@"theme/save"];
    [HNBAFNetTool POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            [[HNBToast shareManager] toastWithOnView:nil msg:@"发帖成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
        }
        else
        {
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"发帖失败" afterDelay:DELAY_TIME style:HNBToastHudFailure];
        failHandler(error);
    }];
    
}

/* 回帖接口 */
+ (void)doReplyPost:(NSString *) userid TID:(NSString *)TID CID:(NSString *)CID content:(NSString *)contentString ImageList:(NSArray*)imageArry withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    
    //显示HUD
    [[HNBToast shareManager] toastWithOnView:nil msg:@"正在提交" afterDelay:0.f style:HNBToastHudWaiting];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                userid,@"id",
                                TID,@"theme_id",
                                CID,@"comment_id",
                                contentString,@"content",
                                imageArry,@"img_list",
                                nil];
    parameters = [HNBUtils addGeneralKey:parameters];
    parameters = [HNBUtils addPlatformKey:parameters];
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"comment/saveSafe"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            [[HNBToast shareManager] toastWithOnView:nil msg:@"评论成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
        }
        else
        {
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"评论失败" afterDelay:DELAY_TIME style:HNBToastHudFailure];
        failHandler(error);
    }];
    

}

/* 点赞接口 */
+ (void)doPraiseTheme:(NSString *) userid TID:(NSString *)TID withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                userid,@"id",
                                TID,@"theme_id",
                                nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",APIURL,@"theme/collectTheme"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
//            NSLog(@"successed");
        }
        else
        {
            NSLog(@"%@",[responseObject valueForKey:@"data"]);
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}

/* 取消点赞接口 */
+ (void)doCancelPraiseTheme:(NSString *) userid TID:(NSString *)TID withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                userid,@"id",
                                TID,@"theme_id",
                                nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",APIURL,@"theme/cancelCollectTheme"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
//            NSLog(@"successed");
        }
        else
        {
            NSLog(@"%@",[responseObject valueForKey:@"data"]);
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}

/* 帖子是否被自己赞过 */
+ (void)doIsThemePraise:(NSString *) userid TID:(NSString *)TID withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                userid,@"id",
                                TID,@"theme_id",
                                nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",APIURL,@"theme/isCollectTheme"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            /*id json1 = [responseObject valueForKey:@"data"];
            NSString * tmpString = [json1 valueForKey:@"is_collect"];*/
//            NSLog(@"successed");
        }
        else
        {
            NSLog(@"doIsThemeCollect = %@",[responseObject valueForKey:@"data"]);
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}

/* 用户修改密码接口 */
+ (void)doChangePWD:(NSString *) userid oldPWD:(NSString*)oldPWDString newPWD:(NSString *)newPWDString confirmPWD:confirmPWDString withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    
    //显示HUD
    [[HNBToast shareManager] toastWithOnView:nil msg:@"正在提交" afterDelay:0.f style:HNBToastHudWaiting];
    RSAEncryptor *rsa = [[RSAEncryptor alloc] init];
    NSString *publicKeyPath = [[NSBundle mainBundle] pathForResource:@"public_ios" ofType:@"der"];
    [rsa loadPublicKeyFromFile:publicKeyPath];
    
    NSString *encryptedoldPWD = [rsa rsaEncryptString:oldPWDString];
    NSString *encryptednewPWD = [rsa rsaEncryptString:newPWDString];
    NSString *encryptedconfirmPWD = [rsa rsaEncryptString:confirmPWDString];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                userid,@"id",
                                encryptedoldPWD,@"pwd",
                                encryptednewPWD,@"newpwd",
                                encryptedconfirmPWD,@"confirmpwd",
                                @PORT_VERSION ,@"port_version",
                                nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",APIURL,@"personal_setpwd/resetPwdSafe"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"修改密码  %@ ",responseObject);
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            [[HNBToast shareManager] toastWithOnView:nil msg:@"修改成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
        }
        else
        {
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"修改失败" afterDelay:DELAY_TIME style:HNBToastHudFailure];
        failHandler(error);
    }];

}


+ (void)dogetVisaPayInfo:(NSString *)order_no Method:(NSString *)pay_method withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    
    //显示HUD
    [[HNBToast shareManager] toastWithOnView:nil msg:@"正在提交" afterDelay:0.f style:HNBToastHudWaiting];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                order_no,@"order_no",
                                pay_method,@"pay_method",
                                nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"pay/getVisaPayInfo"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        //NSLog(@" 微信支付 ： %@",responseObject);
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
             [[HNBToast shareManager] toastWithOnView:nil msg:@"提交成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
        }
        else
        {
             [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"提交失败" afterDelay:DELAY_TIME style:HNBToastHudFailure];
        failHandler(error);
    }];

}

/*  订单号确定 */
+ (void)doVerifyVisaPayInfo:(NSString *)order_no PayState:(NSString *)pay_state withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                order_no,@"order_no",
                                pay_state,@"pay_state",
                                nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"pay/order"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
//        NSLog(@"%@",responseObject);
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
//            NSLog(@"successed");
        }
        else
        {
            NSLog(@"%@",[responseObject valueForKey:@"data"]);
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}
/* 忘记密码1 填写手机号 */
+ (void)doForgetPWDSetpOne:(NSString *) telNum withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                @"mobile",@"login_type",
                                telNum,@"mobile_num",
                                @"need_exist",@"vcode_type",
                                nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    parameters = [HNBUtils addGeneralKey:parameters];
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",APIURL,@"user_register/vcodeSafe"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //成功
        int errCode= [[responseObject valueForKey:@"state"] intValue];
        //int state = [[responseObject valueForKey:@"state"] intValue];
        
        if(errCode == 0)
        {
            
//            NSLog(@"successed");
            
        }
        else
        {
            //显示HUD
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
        //显示HUD
         [[HNBToast shareManager] toastWithOnView:nil msg:@"出现错误" afterDelay:DELAY_TIME style:HNBToastHudFailure];
    }];

}

/* 忘记密码2 填写校验码 */
+ (void)doForgetPWDSetpTwo:(NSString *)VcodeString TEL:(NSString *) telNum withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                @"mobile",@"login_type",
                                telNum,@"mobile_num",
                                @"need_exist",@"vcode_type",
                                VcodeString,@"vcode",
                                nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",APIURL,@"user_register/checkVcode"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //成功
        int errCode= [[responseObject valueForKey:@"state"] intValue];
        //int state = [[responseObject valueForKey:@"state"] intValue];
        
        if(errCode == 0)
        {
            
//            NSLog(@"successed");
            
        }
        else
        {
            //显示HUD
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
        //显示HUD
         [[HNBToast shareManager] toastWithOnView:nil msg:@"出现错误" afterDelay:DELAY_TIME style:HNBToastHudFailure];
    }];

}

/* 忘记密码3 填写新密码 */
+ (void)doForgetPWDSetpThree:(NSString *)newPwd Vcode:(NSString *)VcodeString TEL:(NSString *) telNum withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    //显示HUD
     [[HNBToast shareManager] toastWithOnView:nil msg:@"请稍后" afterDelay:0.f style:HNBToastHudWaiting];
    
    
    RSAEncryptor *rsa = [[RSAEncryptor alloc] init];
    NSString *publicKeyPath = [[NSBundle mainBundle] pathForResource:@"public_ios" ofType:@"der"];
    [rsa loadPublicKeyFromFile:publicKeyPath];
    
    NSString *encryptedPWD = [rsa rsaEncryptString:newPwd];
    NSString *encryptedtelNum = [rsa rsaEncryptString:telNum];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                @"mobile",@"login_type",
                                encryptedtelNum,@"mobile_num",
                                @"need_exist",@"vcode_type",
                                VcodeString,@"vcode",
                                encryptedPWD,@"password",
                                encryptedPWD,@"password_confirm",
                                @PORT_VERSION ,@"port_version",
                                nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",APIURL,@"user_register/resetPwdSafe"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //成功
        int errCode= [[responseObject valueForKey:@"state"] intValue];
        //int state = [[responseObject valueForKey:@"state"] intValue];
        
        if(errCode == 0)
        {
            [[HNBToast shareManager] toastWithOnView:nil msg:@"修改成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
        }
        else
        {

             [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
         [[HNBToast shareManager] toastWithOnView:nil msg:@"提交出现错误" afterDelay:DELAY_TIME style:HNBToastHudFailure];
    }];

}

+ (void)doVerifyUserInfo:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
//    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    [config setHTTPAdditionalHeaders:@{ @"User-Agent" : @"App_IOS_Hinabian"}];
    
    
    
    
    /*NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                telNum,@"mobile_num",
                                VcodeString,@"vcode",
                                nil];*/
    
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",APIURL,@"user_login/verifyUserInfo"] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //成功
        //NSLog(@" %s ",__FUNCTION__);
        [self saveCookies];
        int errCode= [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            [DataHandler doVerifyUserInfoHandleData:responseObject complete:^(id info) {
//                NSMutableDictionary *rltDic = [NSMutableDictionary dictionaryWithDictionary:responseObject];
//                [rltDic setValue:info forKey:NETEASE_LOGIN_RESULT];
                suceedHandler(responseObject);
            }];
        }
        else
        {
            /* 已过期 注销登录 */
            /* 请除用户信息 */
            [PersonalInfo MR_truncateAll];
            /* 清除登录标示 */
            [HNBUtils sandBoxSaveInfo:@"0" forKey:personal_is_login];
            suceedHandler(responseObject);
        }
        
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
        
    }];

}

/* 获取圈子首页基本信息 */
+ (void)doGetTribeIndexBaseInfo:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    
    
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"tribe/getHomeBaseInfo"] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //成功
        int errCode= [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            [DataHandler doGetTribeIndexBaseInfoHandleData:responseObject complete:nil];
        }
        else
        {

        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);

    }];
}

/* 获取圈子首页热门帖子 */
+ (void)doGetTribeIndexPost: (int)start  GetNum:(int)num withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    
    NSString *tmpStart = [NSString stringWithFormat:@"%d",start];
    NSString *tmpNum = [NSString stringWithFormat:@"%d",num];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                tmpStart,@"start",
                                tmpNum,@"num",
                                nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"tribe/getThemeListInTribe"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            [DataHandler doGetTribeIndexPostHandleData:responseObject start:start complete:nil];
        }
        else
        {
            NSLog(@"%@",[responseObject valueForKey:@"data"]);
        }

        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {

        failHandler(error);
    }];

}

/* 新增密码 */
+ (void)doNewPWD:(NSString *)newPWDString confirmPWD:confirmPWDString withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    
    //显示HUD
    [[HNBToast shareManager] toastWithOnView:nil msg:@"正在提交" afterDelay:0.f style:HNBToastHudWaiting];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                newPWDString,@"pwd",
                                confirmPWDString,@"confirmpwd",
                                nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",APIURL,@"Personal_Setpwd/setPwd"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            [[HNBToast shareManager] toastWithOnView:nil msg:@"修改成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
        }
        else
        {
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"修改失败" afterDelay:DELAY_TIME style:HNBToastHudFailure];
        failHandler(error);
    }];

}

+ (void)doHasPWD:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    
    
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"Personal_Userinfo/hasPwd"] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //成功
//        int errCode= [[responseObject valueForKey:@"state"] intValue];
//        if(errCode == 0)
//        {
            //id jsonMain = [responseObject valueForKey:@"data"];
            
//            NSLog(@"successed");
            
//        }
//        else
//        {
//            
//        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failHandler(error);
    }];

}

/* 获取首页华人的一天信息接口 */
+ (void)doGetIndexCODInfo:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    
    
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"cnd/getCODMainInfo"] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            [DataHandler doGetIndexCODInfoHandleData:responseObject complete:nil];
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];

}

/* 新版本获取活动接口 */
+ (void)doGetIndexActivityInfo:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"cnd/getActivityInfo"] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            [DataHandler doGetIndexActivityInfoHandleData:responseObject complete:nil];
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];

}

/* 获取闪屏页 */
+ (void)doGetSplashScreen:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;
{
    
    
    
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"cnd/getSplashPic2"] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
//        //如果成功
//        int errCode=   [[responseObject valueForKey:@"state"] intValue];
//        if(errCode == 0)
//        {
//            NSLog(@"successed");
//        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];

}

/* 获取所有 */
+ (void)doGetAllActivityInfo:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    
    
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"cnd/getAllActivityInfo"] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            [DataHandler doGetAllActivityInfoHandleData:responseObject complete:nil];
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];

}



+ (void)doPostCOD:(NSString *)contentString ImageList:(NSArray*)imageArry NationID:(NSString *) NationID withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    
    //显示HUD
    [[HNBToast shareManager] toastWithOnView:nil msg:@"正在提交" afterDelay:0.f style:HNBToastHudWaiting];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       contentString,@"content",
                                       imageArry,@"img_list",
                                       NationID,@"country_id",
                                         @"1234",@"tribe_id",
                                       nil];
    
    parameters = [HNBUtils addGeneralKey:parameters];
    parameters = [HNBUtils addPlatformKey:parameters];
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"cnd/save"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            [[HNBToast shareManager] toastWithOnView:nil msg:@"发帖成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
        }
        else
        {
             [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"发帖失败" afterDelay:DELAY_TIME style:HNBToastHudFailure];
        failHandler(error);
    }];

}

/*  diretcion  0  获取前面（昨天）的天数   1 获取后面（明天）的天数 */

+ (void)doGetMoreCODPage:(NSString *)t_id Num:(NSString *)numString Direction:(NSString *)directionString withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       t_id,@"t_id",
                                       numString,@"num",
                                       directionString,@"direction",
                                       nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"cnd/getMoreCODPage"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            id josanMain = [responseObject valueForKey:@"data"];
            NSNumber * tmpCount = [josanMain valueForKey:@"count"];
            if ([tmpCount intValue] == 0) {
                //显示HUD
                [[HNBToast shareManager] toastWithOnView:nil msg:@"已无更多内容" afterDelay:DELAY_TIME style:HNBToastHudOnlyText];
            }

            
            
        }
        
        
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];

}

+ (void)doGetGiveBirthInAmericaUrl:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    
    
    
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"index/giveBirthInAmerica"] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
                       
        }
        else
        {
            NSLog(@"%@",[responseObject valueForKey:@"data"]);
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
    

}

+ (void)doGetTribeIndexActivityInfo:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    
    
    
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"tribe/getLatestActivity"] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            
        }
        else
        {
            NSLog(@"%@",[responseObject valueForKey:@"data"]);
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}

+ (void)doSetPushSwitch:(NSString *)typeString Switch:(NSString *)switchstring withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       typeString,@"pushtype",
                                       switchstring,@"switch",
                                       nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"app_notify/switch"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
//        NSLog(@"%@",responseObject);
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            NSLog(@"successed");
        }
        else
        {
            NSLog(@"%@",[responseObject valueForKey:@"data"]);
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];

}

+ (void)doGetVersionFromAppStore:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{

    [HNBAFNetTool acceptableContentTypes:@"text/javascript" POST:[NSString  stringWithFormat:@"http://itunes.apple.com/lookup?id=998252357"] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
//            NSLog(@"successed");
        }
        else
        {
            NSLog(@"%@",[responseObject valueForKey:@"data"]);
        }
        
        suceedHandler(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failHandler(error);
        
    }];
    
}


+ (void)doSetIdeaBack:(NSString *)ideaString withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       ideaString,@"content",
                                       nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"feedback/app"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //如果成功
//        NSLog(@"%@",responseObject);
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
//            NSLog(@"successed");
        }
        else
        {
            NSLog(@"%@",[responseObject valueForKey:@"data"]);
        }
        
        suceedHandler(responseObject);
    }failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}

+ (void)saveCookies{
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    [HNBUtils sandBoxSaveInfo:cookiesData forKey:personal_cookie];
}
+ (void)loadCookies{
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [HNBUtils sandBoxGetInfo:[NSData class] forKey:personal_cookie]];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in cookies){
        [cookieStorage setCookie:cookie];
        //NSLog(@" %s ====== > HNBSESSIONID-setCookie:%@",__FUNCTION__,cookie);
    }
}

+ (NSDictionary *)composingCookieDicInfo{
    NSMutableDictionary *rltDic = [[NSMutableDictionary alloc] init];
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [HNBUtils sandBoxGetInfo:[NSData class] forKey:personal_cookie]];
    for (NSHTTPCookie *cookie in cookies){
        [rltDic setObject:cookie.name forKey:@"name"];
        [rltDic setObject:cookie.value forKey:@"value"];
        NSLog(@" \n \n composingCookieDicInfo-rlt : %@ \n \n",rltDic);
    }
    return rltDic;
}

+ (void)deleteCookieWithKey
{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    NSArray *cookies = [NSArray arrayWithArray:[cookieJar cookies]];
    
    for (NSHTTPCookie *cookie in cookies) {
       
        [cookieJar deleteCookie:cookie];
        //NSLog(@" %s ====== > HNBSESSIONID-deleteCookie:%@",__FUNCTION__,cookie);
        
    }
}

+ (void)doShowBIA:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{

    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"index/isShowBia"] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
//        //如果成功
//        NSLog(@"%@",responseObject);
//        int errCode=   [[responseObject valueForKey:@"state"] intValue];
//        if(errCode == 0)
//        {
//        }else{
//        }
        suceedHandler(responseObject);
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
    
}

+ (void)doSetTribeInfoNativeOrWeb:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"config/symbol?configName=tribeWebOrNative"] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功

        
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            NSArray *functionSetJson = [responseObject valueForKey:@"data"];
            NSString *isNative = [functionSetJson[0] valueForKey:@"isNative"];
//            NSLog(@"%@",isNative);
            [HNBUtils sandBoxSaveInfo:isNative forKey:TRIBEDETAILTHEME_NATIVEUI_WEB];

        }else{
            
        }
        suceedHandler(responseObject);
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}

+(void)doisShowConsultationInIndex:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"config/symbol?configName=appIndexConsultation"] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        //如果成功
        
        suceedHandler(responseObject);
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
    
}

+(void)doGetConfigInfoHomeIndex:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler{

    NSString *URLString = [NSString stringWithFormat:@"%@/%@",H5APIURL,@"config/symbolNativeaAndConsultation"];
    [HNBAFNetTool POST:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int intState=   [[responseObject valueForKey:@"state"] intValue];
        NSString *showConsultation = @"0";
        if (intState == 0) {
            
            NSDictionary *dataDic = [responseObject valueForKey:@"data"];
            NSDictionary *tribeWebOrNativeDic = [dataDic valueForKey:@"tribeWebOrNative"];
            NSArray *web_dataArr = [tribeWebOrNativeDic valueForKey:@"data"];
            NSDictionary *appIndexConsultationDic = [dataDic valueForKey:@"appIndexConsultation"];
            NSArray *consul_dataArr = [appIndexConsultationDic valueForKey:@"data"];
            
            if (web_dataArr != nil && web_dataArr.count > 0) {
                NSDictionary *webConfigDic = [web_dataArr firstObject];
                NSString *isNative = [webConfigDic valueForKey:@"isNative"];
                [HNBUtils sandBoxSaveInfo:isNative forKey:TRIBEDETAILTHEME_NATIVEUI_WEB];
            }
            
            if (consul_dataArr != nil && consul_dataArr.count > 0) {
                NSDictionary *consulConfigDic = [consul_dataArr firstObject];
                showConsultation = [consulConfigDic valueForKey:@"showConsultation"];
                
                NSString *buttonColorString = [consulConfigDic valueForKey:@"consultColor"];
                [HNBUtils sandBoxSaveInfo:buttonColorString forKey:APPOINTMENT_BUTTON_COLOR];
                
                NSString *tipBackground = [consulConfigDic valueForKey:@"tipBackground"];
                [HNBUtils sandBoxSaveInfo:tipBackground forKey:BINDING_PHONENUM_BACKGROUNDCOLOR];
                
                NSString *tipContent = [consulConfigDic valueForKey:@"tipContent"];
                [HNBUtils sandBoxSaveInfo:tipContent forKey:BINDING_PHONENUM_CONTENT];
                
                NSString *tipTextColor = [consulConfigDic valueForKey:@"tipTextColor"];
                [HNBUtils sandBoxSaveInfo:tipTextColor forKey:BINDING_PHONENUM_TEXTCOLOR];
                
                NSString *isShowSkipInGuide = [consulConfigDic valueForKey:@"showSkip"];
                [HNBUtils sandBoxSaveInfo:isShowSkipInGuide forKey:IMGuide_Show_Skip];
                
                NSString *isImassessNative = [consulConfigDic valueForKey:@"isImassessNative"];
                [HNBUtils sandBoxSaveInfo:isImassessNative forKey:im_assess_type];
                
                NSString *recommendURL = [consulConfigDic valueForKey:@"recommendURL"];
                [HNBUtils sandBoxSaveInfo:recommendURL forKey:Personal_Recommend_URL];
                
                NSString *isJumpBootpage = [consulConfigDic valueForKey:@"isJumpBootpage"];
                [HNBUtils sandBoxSaveInfo:isJumpBootpage forKey:IMGuide_Show_Switch];
            }
            
        }
        suceedHandler(showConsultation);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failHandler(error);
        
    }];
    
}

/* 获取所有国家 */
+ (void)doGetAllNations:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5URL,@"Personal_Userinfo/getAllNation"] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            [DataHandler doGetAllNationsHandleData:responseObject complete:nil];
        }
        else
        {
            NSLog(@"%@",[responseObject valueForKey:@"data"]);
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
    
}

+ (void)doGetAllCODNations:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    
    
    
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"cnd/getAllCODNation"] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            [DataHandler doGetAllCODNationsHandleData:responseObject complete:nil];
            
        }
        else
        {
            NSLog(@"%@",[responseObject valueForKey:@"data"]);
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
    
}

+ (void)dogetCountryCodes:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler{

    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",APIURL,@"user_register/appGetMobileNation"] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int errorCode = [[responseObject valueForKey:@"state"] intValue];
        if (errorCode == 0) {
            [DataHandler dogetCountryCodesHandleData:responseObject complete:nil];
        }
        suceedHandler(responseObject);
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
    
}

+(void)doGetAllNationAndMobieNationAllCODNationInfo:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler{

    NSString *URLString = [NSString stringWithFormat:@"%@/%@",H5APIURL,@"national/cndAndNationinfo"];
    [HNBAFNetTool POST:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int intState = [[responseObject valueForKey:@"state"] intValue];
        if (intState == 0) {
            
            [DataHandler doGetAllNationAndMobieNationAllCODNationInfoHandleData:responseObject complete:nil];
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
        
    }];
    
}


#pragma mark - 增加国家码之后的获取手机验证码
+ (void)doVcodeWithCountrycodeMobile: (NSString*)mobile vcode_type:(NSString*)type vcode_mobile_nation:(NSString *)mobilenation withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"mobile",@"login_type",
                                       mobile,@"mobile_num",
                                       type,@"vcode_type",
                                       mobilenation,@"mobile_nation",
                                       nil];
    parameters = [HNBUtils addGeneralKey:parameters];
    parameters = [HNBUtils addPlatformKey:parameters];
    [[HNBToast shareManager] toastWithOnView:nil msg:@"请稍后" afterDelay:DELAY_TIME style:HNBToastHudWaiting];
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",APIURL,@"user_register/vcodeSafe"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //成功
        int errCode= [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0){
            //NSLog(@"successed");
           
        }else{
            //显示HUD
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
            
        }
        suceedHandler(responseObject);
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
        // 显示HUD
        [[HNBToast shareManager] toastWithOnView:nil msg:@"出现错误" afterDelay:DELAY_TIME style:HNBToastHudFailure];
    }];
    
}

#pragma mark ------ v 2.3 手机 + 验证码登录接口

+(void)doLoginWithVcode:(NSString *)vcode mobile_num:(NSString *)mobile_num mobile_nation:(NSString *)mobile_nation im_state:(NSString *)im_state withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler{

    NSString *URLString = [NSString  stringWithFormat:@"%@/%@",APIURL,@"User_Login/loginByVcode"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       mobile_num,@"mobile_num",
                                       mobile_nation,@"mobile_nation",
                                       vcode,@"vcode",
                                       nil];
    
    // v3.0 新增参数 - 本地选择的移民状态、移民国家、移民城市
    NSString *cityID = [HNBUtils sandBoxGetInfo:[NSString class] forKey:IMED_Local_City];
    NSString *nationID = [HNBUtils sandBoxGetInfo:[NSString class] forKey:IMED_Local_Nation];
    if (im_state != nil && im_state.length > 0) {
        [parameters setObject:im_state forKey:@"im_state"];
    }
    if (nationID != nil && nationID.length > 0) {
        [parameters setObject:nationID forKey:@"country_id"];
    }
    if (cityID != nil && cityID.length > 0) {
        [parameters setObject:cityID forKey:@"city_id"];
    }
    
    [[HNBToast shareManager] toastWithOnView:nil msg:@"请稍后" afterDelay:0.f style:HNBToastHudWaiting];
    [HNBAFNetTool POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        if (errCode == 0) {
            
            [DataHandler doLoginWithVcodeHandleData:responseObject complete:^(id info) {
                [self loginNetEaseIMWithCompletion:nil];
            }];
            [[HNBToast shareManager] toastWithOnView:nil msg:@"登录成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
        }else{
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        
        suceedHandler(responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failHandler(error);
        [[HNBToast shareManager] toastWithOnView:nil msg:@"登录失败,请稍后重试" afterDelay:DELAY_TIME style:HNBToastHudFailure];
        
    }];
    
}

+(void)doRegisterWithMobile:(NSString *)mobile vcode_mobile_nation:(NSString *)mobilenation verifyCode:(NSString *)code password:(NSString *)password withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    
    RSAEncryptor *rsa = [[RSAEncryptor alloc] init];
    NSString *publicKeyPath = [[NSBundle mainBundle] pathForResource:@"public_ios" ofType:@"der"];
    [rsa loadPublicKeyFromFile:publicKeyPath];
    NSString *encryptedMobile = [rsa rsaEncryptString:mobile];
    NSString *encryptedPassword = [rsa rsaEncryptString:password];
    NSString *deviceToken = [HNBUtils sandBoxGetInfo:[NSString class] forKey:personal_device_token];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"mobile",@"login_type",
                                       encryptedMobile,@"mobile_num",
                                       mobilenation,@"mobile_nation",
                                       code,@"vcode",
                                       encryptedPassword,@"password",
                                       deviceToken,@"devicetoken",
                                       @PORT_VERSION ,@"port_version",
                                       nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    //显示HUD
    [[HNBToast shareManager] toastWithOnView:nil msg:@"请稍后" afterDelay:0.f style:HNBToastHudWaiting];
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",APIURL,@"user_register/registerSafe"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {

        //如果注册成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0){
            //NSLog(@" %s ",__FUNCTION__);
            [self saveCookies];
            [DataHandler doRegisterWithMobileHandleData:responseObject complete:^(id info) {
                [self loginNetEaseIMWithCompletion:nil];
            }];
            //修改成功
             [[HNBToast shareManager] toastWithOnView:nil msg:@"注册成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
        }else{
             [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        suceedHandler(responseObject);
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
        [[HNBToast shareManager] toastWithOnView:nil msg:@"注册出现错误" afterDelay:DELAY_TIME style:HNBToastHudFailure];
    }];
    
}

/* 第三方登录之后绑定手机号 */
+ (void)doCombineTElForRegister:(NSString *)VcodeString TEL:(NSString *)telNum vcode_mobile_nation:(NSString *)mobilenation withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    
    //显示HUD
    [[HNBToast shareManager] toastWithOnView:nil msg:@"请稍后" afterDelay:0.f style:HNBToastHudWaiting];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       telNum,@"mobile_num",
                                       mobilenation,@"mobile_nation",
                                       VcodeString,@"vcode",
                                       nil];
    parameters = [HNBUtils addPlatformKey:parameters];
//    NSLog(@"VcodeString = %@  telNum = %@ ",VcodeString,telNum);
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",APIURL,@"user_register/appCombineThirdUser"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //成功
        int errCode= [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0){
            //NSLog(@" %s ",__FUNCTION__);
            [self saveCookies];
            [DataHandler doCombineTElForRegisterHandleData:responseObject complete:^(id info) {
                [self loginNetEaseIMWithCompletion:nil];
            }];
            [[HNBToast shareManager] toastWithOnView:nil msg:@"绑定成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
        }else{
             [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        suceedHandler(responseObject);
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
        [[HNBToast shareManager] toastWithOnView:nil msg:@"出现错误" afterDelay:DELAY_TIME style:HNBToastHudFailure];
    }];
    
}

/* 绑定手机号 */
+ (void)doCombineTEl:(NSString *)VcodeString TEL:(NSString *)telNum vcode_mobile_nation:(NSString *)mobilenation withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    
    //显示HUD
    [[HNBToast shareManager] toastWithOnView:nil msg:@"请稍后" afterDelay:0.f style:HNBToastHudWaiting];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       telNum,@"mobile_num",
                                       mobilenation,@"mobile_nation",
                                       VcodeString,@"vcode",
                                       nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",APIURL,@"user_register/bindMobile"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //成功
        int errCode= [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0){
            //NSLog(@" %s ",__FUNCTION__);
            [self saveCookies];
            [DataHandler doCombineTElHandleData:responseObject complete:^(id info) {
                [self loginNetEaseIMWithCompletion:nil];
            }];
             [[HNBToast shareManager] toastWithOnView:nil msg:@"绑定成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
        }else{
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        suceedHandler(responseObject);
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
         [[HNBToast shareManager] toastWithOnView:nil msg:@"出现错误" afterDelay:DELAY_TIME style:HNBToastHudFailure];
    }];
    
}

+ (void)doForgetPWDSetpOne:(NSString *)telNum vcode_mobile_nation:(NSString *)mobilenation withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"mobile",@"login_type",
                                       telNum,@"mobile_num",
                                       mobilenation,@"mobile_nation",
                                       @"need_exist",@"vcode_type",
                                       @"find_pwd",@"from",
                                       nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    parameters = [HNBUtils addGeneralKey:parameters];
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",APIURL,@"user_register/vcodeSafe"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //成功
        int errCode= [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0){
//            NSLog(@"successed");
        }else{
            //显示HUD
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
        //显示HUD
        [[HNBToast shareManager] toastWithOnView:nil msg:@"出现错误" afterDelay:DELAY_TIME style:HNBToastHudFailure];
    }];
    
}

+ (void)doGetCoupon: (int)start  GetNum:(int)num Flag:(int)flag withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler;
{
    NSString *tmpStart = [NSString stringWithFormat:@"%d",start];
    NSString *tmpNum = [NSString stringWithFormat:@"%d",num];
    NSString *tmpFlag = [NSString stringWithFormat:@"%d",flag];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       tmpStart,@"start",
                                       tmpNum,@"num",
                                       tmpFlag,@"flag",
                                       nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"coupon/appGetUserCoupon"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            [DataHandler doGetCouponHandleData:responseObject tmpFlag:tmpFlag complete:nil];
            
        }
        else
        {
            NSLog(@"%@",[responseObject valueForKey:@"data"]);
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failHandler(error);
    }];
}

+ (void)entryUserInfoWithParameter:(NSString *)personId withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/personal_userinfo/getpersonInfobyid/%@",H5APIURL,personId];
//    NSLog(@"==================> 999999%@",urlStr);
    [HNBAFNetTool POST:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //            NSLog(@"responseObject --->  %@",responseObject);
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        int errorCode = [[responseDic valueForKey:@"state"] intValue];
        if (errorCode == 0) {
            
           [DataHandler entryUserInfoWithParameterHandleData:responseObject complete:^(id info) {
               
               if (suceedHandler) {
                   suceedHandler(info);
               }
               
           }];
            
        } else {
            NSLog(@"%@",[responseObject valueForKey:@"data"]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failHandler) {
            failHandler(error);
        }
    }];
    
}


#pragma mark - 改版(2.1) - 他人的个人中心
+ (void)showPersonnalInfoWithPersonId:(NSString *)personId withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    
    NSString *URLString = [NSString stringWithFormat:@"%@/Qa_App/getPersonInfoById?uid=%@",H5APIURL,personId];
    [HNBAFNetTool POST:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
//        NSDictionary *responseDic = (NSDictionary *)responseObject;
//        int errorCode = [[responseDic valueForKey:@"state"] intValue];
//        if (errorCode == 0) {
//            
//            [DataHandler showPersonnalInfoWithPersonIdHandleData:responseObject complete:^(id info) {
//                
//                if (suceedHandler) {
//                    suceedHandler(info);
//                }
//                
//            }];
//            
//        } else {
//            NSLog(@" 改版(2.1) - 他人的个人中心 : %@",[responseObject valueForKey:@"data"]);
//            if (suceedHandler) {
//                suceedHandler(responseDic);
//            }
//            
//        }

        [DataHandler showPersonnalInfoWithPersonIdHandleData:responseObject complete:^(id info) {
            
            if (suceedHandler) {
                suceedHandler(info);
            }
            
        }];

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failHandler) {
            failHandler(error);
            //NSLog(@" 改版(2.1) - 他人的个人中心 error: %@",error);
        }
        
    }];
    
}

#pragma mark - 改版(2.1) - 他人的个人中心 - TA的圈子
+ (void)doGetHisTribeDataWithPersonId:(NSString *)personId start:(NSInteger)start GetNum:(NSInteger)num withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler{

    
    NSDictionary *parameter = @{@"uid":personId,
                                @"start":[NSString stringWithFormat:@"%ld",(long)start],
                                @"num":[NSString stringWithFormat:@"%ld",(long)num]
                                };
    
    NSString *URLString = [NSString stringWithFormat:@"%@/Qa_App/getTribeInfoById",H5APIURL];
    [HNBAFNetTool POST:URLString parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        
//        NSDictionary *responseDic = (NSDictionary *)responseObject;
//        int errorCode = [[responseDic valueForKey:@"state"] intValue];
//        if (errorCode == 0) {
//            
//            [DataHandler doGetHisTribeDataWithPersonIdHandleData:responseObject complete:^(id info) {
//                
//                if (suceedHandler) {
//                    suceedHandler(info);
//                }
//                
//            }];
//
//        } else {
//            NSLog(@" 改版(2.1) - 他人的个人中心 - TA的圈子 : %@",[responseObject valueForKey:@"data"]);
//        }
        
        [DataHandler doGetHisTribeDataWithPersonIdHandleData:responseObject complete:^(id info) {
            
            if (suceedHandler) {
                suceedHandler(info);
            }
            
        }];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failHandler) {
            failHandler(error);
            //NSLog(@" 改版(2.1) - 他人的个人中心 - TA的圈子 error: %@",error);
        }
        
    }];
    
}

#pragma mark - 改版(2.1) - 他人的个人中心 - TA的问答
+ (void)doGetHisQADataWithPersonId:(NSString *)personId start:(NSInteger)start GetNum:(NSInteger)num withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler{

    NSDictionary *parameter = @{@"uid":personId,
                                @"start":[NSString stringWithFormat:@"%ld",(long)start],
                                @"num":[NSString stringWithFormat:@"%ld",(long)num]
                                };
    
    NSString *URLString = [NSString stringWithFormat:@"%@/Qa_App/getQaInfoById",H5APIURL];
    [HNBAFNetTool POST:URLString parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        int errorCode = [[responseDic valueForKey:@"state"] intValue];
        if (errorCode == 0) {
            
            [DataHandler doGetHisQADataWithPersonIdHandleData:responseObject complete:^(id info) {
                
                if (suceedHandler) {
                    suceedHandler(info);
                }
                
            }];
            
        } else {
            NSLog(@" 改版(2.1) - 他人的个人中心 - TA的问答 : %@",[responseObject valueForKey:@"data"]);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failHandler) {
            failHandler(error);
        }
        
    }];
    
}

#pragma mark - 他人的个人中心操作增添关注
+ (void)addFollowWithParameter:(NSString *)parameter withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    
//    [[HNBToast shareManager] toastWithOnView:nil msg:@"请稍后" afterDelay:0.f style:HNBToastHudWaiting];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/personal_follow/follow/%@",H5APIURL,parameter];
    [HNBAFNetTool POST:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger state = [[responseObject valueForKey:@"state"] integerValue];
        if (state == 0) {
//            [[HNBToast shareManager] toastWithOnView:nil msg:@"关注成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
            succeedHandler(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
        [[HNBToast shareManager] toastWithOnView:nil msg:@"关注出现错误" afterDelay:DELAY_TIME style:HNBToastHudFailure];
    }];
    
    
}

#pragma mark - 他人的个人中心操作取消关注
+ (void)removeFollowWithParameter:(NSString *)parameter withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    NSString *urlStr = [NSString stringWithFormat:@"%@/personal_follow/unfollow/%@",H5APIURL,parameter];
    [HNBAFNetTool POST:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger state = [[responseObject valueForKey:@"state"] integerValue];
        if (state == 0) {
            succeedHandler(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
         [[HNBToast shareManager] toastWithOnView:nil msg:@"取消关注出现错误" afterDelay:DELAY_TIME style:HNBToastHudFailure];
    }];
}

#pragma mark - 上传idfa
+ (void) doSendUserToken:(NSString *)idfaString DToken:(NSString *)dTokenString Type:(NSString *)type withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    // 显示HUD
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       idfaString,@"difa",
                                       dTokenString,@"dtoken",
                                       type,@"type",
                                       nil];
    
    parameters = [HNBUtils addGeneralKey:parameters];
    parameters = [HNBUtils addPlatformKey:parameters];
    
    [HNBAFNetTool POST:[NSString stringWithFormat:@"%@/%@",DATAURL,@"app/iosUserinfo"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
           succeedHandler(responseObject);
        }

        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}

+ (void)doSendUserUniqueFlagWithType:(NSString *)type withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler{

    /**
        type = 0时，token 此时并未返回值故可能为 空值
     */
    
    NSString *idfa = [HNBUtils sandBoxGetInfo:[NSString class] forKey:personal_idfa];
    NSString *fidfa = [HNBUtils sandBoxGetInfo:[NSString class] forKey:PRIVATE_FIDFA];
    NSString *token = [HNBUtils sandBoxGetInfo:[NSString class] forKey:personal_device_token];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       type,@"type",
                                       nil];
    if (idfa != nil || idfa.length > 0) {
        [parameters setObject:idfa forKey:@"difa"];
    }
    if (token != nil || token.length > 0) {
        [parameters setObject:token forKey:@"dtoken"];
    }
    if (fidfa != nil || fidfa.length > 0) {
        [parameters setObject:fidfa forKey:@"fdifa"];
    }
    parameters = [HNBUtils addGeneralKey:parameters];
    parameters = [HNBUtils addPlatformKey:parameters];
    [HNBAFNetTool POST:[NSString stringWithFormat:@"%@/%@",DATAURL,@"app/iosUserinfo"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            succeedHandler(responseObject);
        }
        
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
    
}

+ (void)doGetNewIndexMainInfo:(NSDictionary *)parameter withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    NSString *URLString = [NSString stringWithFormat:@"%@/%@",H5APIURL,@"index/getIndexInfo"];
    
    [HNBAFNetTool POST:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        if (errCode == 0) {
            
            [DataHandler doGetNewIndexMainInfoHandleData:responseObject complete:nil];
            succeedHandler(responseObject);
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failHandler(error);
        
    }];
}

+(void)doGetHomeTribesOrChineseDayInfo:(NSInteger)page withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    
    NSString *tmpImState = [HNBUtils sandBoxGetInfo:[NSString class] forKey:IM_INTENTION_LOCAL];
    if (nil == tmpImState) {
        tmpImState = @"";
    }
    NSString *tmpImnatons = [HNBUtils sandBoxGetInfo:[NSString class] forKey:IM_NATION_LOCAL];
    if (nil == tmpImnatons) {
        tmpImnatons = @"";
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       tmpImState,@"im_state",
                                       tmpImnatons,@"im_nation",
                                       nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    
    NSString *URLString = [NSString stringWithFormat:@"%@/%@?page=%ld",H5APIURL,@"index/getSelectInfo",page];
    [HNBAFNetTool POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        if (errCode == 0) {
            [DataHandler doGetHomeTribesOrChineseDayInfoHandleData:responseObject pageNum:page complete:^(id info) {
               
                succeedHandler(responseObject);
                
            }];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failHandler(error);
    }];

}

+ (void)doGetNewsCenterData:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler{

    
    NSString *URLString = [NSString  stringWithFormat:@"%@/%@",H5APIURL,@"index/getMessageNotice"];
    [HNBAFNetTool POST:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        if (errCode == 0) {
            
            [DataHandler doGetNewsCenterDataHandleData:responseObject complete:^(id info) {
                succeedHandler(info);
            }];
            
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failHandler(error);
        
    }];
    
    
}

+(void)doGetStateForProjectShowONHome:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler{

    
    NSString *URLString = [NSString  stringWithFormat:@"%@/%@",H5APIURL,@"Personal_Migrant/getRecentNotice"];
    
    [HNBAFNetTool POST:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [DataHandler doGetStateForProjectShowONHomeHandleData:responseObject complete:^(id info) {
        
            succeedHandler(info);
            
        }];

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"error ------>");
        
    }];
    
}


+(void)doGetImAssessRemindViewShowONHome:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler{

    NSString *URLString = [NSString stringWithFormat:@"%@/%@",H5APIURL,@"assess/assessNum"];
    [HNBAFNetTool POST:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        succeedHandler(responseObject);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failHandler(error);
        
    }];
    
}


+(void)doGetUserInfoAboutImassessionWithUserId:(NSString *)userID success:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler{

    NSString *idfa = [HNBUtils sandBoxGetInfo:[NSString class] forKey:personal_md5_idfa];
    NSString *fidfa = [HNBUtils sandBoxGetInfo:[NSString class] forKey:PRIVATE_MD5_FIDFA];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       idfa,@"idfa",
                                       userID,@"uid",
                                       nil];
    if (fidfa != nil || fidfa.length > 0) {
        [parameters setValue:fidfa forKey:@"fidfa"];
    }
    
    NSString *URLString = [NSString stringWithFormat:@"%@/assess/hasAssess",H5APIURL];
    [HNBAFNetTool POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (succeedHandler) {
            succeedHandler(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failHandler) {
            failHandler(error);
        }
        
    }];
    
}


#pragma mark ------ 移民评估弹框 ：人数 与 移民状态 两个接口和合并
+ (void)doGetInfoAboutImassessionWithUserId:(NSString *)userID success:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler{

    NSString *idfa = [HNBUtils sandBoxGetInfo:[NSString class] forKey:personal_md5_idfa];
    NSString *fidfa = [HNBUtils sandBoxGetInfo:[NSString class] forKey:PRIVATE_MD5_FIDFA];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       idfa,@"idfa",
                                       userID,@"uid",
                                       nil];
    if (fidfa != nil || fidfa.length > 0) {
        [parameters setValue:fidfa forKey:@"fidfa"];
    }
    
    NSString *URLString = [NSString stringWithFormat:@"%@/assess/hasAssessAndNum",H5APIURL];
    [HNBAFNetTool POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (succeedHandler) {
            succeedHandler(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failHandler) {
            failHandler(error);
        }
        
    }];

}

+ (void)doGetInfoAboutImassessionAlertWithUserId:(NSString *)userID success:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler{

    NSString *idfa = [HNBUtils sandBoxGetInfo:[NSString class] forKey:personal_md5_idfa];
    NSString *fidfa = [HNBUtils sandBoxGetInfo:[NSString class] forKey:PRIVATE_MD5_FIDFA];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       idfa,@"idfa",
                                       userID,@"uid",
                                       nil];
    if (fidfa != nil || fidfa.length > 0) {
        [parameters setValue:fidfa forKey:@"fidfa"];
    }
    
    NSString *URLString = [NSString stringWithFormat:@"%@/assess/assessPopAndNum",H5APIURL];
    [HNBAFNetTool POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (succeedHandler) {
            succeedHandler(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failHandler) {
            failHandler(error);
        }
        
    }];

}

+ (void)doCloseViewForProjectShowONHomeWithUserProjectID:(NSString *)parameter succeedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    
    NSString *URLString = [NSString stringWithFormat:@"%@/%@?noticeId=%@",H5APIURL,@"personal_migrant/viewNotice",parameter];
    
    [HNBAFNetTool POST:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        if (errCode == 0) {
        
            succeedHandler(responseObject);
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@" ---- > ");
        
    }];
    
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

+ (void)doSendPVInfo:(NSArray *)pvArray Count:(NSString *)count Time:(NSString *)time withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    NSMutableDictionary *JSONObject = [[NSMutableDictionary alloc] init];
    NSString *idfa = [HNBUtils sandBoxGetInfo:[NSString class] forKey:personal_idfa];
    if (idfa != nil || idfa.length > 0) {
        [JSONObject setValue:[HNBUtils md5HexDigest:idfa] forKey:@"idfa"];
    }
    NSString *fidfa = [HNBUtils sandBoxGetInfo:[NSString class] forKey:PRIVATE_FIDFA];
    if (fidfa != nil || fidfa.length > 0) {
        [JSONObject setValue:[HNBUtils md5HexDigest:fidfa] forKey:@"fidfa"];
    }
    
    [JSONObject setValue:pvArray forKey:@"pv"];
    [JSONObject setValue:count forKey:@"count"];
    [JSONObject setValue:time forKey:@"uploadingTime"];
    [HNBAFNetTool JSONPOST:[NSString stringWithFormat:@"%@/%@",DATAURL,@"stat/pvApp"] parameters:JSONObject success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            succeedHandler(responseObject);
        }
        
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];

}
+ (void)doSendAppOpenTimeInfo:(NSArray *)openArray Count:(NSString *)count Time:(NSString *)time withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    NSMutableDictionary *JSONObject = [[NSMutableDictionary alloc] init];
    NSString *idfa = [HNBUtils sandBoxGetInfo:[NSString class] forKey:personal_idfa];
    if (idfa != nil || idfa.length > 0) {
        [JSONObject setValue:[HNBUtils md5HexDigest:idfa] forKey:@"idfa"];
    }
    NSString *fidfa = [HNBUtils sandBoxGetInfo:[NSString class] forKey:PRIVATE_FIDFA];
    if (fidfa != nil || fidfa.length > 0) {
        [JSONObject setValue:[HNBUtils md5HexDigest:fidfa] forKey:@"fidfa"];
    }
    [JSONObject setValue:openArray forKey:@"time"];
    [JSONObject setValue:count forKey:@"count"];
    [JSONObject setValue:time forKey:@"uploadingTime"];
    
    [HNBAFNetTool JSONPOST:[NSString stringWithFormat:@"%@/%@",DATAURL,@"stat/timeapp/open"] parameters:JSONObject success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            succeedHandler(responseObject);
        }
        
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];

}

+ (void)doSendPVTimeInfo:(NSArray *)pvArray Count:(NSString *)count Time:(NSString *)time withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    //显示HUD
    NSMutableDictionary *JSONObject = [[NSMutableDictionary alloc] init];
    NSString *idfa = [HNBUtils sandBoxGetInfo:[NSString class] forKey:personal_idfa];
    if (idfa != nil || idfa.length > 0) {
        [JSONObject setValue:[HNBUtils md5HexDigest:idfa] forKey:@"idfa"];
    }
    NSString *fidfa = [HNBUtils sandBoxGetInfo:[NSString class] forKey:PRIVATE_FIDFA];
    if (fidfa != nil || fidfa.length > 0) {
        [JSONObject setValue:[HNBUtils md5HexDigest:fidfa] forKey:@"fidfa"];
    }
    [JSONObject setValue:pvArray forKey:@"time"];
    [JSONObject setValue:count forKey:@"count"];
    [JSONObject setValue:time forKey:@"uploadingTime"];
    
    [HNBAFNetTool JSONPOST:[NSString stringWithFormat:@"%@/%@",DATAURL,@"stat/timeapp"] parameters:JSONObject success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            succeedHandler(responseObject);
        }
        
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}

+ (void)doSendClickInfo:(NSArray *)clickArray Count:(NSString *)count withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    //显示HUD
    NSMutableDictionary *JSONObject = [[NSMutableDictionary alloc] init];
    
    NSString *idfa = [HNBUtils sandBoxGetInfo:[NSString class] forKey:personal_idfa];
    if (idfa != nil || idfa.length > 0) {
        [JSONObject setValue:[HNBUtils md5HexDigest:idfa] forKey:@"idfa"];
    }
    NSString *fidfa = [HNBUtils sandBoxGetInfo:[NSString class] forKey:PRIVATE_FIDFA];
    if (fidfa != nil || fidfa.length > 0) {
        [JSONObject setValue:[HNBUtils md5HexDigest:fidfa] forKey:@"fidfa"];
    }
    
    [JSONObject setValue:clickArray forKey:@"click"];
    [JSONObject setValue:count forKey:@"count"];
    [HNBAFNetTool JSONPOST:[NSString stringWithFormat:@"%@/%@",DATAURL,@"stat/clickApp"] parameters:JSONObject success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            succeedHandler(responseObject);
        }
        
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}


+ (void)doSendInterfaceTimeInfo:(NSArray *)interFaceArray Count:(NSString *)count withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    //显示HUD
    NSMutableDictionary *JSONObject = [[NSMutableDictionary alloc] init];
   
    
    NSString *idfa = [HNBUtils sandBoxGetInfo:[NSString class] forKey:personal_idfa];
    if (idfa != nil || idfa.length > 0) {
        [JSONObject setValue:[HNBUtils md5HexDigest:idfa] forKey:@"idfa"];
    }
    NSString *fidfa = [HNBUtils sandBoxGetInfo:[NSString class] forKey:PRIVATE_FIDFA];
    if (fidfa != nil || fidfa.length > 0) {
        [JSONObject setValue:[HNBUtils md5HexDigest:fidfa] forKey:@"fidfa"];
    }
    [JSONObject setValue:interFaceArray forKey:@"time"];
    [JSONObject setValue:count forKey:@"count"];
    
    [HNBAFNetTool JSONPOST:[NSString stringWithFormat:@"%@/%@",DATAURL,@"stat/timeapp/fun"] parameters:JSONObject success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            
            succeedHandler(responseObject);
        }
        
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}

+ (void)doSendWebOpenFailureWithErrorURLStr:(NSString *)errurlstr error:(NSError *)err errDes:(NSString *)errDes{
    
    NSString *URLString = [NSString stringWithFormat:@"%@/%@",DATAURL,@"stat/errorApp"];
    // 当前日期字符串
    NSString *currentDateString = [HNBUtils returnTimestamp];
    // 错误上报标识 - id
    if (errurlstr == nil || [errurlstr isEqualToString:@"null"]) {
        errurlstr = @"发生错误，未取到URLString";
    }
    NSString *upID = [NSString stringWithFormat:@"errurlstr:%@",errurlstr];
    
    // 设备信息 : 手机名字_型号_系统名字_系统版本
    NSString *platformInfo = [NSString stringWithFormat:@"model:%@_name:%@_systemName:%@_systemVersion:%@",[UIDevice currentDevice].model,[UIDevice currentDevice].name,[UIDevice currentDevice].systemName,[UIDevice currentDevice].systemVersion];
    // APP 信息 : app 名字 _app 版本
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *appInfo = [NSString stringWithFormat:@"name:%@_appVersion:%@",[bundleInfo objectForKey:@"CFBundleDisplayName"],[bundleInfo objectForKey:@"CFBundleShortVersionString"]];
    // 拼接错误信息
    NSDictionary *errInfoDict = @{
                                  @"platformInfo":platformInfo,
                                  @"appInfo":appInfo,
                                  @"err_urlstr":errurlstr,
                                  @"errorDes":errDes,
                                  @"error":[NSString stringWithFormat:@"%@",err]
                                  };
    NSDictionary *exceptionDict = @{
                                    @"id":upID,
                                    @"content":errInfoDict
                                    };
    NSDictionary *para = @{
                           @"uploadingTime":currentDateString,
                           @"exception":@[exceptionDict]
                           };
    
    [HNBAFNetTool webOpenFailPOST:URLString parameters:para success:^(NSURLSessionDataTask *task, id responseObject) {
        //NSLog(@" 上报成功 :%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //NSLog(@" 上报失败 :%@",error);
    }];
    
}

+ (void)doGetHotTribesInTribeIndex:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"index/getHotTribe"] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            [DataHandler doGetHotTribesInTribeIndexInfoHandleData:responseObject complete:^(id info) {
                succeedHandler(info);
            }];
        }
        
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}

+(void)doGetTribeInfoWithTribeID:(NSString *)tribe_id withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler{

    NSDictionary *parameter = @{@"tribe_id":tribe_id};
    
    NSString *URLString = [NSString stringWithFormat:@"%@/index/getTribeInfo",H5APIURL];
    
    [HNBAFNetTool POST:URLString parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0){
            [DataHandler doGetTribeInfoHandleData:responseObject complete:^(id info) {
                succeedHandler(info);
            }];
        
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
    
}

#pragma mark - addFollowTribe
+(void)addFollowTribeWithParameter:(NSString *)parameter withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    
    [[HNBToast shareManager] toastWithOnView:nil msg:@"请稍后" afterDelay:0.f style:HNBToastHudWaiting];
    NSString *urlString = [NSString stringWithFormat:@"%@/tribe/joinTribe?tribe_id=%@",APIURL,parameter];
    [HNBAFNetTool POST:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger state = [[responseObject valueForKey:@"state"] integerValue];
        if (state == 0) {
            [[HNBToast shareManager] toastWithOnView:nil msg:@"关注成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
            succeedHandler(responseObject);
            
        }else{
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
        [[HNBToast shareManager] toastWithOnView:nil msg:@"关注出现错误" afterDelay:DELAY_TIME style:HNBToastHudFailure];
    }];
    
    
}

#pragma mark - removeFollowTribe
+(void)removeFollowTribeWithParameter:(NSString *)parameter withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    
    [[HNBToast shareManager] toastWithOnView:nil msg:@"请稍后" afterDelay:0.f style:HNBToastHudWaiting];
    NSString *urlString = [NSString stringWithFormat:@"%@/tribe/leaveTribe?tribe_id=%@",APIURL,parameter];
    [HNBAFNetTool POST:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger state = [[responseObject valueForKey:@"state"] integerValue];
        if (state == 0) {
            [[HNBToast shareManager] toastWithOnView:nil msg:@"取消关注成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
            succeedHandler(responseObject);
        }else{
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
         [[HNBToast shareManager] toastWithOnView:nil msg:@"取消关注出现错误" afterDelay:DELAY_TIME style:HNBToastHudFailure];
    }];
}


+ (void)doGetTribeDetailInfoWithTribeID:(NSString *)tribe_id sortType:(NSString *)sort_type start:(NSInteger)start GetNum:(NSInteger)num withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    
    NSDictionary *parameter = @{@"tribe_id":tribe_id,
                                @"start":[NSString stringWithFormat:@"%ld",(long)start],
                                @"number":[NSString stringWithFormat:@"%ld",(long)num],
                                @"sort_type":sort_type};
    
    NSString *URLString = [NSString stringWithFormat:@"%@/index/getTribeThemeList",H5APIURL];
    [HNBAFNetTool POST:URLString parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            [DataHandler doGetTribeDetailInfoHandleData:responseObject sort_type:sort_type complete:^(id info) {
               
                succeedHandler(info);
                
            }];
        }
        
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failHandler(error);
        
    }];
    
}

+ (void)doGetHotPostInTribeIndex:(NSInteger)start  GetNum:(NSInteger)num withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    NSString *tmpStart = [NSString stringWithFormat:@"%ld",(long)start];
    NSString *tmpNum = [NSString stringWithFormat:@"%ld",(long)num];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       tmpStart,@"start",
                                       tmpNum,@"number",
                                       nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"index/getHotTribeTheme"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            [DataHandler doGetHotPostInTribeIndexsInfoHandleData:responseObject complete:nil];
            suceedHandler(responseObject);
        } 
        
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];

}

+(void)doZanCommentWithId:(NSString *)comment_id withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       comment_id,@"commentId",
                                       nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    NSString *URLString = [NSString  stringWithFormat:@"%@/%@",APIURL,@"comment/praise"];
    [HNBAFNetTool POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            
            suceedHandler(responseObject);
            
        }else{
            
            //[[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
            
        }
        
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
        //[[HNBToast shareManager] toastWithOnView:nil msg:@"" afterDelay:DELAY_TIME style:HNBToastHudFailure];
    }];
    


}

#pragma mark ------ 回复详情

+(void)doGetCommentDetailWithCommentId:(NSString *)comment_id withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler{

    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      comment_id,@"comment_id",
                                      nil];
    parameter = [HNBUtils addPlatformKey:parameter];
    NSString *URLString = [NSString stringWithFormat:@"%@/%@",H5APIURL,@"theme/getCommentDetail"];
    [HNBAFNetTool POST:URLString parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        if (errCode == 0) {
        
            [DataHandler doGetCommentDetailWithCommentIdHandleData:responseObject complete:^(id info) {
                
                suceedHandler(info);
                
            }];
            
        }else{
        
            
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failHandler(error);
        
    }];
    
}

+(void)doGetTribeInfoWithThemeId:(NSString *)theme_id withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       theme_id,@"theme_id",
                                       nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    NSString *URLString = [NSString  stringWithFormat:@"%@/%@",H5APIURL,@"theme/getTribeInfoByTheme"];
    [HNBAFNetTool POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            
            [DataHandler doGetTribeInfoWithThemeIdHandleData:responseObject complete:^(id info) {
                suceedHandler(info);
            }];
            
        }else{
            
            
        }
        
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
    
    
    
}

#pragma mark ------ 帖子详情

+(void)doGetCommentInDetailThemPageWithThemID:(NSString *)theme_id pageNum:(NSInteger)pageNum withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler {
    NSString *pageNumString = [NSString stringWithFormat:@"%ld",(long)pageNum];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       theme_id,@"theme_id",
                                       pageNumString,@"page",
                                       nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    NSString *URLString = [NSString  stringWithFormat:@"%@/%@",H5APIURL,@"theme/getComment"];
    [HNBAFNetTool POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0) {
            [DataHandler doGetCommentInDetailThemPageWithThemIDHandleData:responseObject complete:^(id info) {
                suceedHandler(info);
            }];
        } else {
            //[[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
        //[[HNBToast shareManager] toastWithOnView:nil msg:@"" afterDelay:DELAY_TIME style:HNBToastHudFailure];
    }];
}

+(void)doGetLZCommentInDetailThemPageWithThemID:(NSString *)theme_id pageNum:(NSInteger)pageNum withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    
    NSString *pageNumString = [NSString stringWithFormat:@"%ld",(long)pageNum];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       theme_id,@"theme_id",
                                       pageNumString,@"page",
                                       @"1",@"justlookowner",
                                       nil];
    
    parameters = [HNBUtils addPlatformKey:parameters];
    NSString *URLString = [NSString  stringWithFormat:@"%@/%@",H5APIURL,@"theme/getComment"];
    [HNBAFNetTool POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            
            [DataHandler doGetCommentInDetailThemPageWithThemIDHandleData:responseObject complete:^(id info) {
                suceedHandler(info);
            }];
            
        }else{
            
            //[[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
            
        }
        
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
        //[[HNBToast shareManager] toastWithOnView:nil msg:@"" afterDelay:DELAY_TIME style:HNBToastHudFailure];
    }];
    
    
}


+ (void)doReportWithType:(NSString *)reportType reportId:(NSString *)reportId desc:(NSString *)desc withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler{

    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                                             reportType,@"type",
                                                                             reportId,@"id",
                                                                             desc,@"desc",
                                                                                    nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    NSString *URLString = [NSString  stringWithFormat:@"%@/%@",H5APIURL,@"report"];
    [HNBAFNetTool POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            
           [[HNBToast shareManager] toastWithOnView:nil msg:@"举报成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
            
        }else{
            
            [[HNBToast shareManager] toastWithOnView:nil msg:@"举报失败" afterDelay:DELAY_TIME style:HNBToastHudFailure];
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [[HNBToast shareManager] toastWithOnView:nil msg:@"举报失败" afterDelay:DELAY_TIME style:HNBToastHudFailure];
        
    }];
    
}

+ (void)doGetSearchRelationWords:(NSString *)word  withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       word,@"words",
                                       nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"search/getSuggest"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            suceedHandler(responseObject);
        }
        
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];

}

+ (void)doGetQASearchRelationWords:(NSString *)word  withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"qa",@"searchRange",
                                       word,@"words",
                                       nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"search/getSuggest"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            suceedHandler(responseObject);
        }
        
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}

+ (void)doGetQAIndexQuestionList:(NSInteger)start  GetNum:(NSInteger)num withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    NSString *tmpStart = [NSString stringWithFormat:@"%ld",(long)start];
    NSString *tmpNum = [NSString stringWithFormat:@"%ld",(long)num];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       tmpNum,@"num",
                                       tmpStart,@"start",
                                       nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"Qa_App/getIndexQuestionList"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            [DataHandler doGetQAIndexQuestionList:responseObject complete:nil];
            suceedHandler(responseObject);

        }
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}


+ (void)doGetQAQuestionListByLabels:(NSString *)labels shoudInDatabase:(BOOL)inDatabase Start:(NSInteger)start  GetNum:(NSInteger)num withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    NSString *tmpStart = [NSString stringWithFormat:@"%ld",(long)start];
    NSString *tmpNum = [NSString stringWithFormat:@"%ld",(long)num];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       labels,@"labels",
                                       tmpNum,@"num",
                                       tmpStart,@"start",
                                       nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"Qa_App/getIndexQuestionListByLabels"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            if (inDatabase) {
                [DataHandler doGetQAQuestionListByLabels:responseObject complete:nil];
            }
            suceedHandler(responseObject);
            
        }
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}

+ (void)doGetSpecialistsList:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"Qa_App/getSpecialists"] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            [DataHandler doGetSpecialistsList:responseObject complete:nil];
            succeedHandler(responseObject);
        }
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}

+ (void)doGetQAQustionRelationWords:(NSString *)word withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       word,@"words",
                                       nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"Qa_App/GetQustionWords"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            suceedHandler(responseObject);
        }
        
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}

+ (void) doGetCollectQuestion:(NSString *)q_id CanceleOrCollect:(BOOL) isCollect  withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    NSString *tmpUrl = [NSString  stringWithFormat:@"%@/%@",H5APIURL,@"qa_question/"];
    if (isCollect) {
        tmpUrl = [tmpUrl stringByAppendingString:@"favorite/"];
    }
    else
    {
        tmpUrl = [tmpUrl stringByAppendingString:@"unfavorite/"];
    }
    tmpUrl = [tmpUrl stringByAppendingString:q_id];
    [HNBAFNetTool GET:tmpUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            suceedHandler(responseObject);
            
        }else{
        
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
            
        }
        
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}

+ (void) doGetCollectTheme:(NSString *)t_id CanceleOrCollect:(BOOL) isCollect  withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    NSString *tmpUrl = [NSString  stringWithFormat:@"%@/%@",H5APIURL,@"theme/"];
    if (isCollect) {
        tmpUrl = [tmpUrl stringByAppendingString:@"favorite/"];
    }
    else
    {
        tmpUrl = [tmpUrl stringByAppendingString:@"unfavorite/"];
    }
    tmpUrl = [tmpUrl stringByAppendingString:t_id];
    [HNBAFNetTool GET:tmpUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            suceedHandler(responseObject);
            
        }else{
        
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}

+(void)doSendAppointmentPhoneNum:(NSString *)phone withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       phone,@"phone", nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"project/resCallBack"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //如果成功
//        NSLog(@"%@",responseObject);
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
//            NSLog(@"successed");
        }
        else
        {
            NSLog(@"%@",[responseObject valueForKey:@"data"]);
        }
        
        suceedHandler(responseObject);
    }failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}

+(void)doGetPageHTML:(NSString *)url MD5:(NSString *)md5String withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
//    NSString *tmpUrl = [NSString stringWithFormat:@"%@?&is_local=1&md5=%@",url,md5String];
//    NSURLSession* session = [NSURLSession sessionWithConfiguration:
//                             [NSURLSessionConfiguration defaultSessionConfiguration]];
//    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:tmpUrl]];
//    NSURLSessionDataTask* task =
//    [session dataTaskWithRequest:request
//               completionHandler:^(NSData * _Nullable data,
//                                   NSURLResponse * _Nullable response,
//                                   NSError * _Nullable error) {
////                   NSString * tmpString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
////                   NSString *tmpMd5 = [HNBUtils md5HexDigest:tmpString];
////                   [HNBUtils writeToFile:tmpString filename:@"national.html"];
//                   suceedHandler(data);
//                   
//               }];
//    [task resume];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"1",@"is_local",
                                       md5String,@"md5",
                                       nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    [HNBAFNetTool HTMLPOST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //如果成功
//        NSString * tmpString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"%@",tmpString);
//        int errCode=   [[responseObject valueForKey:@"state"] intValue];
//        if(errCode == 0)
//        {
//            NSLog(@"successed");
//        }
//        else
//        {
//            NSLog(@"%@",[responseObject valueForKey:@"data"]);
//        }
        
        suceedHandler(responseObject);
    }failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];

}
+ (void)doSendCouponCode:(NSString *)code withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    RSAEncryptor *rsa = [[RSAEncryptor alloc] init];
    NSString *publicKeyPath = [[NSBundle mainBundle] pathForResource:@"public_ios" ofType:@"der"];
    [rsa loadPublicKeyFromFile:publicKeyPath];
    
    NSString *encryptedFinalString = [rsa rsaEncryptString:code];

    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       encryptedFinalString,@"promo-code",
                                       nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"coupon/exchangePromoCodeApp"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        int stateCode = [[responseObject valueForKey:@"state"] intValue];
        suceedHandler(responseObject);
        if (stateCode == 0) {
            [[HNBToast shareManager] toastWithOnView:nil msg:@"领取成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
        }
        else
        {
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        
        
    }failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"网络错误" afterDelay:DELAY_TIME style:HNBToastHudFailure];
        failHandler(error);
    }];

}

#pragma mark - 改版(2.6) - 他人的个人中心 - 回帖
+ (void)doGetHisReplyDataWithPersonId:(NSString *)personId start:(NSInteger)start GetNum:(NSInteger)num withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    NSDictionary *parameter = @{@"u_id":personId,
                                @"start":[NSString stringWithFormat:@"%ld",(long)start],
                                @"num":[NSString stringWithFormat:@"%ld",(long)num]
                                };
    
    NSString *URLString = [NSString stringWithFormat:@"%@/personal_userinfo/getCommentTrends",H5APIURL];
    [HNBAFNetTool POST:URLString parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        int errorCode = [[responseDic valueForKey:@"state"] intValue];
        if (errorCode == 0) {
            
            [DataHandler doGetHisReplyDataWithPersonIdHandleData:responseObject complete:^(id info) {
                
                if (suceedHandler) {
                    suceedHandler(info);
                }
                
            }];
            
        } else {
            NSLog(@" 改版(2.6) - 他人的个人中心 - 回帖 : %@",[responseObject valueForKey:@"data"]);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failHandler) {
            //如果不成功，取值是0
            [HNBUtils sandBoxSaveInfo:@"0" forKey:userinfo_hisReply_total];
            failHandler(error);
        }
        
    }];
}

#pragma mark - 改版(2.6) - 他人的个人中心 - 发帖
+ (void)doGetHisPostDataWithPersonId:(NSString *)personId start:(NSInteger)start GetNum:(NSInteger)num withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    NSDictionary *parameter = @{@"u_id":personId,
                                @"start":[NSString stringWithFormat:@"%ld",(long)start],
                                @"num":[NSString stringWithFormat:@"%ld",(long)num]
                                };
    
    NSString *URLString = [NSString stringWithFormat:@"%@/personal_userinfo/getThemeTrends",H5APIURL];
    [HNBAFNetTool POST:URLString parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        int errorCode = [[responseDic valueForKey:@"state"] intValue];
        if (errorCode == 0) {
            
            [DataHandler doGetHisPostDataWithPersonIdHandleData:responseObject complete:^(id info) {
                
                if (suceedHandler) {
                    suceedHandler(info);
                }
                
            }];
            
        } else {
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failHandler) {
            //如果不成功，取值是0
            [HNBUtils sandBoxSaveInfo:@"0" forKey:userinfo_hisPost_total];
            
            failHandler(error);
        }
        
    }];
}

#pragma mark - 分页(2.6) - 移民攻略

+(void)doGetActivityIndexWithType:(NSString *)type start:(NSInteger)start GetNum:(NSInteger)num withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    NSDictionary *parameter = @{@"type":type,
                                @"start":[NSString stringWithFormat:@"%ld",(long)start],
                                @"num":[NSString stringWithFormat:@"%ld",(long)num]
                                };
    
    NSString *URLString = [NSString stringWithFormat:@"%@/raiders/getInfoListByType",H5APIURL];
    [HNBAFNetTool POST:URLString parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        int errorCode = [[responseDic valueForKey:@"state"] intValue];
        if (errorCode == 0) {
            
            [DataHandler doGetActivityIndexHandleData:responseObject complete:^(id info) {
                
                if (suceedHandler) {
                    suceedHandler(info);
                }
                
            }];
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failHandler) {
            //如果不成功，取值是0
            
            failHandler(error);
        }
        
    }];
}

#pragma mark - 分页(2.8.7) - 活动页，首次进入
+ (void)dogetActivityIndexFirstWithType:(NSString *)type start:(NSInteger)start GetNum:(NSInteger)num withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    NSDictionary *parameter = @{@"type":type,
                                @"start":[NSString stringWithFormat:@"%ld",(long)start],
                                @"num":[NSString stringWithFormat:@"%ld",(long)num]
                                };
    
    NSString *URLString = [NSString stringWithFormat:@"%@/raiders/getInfoListAndNumByType",H5APIURL];
    [HNBAFNetTool POST:URLString parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSDictionary *dataDic = (NSDictionary *)[responseObject valueForKey:@"data"];
        /*获取当前type的数据总数*/
        if ([type isEqualToString:@"seminar"]) {
            NSString *total = [dataDic valueForKey:@"total"];
            [HNBUtils sandBoxSaveInfo:total forKey:activity_seminar_total];
        }else if ([type isEqualToString:@"class"]){
            NSString *total = [dataDic valueForKey:@"total"];
            [HNBUtils sandBoxSaveInfo:total forKey:activity_class_total];
        }else if ([type isEqualToString:@"interview"]){
            NSString *total = [dataDic valueForKey:@"total"];
            [HNBUtils sandBoxSaveInfo:total forKey:activity_interview_total];
        }else if ([type isEqualToString:@"activity"]){
            NSString *total = [dataDic valueForKey:@"total"];
            [HNBUtils sandBoxSaveInfo:total forKey:activity_IMActivity_total];
        }
        int errorCode = [[responseDic valueForKey:@"state"] intValue];
        if (errorCode == 0) {
            
            [DataHandler doGetActivityIndexHandleData:responseObject complete:^(id info) {
                
                if (suceedHandler) {
                    suceedHandler(info);
                }
                
            }];
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failHandler) {
            //如果不成功，取值是0
            
            failHandler(error);
        }
        
    }];
}

+ (void)doGetActivityIndexwithType:(NSString *)type SucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    NSString *URLString = [NSString stringWithFormat:@"%@/Raiders/getIndex",H5APIURL];
    [HNBAFNetTool POST:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        int errorCode = [[responseDic valueForKey:@"state"] intValue];
        if (errorCode == 0) {
            [DataHandler doGetActivityTotalHandleDataByType:type responseObject:responseObject complete:^(id info) {
                if (suceedHandler) {
                    suceedHandler(info);
                }
            }];
            
        } else {
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failHandler) {
            //如果不成功，取值是0
            
            failHandler(error);
        }
        
    }];
}

+ (void)doGetContryAndProject:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    NSString *urlString = [NSString stringWithFormat:@"%@/national/getNationAndProject",H5APIURL];
    [HNBAFNetTool POST:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        int errorCode = [[responseDic valueForKey:@"state"] intValue];
        if (errorCode == 0) {
            [DataHandler doGetContryAndProjectHandleData:responseObject complete:^(id info) {
                suceedHandler(info);
            }];
        }else{
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject returnValueWithKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
            suceedHandler(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"请求出错" afterDelay:DELAY_TIME style:HNBToastHudFailure];
        failHandler(error);
    }];
}

+ (void)doGetContryAndProjectWithLocalCachedHandler:(DataFetchLocalCachedHandler)cacheRes succeedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    
    NSString *URLString = [NSString stringWithFormat:@"%@/national/getNationAndProject",H5APIURL];
    id cacheRlt = [HNBFileManager httpCacheForURL:URLString parameters:nil];
    if (cacheRlt != nil) {
        [DataHandler doGetContryAndProjectHandleData:cacheRlt complete:^(id info) {
            cacheRes(info);
        }];
    }
    [HNBAFNetTool POST:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        int errorCode = [[responseDic valueForKey:@"state"] intValue];
        if (errorCode == 0) {
            [DataHandler doGetContryAndProjectHandleData:responseObject complete:^(id info) {
                suceedHandler(info);
                [HNBFileManager setHttpCache:responseObject URL:URLString parameters:nil];
            }];
        }else{
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject returnValueWithKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
            suceedHandler(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"请求出错" afterDelay:DELAY_TIME style:HNBToastHudFailure];
        failHandler(error);
    }];
    
}


+ (void)doGetIsShowConditionTest:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"config/symbol?configName=doShowConditionTest"] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            NSArray *dataArr = [responseObject valueForKey:@"data"];
            NSString *isShow;
            if (dataArr.count != 0) {
                isShow = [dataArr[0] valueForKey:@"isHidden"];
            }
            
            [HNBUtils sandBoxSaveInfo:isShow forKey:HOME_ISSHOW_CONDITIONTEST];
        }
        
        suceedHandler(responseObject);
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}

+ (void)deleteThemeWithThemeID:(NSString *)themeID withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler {
    NSDictionary *parameter = @{@"id":themeID};
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",APIURL,@"theme/delete"] parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        if (errCode == 0) {
            
        }
        
        suceedHandler(responseObject);
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
    
}

+ (void)getThemeInfoWithThemeID:(NSString *)themeID withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler {
    NSDictionary *parameter = @{@"theme_id":themeID};
//    NSString *trueURL = @"theme/getThemeInfo";
    NSString *testURL = @"theme/getThemeInfotest";
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",APIURL,testURL] parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        if (errCode == 0) {
            
        }else{
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        
        suceedHandler(responseObject);
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"请求出错" afterDelay:DELAY_TIME style:HNBToastHudFailure];
        failHandler(error);
    }];
    
}

+ (void)gettabInIMProjectHomewithSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler {
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/national/gettab",H5APIURL] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        if (errCode == 0) {
            [DataHandler doGetTabInIMProjectHome:responseObject complete:^(id info) {
                suceedHandler(info);
            }];
        }else{
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
            suceedHandler(responseObject);
        }
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"请求出错" afterDelay:DELAY_TIME style:HNBToastHudFailure];
        failHandler(error);
    }];
}


+(void)gettabInIMProjectHomeWithLocalCachedHandler:(DataFetchLocalCachedHandler)cacheRes succeedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    
    NSString *URLString = [NSString  stringWithFormat:@"%@/national/gettab",H5APIURL];
    id cacheRlt = [HNBFileManager httpCacheForURL:URLString parameters:nil];
    if (cacheRlt != nil) {
        [DataHandler doGetTabInIMProjectHome:cacheRlt complete:^(id info) {
            cacheRes(info);
        }];
    }
    
    [HNBAFNetTool POST:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        if (errCode == 0) {
            [DataHandler doGetTabInIMProjectHome:responseObject complete:^(id info) {
                suceedHandler(info);
                [HNBFileManager setHttpCache:responseObject URL:URLString parameters:nil];
            }];
        }else{
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
            suceedHandler(responseObject);
        }
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"请求出错" afterDelay:DELAY_TIME style:HNBToastHudFailure];
        failHandler(error);
    }];
}

+ (void)getInfoByTabInIMProjectHomeWithID:(NSString *)ID withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler {
    NSDictionary *parameter = @{@"id":ID};
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/transact/getInfoByTab",H5APIURL] parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        if (errCode == 0) {
            [DataHandler getInfoByTabInIMProjectHome:responseObject complete:^(id info) {
                suceedHandler(info);
            }];
        }else{
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        //        suceedHandler(responseObject);
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"请求出错" afterDelay:DELAY_TIME style:HNBToastHudFailure];
        failHandler(error);
    }];
}

+ (void)doGetHotImmigrantProjectsWithSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    
    NSString *URLString = [NSString stringWithFormat:@"%@/Api_Config/data.html?config_name=newhomerecommandactivitylist&ver=3.0.0",H5APIURL];
    [HNBAFNetTool POST:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        if (errCode == 0) {
            [DataHandler doGetHotImmigrantProjectsHandleData:responseObject complete:^(id info) {
                suceedHandler(info);
            }];
        }else{
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
    
    
}


+ (void)doLoginWithThirdPartWithType:(NSString *)type Access_Token:(NSString *)access_token Open_ID:(NSString *)open_id im_state:(NSString *)im_state withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler {
    
    [[HNBToast shareManager] toastWithOnView:nil msg:@"请稍后" afterDelay:0.f style:HNBToastHudWaiting];
    
//    if ([type isEqualToString:WX_LOGIN_TYPE]) {
//        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//        [config setHTTPAdditionalHeaders:@{ @"User-Agent" : @"App_IOS_Hinabian"}];
//    }
    RSAEncryptor *rsa = [[RSAEncryptor alloc] init];
    NSString *publicKeyPath = [[NSBundle mainBundle] pathForResource:@"public_ios" ofType:@"der"];
    [rsa loadPublicKeyFromFile:publicKeyPath];
    
    NSString* AccessTokenEncode = [access_token stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* OpenIdEncode = [open_id stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * appdate = [HNBUtils getCruntTime];
    NSString * finalString = [NSString stringWithFormat:@"%@:%@:%@",AccessTokenEncode,OpenIdEncode,appdate];
    
    NSString *encryptedFinalString = [rsa rsaEncryptString:finalString];
    
    NSString * deviceToken = [HNBUtils sandBoxGetInfo:[NSString class] forKey:personal_device_token];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       type,@"type",
                                       encryptedFinalString,@"log_key",
                                       deviceToken,@"devicetoken",
                                       nil];
    
    // v3.0 新增参数 - 本地选择的移民状态、移民国家、移民城市
    NSString *cityID = [HNBUtils sandBoxGetInfo:[NSString class] forKey:IMED_Local_City];
    NSString *nationID = [HNBUtils sandBoxGetInfo:[NSString class] forKey:IMED_Local_Nation];
    if (im_state != nil && im_state.length > 0) {
        [parameters setObject:im_state forKey:@"im_state"];
    }
    if (nationID != nil && nationID.length > 0) {
        [parameters setObject:nationID forKey:@"country_id"];
    }
    if (cityID != nil && cityID.length > 0) {
        [parameters setObject:cityID forKey:@"city_id"];
    }
    parameters = [HNBUtils addPlatformKey:parameters];
    
    NSString *URLString = [NSString  stringWithFormat:@"%@/%@",APIURL,@"Api_ThirdLogin/hasPhone"];
    [HNBAFNetTool POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int state =   [[responseObject valueForKey:@"state"] intValue];
        int errorCode = [[responseObject valueForKey:@"errorCode"] intValue];
        if(state == 0){
            //NSLog(@" %s ",__FUNCTION__);
            [self saveCookies];
            if (errorCode == 0) {
                //有账号、有手机号正常登陆了
                //NSLog(@" %s ",__FUNCTION__);
                [self saveCookies];
                [DataHandler doLoginWithThirdPartHandleData:responseObject complete:^(id info) {
                    [self loginNetEaseIMWithCompletion:nil];
                }];
                [[HNBToast shareManager] toastWithOnView:nil msg:@"登录成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
            }else {
                [[HNBToast shareManager] toastWithOnView:nil msg:@"请稍后" afterDelay:0.1f style:HNBToastHudWaiting];
            }
        } else{
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
        [[HNBToast shareManager] toastWithOnView:nil msg:@"出现错误" afterDelay:DELAY_TIME style:HNBToastHudFailure];
    }];
}

+ (void)requestPhoneNumIsBindWithType:(NSString *)type TEL:(NSString *)telNum mobile_nation:(NSString *)mobilenation withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler {
    
//    if ([type isEqualToString:WX_LOGIN_TYPE]) {
//        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//        [config setHTTPAdditionalHeaders:@{ @"User-Agent" : @"App_IOS_Hinabian"}];
//    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       type,@"type",
                                       mobilenation,@"mobile_nation",
                                       telNum,@"mobile_num",
                                       nil];
    parameters = [HNBUtils addPlatformKey:parameters];
    
    NSString *URLString = [NSString  stringWithFormat:@"%@/%@",APIURL,@"Api_ThirdLogin/hasPhoneAndThird"];
    [HNBAFNetTool POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int state =   [[responseObject valueForKey:@"state"] intValue];
        if(state == 0){
//            [self saveCookies];
//            if (errorCode == 0) {
//                //有账号、有手机号正常登陆了
//                [self saveCookies];
//                [DataHandler doLoginWithThirdPartHandleData:responseObject complete:nil];
//                [[HNBToast shareManager] toastWithOnView:nil msg:@"登录成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
//            }else {
//                [[HNBToast shareManager] toastWithOnView:nil msg:@"请稍后" afterDelay:0.1f style:HNBToastHudWaiting];
//            }
        } else{
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:2.0f style:HNBToastHudFailure];
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
        [[HNBToast shareManager] toastWithOnView:nil msg:@"出现错误" afterDelay:DELAY_TIME style:HNBToastHudFailure];
    }];
}

+ (void)doBindPhoneWithThirdPartType:(NSString *)type vCode:(NSString *)VcodeString TEL:(NSString *)telNum vcode_mobile_nation:(NSString *)mobilenation im_state:(NSString *)im_state withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler {
    
    [[HNBToast shareManager] toastWithOnView:nil msg:@"请稍后" afterDelay:0.f style:HNBToastHudWaiting];
    
//    if ([type isEqualToString:WX_LOGIN_TYPE]) {
//        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//        [config setHTTPAdditionalHeaders:@{ @"User-Agent" : @"App_IOS_Hinabian"}];
//    }
//    RSAEncryptor *rsa = [[RSAEncryptor alloc] init];
//    NSString *publicKeyPath = [[NSBundle mainBundle] pathForResource:@"public_ios" ofType:@"der"];
//    [rsa loadPublicKeyFromFile:publicKeyPath];
//
//    NSString* AccessTokenEncode = [access_token stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString* OpenIdEncode = [open_id stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString * appdate = [HNBUtils getCruntTime];
//    NSString * finalString = [NSString stringWithFormat:@"%@:%@:%@",AccessTokenEncode,OpenIdEncode,appdate];
//
//    NSString *encryptedFinalString = [rsa rsaEncryptString:finalString];
    
    NSString * deviceToken = [HNBUtils sandBoxGetInfo:[NSString class] forKey:personal_device_token];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       type,@"type",
                                       telNum,@"mobile_num",
                                       mobilenation,@"mobile_nation",
                                       VcodeString,@"vcode",
                                       deviceToken,@"devicetoken",
                                       nil];
    // v3.0 新增参数 - 本地选择的移民状态、移民国家、移民城市
    NSString *cityID = [HNBUtils sandBoxGetInfo:[NSString class] forKey:IMED_Local_City];
    NSString *nationID = [HNBUtils sandBoxGetInfo:[NSString class] forKey:IMED_Local_Nation];
    if (im_state != nil && im_state.length > 0) {
        [parameters setObject:im_state forKey:@"im_state"];
    }
    if (nationID != nil && nationID.length > 0) {
        [parameters setObject:nationID forKey:@"country_id"];
    }
    if (cityID != nil && cityID.length > 0) {
        [parameters setObject:cityID forKey:@"city_id"];
    }
    parameters = [HNBUtils addPlatformKey:parameters];
    
    NSString *URLString = [NSString  stringWithFormat:@"%@/%@",APIURL,@"Api_ThirdLogin/bindPhone"];
    [HNBAFNetTool POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0){
            //NSLog(@" %s ",__FUNCTION__);
            //有账号、有手机号正常登陆了
            [self saveCookies];
            [DataHandler doLoginWithThirdPartHandleData:responseObject complete:^(id info) {
                [self loginNetEaseIMWithCompletion:nil];
            }];
            [[HNBToast shareManager] toastWithOnView:nil msg:@"登录成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
//            [[HNBToast shareManager] toastWithOnView:nil msg:@"绑定成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
        } else{
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:2.0f style:HNBToastHudFailure];
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
        [[HNBToast shareManager] toastWithOnView:nil msg:@"出现错误" afterDelay:DELAY_TIME style:HNBToastHudFailure];
    }];
    
}

+(void)doIdeaBackWithContent:(NSString *)contentString ImageList:(NSArray*)imageArry withSucceedHandler:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler {
    //显示HUD
    [[HNBToast shareManager] toastWithOnView:nil msg:@"正在提交" afterDelay:0.f style:HNBToastHudWaiting];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       contentString,@"content",
                                       imageArry,@"img_list",
                                       nil];
    
    parameters = [HNBUtils addGeneralKey:parameters];
    parameters = [HNBUtils addPlatformKey:parameters];
    
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",APIURL,@"Api_Feedback/app"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
        int errCode=   [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0)
        {
            [[HNBToast shareManager] dismiss];
//            [[HNBToast shareManager] toastWithOnView:nil msg:@"提交成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
        }
        else
        {
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject valueForKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        
        suceedHandler(responseObject);
        
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"提交失败" afterDelay:DELAY_TIME style:HNBToastHudFailure];
        failHandler(error);
    }];
}
#pragma mark ------------------------------------------ app 3.0 版本接口

+ (void)doSetIndexFunction:(DataFetchSucceedHandler)suceedHandler withFailHandler:(DataFetchFailHandler)failHandler
{
    [HNBAFNetTool POST:[NSString  stringWithFormat:@"%@/%@",H5APIURL,@"config/symbol?configName=iosFunctionNew"] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果成功
//        int errCode=   [[responseObject valueForKey:@"state"] intValue];
//        if(errCode == 0){
//            [DataHandler doSetIndexFunctionHandleData:responseObject complete:^(id info) {
//                suceedHandler(info);
//            }];
//            suceedHandler(responseObject);
//        }else{
//            suceedHandler(responseObject);
//        }
        suceedHandler(responseObject);
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}

// 最佳方案
+(void)doGetHomePage30PreferredPlan:(NSDictionary *)parameter withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    
    [self loadCookies];
    NSString *URLString = [NSString stringWithFormat:@"%@/%@",H5APIURL,HomePage30PreferredPlan];
    [HNBAFNetTool POST:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //NSLog(@" B ====== > 最佳方案数据：%@",responseObject);
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        if (errCode == 0) {
            
            [DataHandler doGetHomePage30PreferredPlanHandleData:responseObject complete:^(id info) {
                succeedHandler(info);
            }];
            
        }else{
            succeedHandler(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}

+(void)doGetHomePage30PreferredPlanWithLocalCachedHandler:(DataFetchLocalCachedHandler)cacheRes para:(NSDictionary *)parameter withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    
    [self loadCookies];
    NSString *URLString = [NSString stringWithFormat:@"%@/%@",H5APIURL,HomePage30PreferredPlan];
    id cacheRlt = [HNBFileManager httpCacheForURL:URLString parameters:[self composingCookieDicInfo]];
    if (cacheRlt != nil) {
        [DataHandler doGetHomePage30PreferredPlanHandleData:cacheRlt complete:^(id info) {
            cacheRes(info);
        }];
    }
    [HNBAFNetTool POST:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        int errCode = [[responseObject valueForKey:@"state"] intValue];
        if (errCode == 0) {
            
            [DataHandler doGetHomePage30PreferredPlanHandleData:responseObject complete:^(id info) {
                succeedHandler(info);
                [HNBFileManager setHttpCache:responseObject URL:URLString parameters:[self composingCookieDicInfo]];
            }];
            
        }else{
            succeedHandler(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
    
}


// 首页 Banner 功能区 快讯
+ (void)doGetHomePage30BannerFuntionsLatestNewsWithSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    NSString *URLString = [NSString stringWithFormat:@"%@/%@",H5APIURL,HomePage30BannerLatestNewsFunctions];
    [HNBAFNetTool POST:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        if (errCode == 0) {
            [DataHandler doGetHomePage30BannerFuntionsLatestNewsHandleData:responseObject complete:^(id info) {
                succeedHandler(info);
            }];
        }else{
            succeedHandler(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}

+(void)doGetHomePage30BannerFuntionsLatestNewsWithLocalCachedHandler:(DataFetchLocalCachedHandler)cacheRes succeedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    NSString *URLString = [NSString stringWithFormat:@"%@/%@",H5APIURL,HomePage30BannerLatestNewsFunctions];
    id cacheRlt = [HNBFileManager httpCacheForURL:URLString parameters:nil];
    if (cacheRlt != nil) {
        [DataHandler doGetHomePage30BannerFuntionsLatestNewsHandleData:cacheRlt complete:^(id info) {
            cacheRes(info);
        }];
    }
    [HNBAFNetTool POST:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        if (errCode == 0) {
            [DataHandler doGetHomePage30BannerFuntionsLatestNewsHandleData:responseObject complete:^(id info) {
                succeedHandler(info);
                [HNBFileManager setHttpCache:responseObject URL:URLString parameters:nil];
            }];
        }else{
            succeedHandler(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}

// 首页 推荐专家 推荐活动 热门话题
+ (void)doGetHomePage30RcmdSpecialRcmdActivityHotTopicWithSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    NSString *URLString = [NSString stringWithFormat:@"%@/%@",H5APIURL,HomePage30RcmdSpecialRcmdActivityHotTopic];
    [HNBAFNetTool POST:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        if (errCode == 0) {
            [DataHandler doGetHomePage30RcmdSpecialRcmdActivityHotTopicHandleData:responseObject complete:^(id info) {
                succeedHandler(info);
            }];
        }else{
            succeedHandler(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}

+(void)doGetHomePage30RcmdSpecialRcmdActivityHotTopicWithLocalCachedHandler:(DataFetchLocalCachedHandler)cacheRes succeedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    NSString *URLString = [NSString stringWithFormat:@"%@/%@",H5APIURL,HomePage30RcmdSpecialRcmdActivityHotTopic];
    id cacheRlt = [HNBFileManager httpCacheForURL:URLString parameters:nil];
    if (cacheRlt != nil) {
        [DataHandler doGetHomePage30RcmdSpecialRcmdActivityHotTopicHandleData:cacheRlt complete:^(id info) {
            cacheRes(info);
        }];
    }
    [HNBAFNetTool POST:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        if (errCode == 0) {
            [DataHandler doGetHomePage30RcmdSpecialRcmdActivityHotTopicHandleData:responseObject complete:^(id info) {
                succeedHandler(info);
                [HNBFileManager setHttpCache:responseObject URL:URLString parameters:nil];
            }];
        }else{
            succeedHandler(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}

// 首页 大咖说 小边说
+ (void)doGetHomePage30GreatTalkHnbEditorTalkWithSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    NSString *URLString = [NSString stringWithFormat:@"%@/%@",H5APIURL,HomePage30GreatTalkHnbEditorTalk];
    [HNBAFNetTool POST:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        if (errCode == 0) {
            [DataHandler doGetHomePage30GreatTalkHnbEditorTalkHandleData:responseObject complete:^(id info) {
                succeedHandler(info);
            }];
        }else{
            succeedHandler(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}

+(void)doGetHomePage30GreatTalkHnbEditorTalkWithLocalCachedHandler:(DataFetchLocalCachedHandler)cacheRes succeedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    
    NSString *URLString = [NSString stringWithFormat:@"%@/%@",H5APIURL,HomePage30GreatTalkHnbEditorTalk];
    id cacheRlt = [HNBFileManager httpCacheForURL:URLString parameters:nil];
    if (cacheRlt != nil) {
        [DataHandler doGetHomePage30GreatTalkHnbEditorTalkHandleData:cacheRlt complete:^(id info) {
            cacheRes(info);
        }];
    }
    
    [HNBAFNetTool POST:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        if (errCode == 0) {
            [DataHandler doGetHomePage30GreatTalkHnbEditorTalkHandleData:responseObject complete:^(id info) {
                succeedHandler(info);
                [HNBFileManager setHttpCache:responseObject URL:URLString parameters:nil];
            }];
        }else{
            succeedHandler(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}


// 最新资讯列表
+ (void)doGetListLatestNewsWithParameterStart:(NSInteger)start count:(NSInteger)count withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    NSString *URLString = [NSString stringWithFormat:@"%@/%@",H5APIURL,ListLatestNews];
    NSString *s = [NSString stringWithFormat:@"%ld",start];
    NSString *c = [NSString stringWithFormat:@"%ld",count];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                                 s,@"start",
                                                                 c,@"num",
                                                                 nil];
    [HNBAFNetTool POST:URLString parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        if (errCode == 0) {
            
            [DataHandler doGetListLatestNewsHandleData:responseObject start:start complete:^(id info) {
                succeedHandler(info);
            }];
        }else{
            succeedHandler(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}

// 专家列表
+ (void)doGetListSpecialWithSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    //NSString *URLString = [NSString stringWithFormat:@"%@/%@%@",H5APIURL,InterfaceConfig,HomePage30RcmdSpecial];
    NSString *URLString = [NSString stringWithFormat:@"%@/Api_Config/data.html?config_name=newhomerecommandspecial&ver=3.0.0",H5APIURL];
    [HNBAFNetTool POST:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        if (errCode == 0) {
            [DataHandler doGetListSpecialHandleData:responseObject complete:^(id info) {
                succeedHandler(info);
            }];
        }else{
            succeedHandler(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}

+(void)doGetListSpecialWithLocalCachedHandler:(DataFetchLocalCachedHandler)cacheRes succeedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    NSString *URLString = [NSString stringWithFormat:@"%@/Api_Config/data.html?config_name=newhomerecommandspecial&ver=3.0.0",H5APIURL];
    
    id cacheRlt = [HNBFileManager httpCacheForURL:URLString parameters:nil];
    if (cacheRlt != nil) {
        [DataHandler doGetListSpecialHandleData:cacheRlt complete:^(id info) {
            cacheRes(info);
        }];
    }
    
    [HNBAFNetTool POST:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        if (errCode == 0) {
            [DataHandler doGetListSpecialHandleData:responseObject complete:^(id info) {
                succeedHandler(info);
                [HNBFileManager setHttpCache:responseObject URL:URLString parameters:nil];
            }];
        }else{
            succeedHandler(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}

// 大咖说列表
+ (void)doGetListGreatTalkWithSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    NSString *URLString = [NSString stringWithFormat:@"%@/%@%@",H5APIURL,InterfaceConfig,HomePage30GreatTalk];
    [HNBAFNetTool POST:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        if (errCode == 0) {
            
            [DataHandler doGetListGreatTalkHandleData:responseObject complete:^(id info) {
                succeedHandler(info);
            }];
            
        }else{
            succeedHandler(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}

+(void)doGetListGreatTalkWithLocalCachedHandler:(DataFetchLocalCachedHandler)cacheRes succeedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    NSString *URLString = [NSString stringWithFormat:@"%@/%@%@",H5APIURL,InterfaceConfig,HomePage30GreatTalk];
    id cacheRlt = [HNBFileManager httpCacheForURL:URLString parameters:nil];
    if (cacheRlt != nil) {
        [DataHandler doGetListGreatTalkHandleData:cacheRlt complete:^(id info) {
            cacheRes(info);
        }];
    }
    [HNBAFNetTool POST:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        if (errCode == 0) {
            
            [DataHandler doGetListGreatTalkHandleData:responseObject complete:^(id info) {
                succeedHandler(info);
            }];
            [HNBFileManager setHttpCache:responseObject URL:URLString parameters:nil];
        }else{
            succeedHandler(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}

// 小边说列表
+ (void)doGetListHnbEditorTalkWithSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    NSString *URLString = [NSString stringWithFormat:@"%@/%@%@",H5APIURL,InterfaceConfig,HomePage30HnbEditorTalk];
    [HNBAFNetTool POST:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        if (errCode == 0) {
            [DataHandler doGetListHnbEditorTalkHandleData:responseObject complete:^(id info) {
                succeedHandler(info);
            }];
        }else{
            succeedHandler(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}

+ (void)doGetListHnbEditorTalkWithLocalCachedHandler:(DataFetchLocalCachedHandler)cacheRes succeedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    NSString *URLString = [NSString stringWithFormat:@"%@/%@%@",H5APIURL,InterfaceConfig,HomePage30HnbEditorTalk];
    
    // 取缓存数据
    id cacheRlt = [HNBFileManager httpCacheForURL:URLString parameters:nil];
    if (cacheRlt != nil) {
        [DataHandler doGetListHnbEditorTalkHandleData:cacheRlt complete:^(id info) {
            cacheRes(info);
        }];
    }
  
    [HNBAFNetTool POST:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        if (errCode == 0) {
            [DataHandler doGetListHnbEditorTalkHandleData:responseObject complete:^(id info) {
                succeedHandler(info);
            }];
            // 更新缓存数据
            [HNBFileManager setHttpCache:responseObject URL:URLString parameters:nil];
            
        }else{
            succeedHandler(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
    
    
}

// 移民评估题目选项请求
+ (void)doGetIMAssessItemsWithSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler {
    
    NSString *URLString = [NSString stringWithFormat:@"%@/%@",H5APIURL,GuideImassessItems];
    [HNBAFNetTool POST:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        if (errCode == 0) {
            [DataHandler doGetIMAssessItemsHandleData:responseObject complete:^(id info) {
                succeedHandler(info);
            }];
        }else{
            NSString *dataRes = [responseObject valueForKey:@"data"];
            [[HNBToast shareManager] toastWithOnView:nil msg:dataRes afterDelay:DELAY_TIME style:HNBToastHudFailure];
            succeedHandler(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"请求失败" afterDelay:DELAY_TIME style:HNBToastHudFailure];
        failHandler(error);
    }];
}

// 移民评估验证码请求
+ (void)doGetIMAssessVCodeWithmobilePhoneNum:(NSString *)mobilePhoneNum SucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       mobilePhoneNum,@"mobile",
                                       @"mobile:collect",@"type",
                                       nil];
    
    NSString *URLString = [NSString stringWithFormat:@"%@/vcode",APIURL];
    [HNBAFNetTool POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        if (errCode == 0) {
            succeedHandler(responseObject);
        }else{
            NSString *dataRes = [responseObject valueForKey:@"data"];
            [[HNBToast shareManager] toastWithOnView:nil msg:dataRes afterDelay:DELAY_TIME style:HNBToastHudFailure];
            succeedHandler(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}

// 生成移民方案
+ (void)doGetIMAssessCaseWithUserInfoData:(NSDictionary *)userInfoData SucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:userInfoData];
    
    NSString *URLString = [NSString stringWithFormat:@"%@/%@",H5APIURL,GuideImassessCase];
    [HNBAFNetTool POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        if (errCode == 0) {
            succeedHandler(responseObject);
        }else{
            NSString *dataRes = [responseObject valueForKey:@"data"];
            [[HNBToast shareManager] toastWithOnView:nil msg:dataRes afterDelay:DELAY_TIME style:HNBToastHudFailure];
            succeedHandler(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}

/**
 * 已移民状态同步所在国家城市
 * ver:去真实版本参数,参见接口文档
 */
+ (void)updateIMEDNationCityWithSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler {
    NSInteger cityID = [[HNBUtils sandBoxGetInfo:[NSString class] forKey:IMED_Local_City] integerValue];
    NSInteger nationID = [[HNBUtils sandBoxGetInfo:[NSString class] forKey:IMED_Local_Nation] integerValue];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithInteger:nationID],@"country_id",
                                       [NSNumber numberWithInteger:cityID],@"city_id",
                                       [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],@"ver",
                                       nil];
    
    NSString *URLString = [NSString stringWithFormat:@"%@/%@",H5APIURL,UpdateNationCity];
    [HNBAFNetTool POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        if (errCode == 0) {
            NSInteger dataRes = [[responseObject valueForKey:@"data"] integerValue];
            if (dataRes == 1) {
                //成功后本地设空
                //上传成功后本地城市和国家设置为0
                [HNBUtils sandBoxSaveInfo:nil forKey:IMED_Local_Nation];
                [HNBUtils sandBoxSaveInfo:nil forKey:IMED_Local_City];
            }
            succeedHandler(responseObject);
        }else{
            //看情况要不要提示用户
//            NSString *dataRes = [responseObject valueForKey:@"data"];
//            [[HNBToast shareManager] toastWithOnView:nil msg:dataRes afterDelay:DELAY_TIME style:HNBToastHudFailure];
//            succeedHandler(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
    }];
}

#pragma mark ------------------------------------------ app web 加载重构上报 URL
+ (void)uploadWebURLString:(NSString *)URLString withSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    NSString *postURL = @"https://m.hinabian.com/Api_Report/url.html";
    if (URLString != nil && URLString.length > 0) {
        
        // APP 信息 : app 名字 _app 版本
        NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = [bundleInfo objectForKey:@"CFBundleShortVersionString"];
        NSDictionary *para = @{
                                  @"ver":appVersion,
                                  @"url":URLString,
                              };
        
        [HNBAFNetTool POST:postURL parameters:para success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSLog(@" success ");
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            NSLog(@" failure ");
            
        }];
        
    }
}

+ (void)doGetListOverSeaClassWithType:(NSString *)type page:(NSString *)page num:(NSString *)num WithSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    
    NSString *URLString = [NSString stringWithFormat:@"%@/%@",H5URL,OverSeaClassListURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       type,@"type",
                                       page,@"page",
                                       num,@"num",
                                       [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],@"ver",
                                       nil];
    
    [HNBAFNetTool POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        
        if (errCode == 0) {
            [DataHandler doGetListOverSeaClassHandleData:responseObject complete:^(id info) {
                succeedHandler(info);
            }];
        }else{
            succeedHandler(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"请求失败" afterDelay:DELAY_TIME style:HNBToastHudFailure];
        failHandler(error);
    }];
}

+(void)doGetListOverSeaClassWithLocalCachedHandler:(DataFetchLocalCachedHandler)cacheRes type:(NSString *)type page:(NSString *)page num:(NSString *)num WithSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    NSString *URLString = [NSString stringWithFormat:@"%@/%@",H5URL,OverSeaClassListURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       type,@"type",
                                       page,@"page",
                                       num,@"num",
                                       [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],@"ver",
                                       nil];
    
    id cacheRlt = [HNBFileManager httpCacheForURL:URLString parameters:parameters];
    if (cacheRlt != nil) {
        [DataHandler doGetListOverSeaClassHandleData:cacheRlt complete:^(id info) {
            cacheRes(info);
        }];
    }
    
    
    [HNBAFNetTool POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        
        if (errCode == 0) {
            [DataHandler doGetListOverSeaClassHandleData:responseObject complete:^(id info) {
                succeedHandler(info);
                [HNBFileManager setHttpCache:responseObject URL:URLString parameters:parameters];
            }];
        }else{
            succeedHandler(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"请求失败" afterDelay:DELAY_TIME style:HNBToastHudFailure];
        failHandler(error);
    }];
}

+ (void)doGetIMNotificationWithStart:(NSString *)start num:(NSString *)num WithSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler {
    NSString *URLString = [NSString stringWithFormat:@"%@/%@",H5URL,NotificationData];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],@"ver",
                                       start,@"start",
                                       num,@"num",
                                       nil];
    
    [HNBAFNetTool POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        
        if (errCode == 0) {
            [DataHandler doGetIMNotificationWithHandlerData:responseObject complete:^(id info) {
                succeedHandler(info);
            }];
        }else{
            succeedHandler(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"请求失败" afterDelay:DELAY_TIME style:HNBToastHudFailure];
        failHandler(error);
    }];
}

+ (void)doSetIMNotificationHasReadWithSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler {
    NSString *URLString = [NSString stringWithFormat:@"%@/%@",H5URL,NotificationHasRead];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],@"ver",
                                       nil];
    
    [HNBAFNetTool POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        
        if (errCode == 0) {
            succeedHandler(responseObject);
        }else{
            succeedHandler(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"请求失败" afterDelay:DELAY_TIME style:HNBToastHudFailure];
        failHandler(error);
    }];
}

#pragma mark -- 获取关注状态接口（登录有效）
+ (void)doGetPersonalIsFollow:(NSString *)u_id WithSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler {
    NSString *URLString = [NSString stringWithFormat:@"%@/%@",H5URL,PersonaIsFollow];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       u_id,@"u_id",
                                       nil];
    
    [HNBAFNetTool POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        succeedHandler(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"请求失败" afterDelay:DELAY_TIME style:HNBToastHudFailure];
        failHandler(error);
    }];
}

#pragma mark -- 获取全部展示列表页的数据
+ (void)doGetAllShowServiceListWithSucceedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler {
    NSString *URLString = [NSString stringWithFormat:@"%@/%@",APIURLTEST,AllServiceList];
    
    [HNBAFNetTool POST:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        
        if (errCode == 0) {
            [DataHandler doGetAllShowServiceListWithHandlerData:responseObject complete:^(id info) {
                succeedHandler(info);
            }];
        }else{
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject returnValueWithKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
        [[HNBToast shareManager] toastWithOnView:nil msg:@"请求失败" afterDelay:DELAY_TIME style:HNBToastHudFailure];
    }];
}

+(void)doGetAllShowServiceListWithLocalCachedHandler:(DataFetchLocalCachedHandler)cacheRes succeedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    NSString *URLString = [NSString stringWithFormat:@"%@/%@",APIURLTEST,AllServiceList];
    
    id cacheRlt = [HNBFileManager httpCacheForURL:URLString parameters:nil];
    if (cacheRlt != nil) {
        [DataHandler doGetAllShowServiceListWithHandlerData:cacheRlt complete:^(id info) {
            cacheRes(info);
        }];
    }
    
    [HNBAFNetTool POST:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        
        if (errCode == 0) {
            [DataHandler doGetAllShowServiceListWithHandlerData:responseObject complete:^(id info) {
                succeedHandler(info);
                [HNBFileManager setHttpCache:responseObject URL:URLString parameters:nil];
            }];
        }else{
            succeedHandler(responseObject);
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject returnValueWithKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failHandler(error);
        [[HNBToast shareManager] toastWithOnView:nil msg:@"请求失败" afterDelay:DELAY_TIME style:HNBToastHudFailure];
    }];
}


+(void)doGetOverSeaServiceListWithType:(NSString *)type start:(NSInteger)start num:(NSInteger)num succeedHandler:(DataFetchSucceedHandler)succeedHandler withFailHandler:(DataFetchFailHandler)failHandler{
    
    NSString *URLString = [NSString stringWithFormat:@"%@/%@",APIURLTEST,OverseaServiceList];//@"?start=0&num=5&type=1";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [NSString stringWithFormat:@"%ld",start],@"start",
                                       [NSString stringWithFormat:@"%ld",num],@"num",
                                       type,@"type",
                                       nil];
    
    [HNBAFNetTool POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //NSLog(@" === ");
        int errCode = [[responseObject valueForKey:@"state"] intValue];
        if(errCode == 0){
            
            [DataHandler doGetOverSeaServiceListWithHandlerData:responseObject complete:^(id info) {
                succeedHandler(info);
            }];
            
        }else{
            [[HNBToast shareManager] toastWithOnView:nil msg:[responseObject returnValueWithKey:@"data"] afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"请求失败" afterDelay:DELAY_TIME style:HNBToastHudFailure];
    }];
    
}

@end
