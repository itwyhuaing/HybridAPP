//
//  ReplyView.m
//  hinabian
//
//  Created by 余坚 on 15/9/2.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import "ReplyView.h"
#import "UIView+KeyboardObserver.h"
#import "DataFetcher.h"
#import "LoginViewController.h"


#define REPLY_INPUT_DISTANCE_TO_EDGE  10.0f
#define FACE_TO_ADD_EDGE   15
#define TEXT_DISTANCE_FROM_EDGE 8
#define PRAISE_ICON_SIZE 18
#define FACE_ICON_SIZE 22
#define SEND_BUTTON_HEIGHT 23
#define SEND_BUTTON_WIDTH 48
#define SCROLL_VIEW_HEIGHT  220
#define INPUT_HEIGHT   33
#define INPUT_WIDTH   (SCREEN_WIDTH > SCREEN_WIDTH_6 ? (SCREEN_WIDTH*3/5):(SCREEN_WIDTH*2/4))
#define DISTANCE_FROM_INPUT_TO_EDGE  (SCREEN_WIDTH - INPUT_WIDTH - REPLY_INPUT_DISTANCE_TO_EDGE)/4

#define TIME                0.25

#define IMAGE_LIMIT_COUNT   9
#define TEXTVIEW_LINE       5
#define INPUT_FONT          16

typedef enum {
    ReplyViewStateKeyBoard    = 0,
    ReplyViewStateFace        = 1 << 0,
    ReplyViewStateAdd         = 1 << 1,
    ReplyViewStateDefault     = 1 << 5,
    
} ReplyViewState;

typedef enum {
    BtnCollect    = 1,
    BtnZan,
    BtnJump,
    BtnAdd,
    BtnFace,
    BtnSend,
} ButtonClick;

@interface ReplyView ()
{
    ReplyViewState state;
    
    CGRect Originalframe;
    NSRange lastTextLocation;   //光标最后的位置
    
    int   imageCount;
    int   textRow;
    float textViewHeight;
    float inputHeight;
    float keyBoardHeight;
    
    BOOL _isSelectOriginalPhoto;
    BOOL _isRepeat;
    BOOL _isInReply;
    BOOL _isUploading;
    BOOL _isPostTheLast;
    
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    NSMutableArray *_imageNameArr;
    NSMutableArray *_allImageArr;   //保存所有上传
    
    CGFloat _itemWH;
    CGFloat _margin;
    LxGridViewFlowLayout *_layout;
}

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray * imageArry;
@end

@implementation ReplyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        lastTextLocation = NSMakeRange(0, 0);
        Originalframe = frame;
        _isInReply = NO;
        _isUploading = NO;
        _isPostTheLast = NO;
        [self initLayOut];
        //[self addKeyboardObserver];
    }
    return self;
}

