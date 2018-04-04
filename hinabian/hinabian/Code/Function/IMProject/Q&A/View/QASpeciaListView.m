//
//  QASpeciaListView.m
//  hinabian
//
//  Created by 余坚 on 16/7/26.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "QASpeciaListView.h"
#import "QASpecialList.h"

#define MAX_NUM         12
#define FIRST_SPECIAL_LEFT_DISTANCE 30
#define SPECIAL_ICON_SIZE   (42*SCREEN_SCALE)

@interface QASpeciaListView ()
@property (strong, nonatomic) UIScrollView *speciaListScrollView;
@property (strong, nonatomic) NSMutableArray *imageViewArray;    //专家头像
@property (strong, nonatomic) NSMutableArray *lableArray;        //专家标签
@property (strong, nonatomic) NSMutableArray *nameArray;         //专家姓名
@property (strong, nonatomic) NSMutableArray *buttonArray;
@end

@implementation QASpeciaListView

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSpeciaListScrollView:frame];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void) initSpeciaListScrollView:(CGRect)frame
{
    _speciaListScrollView = [[UIScrollView alloc] initWithFrame:frame];
    _speciaListScrollView.delegate = (id)self;
    _speciaListScrollView.showsHorizontalScrollIndicator = FALSE;
    [self addSubview:_speciaListScrollView];
    _speciaListScrollView.contentSize =  CGSizeMake(500, 0);
    _imageViewArray = [[NSMutableArray alloc] init];
    _lableArray = [[NSMutableArray alloc] init];
    _nameArray = [[NSMutableArray alloc] init];
    _buttonArray = [[NSMutableArray alloc] init];
    
    CGFloat distance = (SCREEN_WIDTH - FIRST_SPECIAL_LEFT_DISTANCE - (3.5)*SPECIAL_ICON_SIZE)/3;
    for (NSInteger i = 0; i < MAX_NUM; i++) {
        UIButton * tmpButton = [[UIButton alloc] initWithFrame:CGRectMake(FIRST_SPECIAL_LEFT_DISTANCE + (SPECIAL_ICON_SIZE + distance)*i, 16, SPECIAL_ICON_SIZE, SPECIAL_ICON_SIZE+30)];
        [tmpButton setBackgroundColor:[UIColor clearColor]];
        [tmpButton addTarget:self action:@selector(selectSpecial:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonArray addObject:tmpButton];
        
        UIImageView * tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(FIRST_SPECIAL_LEFT_DISTANCE + (SPECIAL_ICON_SIZE + distance)*i, 16, SPECIAL_ICON_SIZE, SPECIAL_ICON_SIZE)];
        tmpImageView.layer.cornerRadius = CGRectGetHeight(tmpImageView.frame) / 2.0;
        tmpImageView.layer.borderWidth = 1.f;
        tmpImageView.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:0.8f].CGColor; // ##E6E6E6
        tmpImageView.layer.masksToBounds = TRUE;
        [_imageViewArray addObject:tmpImageView];
        
        UILabel * nameLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 15)];
        [nameLable setFont:[UIFont systemFontOfSize:FONT_UI24PX]];
        [nameLable setTextColor:[UIColor colorWithRed:50.0/255.0f green:50.0/255.0f blue:50.0/255.0f alpha:1]];
        nameLable.textAlignment = NSTextAlignmentCenter;
        CGPoint lablePositon = CGPointMake(tmpImageView.center.x, tmpImageView.center.y + 14 + SPECIAL_ICON_SIZE / 2);
        nameLable.center = lablePositon;
        [_nameArray addObject:nameLable];
        
        UILabel * expertLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 22)];
        expertLable.layer.borderWidth = 1.0f;
        expertLable.layer.borderColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
        expertLable.layer.cornerRadius = CGRectGetHeight(expertLable.frame) / 2.0;
        [expertLable setFont:[UIFont systemFontOfSize:FONT_UI20PX]];
        [expertLable setTextColor:[UIColor colorWithRed:255.0/255.0f green:151.0/255.0f blue:92.0/255.0f alpha:1.0f]];
        expertLable.textAlignment = NSTextAlignmentCenter;
        CGPoint expertLablePositon = CGPointMake(tmpImageView.center.x, tmpImageView.center.y + 14 + SPECIAL_ICON_SIZE / 2 + 22 + 4);
        expertLable.center = expertLablePositon;
        expertLable.hidden = TRUE;
        [_lableArray addObject:expertLable];
        
        [_speciaListScrollView addSubview:tmpImageView];
        [_speciaListScrollView addSubview:nameLable];
        [_speciaListScrollView addSubview:expertLable];
        [_speciaListScrollView addSubview:tmpButton];
        
    }
}

- (void) QASpeciaListSet:(NSArray *)valueArry
{
    CGFloat distance = (SCREEN_WIDTH - FIRST_SPECIAL_LEFT_DISTANCE - (3.5)*SPECIAL_ICON_SIZE)/3;
    if (nil != valueArry) {
        NSInteger count = valueArry.count;
        for (int i = 0; i < count; i++) {
            QASpecialList * f = valueArry[i];
            [self setFunctionStatus:f Index:i];
        }
        if(count > MAX_NUM)
        {
           _speciaListScrollView.contentSize =  CGSizeMake(SPECIAL_ICON_SIZE * MAX_NUM + distance*(MAX_NUM - 1) + FIRST_SPECIAL_LEFT_DISTANCE*2, 0);
        }
        else
        {
           _speciaListScrollView.contentSize =  CGSizeMake(SPECIAL_ICON_SIZE * count + distance*(count - 1) + FIRST_SPECIAL_LEFT_DISTANCE*2, 0);
        }
        
    }
}

- (void) setFunctionStatus:(QASpecialList *) f Index:(NSInteger) index
{
    if (index < MAX_NUM && index >= 0) {
        UIButton * tmpButton = _buttonArray[index];
        UILabel * tmpNameLable = _nameArray[index];
        UILabel * tmpexpertLable = _lableArray[index];
        UIImageView * tmpImageView = _imageViewArray[index];
        tmpNameLable.text = f.name;
        tmpexpertLable.text = f.expertLabel;
        [tmpImageView sd_setImageWithURL:[NSURL URLWithString:f.headurl]];
        NSString *tribeItemButtonText = f.expertLabel;
        CGSize tribeSize = [tribeItemButtonText sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_UI20PX]}];
        CGFloat tmpW = tribeSize.width + 12 > SPECIAL_ICON_SIZE + 30.f ? SPECIAL_ICON_SIZE + 30.f : tribeSize.width + 12;
        [tmpexpertLable setFrame:CGRectMake(tmpexpertLable.frame.origin.x, tmpexpertLable.frame.origin.y, tmpW, tmpexpertLable.frame.size.height)];
        CGPoint expertLablePositon = CGPointMake(tmpImageView.center.x, tmpImageView.center.y + 14 + SPECIAL_ICON_SIZE / 2 + 22 + 4);
        tmpexpertLable.center = expertLablePositon;
        tmpexpertLable.hidden = FALSE;
        //设置跳转
        tmpButton.tag = [f.userid integerValue];
        //[tmpButton addTarget:self action:@selector(touchSpecialListButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void) selectSpecial:(UIButton *)sender
{
    //QA_INDEX_SPECIAL_SELECT_ITEM
    NSString *tmpID = [NSString stringWithFormat:@"%ld",sender.tag];
    [[NSNotificationCenter defaultCenter] postNotificationName:QA_INDEX_SPECIAL_SELECT_ITEM object:tmpID];
}


@end
