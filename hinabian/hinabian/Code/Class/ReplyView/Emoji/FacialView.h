//
//  FacialView.h
//  KeyBoardTest
//
//  Created by wangqiulei on 11-8-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmojiEmoticons.h"
#import "Emoji.h"
#import "EmojiMapSymbols.h"
#import "EmojiPictographs.h"
#import "EmojiTransport.h"

@protocol facialViewDelegate;


@interface FacialView : UIView

{
    
    NSArray *faces;
}
@property (nonatomic, weak) id<facialViewDelegate> delegate;
-(void)loadFacialView:(int)page size:(CGSize)size;

@end


@protocol facialViewDelegate <NSObject>
@optional
-(void)selectedFacialView:(NSString*)str;

@end