/* 布局 */
-(void) initLayOut
{
    state = ReplyViewStateDefault;
    
    self.inputTextField = [[UITextView alloc] initWithFrame:CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE, (self.frame.size.height-INPUT_HEIGHT)/2, INPUT_WIDTH, INPUT_HEIGHT)];
    self.inputTextField.layer.borderColor = [UIColor DDInputLightGray].CGColor;
    self.inputTextField.layer.borderWidth =1.0;
    self.inputTextField.layer.cornerRadius = 6;
    self.inputTextField.layer.masksToBounds = YES;
    self.inputTextField.delegate = (id)self;
    self.inputTextField.font = [UIFont systemFontOfSize:INPUT_FONT];
    [self addSubview:self.inputTextField];
    
    self.uilabel =  [[UILabel alloc] initWithFrame:CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE + 4, (self.frame.size.height-INPUT_HEIGHT)/2, INPUT_WIDTH, INPUT_HEIGHT)];
    self.uilabel.text = @"捧场点评";
    self.uilabel.textColor = [UIColor DDInputLightGray];
    self.uilabel.enabled = NO;//lable必须设置为不可用
    self.uilabel.backgroundColor = [UIColor clearColor];
    self.uilabel.font = [UIFont systemFontOfSize:FONT_UI24PX];
    [self addSubview:self.uilabel];
    
    self.collectImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"detial_toolbar_mark_btn_default"]];
    [self.collectImageView setFrame:CGRectMake(0, 0, 20, 20)];
    self.collectImageView.center = CGPointMake(REPLY_INPUT_DISTANCE_TO_EDGE + INPUT_WIDTH + DISTANCE_FROM_INPUT_TO_EDGE - 10, self.frame.size.height / 2);
    [self addSubview:self.collectImageView];
    
    self.zanImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tribe_show_zan"]];
    [self.zanImageView setFrame:CGRectMake(0, 0, PRAISE_ICON_SIZE, PRAISE_ICON_SIZE)];
    self.zanImageView.center = CGPointMake(REPLY_INPUT_DISTANCE_TO_EDGE + INPUT_WIDTH + DISTANCE_FROM_INPUT_TO_EDGE*2 - 10, self.frame.size.height / 2);
    [self addSubview:self.zanImageView];
    
    self.collectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, INPUT_HEIGHT)];
    self.collectButton.center = CGPointMake(REPLY_INPUT_DISTANCE_TO_EDGE + INPUT_WIDTH + DISTANCE_FROM_INPUT_TO_EDGE - 10, self.frame.size.height / 2);
    self.collectButton.tag = BtnCollect;
    [self addSubview:self.collectButton];
    
    self.zanButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 38, INPUT_HEIGHT)];
    self.zanButton.center = CGPointMake(REPLY_INPUT_DISTANCE_TO_EDGE + INPUT_WIDTH + DISTANCE_FROM_INPUT_TO_EDGE*2 - 10, self.frame.size.height / 2);
    self.zanButton.tag = BtnZan;
    [self addSubview:self.zanButton];
    
    self.jumpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, INPUT_HEIGHT)];
    self.jumpButton.center = CGPointMake(REPLY_INPUT_DISTANCE_TO_EDGE + INPUT_WIDTH + DISTANCE_FROM_INPUT_TO_EDGE*3 + 5, self.frame.size.height / 2);
    [self.jumpButton setTitle:@"跳页" forState:UIControlStateNormal];
    [self.jumpButton setTitleColor:[UIColor DDNavBarBlue] forState:UIControlStateNormal];
    [self.jumpButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.jumpButton.titleLabel setFont:[UIFont systemFontOfSize:FONT_UI28PX]];
    self.jumpButton.tag = BtnJump;
    [self addSubview:self.jumpButton];
    
    [self.collectButton addTarget:self action:@selector(BtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.zanButton addTarget:self action:@selector(BtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.jumpButton addTarget:self action:@selector(BtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    textRow = 1;
    textViewHeight = self.inputTextField.frame.size.height;
    inputHeight = self.frame.size.height-INPUT_HEIGHT;
    
    [self configCollectionView];
}

//WX版图片选择器
- (void)configCollectionView {
    self.imageArry = [NSMutableArray array];
    _imageNameArr = [NSMutableArray array];
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    _allImageArr = [NSMutableArray array];
    
    _margin = 4;
    _itemWH = (Originalframe.size.width - 2 * _margin - 4) / 4 - _margin;
    _layout = [[LxGridViewFlowLayout alloc] init];
    _layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    _layout.minimumInteritemSpacing = _margin;
    _layout.minimumLineSpacing = _margin;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, Originalframe.size.height / 2, Originalframe.size.width, _layout.itemSize.height + 10) collectionViewLayout:_layout];
    _collectionView.alwaysBounceVertical = NO;
    _collectionView.alwaysBounceHorizontal = YES;
    
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGFloat curkeyBoardHeight = [[[notification userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    CGRect begin = [[[notification userInfo] objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect end = [[[notification userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    // 第三方键盘回调三次问题，监听仅执行最后一次
    if(begin.size.height>0 && (begin.origin.y-end.origin.y>0)){
        keyBoardHeight = curkeyBoardHeight;
    }
}


//-(void) registFirstResponder
//{
//    [self fallAllView];
//}

//-(void) becomeFirstResponder
//{
//    if ([_delegate respondsToSelector:@selector(startReplyEditing)])
//    {
//        [_delegate startReplyEditing];
//    }
//    [_inputTextField becomeFirstResponder];
//}

-(void) replyBecomeFirstResponder{
    
    if ([_delegate respondsToSelector:@selector(startReplyEditing)])
    {
        [_delegate startReplyEditing];
    }
    [_inputTextField becomeFirstResponder];
    
}

/* 设置回复框是否可用 */
-(void) replyViewEnable:(BOOL)enable
{
    self.collectButton.enabled = enable;
    self.zanButton.enabled = enable;
    self.jumpButton.enabled = enable;
    self.inputTextField.editable = enable;
}

/* 缩下回复框 */
-(void) fallAllView
{
    if ([_delegate respondsToSelector:@selector(endReplyEditing)])
    {
        [_delegate endReplyEditing];
    }
    [UIView animateWithDuration:0.2f animations:^{
        [self setFrame:Originalframe];
    }];
    [_inputTextField resignFirstResponder];
    //[self.inputTextField becomeFirstResponder];
    state = ReplyViewStateKeyBoard;
    [self.scrollView removeFromSuperview];
    self.scrollView = nil;
    [self.faceButton setBackgroundImage:[UIImage imageNamed:@"tribe_show_face"] forState:UIControlStateNormal];
    if (self.inputTextField.text.length == 0) {
        self.uilabel.text = @"捧场点评";
    }else{
        self.uilabel.text = @"";
    }
    /*改变文本框高度*/
    [self changeTextFieldHeightByX:REPLY_INPUT_DISTANCE_TO_EDGE width:INPUT_WIDTH];
    /*隐藏发送按钮*/
    [self hideSendBtn:TRUE];
}

/*是否隐藏发送按钮*/
-(void)hideSendBtn:(BOOL)isHiden
{
    self.sendButton.hidden = isHiden;
    self.faceButton.hidden = isHiden;
    self.addButton.hidden = isHiden;
    self.zanButton.hidden = !isHiden;
    self.jumpButton.hidden = !isHiden;
    self.uilabel.hidden = !isHiden;
    self.collectButton.hidden = !isHiden;
    self.collectImageView.hidden = !isHiden;
    self.zanImageView.hidden = !isHiden;
}

#pragma mark --按钮点击事件
-(void)BtnClickEvent:(UIButton *)sender
{
    switch (sender.tag) {
        case BtnZan:
            /* 点赞接口被按下 */
            if ([_delegate respondsToSelector:@selector(HNBReplyViewZanButtonPressed)])
            {
                [_delegate HNBReplyViewZanButtonPressed];
            }
            break;
        case BtnCollect:
            /* 收藏按钮被按下 */
            if ([_delegate respondsToSelector:@selector(HNBReplyViewCollectButtonPressed)])
            {
                [_delegate HNBReplyViewCollectButtonPressed];
            }
            break;
        case BtnJump:
            /* 跳页按钮被按下 */
            [HNBClick event:@"107023" Content:nil];
            if ([_delegate respondsToSelector:@selector(HNBReplyViewJumpButtonPressed)])
            {
                [_delegate HNBReplyViewJumpButtonPressed];
            }
            break;
        case BtnAdd:
            /*添加图片按钮被按下*/
            [self addPicture];
            break;
        case BtnFace:
            /*发送表情按钮被按下*/
            [self disFaceKeyboard];
            break;
        case BtnSend:
            /* 发送按钮被按下 */
            if (_isUploading) {
                //正在传图，不可操作
                [[HNBToast shareManager] toastWithOnView:nil msg:@"正在上传图片，请稍后操作" afterDelay:1.0 style:HNBToastHudFailure];
                return;
            }
            if ([_delegate respondsToSelector:@selector(HNBReplyViewSendButtonPressed:TEXT:IMAGE:)])
            {
                [_delegate HNBReplyViewSendButtonPressed:self TEXT:self.inputTextField.text IMAGE:self.imageArry];
            }
            [self sendClear];
            break;
        default:
            break;
    }
}

- (void)deleteBtnClik:(UIButton *)sender {
    
    if (_isUploading) {
        //正在传图，不可删除
        [[HNBToast shareManager] toastWithOnView:nil msg:@"正在上传图片，请稍后操作" afterDelay:1.0 style:HNBToastHudFailure];
        return;
    }
    
    _layout.itemCount = _selectedPhotos.count;
    int tag = 0;
    id tmpImageAsset = _selectedAssets[sender.tag];
    PHAsset *phAsset;
    ALAsset *alAsset;
    if ([tmpImageAsset isKindOfClass:[ALAsset class]]) {
        alAsset = tmpImageAsset;
        ALAssetRepresentation* representation = [alAsset defaultRepresentation];
        for (int i = 0; i < _imageNameArr.count; i++) {
            if ([[representation filename] isEqualToString:_imageNameArr[i]]) {
                tag = i;
                break;
            }
        }
    }else if ([tmpImageAsset isKindOfClass:[PHAsset class]]){
        phAsset = tmpImageAsset;
        if (phAsset.mediaType == PHAssetMediaTypeImage) {
            for (int i = 0; i < _imageNameArr.count; i++) {
                if ([[phAsset valueForKey:@"filename"] isEqualToString:_imageNameArr[i]]) {
                    tag = i;
                    break;
                }
            }
        }
    }
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    
    [_imageNameArr removeObjectAtIndex:tag];
    [self.imageArry removeObjectAtIndex:tag];
    
    [_collectionView reloadData];
    if (_selectedPhotos.count <= 0) {
        [self.addButton setBadgeString:Nil];
    }else{
        [self.addButton setBadgeString:[NSString stringWithFormat:@"%lu",(unsigned long)_selectedPhotos.count]];
    }
}

/* 发送完成后处理 */
- (void) sendClear
{
    /* 清空对话框 */
    [self.inputTextField resignFirstResponder];
    [self.inputTextField setText:@""];
    self.uilabel.text = @"捧场点评";

    /* 清空控件 */
    [self.addButton setBadgeString:Nil];
    /* 清空图片数据 */
    imageCount = 0;
    [self.collectionView removeFromSuperview];
    self.collectionView = nil;
    if (_picscrollView != nil) {
        //如果picscrollView初始化了
        self.picscrollView.hidden = TRUE;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(hideMaskView:)]) {
        [_delegate hideMaskView:YES];
    }
    
    [self configCollectionView];
    [self fallAllView];
}
/* addbutton click */
-(void)addPicture
{
    [HNBClick event:@"107041" Content:nil];
    
    _isInReply = NO;
    
    [self.scrollView removeFromSuperview];
    self.scrollView = nil;
    
    state = ReplyViewStateAdd;
    
    [self.inputTextField resignFirstResponder];
    
    [self.faceButton setBackgroundImage:[UIImage imageNamed:@"tribe_show_face"] forState:UIControlStateNormal];
    
    self.frame = CGRectMake(0, Originalframe.origin.y - SCROLL_VIEW_HEIGHT,  SCREEN_WIDTH,Originalframe.size.height + SCROLL_VIEW_HEIGHT);
    self.picscrollView.hidden = FALSE;
    [self.picscrollView addSubview:_collectionView];
    
    [_delegate hideMaskView:NO];
    
    [self showAtionSheet];
}

/* facebutton click */
-(void)disFaceKeyboard{
    [HNBClick event:@"107042" Content:nil];
    //如果键盘没有显示，点击表情了，隐藏表情，显示键盘
    if (state == ReplyViewStateFace) {
        [self.inputTextField becomeFirstResponder];
        [self setFrame:Originalframe];
        state = ReplyViewStateKeyBoard;
        [self.scrollView removeFromSuperview];
        self.scrollView = nil;
        [self.faceButton setBackgroundImage:[UIImage imageNamed:@"tribe_show_face"] forState:UIControlStateNormal];
        [self changeTextFieldHeightByX:FACE_ICON_SIZE*2 + REPLY_INPUT_DISTANCE_TO_EDGE*2 + FACE_TO_ADD_EDGE width:self.sendButton.frame.origin.x - (FACE_ICON_SIZE*2 + REPLY_INPUT_DISTANCE_TO_EDGE*3 + FACE_TO_ADD_EDGE)];
        [_delegate hideMaskView:YES];
    }else{
        _isInReply = NO;
        if (_picscrollView != nil) {
            //如果picscrollView初始化了
            self.picscrollView.hidden = TRUE;
        }
        
        //键盘显示的时候，toolbar需要还原到正常位置，并显示表情
        [UIView animateWithDuration:TIME animations:^{
            self.frame = CGRectMake(0, Originalframe.origin.y - SCROLL_VIEW_HEIGHT,  SCREEN_WIDTH,Originalframe.size.height + SCROLL_VIEW_HEIGHT);
            
            float distance =self.inputTextField.frame.size.height - INPUT_HEIGHT - 5;
            
            self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, Originalframe.size.height + distance, SCREEN_WIDTH, SCROLL_VIEW_HEIGHT)];
            [self.scrollView setBackgroundColor:[UIColor clearColor]];
            self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH*9, SCROLL_VIEW_HEIGHT);
            self.scrollView.pagingEnabled=YES;
            [self scrollAddEmoji];
            [self addSubview:self.scrollView];
            
            if (_delegate && [_delegate respondsToSelector:@selector(hideMaskView:)]) {
                [_delegate hideMaskView:NO];
            }
            
        }];
        
        [self.inputTextField resignFirstResponder];
        [self.faceButton setBackgroundImage:[UIImage imageNamed:@"quanzi_tiezi_keyboard"] forState:UIControlStateNormal];
        state = ReplyViewStateFace;
    }
    
}

- (void) scrollAddEmoji
{
    for (int i=0; i<9; i++) {
        FacialView *fview=[[FacialView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCROLL_VIEW_HEIGHT)];
        [fview setBackgroundColor:[UIColor clearColor]];
        
        [fview loadFacialView:i size:CGSizeMake(SCREEN_WIDTH/9, 43)];
        fview.delegate=(id)self;
        [self.scrollView addSubview:fview];
    }
}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_selectedPhotos.count >= 9) {
        /*如果大于9张图，隐藏添加按钮*/
        return _selectedPhotos.count;
    }
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"quanzi_tiezi_tianjia.png"];
        cell.deleteBtn.hidden = YES;
        cell.gifLable.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.asset = _selectedAssets[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_isUploading) {
        //正在传图，不可操作
        [[HNBToast shareManager] toastWithOnView:nil msg:@"正在上传图片，请稍后操作" afterDelay:1.0 style:HNBToastHudFailure];
        return;
    }
    
    if (indexPath.row == _selectedPhotos.count) {
        BOOL showSheet = YES;
        if (showSheet) {
            [self showAtionSheet];
        } else {
            //直接进入相册再选择拍照
            [self pushImagePickerController];
        }
        
    } else { // preview photos or video / 预览照片或者视频
        id asset = _selectedAssets[indexPath.row];
        BOOL isVideo = NO;
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = asset;
            isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = asset;
            isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
        }
        if (isVideo) { // perview video / 预览视频
            TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
            vc.model = model;
            [self.superViewController presentViewController:vc animated:YES completion:nil];
        } else { // preview photos / 预览照片
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
            imagePickerVc.allowPickingOriginalPhoto = NO;
            imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                
                NSMutableArray *tempAssets = [NSMutableArray arrayWithArray:_selectedAssets];
                [tempAssets removeObjectsInArray:assets];
                
                for (id tmpImageAsset in tempAssets) {
                    NSString* filename;
                    if ([tmpImageAsset isKindOfClass:[ALAsset class]]) {
                        ALAssetRepresentation* representation = [tmpImageAsset defaultRepresentation];
                        filename = [representation filename];
                    }else if ([tmpImageAsset isKindOfClass:[PHAsset class]]){
                        filename =[tmpImageAsset valueForKey:@"filename"];
                    }
                    NSMutableArray *tempName = [NSMutableArray arrayWithArray:_imageNameArr];
                    for (int i = 0; i < tempName.count; i++) {
                        if ([filename isEqualToString:tempName[i]]) {
                            [_imageNameArr removeObjectAtIndex:i];
                            [self.imageArry removeObjectAtIndex:i];
                            break;
                        }
                    }
                }
                
                _selectedPhotos = [NSMutableArray arrayWithArray:photos];
                _selectedAssets = [NSMutableArray arrayWithArray:assets];
                _isSelectOriginalPhoto = isSelectOriginalPhoto;
                
                _layout.itemCount = _selectedPhotos.count;
                [_collectionView reloadData];
                if (_selectedPhotos.count <= 0) {
                    [self.addButton setBadgeString:Nil];
                }else{
                    [self.addButton setBadgeString:[NSString stringWithFormat:@"%lu",(unsigned long)_selectedPhotos.count]];
                }
            }];
            [self.superViewController presentViewController:imagePickerVc animated:YES completion:nil];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    if (sourceIndexPath.item >= _selectedPhotos.count || destinationIndexPath.item >= _selectedPhotos.count) return;
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    if (image) {
        [_selectedPhotos exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
        [_selectedAssets exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
        [_collectionView reloadData];
        if (_selectedPhotos.count <= 0) {
            [self.addButton setBadgeString:Nil];
        }else{
            [self.addButton setBadgeString:[NSString stringWithFormat:@"%lu",(unsigned long)_selectedPhotos.count]];
        }
    }
}

#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:IMAGE_LIMIT_COUNT delegate:self];
    
    /*四类个性化设置，这些参数都可以不传，此时会走默认设置*/
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    // 1.如果你需要将拍照按钮放在外面，不要传这个参数
    imagePickerVc.selectedAssets = _selectedAssets; // optional, 可选的
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    // 可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        _selectedAssets = [NSMutableArray arrayWithArray:assets];
    }];
    
    [self.superViewController presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - UIImagePickerController

//WX版图片选择器
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.superViewController.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.superViewController.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS8Later) {
        // 无权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    } else { // 调用相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVc.sourceType = sourceType;
            if(iOS8Later) {
                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self.superViewController presentViewController:_imagePickerVc animated:YES completion:nil];
        } else {
            //            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
}

//拍完照后
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:IMAGE_LIMIT_COUNT delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
            [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                [tzImagePickerVc hideProgressHUD];
                TZAssetModel *assetModel = [models firstObject];
                if (tzImagePickerVc.sortAscendingByModificationDate) {
                    assetModel = [models lastObject];
                }
                [_selectedAssets addObject:assetModel.asset];
                [_selectedPhotos addObject:image];
                [_collectionView reloadData];
                
                if (_selectedPhotos.count <= 0) {
                    [self.addButton setBadgeString:Nil];
                }else{
                    [self.addButton setBadgeString:[NSString stringWithFormat:@"%lu",(unsigned long)_selectedPhotos.count]];
                }
            }];
            //保存图片至服务器
            self.imageArry = [NSMutableArray array];
            _imageNameArr = [NSMutableArray array];
            
            //                for (id tmpImageAsset in _selectedAssets) {
            for (int i = 0;i<_selectedAssets.count; i++) {
                if (i == _selectedAssets.count - 1) {
                    //如果是最后一张图片
                    _isPostTheLast = YES;
                }
                id tmpImageAsset = _selectedAssets[i];
                id tmpImagePhoto = _selectedPhotos[i];
                NSString* filename;
                PHAsset *phAsset;
                ALAsset *alAsset;
                if ([tmpImageAsset isKindOfClass:[ALAsset class]]) {
                    alAsset = tmpImageAsset;
                    
                    ALAssetRepresentation* representation = [alAsset defaultRepresentation];
                    filename = [representation filename];
                    [self saveImage:[UIImage imageWithCGImage:alAsset.defaultRepresentation.fullScreenImage] Name:filename asset:tmpImageAsset photo:tmpImagePhoto];
                    
                }else if ([tmpImageAsset isKindOfClass:[PHAsset class]]){
                    phAsset = tmpImageAsset;
                    
                    filename =[phAsset valueForKey:@"filename"];
                    PHImageRequestOptions * options = [[PHImageRequestOptions alloc] init];
                    options.version = PHImageRequestOptionsVersionCurrent;
                    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
                    options.synchronous = YES;
                    [[PHImageManager defaultManager] requestImageDataForAsset: phAsset options: options resultHandler: ^(NSData * imageData, NSString * dataUTI, UIImageOrientation orientation, NSDictionary * info) {
                        [self saveImage:[UIImage imageWithData:imageData] Name:filename asset:tmpImageAsset photo:tmpImagePhoto];
                    }];
                }
            }
        }];

    }
    
}


