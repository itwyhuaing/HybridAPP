//
//  IdeaBackMainView.m
//  hinabian
//
//  Created by 何松泽 on 2017/9/18.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "IdeaBackMainView.h"
#import "IdeaBackSuccessView.h"
//#import "HNBImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
//#import "HNBImageManager.h"
#import "DataFetcher.h"
#import <TZImagePickerController/TZImagePickerController.h>

#define ITEM_TOP_GAP 27
#define ITEM_HEIGHT 44
#define ITEM_LEADING_GAP 16
#define PHONE_IMAGE_HEIGT 130

#define TEXT_FONT  13
#define LABEL_HEIGHT    38
#define TEXTVIEW_HEIGHT 154

#define LIMITED_PHOTO_NUM   4

static const int kCloseViewHeight = 70.f;

@interface IdeaBackMainView() <UITextViewDelegate,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIActionSheetDelegate,TZImagePickerControllerDelegate>
{
    int photoNum;
    int postedPhotoNum;     //已传图片的数量
    
    //WX版图片选择器
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    NSMutableArray *_imageNameArr;
    NSMutableArray *_allImageArr;   //保存所有上传
    NSMutableArray *_cellArr;
    
    BOOL _isSelectOriginalPhoto;    //是否允许上传原图
    BOOL isRepeat;                  //是否上传了重复的照片
    BOOL isUploading;               //是否正在上传图片
    
    CGFloat _itemWH;
    CGFloat _margin;
    LxGridViewFlowLayout *_layout;
}

@property (nonatomic, strong) UICollectionView          *collectionView;
@property (nonatomic, strong) UIProgressView            *progressView; //传图进度条
@property (nonatomic, strong) UILabel                   *alertLabel;
@property (nonatomic, strong) UIScrollView   *pagingView; //用于滚动
@property (nonatomic, strong) UILabel        *photoLabel;
@property (nonatomic, strong) UIButton       *completeBtn;
@property (nonatomic, strong) UIView         *completeView;
@property (nonatomic, strong) IdeaBackSuccessView *successView;
@property (nonatomic, strong) UIViewController *superController;
@property (nonatomic, strong) NSMutableArray    *imageArry;

@end

@implementation IdeaBackMainView

- (instancetype)initWithFrame:(CGRect)frame
              superController:(UIViewController *)superController
{
    self = [super initWithFrame:frame];
    if (self) {
        self.superController = superController;
        
        [self loadViewWithFame:frame];
    }
    return self;
}

- (void)loadViewWithFame:(CGRect)frame{
    //加入分页
    self.pagingView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, (float)SCREEN_WIDTH, (float)SCREEN_HEIGHT)];
    self.pagingView.backgroundColor = [UIColor DDR153_G153_B153ColorWithalph:0.1f];
    self.pagingView.delegate = self;
    self.pagingView.pagingEnabled = true;
    self.pagingView.scrollEnabled = FALSE;
    self.pagingView.showsHorizontalScrollIndicator = false;
    self.pagingView.contentSize = CGSizeMake(self.pagingView.frame.size.width * 3,  self.pagingView.frame.size.height );
    
    _describeTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TEXTVIEW_HEIGHT)];
    _describeTextView.delegate = (id)self;
    _describeTextView.font = [UIFont systemFontOfSize:TEXT_FONT];
    _describeTextView.backgroundColor = [UIColor clearColor];
    
    _placeHoldTextView = [[UITextView alloc] initWithFrame:CGRectMake(0 , 0, SCREEN_WIDTH, TEXTVIEW_HEIGHT)];
    _placeHoldTextView.backgroundColor = [UIColor whiteColor];
    _placeHoldTextView.textColor = [UIColor DDR153_G153_B153ColorWithalph:1.0f];
    _placeHoldTextView.text = @" 请简要描述您要反馈的问题和意见";
    _placeHoldTextView.font = [UIFont systemFontOfSize:TEXT_FONT];
    /*主要作用是不允许其响应---->UIKeyboard如果有两个响应就会出现上下按钮*/
