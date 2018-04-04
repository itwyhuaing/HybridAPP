//
//  IndexFunctionStatus.h
//  hinabian
//
//  Created by hnb on 16/4/18.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndexFunctionStatus : NSObject <NSCoding>

@property (nonatomic, strong) NSString * no;         //顺序号从1开始
@property (nonatomic, strong) NSString * name;       //功能名字
@property (nonatomic, strong) NSString * pic;        //图片url地址
@property (nonatomic, strong) NSString * url;        //url地址
@property (nonatomic, strong) NSString * title;      //显示标题
@property (nonatomic, strong) NSString * isLocal;    //是否跳转原生界面 1:原生 0：非原生
@property (nonatomic, strong) NSString * isHide;     //是否隐藏 1：隐藏 0：不隐藏

// APP 提升转化率一期
@property (nonatomic,copy) NSString *isShowTip;
@property (nonatomic,copy) NSString *tipText;
@property (nonatomic,copy) NSString *tipBgColor;

@end