#pragma mark - UIActionSheetDelegate

- (void)showAtionSheet
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册中选择", nil];
    [sheet showInView:self];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        /*拍照*/
        if (_selectedPhotos.count < 9) {
            [self takePhoto];
        }
    } else if (buttonIndex == 1) {
        /*打开相册*/
        [self pushImagePickerController];
    }
}

#pragma mark - TZImagePickerControllerDelegate

/* 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
 如果isSelectOriginalPhoto为YES，表明用户选择了原图
 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
 photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它*/
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    _layout.itemCount = _selectedPhotos.count;
    
    //保存图片至服务器
    self.imageArry = [NSMutableArray array];
    _imageNameArr = [NSMutableArray array];
    
    //    for (id tmpImageAsset in _selectedAssets) {
    for (int i = 0;i<assets.count; i++) {
        if (i == _selectedAssets.count - 1) {
            //如果是最后一张图片
            _isPostTheLast = YES;
        }
        id tmpImageAsset = assets[i];
        id tmpImagePhoto = photos[i];
        NSString* filename;
        PHAsset *phAsset;
        ALAsset *alAsset;
        if ([tmpImageAsset isKindOfClass:[ALAsset class]]) {
            alAsset = tmpImageAsset;
            
            ALAssetRepresentation* representation = [alAsset defaultRepresentation];
            filename = [representation filename];
            [self saveImage:[UIImage imageWithCGImage:alAsset.defaultRepresentation.fullScreenImage] Name:filename asset:tmpImageAsset photo:tmpImagePhoto];
            
        }else if ([tmpImageAsset isKindOfClass:[PHAsset class]]){
            phAsset = tmpImageAsset;
            
            filename =[phAsset valueForKey:@"filename"];
            PHImageRequestOptions * options = [[PHImageRequestOptions alloc] init];
            options.version = PHImageRequestOptionsVersionCurrent;
            options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
            options.synchronous = YES;
            [[PHImageManager defaultManager] requestImageDataForAsset: phAsset options: options resultHandler: ^(NSData * imageData, NSString * dataUTI, UIImageOrientation orientation, NSDictionary * info) {
                [self saveImage:[UIImage imageWithData:imageData] Name:filename asset:tmpImageAsset photo:tmpImagePhoto];
            }];
        }
    }
    
    [_collectionView reloadData];
    if (_selectedPhotos.count <= 0) {
        [self.addButton setBadgeString:Nil];
    }else{
        [self.addButton setBadgeString:[NSString stringWithFormat:@"%lu",(unsigned long)_selectedPhotos.count]];
    }
}

