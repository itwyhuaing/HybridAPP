//
//  IMAllCountryView.m
//  hinabian
//
//  Created by 何松泽 on 2017/8/25.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "IMAllCountryView.h"
#import "IMHomeNationTabModel.h"
#import "IMAllCountryCell.h"

@interface IMAllCountryView()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation IMAllCountryView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _dataArr = [[NSMutableArray alloc] init];
        
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _BGImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 2, 0, 2, 2)];
        _BGImageView.hidden = NO;
        _BGImageView.alpha = 1.0f;
        [_BGImageView setImage:[UIImage imageNamed:@"project_allcountry_bg"]];
        [self addSubview:_BGImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_STATUSHEIGHT + 5, SCREEN_WIDTH, 30)];
        _titleLabel.hidden = NO;
        _titleLabel.textColor = [UIColor blackColor];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:FONT_UI30PX]];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"全部国家";
        [self addSubview:_titleLabel];
        
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, SCREEN_STATUSHEIGHT + 5, 40, 40)];
        [_closeBtn setImage:[UIImage imageNamed:@"project_allcountry_delete"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeBtn];
        
        CGRect rect = CGRectZero;
        rect.origin.y = SCREEN_NAVHEIGHT + SCREEN_STATUSHEIGHT;
        rect.size.width = SCREEN_WIDTH;
        rect.size.height = SCREEN_HEIGHT - (SCREEN_NAVHEIGHT + SCREEN_STATUSHEIGHT);
        _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:_layout];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.alwaysBounceHorizontal = NO;
        
        self.backgroundColor = [UIColor clearColor];
        _collectionView.hidden = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [self.collectionView registerClass:[IMAllCountryCell class] forCellWithReuseIdentifier:cellNib_IMAllCountryCell];
        [self addSubview:_collectionView];
    }
    return self;
}

- (void)close {
    if (self.clickCloseBlock) {
        self.clickCloseBlock();
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IMAllCountryCell *cell;
    if (cell == nil) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellNib_IMAllCountryCell forIndexPath:indexPath];
    }
    IMHomeNationTabModel *model = _dataArr[indexPath.row];
    [cell setModel:model];
//    [cell setImageURL:model.f_icon];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectCellWithIndex) {
        self.didSelectCellWithIndex(indexPath);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREEN_WIDTH - 30)/3,(SCREEN_WIDTH - 50)/3);
}

@end
