//
//  CouponMainManager.m
//  hinabian
//
//  Created by hnb on 16/4/22.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "CouponMainManager.h"
#import "Coupon.h"
#import "DataFetcher.h"
#import "SWKIMProjectShowController.h"
#import "SWKConsultOnlineViewController.h"
#import "CouponCodeView.h"
#import "CouponExplainView.h"

enum CouponFlag
{
    FLAG_INUSE = 1,
    FLAG_USED,
    FLAG_OUT_OF_DATE,
};

@interface CouponMainManager()<UIAlertViewDelegate, CouponCodeViewDelegate, CouponExplainViewDelegate>
{
    NSInteger fetcherCount;
}
@property (strong, nonatomic) UIView * backGroundView;
@property (strong, nonatomic) CouponCodeView *codeView;
@end

@implementation CouponMainManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _couponInUseArry = [[NSMutableArray alloc] init];
        _couponUsedArry = [[NSMutableArray alloc] init];
        _couponOutOfDateArry = [[NSMutableArray alloc] init];
        [self getDataSource];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inUsedSelect:) name:COUPON_SELECT_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(codeSelect:) name:COUPON_CODE_SELECT_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(explainSelect:) name:COUPON_EXPLAIN_SELECT_NOTIFICATION object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:COUPON_SELECT_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:COUPON_CODE_SELECT_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:COUPON_EXPLAIN_SELECT_NOTIFICATION object:nil];
}

-(void)getDataSource{

    [Coupon MR_truncateAll];
    fetcherCount = 0;
    [self getCouponInfo:0 GetNum:100 Flag:1];
    [self getCouponInfo:0 GetNum:100 Flag:2];
    [self getCouponInfo:0 GetNum:100 Flag:3];

}


/**
 *  从服务器获取数据
 *
 *  @param start
 *  @param num
 *  @param flag   1：未使用 2：已使用 3:已过期
 */
- (void) getCouponInfo:(int) start GetNum:(int) num Flag:(int) flag
{
    [DataFetcher doGetCoupon:start GetNum:num Flag:flag withSucceedHandler:^(id JSON) {
        int errCode = [[JSON valueForKey:@"state"] intValue];
        fetcherCount++;
        NSLog(@"%ld",(long)fetcherCount);
        if (errCode == 0) {
            NSArray * allCoupon = [Coupon MR_findAllSortedBy:@"timestamp" ascending:YES];
            if (flag == FLAG_INUSE && allCoupon != nil && allCoupon.count != 0) {
                //NSArray *inUseArry = [Coupon where:@"flag == %d",FLAG_INUSE];
                NSString *filterStr = [NSString stringWithFormat:@"%d",FLAG_INUSE];
                NSPredicate *filter = [NSPredicate predicateWithFormat:@"flag IN %@",@[filterStr]];
                //NSArray *inUseArry = [Coupon MR_findAllWithPredicate:filter];
                NSArray *inUseArry = [Coupon MR_findAllSortedBy:@"timestamp" ascending:YES withPredicate:filter];
                [_couponInUseArry removeAllObjects];
                _couponInUseArry = [NSMutableArray arrayWithArray:inUseArry];
            }
            else if(flag == FLAG_USED && allCoupon != nil && allCoupon.count != 0)
            {
                NSLog(@"flag == %d",FLAG_USED);
                //NSArray *usedArry = [Coupon where:@"flag == %d",FLAG_USED];
                NSString *filterStr = [NSString stringWithFormat:@"%d",FLAG_USED];
                NSPredicate *filter = [NSPredicate predicateWithFormat:@"flag IN %@",@[filterStr]];
                //NSArray *usedArry = [Coupon MR_findAllWithPredicate:filter];
                NSArray *usedArry = [Coupon MR_findAllSortedBy:@"timestamp" ascending:YES withPredicate:filter];
                [_couponUsedArry removeAllObjects];
                _couponUsedArry = [NSMutableArray arrayWithArray:usedArry];
            }
            else if(flag == FLAG_OUT_OF_DATE && allCoupon != nil && allCoupon.count != 0)
            {
                //NSArray *outOfDateArry = [Coupon where:@"flag == %d",FLAG_OUT_OF_DATE];
                NSString *filterStr = [NSString stringWithFormat:@"%d",FLAG_OUT_OF_DATE];
                NSPredicate *filter = [NSPredicate predicateWithFormat:@"flag IN %@",@[filterStr]];
                //NSArray *outOfDateArry = [Coupon MR_findAllWithPredicate:filter];
                NSArray *outOfDateArry = [Coupon MR_findAllSortedBy:@"timestamp" ascending:YES withPredicate:filter];
                [_couponOutOfDateArry removeAllObjects];
                _couponOutOfDateArry = [NSMutableArray arrayWithArray:outOfDateArry];
            }

        }
        if(fetcherCount >= 3)
        {
            if ([_delegate respondsToSelector:@selector(getAllDateComplete)])
            {
                [_delegate getAllDateComplete];
            }
        }
    } withFailHandler:^(NSError* error) {
        fetcherCount++;
        if(fetcherCount >= 3)
        {
            if ([_delegate respondsToSelector:@selector(reqNetFail)])
            {
                [_delegate reqNetFail];
            }
            
        }
        NSLog(@"errCode = %ld",(long)error.code);
    }];
}

