//
//  HotTopicListVC.h
//  hinabian
//
//  Created by hnbwyh on 2017/11/1.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

/**
 处理优化 web 加载
 */

@interface HotTopicListVC : SWKCommonWebVC

// 发布完参与的内容之后，回退到当前控制器需要刷新 web
@property (nonatomic,assign) BOOL isRefreshWhenPop;

@end

