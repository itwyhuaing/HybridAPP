//
//  RecommendSpecialistView.m
//  hinabian
//
//  Created by 何松泽 on 2017/10/19.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "RecommendSpecialistView.h"
#import "RecommendSpecialistCell.h"
#import "RcmdSpecialModel.h"

@interface RecommendSpecialistView()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionViewFlowLayout *_layout;
    UICollectionView *_collectionView;
}
@end

@implementation RecommendSpecialistView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupMainView];
    }
    return self;
}

+ (instancetype) recommendSpecialistWithFrame:(CGRect)frame specialists:(NSArray *)dataArr delegate:(id<RecommendSpecialistDelegate>)delegate{
    
    RecommendSpecialistView *view = [[self alloc] initWithFrame:frame specialists:dataArr];
    view.delegate = delegate;
    view.dataArr = dataArr;
    return view;
}

- (instancetype) initWithFrame:(CGRect)frame specialists:(NSArray *)dataArr {

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
    _layout.itemSize = CGSizeMake(265, 195);
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
    _collectionView.contentInset = UIEdgeInsetsMake(4, 10, 4, 10);
    [_collectionView registerClass:[RecommendSpecialistCell class] forCellWithReuseIdentifier:cellNib_RecommendSpecialistCell];
    [self addSubview:_collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RecommendSpecialistCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellNib_RecommendSpecialistCell forIndexPath:indexPath];
    
    if (indexPath.row < self.dataArr.count) {
        [cell setModel:self.dataArr[indexPath.row]];
        [cell.consultBtn setTag:indexPath.row];
        [cell.consultBtn addTarget:self action:@selector(consultSpecialistsAtIndexPath:) forControlEvents:UIControlEventTouchUpInside];
    }else if (indexPath.row == self.dataArr.count) {
        [cell setShowAllCell];
    }
    
    
    return cell;
}

- (void)reFreshViewWithDataSource:(id)data{
    //NSLog(@" reFreshViewWithDataSource :%@ ",data);
    self.dataArr = (NSArray *)data;
    [_collectionView reloadData];
}


- (void)consultSpecialistsAtIndexPath:(UIButton *)btn {
    //NSLog(@"咨询咨询%ld",(long)btn.tag);
    if (_delegate && [_delegate respondsToSelector:@selector(recommendSpecialistConsult:)]) {
        [_delegate recommendSpecialistConsult:btn.tag];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_delegate && [_delegate respondsToSelector:@selector(recommendSpecialistCheckAtIndexPath:)]) {
        [_delegate recommendSpecialistCheckAtIndexPath:indexPath];
    }
}

@end




