//
//  HKKTagWriteView.m
//  TagWriteViewTest
//
//  Created by kyokook on 2014. 1. 11..
//  Copyright (c) 2014 rhlab. All rights reserved.
//

#import "HKKTagWriteView.h"

//椭圆效果
#define BUTTON_ITEM_HEIGHT  33*SCREEN_SCALE_IPHONE6
#define BUTTON_ITEM_WIDTH   90*SCREEN_SCALE_IPHONE6
#define SCREEN_SCALE_IPHONE6    (SCREEN_WIDTH / SCREEN_WIDTH_6)
//

#define DISTANCE_FROM_EACH 10

#define COUNT_IN_ONE_ROW 3

@import QuartzCore;

@interface HKKTagWriteView  ()<UITextViewDelegate>
{
    NSInteger limit;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *tagViews;
@property (nonatomic, strong) UITextView *inputView;
@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, strong) NSMutableArray *tagsMade;

@property (nonatomic, assign) BOOL readyToDelete;

@end

@implementation HKKTagWriteView

#pragma mark - Life Cycle
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        [self initProperties];
        [self initControls];
        limit = 3;
        [self reArrangeSubViews];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initProperties];
    [self initControls];
    
    [self reArrangeSubViews];
}

#pragma mark - Property Get / Set
- (void)setFont:(UIFont *)font
{
    _font = font;
    for (UIButton *btn in _tagViews)
    {
        [btn.titleLabel setFont:_font];
    }
}

- (void)settagTextColor:(UIColor *)tagTextColor
{
    _tagTextColor = tagTextColor;
}

- (void)setTagBackgroundColor:(UIColor *)tagBackgroundColor
{
    _tagBackgroundColor = tagBackgroundColor;
    /*for (UIButton *btn in _tagViews)
    {
        [btn setBackgroundColor:_tagBackgroundColor];
    }*/
    
    _inputView.layer.borderColor = _tagBackgroundColor.CGColor;
    _inputView.textColor = _tagBackgroundColor;
}

- (void)setTagForegroundColor:(UIColor *)tagForegroundColor
{
    _tagForegroundColor = tagForegroundColor;
    for (UIButton *btn in _tagViews)
    {
        [btn setTitleColor:_tagForegroundColor forState:UIControlStateNormal];
    }
}

//- (void)setMaxTagLength:(int)maxTagLength
//{
//    _maxTagLength = maxTagLength;
//}

- (NSArray *)tags
{
    return _tagsMade;
}

- (void)setFocusOnAddTag:(BOOL)focusOnAddTag
{
    _focusOnAddTag = focusOnAddTag;
    if (_focusOnAddTag)
    {
        [_inputView becomeFirstResponder];
    }
    else
    {
        [_inputView resignFirstResponder];
    }
}

#pragma mark - Interfaces
- (void)clear
{
    _inputView.text = @"";
    [_tagsMade removeAllObjects];
    [self reArrangeSubViews];
}

- (void)setTextToInputSlot:(NSString *)text
{
    _inputView.text = text;
}

