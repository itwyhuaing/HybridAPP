//
//  PoorNetWorkView.h
//  hinabian
//
//  Created by 余坚 on 16/6/2.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PoorNetWorkViewDelegate;
@interface PoorNetWorkView : UIView
@property (nonatomic, weak) id<PoorNetWorkViewDelegate> delegate;
@end

@protocol PoorNetWorkViewDelegate <NSObject>
@optional
- (void) poorNetWorkThenReload;
@end