// 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/* 如果用户选择了一个视频，下面的handle会被执行
 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象*/
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    _layout.itemCount = _selectedPhotos.count;

    [_collectionView reloadData];
}

#pragma mark - Save Image

- (void)saveImage:(UIImage *)image Name:(NSString*) imageName asset:(id)asset photo:(id)photo{
    
    UIImage *selfPhoto = image;//读取图片文件
    
    if (_allImageArr.count != 0) {
        for (int i = 0 ; i < _allImageArr.count ; i++) {
            if ([[_allImageArr[i]valueForKey:@"name"] isEqualToString:imageName]) {
                [self.imageArry addObject:[_allImageArr[i]valueForKey:@"url"]];
                [_imageNameArr addObject:[_allImageArr[i]valueForKey:@"name"]];
                _isRepeat = YES;
                break;
            }
        }
        if (_isRepeat) {
            _isRepeat = NO;
        }else{
            _isUploading = YES;
            
            [DataFetcher updatePostImage:selfPhoto WithSucceedHandler:^(id JSON) {
                int errCode=   [[JSON valueForKey:@"state"] intValue];
                NSLog(@"errCode = %d",errCode);
                if (errCode == 0) {
                    id json1 = [JSON valueForKey:@"data"];
                    NSString * tmpString = [json1 valueForKey:@"real_url"];
                    [self.imageArry addObject:tmpString];
                    [_imageNameArr addObject:imageName];
                    [_allImageArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:imageName,@"name",tmpString,@"url", nil]];
                }
                [self isUpLoading];
                
            } withFailHandler:^(NSError *error) {
                [_selectedAssets removeObject:asset];
                [_selectedPhotos removeObject:photo];
                
                _layout.itemCount = _selectedAssets.count;
                [_collectionView reloadData];
                if (_selectedPhotos.count <= 0) {
                    [self.addButton setBadgeString:Nil];
                }else{
                    [self.addButton setBadgeString:[NSString stringWithFormat:@"%lu",(unsigned long)_selectedPhotos.count]];
                }
                
                [self isUpLoading];
                
                NSLog(@"errCode = %ld",(long)error.code);
            }];
            _isRepeat = NO;
        }
    }else{
        _isUploading = YES;
        
        [DataFetcher updatePostImage:selfPhoto WithSucceedHandler:^(id JSON) {
            int errCode=   [[JSON valueForKey:@"state"] intValue];
            NSLog(@"errCode = %d",errCode);
            if (errCode == 0) {
                id json1 = [JSON valueForKey:@"data"];
                NSString * tmpString = [json1 valueForKey:@"real_url"];
                [self.imageArry addObject:tmpString];
                [_imageNameArr addObject:imageName];
                [_allImageArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:imageName,@"name",tmpString,@"url", nil]];
                
            }
            [self isUpLoading];
            
        } withFailHandler:^(NSError *error) {
            [_selectedAssets removeObject:asset];
            [_selectedPhotos removeObject:photo];
            
            _layout.itemCount = _selectedAssets.count;
            [_collectionView reloadData];
            if (_selectedPhotos.count <= 0) {
                [self.addButton setBadgeString:Nil];
            }else{
                [self.addButton setBadgeString:[NSString stringWithFormat:@"%lu",(unsigned long)_selectedPhotos.count]];
            }
            
            [self isUpLoading];
            
            NSLog(@"errCode = %ld",(long)error.code);
        }];
    }
}

