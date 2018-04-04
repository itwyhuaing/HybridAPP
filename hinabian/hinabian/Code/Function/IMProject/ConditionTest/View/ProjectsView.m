//
//  ProjectsView.m
//  hinabian
//
//  Created by hnbwyh on 17/6/9.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "ProjectsView.h"
#import "NationalButton.h"
#import "ProjectNationsModel.h"
#import "ProjectItemModel.h"


@interface ProjectsView()

@property (nonatomic, strong) NationalButton *chosenNation;
@property (nonatomic, strong) NSMutableArray *selectedProj;
@property (nonatomic, strong) NSMutableArray *projButtonArr;
@property (nonatomic, strong) UILabel *titleLabel;

@end


@implementation ProjectsView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        CGRect rect = CGRectZero;
        
        rect.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_STATUSHEIGHT - SCREEN_NAVHEIGHT - SUIT_IPHONE_X_HEIGHT);
        self.proDelegate = (id)self;
        self.scrollEnabled = NO;
        self.showsHorizontalScrollIndicator = NO;
        
        rect.size.width = 110.f;
        rect.size.height = 50.f;
        rect.origin.x = SCREEN_WIDTH/2 - rect.size.width/2;
        rect.origin.y = 34.f;
        _chosenNation = [[NationalButton alloc] initWithFrame:rect];
        [_chosenNation setSelectedBtn];
        
        rect.size.width = 150.f;
        rect.size.height = 30.f;
        rect.origin.x = SCREEN_WIDTH/2 - rect.size.width/2;
        rect.origin.y = CGRectGetMaxY(_chosenNation.frame) + 13.f;
        _titleLabel = [[UILabel alloc] initWithFrame:rect];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = [NSString stringWithFormat:@"想办理的项目?"];
        _titleLabel.font = [UIFont systemFontOfSize:FONT_UI32PX];
        _titleLabel.tag = kChosenNationTag;
        
        [self addSubview:_chosenNation];
        [self addSubview:_titleLabel];
        
        _selectedProj  = [[NSMutableArray alloc] init];
        _projButtonArr = [[NSMutableArray alloc] init];
        
    }
    return self;
}

-(void)setViewWithNationModel:(ProjectNationsModel *)f
{
    
    _chosenNation.describeLabel.text = f.desc;
    _chosenNation.nationLabel.text = f.cn_short_name;
    _chosenNation.tag = kChosenNationTag;
    [_chosenNation addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    _proDataSource = [[NSMutableArray alloc] initWithArray:f.project_Arr];
    for (int index = 0; index < _proDataSource.count; index ++) {
        
        ProjectItemModel *itemModel = _proDataSource[index];
        
        CGRect rect = CGRectZero;
        rect.size.width = SCREEN_WIDTH - 60;
        rect.size.height = 40.f;
        rect.origin.x = SCREEN_WIDTH/2 - rect.size.width/2;
        rect.origin.y = CGRectGetMaxY(_titleLabel.frame) + 27 + 12*index + rect.size.height*index;
        
        NationalButton *tmpBtn = [[NationalButton alloc] initWithProjectFrame:rect];
        tmpBtn.tag = kTmpProjectBtnTag;
        tmpBtn.idTag = itemModel.project_id;
        [tmpBtn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [tmpBtn setTitle:itemModel.name forState:UIControlStateNormal];
        [self addSubview:tmpBtn];
        
        [_projButtonArr addObject:tmpBtn];
        
        if (CGRectGetMaxY(tmpBtn.frame) > SCREEN_HEIGHT - SCREEN_NAVHEIGHT - SCREEN_STATUSHEIGHT) {
            self.scrollEnabled = YES;
            self.contentSize = CGSizeMake(0, CGRectGetMaxY(tmpBtn.frame) + 20);
        }else{
            self.scrollEnabled = NO;
            self.contentSize = CGSizeMake(0, SCREEN_HEIGHT - SCREEN_NAVHEIGHT - SCREEN_STATUSHEIGHT);
        }
    }
    
}


-(void)clickEvent:(id)sender;
{
    NationalButton *tmpBtn = sender;
    if (tmpBtn.tag == kChosenNationTag) {
        if (_proDelegate && [_proDelegate respondsToSelector:@selector(cancelNationEvent)]) {
            
            [_proDelegate cancelNationEvent];
            
            [_selectedProj removeAllObjects];
            [_projButtonArr removeAllObjects];
        }
    }else{
        
        if (_proDelegate && [_proDelegate respondsToSelector:@selector(clickProjectItem:)]) {
            
            [self singleChosen:tmpBtn];
            
            [_proDelegate clickProjectItem:tmpBtn.idTag];
            
        }
        
    }
}

- (void)singleChosen:(NationalButton *)tmpBtn
{
    if (_selectedProj.count == 1) {
        NSString *tmpTitle = (NSString *)[_selectedProj firstObject];
        if ([tmpBtn.titleLabel.text isEqualToString:tmpTitle]) {
            return;
        }else{
            for (int index = 0; index < _projButtonArr.count; index++) {
                UIButton *btn = (UIButton *)_projButtonArr[index];
                if ([tmpTitle isEqualToString:btn.titleLabel.text]) {
                    [btn setBackgroundColor:[UIColor whiteColor]];
                    [btn setTitleColor:[UIColor DDNavBarBlue] forState:UIControlStateNormal];
                    break;
                }
            }
            [_selectedProj replaceObjectAtIndex:0 withObject:tmpBtn.titleLabel.text];
            [tmpBtn setBackgroundColor:[UIColor DDNavBarBlue]];
            [tmpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }else{
        [_selectedProj addObject:tmpBtn.titleLabel.text];
        [tmpBtn setBackgroundColor:[UIColor DDNavBarBlue]];
        [tmpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

@end