- (void)addTags:(NSArray *)tags
{
    if ([self tagsIsAlreadyFull]) {
        return;
    }

    
    for (NSString *tag in tags)
    {
        NSString * tagString  = [[[[tag stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByTrimmingCharactersInSet:[NSCharacterSet illegalCharacterSet]] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"　" withString:@""];
        
        NSArray *result = [_tagsMade filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF == %@", tagString]];
        if (result.count == 0)
        {

            [_tagsMade addObject:tagString];
        }
    }
    [self reArrangeSubViews];
    
    if ([self tagsIsAlreadyFull]) {
        _inputView.editable = FALSE;
        _inputView.layer.borderColor = [UIColor clearColor].CGColor;
    }
    
}

- (void)removeTags:(NSArray *)tags
{
    for (NSString *tag in tags)
    {
        NSArray *result = [_tagsMade filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF == %@", tag]];
        if (result)
        {
            [_tagsMade removeObjectsInArray:result]; 
        }
    }
    [self reArrangeSubViews];
    if (![self tagsIsAlreadyFull]) {
        _inputView.editable = TRUE;
       // _inputView.layer.borderColor = _tagBackgroundColor.CGColor;
    }

}
- (void)setTagsLimitNum:(NSInteger)limitNum
{
    limit = limitNum;
}

- (BOOL)tagsIsAlreadyFull
{
    if(_tagsMade.count < limit)
    {
        return NO;
    }
    else
    {
        return YES;
    }
    
    return NO;
}

- (void)setTagsBackGroudColorByCount
{
    switch (_tagsMade.count) {
        case 1:
//            _tagBackgroundColor = [UIColor DDLableBlue];
            _tagBackgroundColor = [UIColor DDNavBarBlue];
            break;
        case 2:
//            _tagBackgroundColor = [UIColor DDLableYellow];
            _tagBackgroundColor = [UIColor DDNavBarBlue];
            break;
        case 3:
//            _tagBackgroundColor = [UIColor DDLableRed];
            _tagBackgroundColor = [UIColor DDNavBarBlue];
            break;
        default:
            break;
    }
}

-(UIColor *) getTagsBackGroundByConut: (int)count
{
//    UIColor * tmpColor = [UIColor DDNavBarBlue];
//    switch (count) {
//        case 1:
////            tmpColor = [UIColor DDLableBlue];
//            _tagBackgroundColor = [UIColor DDNavBarBlue];
//            break;
//        case 2:
////            tmpColor = [UIColor DDLableYellow];
//            _tagBackgroundColor = [UIColor DDNavBarBlue];
//            break;
//        case 3:
////            tmpColor = [UIColor DDLableRed];
//            _tagBackgroundColor = [UIColor DDNavBarBlue];
//            break;
//        default:
//            break;
//    }
    return _tagBackgroundColor;
}


- (void)addTagToLast:(NSString *)tag animated:(BOOL)animated
{
    
    for (NSString *t in _tagsMade)
    {
        if ([tag isEqualToString:t])
        {
            //NSLog(@"DUPLICATED!");
            return;
        }
    }
    
    [_tagsMade addObject:tag];
    
    _inputView.text = @"";
    
    [self addTagViewToLast:tag animated:animated];
    [self layoutInputAndScroll];
    
    if ([_delegate respondsToSelector:@selector(tagWriteView:didMakeTag:)])
    {
        [_delegate tagWriteView:self didMakeTag:tag];
    }
    if ([self tagsIsAlreadyFull]) {
        _inputView.editable = FALSE;
        _inputView.layer.borderColor = [UIColor clearColor].CGColor;
    }
    
}

- (void)removeTag:(NSString *)tag animated:(BOOL)animated
{
    NSInteger foundedIndex = -1;
    for (NSString *t in _tagsMade)
    {
        if ([tag isEqualToString:t])
        {
            ////NSLog(@"FOUND!");
            foundedIndex = (NSInteger)[_tagsMade indexOfObject:t];
            break;
        }
    }
    
    if (foundedIndex == -1)
    {
        return;
    }

    [_tagsMade removeObjectAtIndex:foundedIndex];

    [self removeTagViewWithIndex:foundedIndex animated:animated completion:^(BOOL finished){
        //[self layoutInputAndScroll];
    }];
    if ([_delegate respondsToSelector:@selector(tagWriteView:didRemoveTag:)])
    {
        [_delegate tagWriteView:self didRemoveTag:tag];
    }
    if (![self tagsIsAlreadyFull]) {
        _inputView.editable = TRUE;
        //_inputView.layer.borderColor = _tagBackgroundColor.CGColor;
    }
    if (_tagViews.count < 1) {
        chooseLabel.alpha = 1.f;
    }
}

- (void)removeAllTags
{
    [_tagsMade removeAllObjects];
}

#pragma mark - Internals
- (void)initControls
{
    //NSLog(@"%f,%f,%f,%f",self.bounds.origin.x,self.bounds.origin.y,self.bounds.size.width,self.bounds.size.height);
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.scrollsToTop = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_scrollView];
    
    chooseLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _scrollView.frame.size.height)];
    chooseLabel.text = @"选择标签";
    chooseLabel.font = [UIFont systemFontOfSize:FONT_UI32PX*SCREEN_SCALE_IPHONE6];
    chooseLabel.textColor = [UIColor black50PercentColor];
    [_scrollView addSubview:chooseLabel];

    _inputView = [[UITextView alloc] initWithFrame:CGRectInset(self.bounds, 0, _tagGap)];
    _inputView.autocorrectionType = UITextAutocorrectionTypeNo;
    _inputView.delegate = self;
    _inputView.returnKeyType = UIReturnKeyDone;
    _inputView.contentInset = UIEdgeInsetsMake(-6, 0, 0, 0);
    _inputView.scrollsToTop = NO;
    _inputView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    _inputView.hidden = TRUE;
    [_scrollView addSubview:_inputView];
    
    _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(30, -10*SCREEN_SCALE, 15*SCREEN_SCALE, 15*SCREEN_SCALE)];
    [_deleteButton setBackgroundImage:[UIImage imageNamed:@"btn_tag_delete"] forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(deleteTagDidPush:) forControlEvents:UIControlEventTouchUpInside];
    _deleteButton.hidden = YES;
}