//    _placeHoldTextView.editable = NO;
    
    _photoLabel = [[UILabel alloc] initWithFrame:CGRectMake(ITEM_LEADING_GAP, CGRectGetMaxY(_placeHoldTextView.frame), SCREEN_WIDTH - 10, LABEL_HEIGHT)];
    _photoLabel.text = [NSString stringWithFormat:@"问题截图（选填，最多%d张）",LIMITED_PHOTO_NUM];
    _photoLabel.textColor = [UIColor blackColor];
    _photoLabel.textAlignment = NSTextAlignmentLeft;
    _photoLabel.font = [UIFont boldSystemFontOfSize:FONT_UI28PX];
    _photoLabel.backgroundColor = [UIColor clearColor];
    
    CGRect statusFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rect = CGRectZero;
    /*完成*/
    rect.origin.x = 0;
    if (IS_IPHONE_X) {
        rect.origin.y = SCREEN_HEIGHT - statusFrame.size.height - SCREEN_NAVHEIGHT - kCloseViewHeight - SUIT_IPHONE_X_HEIGHT;
    }else{
        rect.origin.y = SCREEN_HEIGHT - statusFrame.size.height - SCREEN_NAVHEIGHT - kCloseViewHeight;
    }
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = kCloseViewHeight;
    _completeView = [[UIView alloc]initWithFrame:rect];
    _completeView.backgroundColor = [UIColor whiteColor];
    _completeView.layer.borderColor = [UIColor DDEdgeGray].CGColor;
    _completeView.layer.borderWidth = 0.5f;
    
    rect.origin.x = ITEM_LEADING_GAP;
    rect.origin.y = 10;
    rect.size.width = SCREEN_WIDTH - ITEM_LEADING_GAP * 2;
    rect.size.height = kCloseViewHeight - 10 * 2;
    _completeBtn = [[UIButton alloc]initWithFrame:rect];
    [_completeBtn setTitle:@"提交反馈" forState:UIControlStateNormal];
    _completeBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_UI28PX];
    _completeBtn.titleLabel.textColor = [UIColor whiteColor];
    _completeBtn.layer.cornerRadius = RRADIUS_LAYERCORNE * 2.0;
    _completeBtn.enabled = FALSE;
    _completeBtn.backgroundColor = [UIColor DDR63_G162_B255ColorWithalph:0.6f];
    _completeBtn.layer.borderColor = [UIColor DDR63_G162_B255ColorWithalph:0.6f].CGColor;
    [_completeBtn addTarget:self action:@selector(clickComplete) forControlEvents:UIControlEventTouchUpInside];
    
    [_completeView addSubview:_completeBtn];
    [self addSubview:self.pagingView];
    [self.pagingView addSubview:_placeHoldTextView];
    [self.pagingView addSubview:_describeTextView];
    [self.pagingView addSubview:_photoLabel];
    [self.pagingView addSubview:_completeView];
    
    [self configCollectionView];
}

//WX版图片选择器
- (void)configCollectionView {
    _layout = [[LxGridViewFlowLayout alloc] init];
    _margin = 4;
    _itemWH = (self.frame.size.width - 2 * _margin - 4) / 4 - _margin;
    _layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    _layout.minimumInteritemSpacing = _margin;
    _layout.minimumLineSpacing = _margin;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_photoLabel.frame), self.frame.size.width, _layout.itemSize.height + 20) collectionViewLayout:_layout];
    _collectionView.alwaysBounceHorizontal = NO;
    _collectionView.alwaysBounceVertical = NO;
    
    CGFloat rgb = 255 / 255.0;
    _collectionView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    
    /*AlertLabel提醒剩余照片数量标签*/
    _alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_collectionView.frame), SCREEN_WIDTH, 30)];
    _alertLabel.backgroundColor = [UIColor whiteColor];
    _alertLabel.textAlignment = NSTextAlignmentCenter;
    _alertLabel.textColor = [UIColor DDR153_G153_B153ColorWithalph:1.0f];
    _alertLabel.text = [NSString stringWithFormat:@"已选择0张,还可添加%d张",LIMITED_PHOTO_NUM];
    _alertLabel.font = [UIFont systemFontOfSize:FONT_UI32PX];
    
    /*进度条*/
    _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_alertLabel.frame), SCREEN_WIDTH, 5)];
    _progressView.tintColor = [UIColor DDNavBarBlue];
    _progressView.progress = 0.f;
    _progressView.hidden = YES;
    
    [self.pagingView addSubview:_collectionView];
    [self.pagingView addSubview:self.alertLabel];
    [self.pagingView addSubview:_progressView];
    
}

