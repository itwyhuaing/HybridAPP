//
//  IMAllCountryView.h
//  hinabian
//
//  Created by 何松泽 on 2017/8/25.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMAllCountryView : UIView

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIImageView *BGImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, copy) void (^clickCloseBlock)();

@property (nonatomic, copy) void (^didSelectCellWithIndex)(NSIndexPath *indexPath);

@end
