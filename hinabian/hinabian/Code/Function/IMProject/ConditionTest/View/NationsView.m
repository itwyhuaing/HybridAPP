//
//  NationsView.m
//  hinabian
//
//  Created by hnbwyh on 17/6/9.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "NationsView.h"
#import "NationItemCell.h"
#import "NationHeaderRV.h"
#import "ProjectContientModel.h"
#import "ProjectNationsModel.h"

#define NATION_FOOTER_ID @"NationView_Footer_ID"
#define ITEM_HEIGHT 45.0
#define ITEM_GAP 15.0
#define SECTION_FIRST_HEADER_H 120
#define SECTION_HEADER_H 45.0
#define SECTION_FOOTER_H 18.0 // 20 - 2

@interface NationsView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UILabel *msgLabel;
@property (nonatomic,strong) UICollectionViewFlowLayout *layout;
@property (nonatomic,assign) CGRect selfRect;
@property (nonatomic,assign) CGSize itemSize;
@property (nonatomic,assign) NSIndexPath *lastSelectedIndex;

@end

@implementation NationsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //[self addSubview:self.msgLabel];
        
        // 参数默认值设置
        CGFloat widthRadio = [UIScreen mainScreen].bounds.size.width/350.0;
        CGFloat minLineSpace = ITEM_GAP * widthRadio;
        CGFloat minItemSpace = ITEM_GAP * widthRadio;
        UIEdgeInsets edgeSet = UIEdgeInsetsMake(10 * widthRadio, ITEM_GAP * widthRadio, 2, ITEM_GAP * widthRadio); // top - left - bottom - right
        
        // 初始化参数
        _selfRect = frame;
        _itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - minItemSpace*4)/3.0, ITEM_HEIGHT * widthRadio);
        
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _layout.minimumLineSpacing = minLineSpace;
        _layout.minimumInteritemSpacing = 0;    //重复设置会出现适配问题
        _layout.itemSize = _itemSize;
//        _layout.headerReferenceSize = CGSizeMake(_selfRect.size.width, SECTION_HEADER_H * widthRadio);
        _layout.footerReferenceSize = CGSizeMake(_selfRect.size.width, SECTION_FOOTER_H * widthRadio);
        _layout.sectionInset = edgeSet;
        
        _selfRect.origin.x = 0;
        _selfRect.origin.y = 0;//CGRectGetMaxY(self.msgLabel.frame) + 38.0;
        _collectView = [[UICollectionView alloc] initWithFrame:_selfRect collectionViewLayout:_layout];
        _collectView.bounces = NO;
        _collectView.dataSource = self;
        _collectView.delegate = self;
        _collectView.showsHorizontalScrollIndicator = NO;
        [_collectView registerClass:[NationItemCell class] forCellWithReuseIdentifier:cell_NationItemCell_identify];
        [_collectView registerClass:[NationHeaderRV class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseV_NationHeaderRV];
        [_collectView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NATION_FOOTER_ID];
        [self addSubview:_collectView];
        
        _collectView.backgroundColor = [UIColor whiteColor];
//        self.msgLabel.backgroundColor = [UIColor greenColor];
        
    }
    return self;
}

#pragma mark ------ UICollectionViewDataSource

-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        CGSize size = {_selfRect.size.width, SECTION_FIRST_HEADER_H};
        return size;
    }
    else
    {
        CGSize size = {_selfRect.size.width, SECTION_HEADER_H};
        return size;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    ProjectContientModel *f = self.nationDataSource[section];
    return f.nations_Arr.count;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.nationDataSource.count <= 0) {
        return 0;
    }
    return self.nationDataSource.count;
}


-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        NationHeaderRV *headerV = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseV_NationHeaderRV forIndexPath:indexPath];
        ProjectContientModel *f = self.nationDataSource[indexPath.section];
        [headerV configNationHeaderRVContentsWithAreaName:[NSString stringWithFormat:@"%@",f.cn_name]];
        if (indexPath.section == 0) {
            [headerV setTitleLabelHide:FALSE];
        }else{
            [headerV setTitleLabelHide:TRUE];
        }
        return headerV;
    }else{
        UICollectionReusableView *footerV = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NATION_FOOTER_ID forIndexPath:indexPath];
        return footerV;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    NationItemCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:cell_NationItemCell_identify forIndexPath:indexPath];
    ProjectContientModel *f = self.nationDataSource[indexPath.section];
    ProjectNationsModel *nationModel = f.nations_Arr[indexPath.row];
    [item configNationItemCellContentsWithDataModel:nationModel];
    return item;
}

#pragma mark ------ UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSLog(@" didSelectItemAtIndexPath : %ld ",indexPath.row);
    ProjectContientModel *f = self.nationDataSource[indexPath.section];
    ProjectNationsModel *nationModel = f.nations_Arr[indexPath.row]; 
    if (_delegate && [_delegate respondsToSelector:@selector(nationsView:didSelectedIndex:dataModel:)]) {
        [_delegate nationsView:self didSelectedIndex:indexPath dataModel:nationModel];
    }
    [self modifySelectedStateCurrentIndex:indexPath lastIndex:_lastSelectedIndex];
    _lastSelectedIndex = indexPath;
}


- (void)modifySelectedStateCurrentIndex:(NSIndexPath *)curIndex lastIndex:(NSIndexPath *)lastIndex{

//    NSLog(@" === > ");
    if (lastIndex != nil) {
        NationItemCell *lastCell = (NationItemCell *)[_collectView cellForItemAtIndexPath:lastIndex];
        lastCell.isSelected = NO;
    }
    NationItemCell *curCell = (NationItemCell *)[_collectView cellForItemAtIndexPath:curIndex];
    curCell.isSelected = YES;
    
}


- (void)setNationDataSource:(NSArray *)nationDataSource{
    
    _nationDataSource = nationDataSource;
    [_collectView reloadData];
    
}

-(UILabel *)msgLabel{

    if (_msgLabel == nil) {
        _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 15.0)];
        _msgLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
        _msgLabel.font = [UIFont systemFontOfSize:FONT_UI32PX];
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.text = @"想去哪个国家？";
    }
    return _msgLabel;
    
}

@end
