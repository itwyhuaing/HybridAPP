//
//  EditorViewCell.h
//  hinabian
//
//  Created by 何松泽 on 2017/6/6.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

typedef enum : NSUInteger{
    CareBtnTag = 1,
    HeadIconBtnTag,
}EditorButtonTag;

#import <UIKit/UIKit.h>


static NSString *cellNibName_EditorViewCell = @"EditorViewCell";

@interface EditorViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headIcon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *careButton;
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UIImageView *levelImage;
@property (weak, nonatomic) IBOutlet UIImageView *vImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *levelTrailingToView;

-(void)setViewWithPersonInfo:(id)info;
-(void)setCellHidden:(BOOL)isHidden;


@end
