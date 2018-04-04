//
//  ShowAllServicesCell.h
//  ShowAllServicesViewController
//
//  Created by 何松泽 on 2018/3/26.
//  Copyright © 2018年 HSZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShowAllServicesModel;

@protocol ShowAllSercicesCellDelegate<NSObject>

- (void)ShowAllSercicesCellClickModel:(ShowAllServicesModel *)model;

@end

@interface ShowAllServicesCell : UIView

@property (nonatomic, weak) id<ShowAllSercicesCellDelegate> delegate;

- (void)setCellWithModel:(ShowAllServicesModel *)model;

@end