- (void)isUpLoading
{
    if (_isPostTheLast) {
        _isUploading = NO;
    }
}

#pragma mark - TextView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _isInReply = YES;
    if ([_delegate respondsToSelector:@selector(startReplyEditing)])
    {
        [_delegate startReplyEditing];
    }
    
    [HNBClick event:@"107021" Content:nil];
    // 友盟统计点击次数－帖子详情页的评论框
    if([self.from isEqualToString:@"1"]){
        //NSDictionary *dic = @{@"idForThem":_curUrlStr};
        [MobClick event:@"clickStartComment" attributes:nil];
    }
    self.from = @"1";
    NSString * isLogin = [HNBUtils sandBoxGetInfo:[NSString class] forKey:personal_is_login];
    if (isLogin == nil) {
        isLogin = @"0";
    }
    
    if (![isLogin isEqualToString:@"0"]) {
        [self hideSendBtn:FALSE];
        self.sendButton.alpha = 0.f;
        self.faceButton.alpha = 0.f;
        self.addButton.alpha  = 0.f;
        self.uilabel.text = @"";
        [self setFrame:Originalframe];
        /*改变文本框高度*/
        
        [UIView animateWithDuration:TIME animations:^{
            [self changeTextFieldHeightByX:FACE_ICON_SIZE*2 + REPLY_INPUT_DISTANCE_TO_EDGE*2 + FACE_TO_ADD_EDGE width:self.sendButton.frame.origin.x - (FACE_ICON_SIZE*2 + REPLY_INPUT_DISTANCE_TO_EDGE*3 + FACE_TO_ADD_EDGE)];
            self.sendButton.alpha = 1.f;
            self.faceButton.alpha = 1.f;
            self.addButton.alpha  = 1.f;
        } completion:^(BOOL finished) {
            
        }];
        
        state = ReplyViewStateKeyBoard;
        [self.scrollView removeFromSuperview];
        self.scrollView = nil;
        [self.faceButton setBackgroundImage:[UIImage imageNamed:@"tribe_show_face"] forState:UIControlStateNormal];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    lastTextLocation = textView.selectedRange;
    
//    if (self.scrollView == nil || (_picscrollView == nil || _picscrollView.hidden))
//    {
        //发图scrollview如果没有初始化或者初始化后隐藏了
//        [_delegate endReplyEditing];
//    }
    if (_isInReply) {
        [self fallAllView];
    }
    _isInReply = NO;
    
    if (textView.text.length == 0) {
        self.uilabel.text = @"捧场点评";
    }else{
        self.uilabel.text = @"";
    }
    
}

