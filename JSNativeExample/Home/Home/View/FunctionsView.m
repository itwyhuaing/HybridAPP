//
//  FunctionsView.m
//  LXYHOCFunctionsDemo
//
//  Created by hnbwyh on 17/5/27.
//  Copyright © 2017年 lachesismh. All rights reserved.
//

#import "FunctionsView.h"
#import "FunctionCellItem.h"
#import "IndexFunctionStatus.h"
#import "FunctionModel.h"
#import "ShowAllServicesModel.h"

#define kItemCount 5.0 // 4.5 屏幕尺寸的宽度显示的 item 个数

@interface FunctionsView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionViewFlowLayout *layout;
@property (nonatomic,strong) UICollectionView *collectView;
@property (nonatomic,assign) CGRect selfRect;
@property (nonatomic,assign) CGSize itemSize;
@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation FunctionsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 参数默认值设置
        //CGFloat widthRadio = [UIScreen mainScreen].bounds.size.width/320.0; // 以 320 为基准
        CGFloat widthRadio = [UIScreen mainScreen].bounds.size.width/375.0; // 以 375 为基准
        CGFloat minLineSpace = 5.f * widthRadio;
        CGFloat minItemSpace = 8.f * widthRadio;
        UIEdgeInsets edgeSet = UIEdgeInsetsMake(0, 8 * widthRadio, 0, 8 * widthRadio);
        
        // 初始化参数
        _selfRect = frame;
        //_itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - (edgeSet.left + minLineSpace*4))/kItemCount, _selfRect.size.height);
        _itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - (edgeSet.left + edgeSet.right + minLineSpace*4.0))/kItemCount, _selfRect.size.height); // V3.2
        _dataSource = [[NSMutableArray alloc] init];
        
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.minimumLineSpacing = minLineSpace;
        _layout.minimumInteritemSpacing = minItemSpace;
        _layout.itemSize = _itemSize;
        _layout.sectionInset = edgeSet;
        
        _selfRect.origin.x = 0;
        _selfRect.origin.y = 0;
        _collectView = [[UICollectionView alloc] initWithFrame:_selfRect collectionViewLayout:_layout];
        _collectView.bounces = NO;
        _collectView.dataSource = self;
        _collectView.delegate = self;
        _collectView.showsHorizontalScrollIndicator = NO;
        [_collectView registerClass:[FunctionCellItem class] forCellWithReuseIdentifier:cell_FunctionCellItem_identify];
        [self addSubview:_collectView];
        
        _collectView.backgroundColor = [UIColor whiteColor];
        _collectView.scrollEnabled = FALSE;
        
    }
    return self;
}


#pragma mark ------ modify layout property  updateLayout


#pragma mark ------ UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //+1 全部
    return self.dataSource.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FunctionCellItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:cell_FunctionCellItem_identify forIndexPath:indexPath];
    if (indexPath.row == self.dataSource.count) {
        [item setUpAllServiceCell];
    }else {
        id f = self.dataSource[indexPath.row];
        //[item configContentsWithDataModel:f];
        [item setUpItemCellWithModel:f];
    }
    
    
    return item;
}

#pragma mark ------ UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@" didSelectItemAtIndexPath : %ld ",indexPath.row);
    // < v3.0
//    IndexFunctionStatus *f = _dataSource[indexPath.row];
//    [[NSNotificationCenter defaultCenter] postNotificationName:HOMEPAGE_FUNCTION_NOTIFICATION object:f.no];
//    if(_delegate && [_delegate respondsToSelector:@selector(functionsViewDidSelectedModel:)]){
//        [_delegate functionsViewDidSelectedModel:f];
//    }
    
    // v 3.0
//    FunctionModel *f = _dataSource[indexPath.row];
//    if (_delegate && [_delegate respondsToSelector:@selector(functionsViewDidSelectedV30Model:)]) {
//        [_delegate functionsViewDidSelectedV30Model:f];
//    }
    
    // v3.2
    if (indexPath.row == self.dataSource.count) {
        if (_delegate && [_delegate respondsToSelector:@selector(functionsViewToAllShowServices)]) {
            [_delegate functionsViewToAllShowServices];
        }
    }else {
        ShowAllServicesModel *f = _dataSource[indexPath.row];
        if (_delegate && [_delegate respondsToSelector:@selector(functionsViewDidSelectedV30Model:)]) {
            [_delegate functionsViewDidSelectedV30Model:f];
        }
    }
}

-(void)refreshCollectionWithData:(NSArray *)data{

    if (data == nil || data.count <= 0) {
        return;
    }
    NSMutableArray *tmpData = [[NSMutableArray alloc] initWithArray:data];
    // 不隐藏数据模型进行一次由小到大的排序
    for (NSInteger cou = 0; cou < tmpData.count; cou ++) {
        IndexFunctionStatus *f = tmpData[cou];
        //NSLog(@"处理前 ： %@ - %@ - %@",f.no,f.isHide,f.title);
        if ([f.isHide isEqualToString:@"1"]) {
            [tmpData removeObject:f];
        }else{
            if (f.no != nil && f.no.length == 1) {
                NSString *tmpString = f.no;
                f.no = [NSString stringWithFormat:@"0%@",tmpString];
            }
            //NSLog(@" ====== > %@",f.no);
        }
    }
    if (tmpData.count <= 0) {
        return;
    }
    NSMutableArray *reslt = [[NSMutableArray alloc] initWithArray:[HNBUtils sortedObjects:tmpData withKey:@"no"]];
    [_dataSource removeAllObjects];
    // 恢复 f.no
    //NSLog(@"======");
    for (NSInteger cou = 0; cou < reslt.count; cou ++) {
        IndexFunctionStatus *f = reslt[cou];
        if (f.no != nil && [f.no hasPrefix:@"0"]) {
            NSString *tmpString = [f.no substringFromIndex:1];
            f.no = [NSString stringWithFormat:@"%@",tmpString];
        }
        [_dataSource addObject:f];
        //NSLog(@"最终处理数据 ： %@ - %@ - %@",f.no,f.isHide,f.title);
    }
    
    [_collectView reloadData];
    NSLog(@" refreshCollectionWithData ");
}

-(void)refreshCollectionWithV30Data:(NSArray *)data{
    
    if (data == nil || data.count <= 0) {
        return;
    }
    
    _dataSource = [[NSMutableArray alloc] initWithArray:data];
    [_collectView reloadData];
    
}

- (void)test{
    
}

@end