//给UILabel设置行间距和字间距
-(void)setLabelSpace:(UILabel*)label
           withValue:(NSString*)str
            withFont:(UIFont*)font
     withLineSpacing:(float)lineSpacing{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentCenter;
    paraStyle.lineSpacing = lineSpacing; //设置行间距
    //设置字间距 NSKernAttributeName:@1.f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.f
                          };
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    label.attributedText = attributeStr;
}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_selectedPhotos.count >= LIMITED_PHOTO_NUM) {
        return _selectedPhotos.count;
    }
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.row == _selectedPhotos.count) {
        cell.layer.borderWidth = 1.0f;
        cell.layer.borderColor = [UIColor DDR153_G153_B153ColorWithalph:0.3f].CGColor;
        cell.clipsToBounds = NO;
        cell.imageView.image = [UIImage imageNamed:@"ideaback_Photo_image"];
        cell.deleteBtn.hidden = YES;
        cell.gifLable.hidden = YES;
    } else {
        cell.layer.borderWidth = 1.f;
        cell.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.clipsToBounds = YES;
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.asset = _selectedAssets[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (isUploading) {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"正在上传图片，请稍后操作" afterDelay:0.5 style:HNBToastHudFailure];
        return;
    }
    if (indexPath.row == _selectedPhotos.count) {
        //直接进入相册再选择拍照
        [self pushImagePickerController];
        
    } else {
        // preview photos / 预览照片
//            HNBImagePickerController *imagePickerVc = [[HNBImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
//            imagePickerVc.isIdeaBack = YES;
            imagePickerVc.allowPickingOriginalPhoto = NO;
            imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
        
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                
                NSMutableArray *tempAssets = [NSMutableArray arrayWithArray:_selectedAssets];
                [tempAssets removeObjectsInArray:assets];
                
                for (id tmpImageAsset in tempAssets) {
                    NSString* filename;
                    if ([tmpImageAsset isKindOfClass:[PHAsset class]]){
                        filename =[tmpImageAsset valueForKey:@"filename"];
                    }
                    NSMutableArray *tempName = [NSMutableArray arrayWithArray:_imageNameArr];
                    for (int i = 0; i < tempName.count; i++) {
                        if ([filename isEqualToString:tempName[i]]) {
                            postedPhotoNum --;  //除去删除的照片
                            [_imageNameArr removeObjectAtIndex:i];
                            [self.imageArry removeObjectAtIndex:i];
                            break;
                        }
                    }
                }
//                NSMutableArray *tempPhotos = [[NSMutableArray alloc] init];
//                for (id asset in assets) {
//                    [[HNBImageManager manager] getFastShowPhotoWithAsset:asset completion:^(UIImage *photo) {
//                    [tempPhotos addObject:photo];
//                    }];
//                }
//                _selectedPhotos = [NSMutableArray arrayWithArray:tempPhotos];
//                _selectedAssets = [NSMutableArray arrayWithArray:assets];
//                _isSelectOriginalPhoto = isSelectOriginalPhoto;
                
                _selectedPhotos = [NSMutableArray arrayWithArray:photos];
                _selectedAssets = [NSMutableArray arrayWithArray:assets];
                _isSelectOriginalPhoto = isSelectOriginalPhoto;
                
                _layout.itemCount = _selectedAssets.count;
                [_collectionView reloadData];
                //预览图片中更改选择图片后，发送notification
                [self changeLabelPhotoNum];
            }];
        [self.superController presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    if (sourceIndexPath.item >= _selectedPhotos.count || destinationIndexPath.item >= _selectedPhotos.count) return;
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    if (image) {
        [_selectedPhotos exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
        [_selectedAssets exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
        [_collectionView reloadData];
        [self changeLabelPhotoNum];
    }
}

- (void)saveImage:(UIImage *)image Name:(NSString*) imageName asset:(id)asset photo:(id)photo{
    
    UIImage *selfPhoto = image;//读取图片文件
    
    if (_allImageArr.count != 0) {
        for (int i = 0 ; i < _allImageArr.count ; i++) {
            if ([[_allImageArr[i]valueForKey:@"name"] isEqualToString:imageName]) {
                [self.imageArry addObject:[_allImageArr[i]valueForKey:@"url"]];
                [_imageNameArr addObject:[_allImageArr[i]valueForKey:@"name"]];
                isRepeat = YES;
                break;
            }
        }
        if (isRepeat) {
            //            postedPhotoNum ++;   //已上传的图片数量
            [self changePostProgress];
            isRepeat = NO;
        }else{
            isUploading = YES;
            
            [DataFetcher updatePostImage:selfPhoto WithSucceedHandler:^(id JSON) {
                int errCode= [[JSON valueForKey:@"state"] intValue];
                if (errCode == 0) {
                    id json1 = [JSON valueForKey:@"data"];
                    NSString * tmpString = [json1 valueForKey:@"real_url"];
                    [self.imageArry addObject:tmpString];
                    [_imageNameArr addObject:imageName];
                    [_allImageArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:imageName,@"name",tmpString,@"url", nil]];
                    
                    [self changePostProgress];
                }else
                {
                    [self postImageFailWithAsset:asset photo:photo];
                }
            } withFailHandler:^(NSError *error) {
                
                [self postImageFailWithAsset:asset photo:photo];
                
                NSLog(@"errCode = %ld",(long)error.code);
            }];
            
        }
    }else{
        isUploading = YES;
        
        [DataFetcher updatePostImage:selfPhoto WithSucceedHandler:^(id JSON) {
            int errCode = [[JSON valueForKey:@"state"] intValue];
            if (errCode == 0) {
                id json1 = [JSON valueForKey:@"data"];
                NSString * tmpString = [json1 valueForKey:@"real_url"];
                [self.imageArry addObject:tmpString];
                [_imageNameArr addObject:imageName];
                [_allImageArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:imageName,@"name",tmpString,@"url", nil]];
                
                [self changePostProgress];
            }else
            {
                [self postImageFailWithAsset:asset photo:photo];
            }
        } withFailHandler:^(NSError *error) {
            
            [self postImageFailWithAsset:asset photo:photo];
            
            NSLog(@"errCode = %ld",(long)error.code);
        }];
    }
}

