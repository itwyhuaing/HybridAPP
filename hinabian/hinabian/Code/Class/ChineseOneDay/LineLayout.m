

#import "LineLayout.h"

#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT       [UIScreen mainScreen].bounds.size.height
#define ITEM_SIZE 200.0
#define ACTIVE_DISTANCE 200
#define ZOOM_FACTOR 0.4

#define IPHONE5_HEIGHT      568
#define IPHONE4_HEIGHT      480

#define RESOLUTION          SCREEN_HEIGHT/568

@implementation LineLayout

-(id)init
{
    self = [super init];
    if (self) {
        self.minimumLineSpacing = 0.f;
        
        self.itemSize = CGSizeMake(ITEM_SIZE, SCREEN_HEIGHT);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

/**
 *  @author &#20313;&#22362;, 15-11-11 09:11:40
 *
 *  初始的layout外观将由该方法返回的UICollctionViewLayoutAttributes来决定
 *
 *  @param NSArray 各个content的rect的集合
 *
 *  @return 各个content的rect的集合
 */

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    NSArray *data = [super layoutAttributesForElementsInRect:rect];
    [data enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *obj, NSUInteger idx, BOOL *stop) {
        
        if (CGRectIntersectsRect (obj.frame,rect)) {
            CGFloat distance = CGRectGetMidX(visibleRect) - obj.center.x;
            CGRect frame = obj.frame;
            frame.origin.y += ABS(distance) * 0.05;
            //            frame.size.height -= ABS(distance) * 0.05;
            obj.frame = frame;
            
        }
    }];
    return data;
}

/**
 *  @author &#20313;&#22362;, 15-11-10 18:11:12
 *
 *  对当前屏幕中的UICollectionViewLayoutAttributes逐个与屏幕中心进行比较，找出最接近中心的一个
 *
 *  @param proposedContentOffset 没有对齐到网格时本来应该停下来的位置
 *  @param velocity              滑动速度的方向
 *
 *  @return 当前contentView位置
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat offsetAdjustment = MAXFLOAT;
    
    float contentOffsetX = 0;
    
    if (_distanceContextX <= 0 && velocity.x<0) {
        
        contentOffsetX = 0;
        _distanceContextX += contentOffsetX;
        
    }else if(_distanceContextX >= proposedContentOffset.x&& velocity.x > 0){
        
        contentOffsetX = 0;
        _distanceContextX += contentOffsetX;
        
    }else{
        
        if (velocity.x > 0) {
            contentOffsetX = CGRectGetWidth(self.collectionView.bounds);
        }
        else if(velocity.x < 0){
            contentOffsetX =-CGRectGetWidth(self.collectionView.bounds);
        }else{
            contentOffsetX = 0;
        }
        _distanceContextX += contentOffsetX;
        
    }
    
    
    CGFloat horizontalCenter = _distanceContextX + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    
    CGRect targetRect = CGRectMake(_distanceContextX, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    return CGPointMake(_distanceContextX, proposedContentOffset.y);
}


@end
