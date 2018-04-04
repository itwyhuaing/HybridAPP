//
//  ReplyDetailInfoView.m
//  hinabian
//
//  Created by hnbwyh on 16/11/14.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "ReplyDetailInfoView.h"
#import "TribeDetailInfoCellManager.h"
#import "FloorCommentModel.h"
#import "FloorCommentReplyModel.h"
#import "ReplyTableViewCell.h"
#import "IQKeyboardManager.h"

#define TextFieldPlaceHolder @"对TA说点什么吧"

@interface ReplyDetailInfoView ()<UITableViewDelegate,UITableViewDataSource,ReplyTableViewCellDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *inputView;

@property (nonatomic) CGRect rect;

@property (nonatomic,strong) TribeDetailInfoCellManager *manager;

@property (strong, nonatomic) UITextView *inputTextView;
@property (strong, nonatomic) UIButton * sendButton;
@property (strong, nonatomic) UILabel * uilabel;

@property (nonatomic) CGFloat keyBoardHeight;
@property (nonatomic) CGFloat textViewHeight;
@property (nonatomic) CGFloat inputViewY;
@property (nonatomic) NSInteger textRow;

@end

@implementation ReplyDetailInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _rect = frame;
        //_tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _rect.size.width, _rect.size.height - INPUT_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        
        _inputView = [[UIView alloc] initWithFrame:CGRectMake(0,_rect.size.height-INPUT_HEIGHT,_rect.size.width,INPUT_HEIGHT)];
        _inputView.backgroundColor = [UIColor DDNormalBackGround];
        [self addSubview:_inputView];
        /**< 创建 >*/
        _inputTextView = [[UITextView alloc] initWithFrame:CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE, 2.f, _rect.size.width - REPLY_INPUT_DISTANCE_TO_EDGE * 2.f, INPUT_HEIGHT-2.0*2)];
        _inputTextView.layer.borderColor = [UIColor DDInputLightGray].CGColor;
        _inputTextView.layer.borderWidth =1.0;
        _inputTextView.layer.cornerRadius = 6;
        _inputTextView.layer.masksToBounds = YES;
        _inputTextView.delegate = (id)self;
        _inputTextView.font = [UIFont systemFontOfSize:INPUT_FONT];
        [_inputView addSubview:_inputTextView];
        
        CGRect tmpRect = CGRectZero;
        tmpRect.origin.x = CGRectGetMinX(_inputTextView.frame)+3.0f;
        tmpRect.origin.y = CGRectGetMinY(_inputTextView.frame);
        tmpRect.size.width = CGRectGetWidth(_inputTextView.frame) - 3.0 * 2;
        tmpRect.size.height = CGRectGetHeight(_inputTextView.frame);
        _uilabel =  [[UILabel alloc] initWithFrame:tmpRect];
        _uilabel.text = TextFieldPlaceHolder;
        _uilabel.textColor = [UIColor DDInputLightGray];
        _uilabel.enabled = NO;//lable必须设置为不可用
        _uilabel.backgroundColor = [UIColor clearColor];
        _uilabel.font = [UIFont systemFontOfSize:16];
        [_inputView addSubview:_uilabel];
        
//        _inputView.backgroundColor = [UIColor redColor];
//        _uilabel.backgroundColor = [UIColor greenColor];
//        _inputTextView.backgroundColor = [UIColor cyanColor];
        
        _sendButton = [[UIButton alloc] initWithFrame:CGRectMake(_rect.size.width - REPLY_INPUT_DISTANCE_TO_EDGE - SEND_BUTTON_WIDTH, (_inputView.frame.size.height - SEND_BUTTON_HEIGHT) / 2.f, SEND_BUTTON_WIDTH, SEND_BUTTON_HEIGHT)];
        _sendButton.backgroundColor = [UIColor DDNavBarBlue];
        _sendButton.layer.cornerRadius = 5;
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor DDInputLightGray] forState:UIControlStateHighlighted];
        [_sendButton addTarget:self action:@selector(touchSendButton:) forControlEvents:UIControlEventTouchUpInside];
        _sendButton.hidden = TRUE;
        [_inputView addSubview:_sendButton];
        
        _textRow = 1;