-(void)postImageFailWithAsset:(id)asset photo:(id)photo
{
    [_selectedAssets removeObject:asset];
    [_selectedPhotos removeObject:photo];
    
    _layout.itemCount = _selectedAssets.count;
    [_collectionView reloadData];
    
    if (postedPhotoNum == _selectedPhotos.count) {
        isUploading = NO;
        _progressView.hidden = YES;
        [self changeLabelPhotoNum];
    }
}

-(void)changePostProgress
{
    postedPhotoNum ++;
    if (postedPhotoNum == _selectedPhotos.count) {
        isUploading = NO;
        NSLog(@"传图完成");
        _progressView.hidden = YES;
        [self changeLabelPhotoNum];
    }else{
        _progressView.hidden = NO;
        float progressValue = (float)postedPhotoNum/(float)_selectedPhotos.count;
        [_progressView setProgress:progressValue];
        
        self.alertLabel.text = [NSString stringWithFormat:@"已上传%lu/%lu",(unsigned long)postedPhotoNum,(unsigned long)_selectedPhotos.count];
    }
}

//更改提醒Label中已选择的照片数目
-(void)changeLabelPhotoNum
{
    self.alertLabel.text = [NSString stringWithFormat:@"已选择%lu张,还可添加%lu张",(unsigned long)_selectedPhotos.count,LIMITED_PHOTO_NUM -_selectedPhotos.count];
}