-(void)changeTextFieldHeightByX:(float)x width:(float)width
{
    CGSize size = [_inputTextField sizeThatFits:CGSizeMake(width,MAXFLOAT)];
    UIFont *font = [UIFont systemFontOfSize:INPUT_FONT];
    NSInteger tempRow = (NSInteger)size.height / font.lineHeight;
    CGRect inputViewFrame = self.frame;
    if (tempRow <= TEXTVIEW_LINE) {
        self.frame = CGRectMake(0,inputViewFrame.origin.y - (size.height - INPUT_HEIGHT), SCREEN_WIDTH, size.height + inputHeight);
        self.inputTextField.frame = CGRectMake(x, inputHeight/2, width, size.height);
    }else{
        self.frame = CGRectMake(0,inputViewFrame.origin.y - (textViewHeight - INPUT_HEIGHT), SCREEN_WIDTH, textViewHeight + inputHeight);
        self.inputTextField.frame = CGRectMake(x, inputHeight/2, width, textViewHeight);
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    float inputViewY = self.frame.origin.y;
    if (textView.text.length == 0) {
        self.uilabel.text = @"捧场点评";
    }else{
        UIFont *font = [UIFont systemFontOfSize:INPUT_FONT];
        CGSize size = [textView sizeThatFits:CGSizeMake(textView.frame.size.width,MAXFLOAT)];
        /*获取textview当前行数*/
        NSInteger tempRow = (NSInteger)size.height / font.lineHeight;
        
        if (tempRow < TEXTVIEW_LINE && tempRow > textRow) {
            self.inputTextField.frame = CGRectMake(FACE_ICON_SIZE*2 + REPLY_INPUT_DISTANCE_TO_EDGE*2 + FACE_TO_ADD_EDGE, inputHeight/2, textView.frame.size.width, size.height);
            self.frame = CGRectMake(0, inputViewY - font.lineHeight, SCREEN_WIDTH, size.height + inputHeight);
            textViewHeight = self.inputTextField.frame.size.height;
            [self.inputTextField setContentOffset:CGPointMake(0, -5)];
            textRow ++;
        }else if (tempRow <= TEXTVIEW_LINE && tempRow < textRow){
            self.inputTextField.frame = CGRectMake(FACE_ICON_SIZE*2 + REPLY_INPUT_DISTANCE_TO_EDGE*2 + FACE_TO_ADD_EDGE, inputHeight/2, textView.frame.size.width, size.height);
            self.frame = CGRectMake(0, inputViewY + font.lineHeight, SCREEN_WIDTH, size.height + inputHeight);
            textViewHeight = self.inputTextField.frame.size.height;
            textRow --;
        }
        if (_picscrollView != nil) {
            //如果picscrollView初始化了就要对y坐标进行适配
            float distance =self.inputTextField.frame.size.height - INPUT_HEIGHT;
            [self.picscrollView setFrame:CGRectMake(0, Originalframe.size.height + distance, SCREEN_WIDTH, SCROLL_VIEW_HEIGHT)];
        }
        
        self.uilabel.text = @"";
    }
}

#pragma mark --facialView delegate 点击表情键盘上的文字
-(void)selectedFacialView:(NSString*)str
{
    NSString *newStr;
    if ([str isEqualToString:@"删除"]) {
        if (self.inputTextField.text.length>0) {
            if ([[Emoji allEmoji] containsObject:[self.inputTextField.text substringWithRange:NSMakeRange(lastTextLocation.location - 2, 2)]]) {
                NSRange foreRange = NSMakeRange(0, lastTextLocation.location - 2);
                NSRange backRange = NSMakeRange(lastTextLocation.location, _inputTextField.text.length - lastTextLocation.location);
                NSString *foreStr = [self.inputTextField.text substringWithRange:foreRange];
                NSString *backStr = [self.inputTextField.text substringWithRange:backRange];
                newStr = [NSString stringWithFormat:@"%@%@",foreStr,backStr];
                lastTextLocation = NSMakeRange(lastTextLocation.location - 2, 0);
            }else{
                NSRange foreRange = NSMakeRange(0, lastTextLocation.location - 1);
                NSRange backRange = NSMakeRange(lastTextLocation.location, _inputTextField.text.length - lastTextLocation.location);
                NSString *foreStr = [self.inputTextField.text substringWithRange:foreRange];
                NSString *backStr = [self.inputTextField.text substringWithRange:backRange];
                newStr = [NSString stringWithFormat:@"%@%@",foreStr,backStr];
                lastTextLocation = NSMakeRange(lastTextLocation.location - 1, 0);
            }
            self.inputTextField.text=newStr;
        }
    }else{
        NSRange foreRange = NSMakeRange(0, lastTextLocation.location);
        NSRange backRange = NSMakeRange(lastTextLocation.location, _inputTextField.text.length - lastTextLocation.location);
        NSString *foreStr = [self.inputTextField.text substringWithRange:foreRange];
        NSString *backStr = [self.inputTextField.text substringWithRange:backRange];
        newStr = [NSString stringWithFormat:@"%@%@%@",foreStr,str,backStr];
        lastTextLocation = NSMakeRange(lastTextLocation.location + 2, 0);
    }
    
    UIFont *font = [UIFont systemFontOfSize:INPUT_FONT];
    CGSize size = [_inputTextField sizeThatFits:CGSizeMake(_inputTextField.frame.size.width,MAXFLOAT)];
    /*获取textview当前行数*/
    NSInteger tempRow = (NSInteger)size.height / font.lineHeight;
    
    if (tempRow < TEXTVIEW_LINE && tempRow > textRow) {
        self.inputTextField.frame = CGRectMake(FACE_ICON_SIZE*2 + REPLY_INPUT_DISTANCE_TO_EDGE*2 + FACE_TO_ADD_EDGE, inputHeight/2, _inputTextField.frame.size.width, size.height);
        self.frame = CGRectMake(0, self.frame.origin.y - font.lineHeight, SCREEN_WIDTH, size.height + inputHeight + SCROLL_VIEW_HEIGHT);
        textViewHeight = self.inputTextField.frame.size.height;
        textRow ++;
    }else if (tempRow <= TEXTVIEW_LINE && tempRow < textRow){
        self.inputTextField.frame = CGRectMake(FACE_ICON_SIZE*2 + REPLY_INPUT_DISTANCE_TO_EDGE*2 + FACE_TO_ADD_EDGE, inputHeight/2, _inputTextField.frame.size.width, size.height);
        self.frame = CGRectMake(0, self.frame.origin.y + font.lineHeight, SCREEN_WIDTH, size.height + inputHeight + SCROLL_VIEW_HEIGHT);
        textViewHeight = self.inputTextField.frame.size.height;
        textRow --;
    }
    float distance =self.inputTextField.frame.size.height - INPUT_HEIGHT;
    if (_picscrollView != nil) {
        //如果picscrollView初始化了就要对y坐标进行适配
        [self.picscrollView setFrame:CGRectMake(0, Originalframe.size.height + distance, SCREEN_WIDTH, SCROLL_VIEW_HEIGHT)];
    }
    [self.scrollView setFrame:CGRectMake(0, Originalframe.size.height + distance - 5, SCREEN_WIDTH, SCROLL_VIEW_HEIGHT)];
    
    [self.inputTextField setText:newStr];
}

#pragma mark --懒加载
-(UIButton *)sendButton
{
    if(!_sendButton){
        _sendButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - REPLY_INPUT_DISTANCE_TO_EDGE - SEND_BUTTON_WIDTH, (self.frame.size.height - SEND_BUTTON_HEIGHT) / 2, SEND_BUTTON_WIDTH, SEND_BUTTON_HEIGHT)];
        _sendButton.backgroundColor = [UIColor DDNavBarBlue];
        _sendButton.layer.cornerRadius = 5;
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor DDInputLightGray] forState:UIControlStateHighlighted];
        [_sendButton addTarget:self action:@selector(BtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        _sendButton.tag = BtnSend;
        [self addSubview:_sendButton];
    }
    return _sendButton;
}

