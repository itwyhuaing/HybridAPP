//
//  IMFunctionView.h
//  hinabian
//
//  Created by 何松泽 on 2017/8/23.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMFunctionView : UIView

- (void)setNationName:(NSString *)nation;

@property (nonatomic, copy)void (^clickWalkIN)();
@property (nonatomic, copy)void (^clickStrategy)();
@property (nonatomic, copy)void (^clickIMassess)();
@property (nonatomic, copy)void (^clickTest)();

@end
