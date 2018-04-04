//
//  HNBPreviewImageViewController.h
//  hinabian
//
//  Created by 何松泽 on 2017/11/15.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NIMSDK/NIMSDK.h>

@interface HNBGalleryItem : NSString
@property (nonatomic,copy)  NSString    *itemId;
@property (nonatomic,copy)  NSString    *thumbPath;
@property (nonatomic,copy)  NSString    *imageURL;
@property (nonatomic,copy)  NSString    *name;
@end

@interface HNBPreviewImageViewController : UIViewController

- (instancetype)initWithItem:(HNBGalleryItem *)item session:(NIMSession *)session;

@end