-(MIBadgeButton *)addButton
{
    if (!_addButton) {
        _addButton = [MIBadgeButton buttonWithType:UIButtonTypeCustom];
        [_addButton setFrame:CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE, (self.frame.size.height - FACE_ICON_SIZE) / 2, FACE_ICON_SIZE, FACE_ICON_SIZE)];
        
        [_addButton setBadgeBackgroundColor:[UIColor DDNavBarBlue]];
        [_addButton addTarget:self action:@selector(BtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_addButton setBackgroundImage:[UIImage imageNamed:@"tribe_show_pic"] forState:UIControlStateNormal];
        _addButton.tag = BtnAdd;
        [self addSubview:_addButton];
    }
    return _addButton;
}

-(UIButton *)faceButton
{
    if (!_faceButton) {
        _faceButton = [[UIButton alloc] initWithFrame:CGRectMake(REPLY_INPUT_DISTANCE_TO_EDGE + FACE_TO_ADD_EDGE + FACE_ICON_SIZE, (self.frame.size.height - FACE_ICON_SIZE) / 2, FACE_ICON_SIZE, FACE_ICON_SIZE)];
        [_faceButton addTarget:self action:@selector(BtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_faceButton setBackgroundImage:[UIImage imageNamed:@"tribe_show_face"] forState:UIControlStateNormal];
        _faceButton.tag = BtnFace;
        [self addSubview:_faceButton];
    }
    return _faceButton;
}

-(UIScrollView *)picscrollView
{
    if (!_picscrollView) {
        float distance =self.inputTextField.frame.size.height - INPUT_HEIGHT;
        _picscrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, Originalframe.size.height + distance, SCREEN_WIDTH, SCROLL_VIEW_HEIGHT)];
        [self addSubview:_picscrollView];
    }
    return _picscrollView;
}

@end
