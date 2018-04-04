//
//  ARSegmentView.m
//  ARSegmentPager
//
//  Created by August on 15/3/28.
//  Copyright (c) 2015年 August. All rights reserved.
//

#import "ARSegmentView.h"

@implementation ARSegmentView
{
    UIView *_bottomLine;
}

#pragma mark - init methods

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self _baseConfigs];
    }
    return self;
}

#pragma mark - private methods

-(void)_baseConfigs
{
//    self.translucent = NO;
    self.backgroundColor = [UIColor whiteColor];
    
    _segmentControl = [[UISegmentedControl alloc] init];
    _segmentControl.selectedSegmentIndex = 0;
    _segmentControl.tintColor = [UIColor clearColor];

    [_segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor DDNavBarBlue],NSFontAttributeName:[UIFont fontWithName:@"MarkerFelt-Thin"size:FONT_UI28PX*SCREEN_SCALE]} forState:UIControlStateSelected];
    [_segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont fontWithName:@"MarkerFelt-Thin"size:FONT_UI28PX*SCREEN_SCALE]} forState:UIControlStateNormal];
    [self addSubview:self.segmentControl];
    
    _bottomLine = [[UIView alloc] init];
    _bottomLine.backgroundColor = [UIColor colorWithRed:236/255.f green:236/255.f blue:236/255.f alpha:1.f];
    [self addSubview:_bottomLine];
    
    self.segmentControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentControl attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentControl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1 constant:-14]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentControl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:-16]];
    
    _bottomLine.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_bottomLine attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_bottomLine attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [_bottomLine addConstraint:[NSLayoutConstraint constraintWithItem:_bottomLine attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:1]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_bottomLine attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}

@end