//        /**< 关闭IQKeyboardManager监听 >*/
//        [[IQKeyboardManager sharedManager] setEnable:NO];
        
    
    }
    return self;
}


#pragma mark ------ UITableViewDelegate,UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return _manager.cellHeight;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ReplyTableViewCell *returnCell = [tableView dequeueReusableCellWithIdentifier:@"ReplyTableViewCellReplyDetail"];
    if (returnCell == nil) {
        
        returnCell = [[ReplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReplyTableViewCellReplyDetail"];
        returnCell.delegate = self;
        returnCell.cellStyle = ReplyTableViewCellReplyDetail;
        returnCell.layer.borderColor = [UIColor whiteColor].CGColor;
        returnCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    [returnCell setManager:_manager];
    
    return returnCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self endEditing:YES];
    
}

#pragma mark ------ ReplyTableViewCellDelegate

- (void)replyTableViewCell:(ReplyTableViewCell *)cell eventSource:(id)eventSource info:(id)info{
    
    if (_delegate && [_delegate respondsToSelector:@selector(replyDetailInfoView:didClickEvent:info:)]) {
        
        [_delegate replyDetailInfoView:self didClickEvent:eventSource info:info];
    }
    
}

#pragma mark ------ 数据接收与界面刷新

-(void)reFreshViewWithData:(TribeDetailInfoCellManager *)manager{

    _manager = manager;
    [_tableView reloadData];
    
}

#pragma mark ------ 输入处理
- (void)keyboardWillShow:(NSNotification *)notification {
    
    CGFloat curkeyBoardHeight = [[[notification userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    CGRect begin = [[[notification userInfo] objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect end = [[[notification userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    // 第三方键盘回调三次问题，监听仅执行最后一次
    if(begin.size.height>=0 && (begin.origin.y-end.origin.y>0)){
        _keyBoardHeight = curkeyBoardHeight;
        [self showKeyboard:notification];
    }
    
}

- (void)showKeyboard:(NSNotification *)notification {
    
    CGSize size = [_inputTextView sizeThatFits:CGSizeMake(SCREEN_WIDTH - REPLY_INPUT_DISTANCE_TO_EDGE * 3 - SEND_BUTTON_WIDTH,MAXFLOAT)];
    UIFont *font = [UIFont systemFontOfSize:INPUT_FONT];
    NSInteger tempRow = (NSInteger)size.height / font.lineHeight;
    
    CGRect tmpRect = _inputView.frame;
    CGRect inputTextRect = _inputTextView.frame;
    
    if (tempRow <= TEXTVIEW_LINE) {
        
        tmpRect.origin.y = _rect.size.height - _keyBoardHeight - size.height - 4.f;
        tmpRect.size.height = size.height + 4.f;
        inputTextRect.size.width = _rect.size.width - REPLY_INPUT_DISTANCE_TO_EDGE * 3.f - SEND_BUTTON_WIDTH;
        inputTextRect.size.height = size.height;
        
    }else{

        tmpRect.origin.y = _rect.size.height - _keyBoardHeight - _textViewHeight - 4.f;
        tmpRect.size.height = _textViewHeight + 4.f;
        inputTextRect.size.width = _rect.size.width - REPLY_INPUT_DISTANCE_TO_EDGE * 3.f - SEND_BUTTON_WIDTH;
        inputTextRect.size.height = _textViewHeight;
    }
    
    [_inputView setFrame:tmpRect];
    [_inputTextView setFrame:inputTextRect];
    
}


#pragma mark ----  UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSString * isLogin = [HNBUtils sandBoxGetInfo:[NSString class] forKey:personal_is_login];
    if (isLogin == nil) {
        isLogin = @"0";
    }
    
    if ([isLogin isEqualToString:@"0"]) {
        
        [_inputTextView resignFirstResponder];
        [_inputTextView setText:@""];
        
        if (_delegate && [_delegate respondsToSelector:@selector(replyDetailInfoView:didClickEvent:info:)]) {
            [_delegate replyDetailInfoView:self didClickEvent:self info:_inputTextView.text];
        }
        
    }
    else
    {
        NSLog(@"textFieldDidBeginEditing");
        _inputViewY = _inputView.frame.origin.y;
        
        self.sendButton.hidden = FALSE;
        self.uilabel.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"textFieldDidEndEditing");
    
    CGSize size = [_inputTextView sizeThatFits:CGSizeMake(SCREEN_WIDTH - REPLY_INPUT_DISTANCE_TO_EDGE*2,MAXFLOAT)];
    UIFont *font = [UIFont systemFontOfSize:INPUT_FONT];
    NSInteger tempRow = (NSInteger)size.height / font.lineHeight;
    
    if (tempRow <= TEXTVIEW_LINE) {
        _inputView.frame = CGRectMake(0,_rect.size.height - size.height - 4, SCREEN_WIDTH, size.height + 4);
        _inputTextView.frame = CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE, 2, SCREEN_WIDTH - REPLY_INPUT_DISTANCE_TO_EDGE*2, size.height);
    }else{
        _inputView.frame = CGRectMake(0,_rect.size.height - _textViewHeight - 4, SCREEN_WIDTH, _textViewHeight + 4);
        _inputTextView.frame = CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE, 2, SCREEN_WIDTH - REPLY_INPUT_DISTANCE_TO_EDGE*2, _textViewHeight);
    }
    
    self.sendButton.hidden = TRUE;
    if (textView.text.length == 0) {
        self.uilabel.text = TextFieldPlaceHolder;
    }else{
        self.uilabel.text = @"";
    }
}

-(void)textViewDidChange:(UITextView *)textView{
    
    _inputViewY = _inputView.frame.origin.y;
    if (textView.text.length == 0) {
        
        self.uilabel.text = TextFieldPlaceHolder;
        
    }else{
        
        UIFont *font = [UIFont systemFontOfSize:INPUT_FONT];
        CGSize size = [textView sizeThatFits:CGSizeMake(textView.frame.size.width,MAXFLOAT)];
        /*获取textview当前行数*/
        NSInteger tempRow = (NSInteger)size.height / font.lineHeight;
        
        if (tempRow < TEXTVIEW_LINE && tempRow > _textRow) {
            
            _inputTextView.frame = CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE, 2, textView.frame.size.width, size.height);
            _inputView.frame = CGRectMake(0, _inputViewY - font.lineHeight, SCREEN_WIDTH, size.height + 4);
            [_inputTextView setContentOffset:CGPointMake(0, -5)];
            _textViewHeight = _inputTextView.frame.size.height;
            _textRow ++;
            
        }else if (_textRow <= TEXTVIEW_LINE && tempRow < _textRow){
            
            _inputTextView.frame = CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE, 2, textView.frame.size.width, size.height);
            _inputView.frame = CGRectMake(0, _inputViewY + font.lineHeight, SCREEN_WIDTH, size.height + 4);
            _textViewHeight = _inputTextView.frame.size.height;
            _textRow --;
            
        }
        self.uilabel.text = @"";
    }
}


- (void)touchSendButton:(UIButton *)btn{
    
    if (_delegate && [_delegate respondsToSelector:@selector(replyDetailInfoView:didClickEvent:info:)]) {
        [self endEditing:YES];
        [_delegate replyDetailInfoView:self didClickEvent:_inputTextView info:_inputTextView.text];
    }
    
}

- (void)SuccessedSendInfo{

    [self endEditing:YES];
    
    _inputView.frame = CGRectMake(0,_rect.size.height - INPUT_HEIGHT, SCREEN_WIDTH, INPUT_HEIGHT);
    _inputTextView.frame = CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE, 2, SCREEN_WIDTH - REPLY_INPUT_DISTANCE_TO_EDGE * 2, INPUT_HEIGHT - 4.f);
    
    [_inputTextView setText:@""];
    _uilabel.text = TextFieldPlaceHolder;
    
}

- (void)failedSendInfo{
    
    [_inputTextView resignFirstResponder];
}

@end
