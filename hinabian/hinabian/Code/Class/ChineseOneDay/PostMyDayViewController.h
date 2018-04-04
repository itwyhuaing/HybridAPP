//
//  PostMyDayViewController.h
//  hinabian
//
//  Created by 余坚 on 15/10/10.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostMyDayViewController : UIBaseViewController

@property (strong, nonatomic) NSString * choseTribeName;
@property (strong, nonatomic) NSString * choseTribeCode;

/*TZImageView*/
-(id)initWithCamerImage:(NSMutableArray *)selectAsset
                  image:(NSMutableArray *)selectImage;
-(id)initWithPickeImage:(NSMutableArray *)selectAsset
                  image:(NSMutableArray *)selectImage;

-(void)configCollectionView;
-(void)configTextView;
@end
