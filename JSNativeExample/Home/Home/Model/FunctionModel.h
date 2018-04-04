//
//  FunctionModel.h
//  hinabian
//
//  Created by hnbwyh on 2017/10/23.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FunctionModel : NSObject


@property (nonatomic, strong) NSString * name;       //功能名字
@property (nonatomic, strong) NSString * pic;        //图片url地址
@property (nonatomic, strong) NSString * url;        //url地址
@property (nonatomic, strong) NSString * title;      //显示标题
@property (nonatomic, strong) NSString * isLocal;    //是否跳转原生界面 1:原生 0：非原生

/**
 
 nationnav
 http://www.baidu.com
 国家百科
 
 yimingproject
 http://www.baidu.com
 移民项目
 
 estate
 https://m.hinabian.com/estate.html
 海外房产
 
 visa
 https://m.hinabian.com/native/visa.html
 大国签证
 
 */

@end
