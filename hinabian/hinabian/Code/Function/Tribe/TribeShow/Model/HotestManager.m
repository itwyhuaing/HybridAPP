//
//  HotestManager.m
//  hinabian
//
//  Created by hnbwyh on 16/6/22.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "HotestManager.h"
#import "DataFetcher.h"
#import "DetailTribeHotestitem.h"

@interface HotestManager ()
@property (nonatomic,strong) UIViewController *superVC;
@property (nonatomic,copy) NSString *tribeId;
@property (nonatomic,strong) NSArray *data;

@end

@implementation HotestManager

-(void)setSuperControl:(UIViewController *)supercontroller tribe:(NSString *)tribeId{
    
    _superVC = supercontroller;
    _tribeId = tribeId;
    
}


-(void)requestHotViewDataWithStart:(NSInteger)start getCount:(NSInteger)num{

    [DataFetcher doGetTribeDetailInfoWithTribeID:_tribeId
                                        sortType:TRIBE_HOTEST
                                           start:start
                                          GetNum:num
                              withSucceedHandler:^(id JSON) {
                                  
                                      NSPredicate *filter = [NSPredicate predicateWithFormat:@"tribe_id IN %@", @[_tribeId]];
                                      _data = [DetailTribeHotestitem MR_findAllSortedBy:@"timestamp" ascending:YES withPredicate:filter];

                                  //_data = [DetailTribeHotestitem MR_findAllSortedBy:@"timestamp" ascending:YES];
                                  //[self reqNetImages:_data];
                                  if (_delegate && [_delegate respondsToSelector:@selector(completeThenRefreshViewWithDataSource:)]) {
                                      
                                      [_delegate completeThenRefreshViewWithDataSource:_data];
                                      
                                  }
                                  
                                  
                              } withFailHandler:^(id error) {
                                  
                                  if (_delegate && [_delegate respondsToSelector:@selector(failureThenFinishRefresh)]) {
                                      [_delegate failureThenFinishRefresh];
                                  }
                                  
                              }];
    
    
}

#pragma mark ------ reqNetImage

- (void)reqNetImages:(NSArray *)data{
    
    SDWebImageDownloader *mgr = [SDWebImageDownloader sharedDownloader];
    for (DetailTribeHotestitem *f in data) {
        
        NSString *iconURLString = f.head_url;
        NSString *img_url_string = f.img_list;
        NSArray *img_url_arr = [img_url_string componentsSeparatedByString:@"&"];
        NSString *img_url= [img_url_arr firstObject];
        
        // icon
        if (![iconURLString isEqualToString:@""]) {
            [mgr downloadImageWithURL:[NSURL URLWithString:iconURLString]
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                                 
                             }completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                                 
                             }];
        }
        
        // 大图片
        if (![img_url isEqualToString:@""]) {
            
            [mgr downloadImageWithURL:[NSURL URLWithString:img_url]
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                                 
                             }completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                                 
                             }];
            
            
        }
        
    }
    
}

@end
