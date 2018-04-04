//
//  BeenUsedView.m
//  hinabian
//
//  Created by hnb on 16/4/13.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "BeenUsedView.h"
#import "CouponTableViewCell.h"
#import "CouponDiscountTableViewCell.h"
#import "Coupon.h"
#import "CouponCodeTableViewCell.h"
@interface BeenUsedView()<UITableViewDelegate,UITableViewDataSource>

@end
enum OutOfDateCouponCellFlag
{
    BU_HEAD = 0,
    BU_DEAULT,
};
@implementation BeenUsedView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataArray = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor DDNormalBackGround];
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.tableView.delegate = (id)self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor clearColor];
        //self.tableView.tableFooterView = [[UIView alloc]init];
        //self.tableView.contentInset = UIEdgeInsetsMake(-66, 0, 0, 0);
        [self addSubview:self.tableView];
        [self registerCellPrototype];
    }
    return self;
}
-(void)registerCellPrototype
{
    [self.tableView registerNib:[UINib nibWithNibName:cellNibName_CouponTableViewCell bundle:nil] forCellReuseIdentifier:cellNibName_CouponTableViewCell];
    [self.tableView registerNib:[UINib nibWithNibName:cellNibName_CouponDiscountTableViewCell bundle:nil] forCellReuseIdentifier:cellNibName_CouponDiscountTableViewCell];
    [self.tableView registerNib:[UINib nibWithNibName:cellNibName_CouponCodeTableViewCell bundle:nil] forCellReuseIdentifier:cellNibName_CouponCodeTableViewCell];
}

/**
 *  无数据时界面设置
 */
- (void) setNothing
{
    UIImageView *nullImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    nullImage.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 - 70);
    [nullImage setImage:[UIImage imageNamed:@"coupon_null_image"]];
    UILabel * nullLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    nullLabel.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    nullLabel.textAlignment = NSTextAlignmentCenter;
    nullLabel.textColor = [UIColor DDCouponTextGray];
    nullLabel.text = @"无已使用优惠券";
    [self addSubview:nullLabel];
    [self addSubview:nullImage];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count + BU_DEAULT;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCellPtr = [[UITableViewCell alloc] init];
    if (indexPath.row == BU_HEAD) {
        CouponCodeTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellNibName_CouponCodeTableViewCell];
        returnCellPtr = cell;
    }
    else
    {
        Coupon * f =  _dataArray[indexPath.row - BU_DEAULT];
        NSLog(@"%@",f.type);
        if ([f.type isEqualToString:@"2"]) {
            CouponDiscountTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellNibName_CouponDiscountTableViewCell];
            [cell setCouponData:f];
            [cell setNotAvailable];
            returnCellPtr = cell;
        }
        else if([f.type isEqualToString:@"1"])
        {
            CouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNibName_CouponTableViewCell];
            [cell setCouponData:f];
            [cell setNotAvailable];
            returnCellPtr = cell;
        }

    }
    
    
    returnCellPtr.selectionStyle = UITableViewCellSelectionStyleNone;
    return returnCellPtr;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == BU_HEAD) {
        return 80;
    }
    else
    {
        return 170;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == BU_HEAD) {
        [[NSNotificationCenter defaultCenter] postNotificationName:COUPON_CODE_SELECT_NOTIFICATION object:nil];
    }

}




@end