- (void)initProperties
{
    _font = [UIFont systemFontOfSize:14.0f];
    _tagBackgroundColor = [UIColor DDNavBarBlue];
    _tagForegroundColor = [UIColor whiteColor];
    _tagTextColor = [UIColor whiteColor];
    /* 限制10个字 */
    _maxTagLength = 10;
    
    _tagGap = 4.0f;
    
    _tagsMade = [NSMutableArray array];
    _tagViews = [NSMutableArray array];
    
    _readyToDelete = NO;
}

- (void)addTagViewToLast:(NSString *)newTag animated:(BOOL)animated
{
    CGFloat posX = [self posXForObjectNextToLastTagView];
    UIButton *tagBtn = [self tagButtonWithTag:newTag posX:posX];
    [tagBtn setBackgroundColor:[self getTagsBackGroundByConut:(int)(_tagsMade.count)]];
    [_tagViews addObject:tagBtn];
    tagBtn.tag = [_tagViews indexOfObject:tagBtn];
    [_scrollView addSubview:tagBtn];
    
    if (animated)
    {
        tagBtn.alpha = 0.0f;
        [UIView animateWithDuration:0.25 animations:^{
            tagBtn.alpha = 1.0f;
        }];
    }
}

- (void)removeTagViewWithIndex:(NSUInteger)index animated:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
    NSAssert(index < _tagViews.count, @"incorrected index");
    if (index >= _tagViews.count)
    {
        return;
    }
    
    UIView *deletedView = [_tagViews objectAtIndex:index];
    [deletedView removeFromSuperview];
    [_tagViews removeObject:deletedView];
    
    void (^layoutBlock)(void) = ^{
        CGFloat posX = _tagGap;
        for (int idx = 0; idx < _tagViews.count; ++idx)
        {
            UIView *view = [_tagViews objectAtIndex:idx];
            [view setBackgroundColor:[self getTagsBackGroundByConut:(idx+1)]];
            CGRect viewFrame = view.frame;
            viewFrame.origin.x = posX;
            view.frame = viewFrame;
            
            posX += viewFrame.size.width + _tagGap + ( _deleteButton.frame.size.width / 2);
            
            view.tag = idx;
        }
    };
    
    if (animated)
    {
        [UIView animateWithDuration:0.25 animations:layoutBlock completion:completion];
    }
    else
    {
        layoutBlock();
    }

}

