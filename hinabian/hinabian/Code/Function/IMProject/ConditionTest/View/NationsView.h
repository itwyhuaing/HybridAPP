//
//  NationsView.h
//  hinabian
//
//  Created by hnbwyh on 17/6/9.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NationsView;
@protocol NationsViewDelegate <NSObject>
@optional
- (void)nationsView:(NationsView *)naView didSelectedIndex:(NSIndexPath *)inde dataModel:(id)model;
@end


@interface NationsView : UIView

@property (nonatomic,weak) id<NationsViewDelegate>delegate;
@property (nonatomic,strong) NSArray *nationDataSource;
@property (nonatomic,strong) UICollectionView *collectView;

@end