#pragma mark -- HNBImagePickerController
- (void)pushImagePickerController {
//    HNBImagePickerController *imagePickerVc = [[HNBImagePickerController alloc] initWithMaxImagesCount:LIMITED_PHOTO_NUM  columnNumber:4 delegate:self isIdeaBack:YES];
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:4 delegate:self];
#pragma mark -- 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    
    // 如果需要将拍照按钮放在外面，不要传这个参数
    imagePickerVc.selectedAssets = _selectedAssets; // optional, 可选的
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    // 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    // 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = NO;
#pragma mark -- 到这里为止
    
    // 通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        _selectedAssets = [NSMutableArray arrayWithArray:assets];
    }];
    
    [self.superController presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    _layout.itemCount = _selectedPhotos.count;
    
    //保存图片至服务器
    self.imageArry = [NSMutableArray array];
    _imageNameArr = [NSMutableArray array];
    
    postedPhotoNum = 0;
    _progressView.hidden = NO;
    float progressValue = (float)postedPhotoNum/(float)_selectedPhotos.count;
    [_progressView setProgress:progressValue];
    
    self.alertLabel.text = [NSString stringWithFormat:@"已上传%lu/%lu",(unsigned long)postedPhotoNum,(unsigned long)_selectedPhotos.count];
    
    for (int i = 0;i<assets.count; i++) {
        id tmpImageAsset = assets[i];
        id tmpImagePhoto = photos[i];
        
        NSString* filename;
        PHAsset *phAsset;
        if ([tmpImageAsset isKindOfClass:[PHAsset class]]){
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
    //    [self changeLabelPhotoNum];
}

#pragma mark ------ click event

- (void)clickComplete{
    [self endEditing:YES];
    
    if (isUploading) {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"正在上传图片，请稍后操作" afterDelay:0.5 style:HNBToastHudFailure];
        return;
    }
    [DataFetcher doIdeaBackWithContent:_describeTextView.text ImageList:self.imageArry withSucceedHandler:^(id JSON) {
        int errCode = [[JSON valueForKey:@"state"] intValue];
        
        if (errCode == 0) {
            //清空描述的全部内容，否则成功后点击返回会弹框
            _describeTextView.text = @"";
            [self nextOperation];
        }
    } withFailHandler:^(id error) {
        
    }];
}

//点击删除按钮
- (void)deleteBtnClik:(UIButton *)sender {
    
    if (isUploading) {
        //正在传图，不可删除
        [[HNBToast shareManager] toastWithOnView:nil msg:@"正在上传图片，请稍后操作" afterDelay:1.0 style:HNBToastHudFailure];
        return;
    }else{
        postedPhotoNum --;
        _layout.itemCount = _selectedAssets.count;
        int tag = 0;
        id tmpImageAsset = _selectedAssets[sender.tag];
        PHAsset *phAsset;
        if ([tmpImageAsset isKindOfClass:[PHAsset class]]){
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
        [self changeLabelPhotoNum];
    }
}

/*滚动到反馈成功页*/
- (void)nextOperation
{
    self.pagingView.backgroundColor = [UIColor whiteColor];
    
    _successView = [[IdeaBackSuccessView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT) superController:self.superController];
    [self.pagingView addSubview:_successView];
    
    [self.pagingView endEditing:YES];
    CGPoint pt = self.pagingView.contentOffset;
    if(pt.x == SCREEN_WIDTH * 2){
        [self.pagingView setContentOffset:CGPointMake(0, 0)];
        [self.pagingView scrollRectToVisible:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT) animated:YES];
    }else{
        pt.x += SCREEN_WIDTH;
        [self.pagingView setContentOffset:pt animated:YES];
    }
}

#pragma mark ------ TextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView == _describeTextView) {
        if(![text isEqualToString:@""])
        {
            [_placeHoldTextView setHidden:YES];
            _describeTextView.backgroundColor = [UIColor whiteColor];
        }
        if([text isEqualToString:@""] && range.length==1 && range.location==0){
            [_placeHoldTextView setHidden:NO];
            _describeTextView.backgroundColor = [UIColor clearColor];
        }
        if (1 == range.length) {//按下回格键
            return YES;
        }
        if ([textView.text length] < 500) {//判断字符个数
            return YES;
        }
    }
    
    return NO;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if (_describeTextView.text.length > 0) {
        _completeBtn.enabled = TRUE;
        _completeBtn.backgroundColor = [UIColor DDR63_G162_B255ColorWithalph:1.0f];
        _completeBtn.layer.borderColor = [UIColor DDR63_G162_B255ColorWithalph:1.0f].CGColor;
        
    }else{
        _completeBtn.enabled = FALSE;
        _completeBtn.backgroundColor = [UIColor DDR63_G162_B255ColorWithalph:0.6f];
        _completeBtn.layer.borderColor = [UIColor DDR63_G162_B255ColorWithalph:0.6f].CGColor;
        
    }
}


@end