- (void)reArrangeSubViews
{
    CGFloat accumX = _tagGap;
    _deleteButton.hidden = TRUE;
   [_deleteButton removeFromSuperview];

    
    NSMutableArray *newTags = [[NSMutableArray alloc] initWithCapacity:_tagsMade.count];
    int index = 1;
    for (NSString *tag in _tagsMade)
    {
        UIButton *tagBtn = [self tagButtonWithTag:tag posX:accumX];
        [tagBtn setBackgroundColor:[self getTagsBackGroundByConut:index]];
        [tagBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [newTags addObject:tagBtn];
        tagBtn.tag = [newTags indexOfObject:tagBtn];
        
        //为了换行加的label
        UILabel *buttonLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*SCREEN_SCALE_IPHONE6, 0, BUTTON_ITEM_WIDTH/6.2*5, BUTTON_ITEM_HEIGHT)];
        buttonLabel.text = tagBtn.titleLabel.text;
        [buttonLabel setFont:[UIFont systemFontOfSize:FONT_UI28PX*SCREEN_SCALE_IPHONE6]];
        buttonLabel.textAlignment = NSTextAlignmentCenter;
        buttonLabel.textColor = _tagTextColor;
//        buttonLabel.layer.borderColor = [UIColor DDNavBarBlue].CGColor;
//        buttonLabel.layer.borderWidth = 0.5;
        [tagBtn addSubview:buttonLabel];
        
        UIButton *tmpBorderView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, tagBtn.frame.size.width, tagBtn.frame.size.height)];
        tmpBorderView.layer.borderColor = [UIColor DDNavBarBlue].CGColor;
        tmpBorderView.layer.borderWidth = 1.0f;
        [[tmpBorderView layer]setCornerRadius:(BUTTON_ITEM_HEIGHT/ 2)];
        [tmpBorderView addTarget:self action:@selector(touchDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        //delButton
        UIButton *delBtn = [[UIButton alloc]initWithFrame:CGRectMake(BUTTON_ITEM_WIDTH-13*SCREEN_SCALE_IPHONE6, -1, 13*SCREEN_SCALE_IPHONE6, 13*SCREEN_SCALE_IPHONE6)];
        [delBtn setImage:[UIImage imageNamed:@"detail_content_cancel_btn_default"] forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(touchDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [tagBtn addSubview:tmpBorderView];
        [tagBtn addSubview:delBtn];
        
        
        if (buttonLabel.text.length > 5) {
            /*如果标签长度大于5，换两行*/
            buttonLabel.numberOfLines = 2;
            buttonLabel.font = [UIFont systemFontOfSize:FONT_UI26PX*SCREEN_SCALE_IPHONE6];
        }

        accumX += tagBtn.frame.size.width + ( _deleteButton.frame.size.width / 2);
        [_scrollView addSubview:tagBtn];
        index++;
    }
    
    for (UIView *oldTagView in _tagViews)
    {
        [oldTagView removeFromSuperview];
    }
    _tagViews = newTags;
    
    if (_tagViews.count < 1) {
        chooseLabel.alpha = 1.f;
    }else{
        chooseLabel.alpha = 0.f;
    }
    
    [self layoutInputAndScroll];
}

-(void)touchDeleteBtn:(id)sender
{
    UIButton *btn = sender;
    UIButton *tagBtn = (UIButton *)btn.superview;
    
    NSString *tag = tagBtn.titleLabel.text;
    [self removeTag:tag animated:YES];
    
}

- (void)layoutInputAndScroll
{
    if (![self tagsIsAlreadyFull])
    {
        _deleteButton.hidden = TRUE;
        [_deleteButton removeFromSuperview];

        CGFloat accumX = [self posXForObjectNextToLastTagView];

        CGRect inputRect = _inputView.frame;
        inputRect.origin.x = accumX;
        inputRect.origin.y = _tagGap + 3.0f;
//        inputRect.size.width = [self widthForInputViewWithText:_inputView.text];
//        inputRect.size.height = self.frame.size.height - 13.0f;
        inputRect.size.width = BUTTON_ITEM_WIDTH;
        inputRect.size.height = BUTTON_ITEM_HEIGHT;
        _inputView.frame = inputRect;
        _inputView.font = _font;
        _inputView.layer.borderColor = [self getTagsBackGroundByConut: (int)(_tagsMade.count + 1)].CGColor;//_tagBackgroundColor.CGColor;
        _inputView.layer.borderWidth = 1.0f;
        _inputView.layer.cornerRadius = _inputView.frame.size.height * 0.2f;
        _inputView.backgroundColor = [UIColor clearColor];
        _inputView.textColor = [self getTagsBackGroundByConut: (int)(_tagsMade.count + 1)];//_tagBackgroundColor;

        CGSize contentSize = _scrollView.contentSize;
        contentSize.width = accumX + inputRect.size.width + 20;
        _scrollView.contentSize = contentSize;

        [self setScrollOffsetToShowInputView];
    }
}

- (void)setScrollOffsetToShowInputView
{
    CGRect inputRect = _inputView.frame;
    CGFloat scrollingDelta = (inputRect.origin.x + inputRect.size.width) - (_scrollView.contentOffset.x + _scrollView.frame.size.width);
    if (scrollingDelta > 0)
    {
        CGPoint scrollOffset = _scrollView.contentOffset;
        scrollOffset.x += scrollingDelta + 40.0f;
        _scrollView.contentOffset = scrollOffset;
    }
}

- (void)setScrollOffsetToLeft
{
    CGPoint scrollOffset = _scrollView.contentOffset;
    scrollOffset.x = 0.0f;
    _scrollView.contentOffset = scrollOffset;
    
}

- (CGFloat)widthForInputViewWithText:(NSString *)text
{
    return MAX(50.0, [text sizeWithAttributes:@{NSFontAttributeName:_font}].width + 25.0f);
}

- (CGFloat)posXForObjectNextToLastTagView
{
    CGFloat accumX = _tagGap;
    if (_tagViews.count)
    {
        UIView *last = _tagViews.lastObject;
        
        accumX = last.frame.origin.x + last.frame.size.width + _tagGap +( _deleteButton.frame.size.width / 2);
    }
    return accumX;
}

- (UIButton *)tagButtonWithTag:(NSString *)tag posX:(CGFloat)posX
{
    
    UIButton *tagBtn = [[UIButton alloc] init];
    [tagBtn.titleLabel setFont:_font];
    //[tagBtn setBackgroundColor:_tagBackgroundColor];
    [tagBtn setTitleColor:_tagForegroundColor forState:UIControlStateNormal];
//    [tagBtn addTarget:self action:@selector(tagButtonDidPushed:) forControlEvents:UIControlEventTouchUpInside];
    [tagBtn setTitle:tag forState:UIControlStateNormal];
    
//    CGRect btnFrame = tagBtn.frame;
//    
//    btnFrame = CGRectMake(
//                                 posX,
//                                 _tagGap + 3.0f,
//                                 BUTTON_ITEM_WIDTH,
//                                 BUTTON_ITEM_HEIGHT
//                                 );
    CGRect btnFrame = CGRectMake(
                          posX,
                          _tagGap + 3.0f,
                          BUTTON_ITEM_WIDTH,
                          BUTTON_ITEM_HEIGHT
                          );
    [[tagBtn layer]setCornerRadius:(BUTTON_ITEM_HEIGHT/ 2)];
    
    btnFrame.origin.x = posX;
    btnFrame.origin.y = _tagGap + 3.0f;
    btnFrame.size.width = BUTTON_ITEM_WIDTH;
    btnFrame.size.height = BUTTON_ITEM_HEIGHT;
    tagBtn.frame = CGRectIntegral(btnFrame);
//    btnFrame.size.width = [tagBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:_font}].width + (tagBtn.layer.cornerRadius * 2.0f) + 20.0f;
//    btnFrame.size.height = self.frame.size.height - 13.0f;
//    tagBtn.layer.cornerRadius = btnFrame.size.height * 0.2f;
    
    ////NSLog(@"btn frame [%@] = %@", tag, NSStringFromCGRect(tagBtn.frame));
    
    return tagBtn;
}

- (void)detectBackspace
{
    if (_inputView.text.length == 0)
    {
        if (_readyToDelete)
        {
            // remove lastest tag
            if (_tagsMade.count > 0)
            {
                NSString *deletedTag = _tagsMade.lastObject;
                [self removeTag:deletedTag animated:YES];
                _readyToDelete = NO;
            }
        }
        else
        {
            _readyToDelete = YES;
        }
    }
}

#pragma mark - UI Actions
- (void)tagButtonDidPushed:(id)sender
{
    UIButton *btn = sender;
    //NSLog(@"tagButton pushed: %@, idx = %ld", btn.titleLabel.text, (long)btn.tag);
    
    if (_deleteButton.hidden == NO && btn.tag == _deleteButton.tag)
    {
        // hide delete button
        _deleteButton.hidden = YES;
        [_deleteButton removeFromSuperview];
    }
    else
    {
        // show delete button
        CGRect newRect = _deleteButton.frame;
        newRect.origin.x = btn.frame.origin.x + btn.frame.size.width - (newRect.size.width * 0.4f) - 5*SCREEN_SCALE;
        newRect.origin.y = _inputView.frame.origin.y + (_inputView.frame.size.height / 2) - (_deleteButton.frame.size.height / 2) - 10*SCREEN_SCALE;
        _deleteButton.frame = newRect;
        _deleteButton.tag = btn.tag;
        
        if (_deleteButton.superview == nil)
        {
            [_scrollView addSubview:_deleteButton];
        }
        _deleteButton.hidden = NO;
    }
}

- (void)deleteTagDidPush:(id)sender
{
    
    NSAssert(_tagsMade.count > _deleteButton.tag, @"out of range");
    if (_tagsMade.count <= _deleteButton.tag)
    {
        return;
    }
    
    _deleteButton.hidden = YES;
    [_deleteButton removeFromSuperview];
    
    NSString *tag = [_tagsMade objectAtIndex:_deleteButton.tag];
    [self removeTag:tag animated:YES];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length > 5) {
        NSString *strFore;
        NSString *strBack;
        for (int i = 0 ; i < 5; i++) {
            char c = [textView.text characterAtIndex:i];
            strFore = [NSString stringWithFormat:@"%@%c",strFore,c];
            NSLog(@"%@",strFore);
            if (i==4) {
                strFore = [NSString stringWithFormat:@"%@\n",strFore];
            }
        }
        for (int i = 5; i<textView.text.length; i++) {
            char c = [textView.text characterAtIndex:i];
            strBack = [NSString stringWithFormat:@"%@%c",strBack,c];
            NSLog(@"%@",strBack);
        }
        textView.text = [NSString stringWithFormat:@"%@,%@",strFore,strBack];
    }
    if ([text isEqualToString:@" "] || [text isEqualToString:@"\n"])
    {
        if (textView.text.length > 0)
        {
            [self addTagToLast:textView.text animated:YES];
            textView.text = @"";
        }

        if ([text isEqualToString:@"\n"])
        {
            [textView resignFirstResponder];
        }

        return NO;
    }
    
    CGFloat currentWidth = [self widthForInputViewWithText:textView.text];
    CGFloat newWidth = 0;
    NSString *newText = nil;
    
    if (text.length == 0)
    {
        // delete
        if (textView.text.length)
        {
            newText = [textView.text substringWithRange:NSMakeRange(0, textView.text.length - range.length)];
        }
        else
        {
            [self detectBackspace];
            return NO;
        }
    }
    else
    {
        if (textView.text.length + text.length > _maxTagLength)
        {
            return NO;
        }
        newText = [NSString stringWithFormat:@"%@%@", textView.text, text];
    }
    newWidth = [self widthForInputViewWithText:newText];
    
    CGRect inputRect = _inputView.frame;
    inputRect.size.width = newWidth;
    _inputView.frame = inputRect;

    CGFloat widthDelta = newWidth - currentWidth;
    CGSize contentSize = _scrollView.contentSize;
    contentSize.width += widthDelta;
    _scrollView.contentSize = contentSize;
    
    [self setScrollOffsetToShowInputView];
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([_delegate respondsToSelector:@selector(tagWriteView:didChangeText:)])
    {
        [_delegate tagWriteView:self didChangeText:textView.text];
    }
    
    if (_deleteButton.hidden == NO)
    {
        _deleteButton.hidden = YES;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([_delegate respondsToSelector:@selector(tagWriteViewDidBeginEditing:)])
    {
        [_delegate tagWriteViewDidBeginEditing:self];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([_delegate respondsToSelector:@selector(tagWriteViewDidEndEditing:)])
    {
        [_delegate tagWriteViewDidEndEditing:self];
    }
}
@end







