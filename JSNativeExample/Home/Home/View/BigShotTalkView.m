//
//  BigShotTalkView.m
//  hinabian
//
//  Created by 何松泽 on 2017/10/20.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "BigShotTalkView.h"
#import "BigShotCell.h"

@interface BigShotTalkView()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionViewFlowLayout *_layout;
    UICollectionView *_collectionView;
}
@end

@implementation BigShotTalkView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
        [self setupMainView];
    }
    return self;
}

+ (instancetype) bigShotTalkWithFrame:(CGRect)frame dataArr:(NSArray *)dataArr delegate:(id<BigShotTalkDelegate>)delegate{
    
    BigShotTalkView *view = [[self alloc] initWithFrame:frame dataArr:dataArr];
    view.delegate = delegate;
    view.dataArr = dataArr;
    return view;
}

- (instancetype) initWithFrame:(CGRect)frame dataArr:(NSArray *)dataArr {
    
    if (self = [super initWithFrame:frame]) {
        self.dataArr = dataArr;
        
        [self initialization];
        [self setupMainView];
    }
    return self;
}

- (void)initialization {
    
}

- (void)setupMainView {
    
    _layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat margin = 10;
    _layout.itemSize = CGSizeMake(262, 166);
    _layout.minimumInteritemSpacing = margin;
    _layout.minimumLineSpacing = margin;
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_layout];
    _collectionView.delegate = (id)self;
    _collectionView.dataSource = (id)self;
    _collectionView.alwaysBounceVertical = NO;
    _collectionView.alwaysBounceHorizontal = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    //Top---Left---Bottom---Right
    _collectionView.contentInset = UIEdgeInsetsMake(10, 10, 4, 10);
    [_collectionView registerClass:[BigShotCell class] forCellWithReuseIdentifier:cellNib_BigShotCell];
    [self addSubview:_collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BigShotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellNib_BigShotCell forIndexPath:indexPath];
    
    if (indexPath.row < self.dataArr.count) {
        [cell setModel:self.dataArr[indexPath.row]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_delegate && [_delegate respondsToSelector:@selector(bigShotTalkClick:)]) {
        [_delegate bigShotTalkClick:indexPath];
    }
}

- (void)reFreshViewWithDataSource:(id)data{
    self.dataArr = (NSArray *)data;
    [_collectionView reloadData];
}

@end





