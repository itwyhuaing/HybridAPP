//
//  QAMainView.h
//  hinabian
//
//  Created by 余坚 on 16/7/25.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QARecommendView.h"
#import "QAFilterView.h"

@interface QAMainView : UIView
@property (strong, nonatomic) QARecommendView *firstView;
@property (strong, nonatomic) QAFilterView *secondView;
- (void) reloadQAIndexData;
- (void) setFirstViewRefreshBottom:(BOOL)hide;
- (void) reloadQAIndexFilterData;
- (void) setFilterViewBottomFresh:(BOOL) isTrue;
- (void) setIndexViewBottomFresh:(BOOL) isTrue;

- (void) hideFilterView;
- (void) choseSegmentView:(NSInteger) index;
- (BOOL) isLabelSelectEmpty;
- (void) setSearchPlaceHold:(NSString *)placeHold;
- (void) stopIndexViewBottomFresh;
- (void) stopIndexViewTopFresh;
@end
