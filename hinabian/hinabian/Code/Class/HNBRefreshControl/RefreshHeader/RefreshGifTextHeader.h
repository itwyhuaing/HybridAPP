//
//  RefreshGifTextHeader.h
//  hinabian
//
//  Created by hnbwyh on 2017/10/31.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

@interface RefreshGifTextHeader : MJRefreshHeader

- (void)modifyLableMsg:(NSString *)msg hidden:(BOOL)hs;

- (void)modifyGifHidden:(BOOL)hs;

@end
