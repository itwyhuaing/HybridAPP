//
//  UserInfoMainManager.h
//  hinabian
//
//  Created by hnbwyh on 16/7/25.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PersonInfoModel;

@class UserInfoMainManager;
@protocol UserInfoMainManagerDelegate <NSObject>
@optional

- (void) completeDataThenRefreshViewWithPersonInfo:(PersonInfoModel *)pModel hisTribePosts:(NSArray *)posts personInfoReqStatus:(BOOL)personInfoReqStatus hisTribeReqStatus:(BOOL)hisTribeReqStatus;
//- (void) completeDataThenRefreshViewWithPersonInfo:(PersonInfoModel *)pModel hisTribePosts:(NSArray *)posts hisTribeReply:(NSArray *)reply personInfoReqStatus:(BOOL)personInfoReqStatus hisTribeReqStatus:(BOOL)hisTribeReqStatus;
//- (void) completeDataThenRefreshViewWithPersonInfo:(PersonInfoModel *)pModel hisTribeReply:(NSArray *)reply personInfoReqStatus:(BOOL)personInfoReqStatus hisTribeReplyReqStatus:(BOOL)hisTribeReplyReqStatus;

- (void) completeDataThenRefreshViewWithPersonInfo:(PersonInfoModel *)pModel hisQA:(NSArray *)hisQA personInfoReqStatus:(BOOL)personInfoReqStatus hisQAReqStatus:(BOOL)hisQAReqStatus;

- (void) completePersonInfoDataThenRefreshTheViewWithData:(PersonInfoModel *)pModel;

- (void) failToReqPersonInfoData;

@end





@interface UserInfoMainManager : NSObject

@property (nonatomic,weak) id<UserInfoMainManagerDelegate> delegate;

@property (nonatomic,strong) UIViewController *superVC;
@property (nonatomic,strong) NSString *personid;
@property (nonatomic,copy) NSString *personType; // 区分专家或个人


/**
 * 第一次进入时 请求个人信息 + 请求 TA 的圈子数据
 * personID - 个人ID
 */
- (void)reqPersonalOrSpecialInfoAndHisTribeDataWithID:(NSString *)personID count:(NSInteger)countNum;

/**
 * 请求个人信息
 * personID - 个人ID
 */
- (void)reqPersonalOrSpecialInfoWithID:(NSString *)personID;

@end