-(void)inUsedSelect:(NSNotification*)notification
{
    NSInteger  index = [[notification object] intValue];
    if(index < _couponInUseArry.count)
    {
        Coupon * f = _couponInUseArry[index];
        NSDictionary *dict = @{@"coupon_id" : f.id};
        [HNBClick event:@"106021" Content:dict];
        if (f.jumpurl) {
            NSLog(@"jumpurl = %@",f.jumpurl);
            NSLog(@"jumpdescribe = %@",f.jumpdescribe);
        }
        //有jumpurl则跳转如果没有则提示描述
        if (![f.jumpurl isEqualToString:@""] && nil != f.jumpurl) {

            SWKIMProjectShowController *vc = [[SWKIMProjectShowController alloc] init];
            vc.URL = [NSURL URLWithString:f.jumpurl];
            [self.superController.navigationController pushViewController:vc animated:YES];
        }
        else if(![f.jumpdescribe isEqualToString:@""] && nil != f.jumpdescribe)
        {
            UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:f.jumpdescribe  delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"在线咨询",@"电话咨询", nil];
            [alterview show];
        }
        
    }
}

-(void) codeSelect:(NSNotification*)notification
{
    
    _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _backGroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];

    NSArray *nibs_code = [[NSBundle mainBundle] loadNibNamed:@"CouponCodeView" owner:self options:nil];
    _codeView = [nibs_code objectAtIndex:0];
    _codeView.delegate = (id)self;
    if (SCREEN_WIDTH < SCREEN_WIDTH_6) {
        [_codeView setFrame:CGRectMake(0, 0, 250, 160)];
    }
    else
    {
        [_codeView setFrame:CGRectMake(0, 0, 300, 160)];
    }
    
    [_codeView setCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/3)];
    [_backGroundView addSubview:_codeView];
    [[UIApplication sharedApplication].keyWindow addSubview:_backGroundView];

}

-(void) explainSelect:(NSNotification*)notification
{
    _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _backGroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
    
    NSArray *nibs_explain = [[NSBundle mainBundle] loadNibNamed:@"CouponExplainView" owner:self options:nil];
    CouponExplainView *explainView = [nibs_explain objectAtIndex:0];
    explainView.delegate = (id)self;
    [explainView setFrame:CGRectMake(0, 0, 248, 380)];
    [explainView setCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)];
    [_backGroundView addSubview:explainView];
    [[UIApplication sharedApplication].keyWindow addSubview:_backGroundView];
}

#pragma mark AlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"在线咨询"]) {
        NSString *str = [NSString stringWithFormat:@"https://eco-api.meiqia.com/dist/standalone.html?eid=1875"];

        SWKConsultOnlineViewController *vc = [[SWKConsultOnlineViewController alloc]init];
        vc.URL = [[NSURL alloc] withOutNilString:str];
        [self.superController.navigationController pushViewController:vc animated:YES];

    }else if ([buttonTitle isEqualToString:@"电话咨询"]){

        NSString *urlString = [NSString stringWithFormat:@"telprompt://%@",DEFAULT_TELNUM];//@"telprompt://4009933922";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
}

#pragma mark CouponCodeViewDelegate
-(void) CouponCodeDelButtonPressed
{
    [_backGroundView removeFromSuperview];
}
-(void) CouponCodeSubMitButtonPressed:(NSString *)text
{
    NSLog(@"CouponCodeSubMitButtonPressed = %@",text);
    
    if (text && ![text isEqualToString:@""]) {
        [DataFetcher doSendCouponCode:text withSucceedHandler:^(id JSON) {
            int errCode = [[JSON valueForKey:@"state"] intValue];
            if (errCode == 0) {
                [self getDataSource];
                [_backGroundView removeFromSuperview];
            }
            else
            {
                [_codeView.inPutTextField setText:@""];
            }
            
        } withFailHandler:^(id error) {
            
        }];
    }
    else{
        [[HNBToast shareManager] toastWithOnView:nil msg:@"请输入兑换码" afterDelay:DELAY_TIME style:HNBToastHudFailure];
    }
}

#pragma mark CouponExplainViewDelegate
-(void) CouponExplainDelButtonPressed
{
    [_backGroundView removeFromSuperview];
}

-(void) CouponExplainOKButtonPressed
{
    [_backGroundView removeFromSuperview];
}

@end
