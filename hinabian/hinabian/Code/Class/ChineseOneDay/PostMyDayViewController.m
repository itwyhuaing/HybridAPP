//
//  PostMyDayViewController.m
//  hinabian
//
//  Created by 余坚 on 15/10/10.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import "PostMyDayViewController.h"
#import "RDVTabBarController.h"
#import "HNBCustomActionSheet.h"
#import "DataFetcher.h"
#import "Tribe.h"
#import "PersonalInfo.h"
#import "HNBToast.h"
#import "ActionSheetPicker.h"
#import "CODNation.h"
#import "MyOnedayViewController.h"

#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"

@interface PostMyDayViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UIPickerViewDelegate,UITextViewDelegate,UITextFieldDelegate, TZImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    //WX版图片选择器
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    NSMutableArray *_imageNameArr;
    NSMutableArray *_allImageArr;   //保存所有上传
    /*从别的入口传图片进来*/
    NSMutableArray *_tempPickerArry;
    NSMutableArray *_tempAssetsArry;
    
    BOOL _isSelectOriginalPhoto;
    BOOL _isRepeat;
    
    CGFloat _itemWH;
    CGFloat _margin;
    LxGridViewFlowLayout *_layout;
}

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) UITextView * postDescribeTextView;
@property (strong, nonatomic) UITextView * placeHoldTextView;
@property (strong, nonatomic) NSMutableArray *imageArry;

@property (strong, nonatomic) UILabel * tribeLabel;
@property (strong, nonatomic) UILabel * alertLabel;
@property (strong, nonatomic) UIButton * tribeLabelButton;
@property (strong, nonatomic) UIButton * choseTribeButton;

@property (strong, nonatomic) UIPickerView *tribePickerView;
@property (strong, nonatomic) NSArray *nationArray;//国家

@end

#define TEXT_DISTANCE_FROM_EDGE         8
#define POST_DESCRIBE_TEXT_ITEM_HEIGHT  100
#define POST_TEXT_VIEW_HEIGHT           120

#define ALERT_LABEL_HEIGHT      15

#define CHOSE_TRIBE_VIEW_HEIGHT     44
#define CHOSE_TRIBE_ICON_SIZE       18
#define CHOSE_LABEL_WIDTH           120
#define CHOSE_TRIBE_BUTTON_HEIGHT   4

#define IMAGE_LIMIT_COUNT    9

@implementation PostMyDayViewController

-(id)initWithCamerImage:(NSMutableArray *)selectAsset
                  image:(NSMutableArray *)selectImage
{
    if (self = [super init]) {
        _tempPickerArry = [[NSMutableArray alloc] initWithArray:selectImage];
        _tempAssetsArry = [[NSMutableArray alloc] initWithArray:selectAsset];
        
    }
    return self;
}

-(id)initWithPickeImage:(NSMutableArray *)selectAsset
                  image:(NSMutableArray *)selectImage
{
    if (self = [super init]) {
        _tempPickerArry = [[NSMutableArray alloc] initWithArray:selectImage];
        _tempAssetsArry = [[NSMutableArray alloc] initWithArray:selectAsset];
    }
    return self;
}

//WX版图片选择器
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"发表我的一天";
    // Do any additional setup after loading the view.
    
    [self configTextView];
    [self configCollectionView];
    
    self.imageArry = [NSMutableArray array];
    _imageNameArr = [NSMutableArray array];
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    _allImageArr = [NSMutableArray array];
    _isRepeat = NO;
    
    [self changeLabelPhotoNum];
    
    if (_tempPickerArry != nil) {
        _selectedPhotos = [NSMutableArray arrayWithArray:_tempPickerArry];
    }
    if (_tempAssetsArry != nil) {
        _selectedAssets = [NSMutableArray arrayWithArray:_tempAssetsArry];
    }
    //保存图片至服务器
    
    //    for (id tmpImageAsset in _selectedAssets) {
    for (int i = 0;i<_selectedAssets.count; i++) {
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
    
    [_collectionView reloadData];
    [self changeLabelPhotoNum];
}

//WX版图片选择器
- (void)configCollectionView {
    _layout = [[LxGridViewFlowLayout alloc] init];
    _margin = 4;
    _itemWH = (self.view.tz_width - 2 * _margin - 4) / 4 - _margin;
    _layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    _layout.minimumInteritemSpacing = _margin;
    _layout.minimumLineSpacing = _margin;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, POST_TEXT_VIEW_HEIGHT, self.view.tz_width, _layout.itemSize.height + 10) collectionViewLayout:_layout];
    _collectionView.alwaysBounceVertical = NO;
    _collectionView.alwaysBounceHorizontal = YES;
    
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    
    //AlertLabel提醒剩余照片数量标签
    float alertLabelH = _collectionView.frame.origin.y + _collectionView.frame.size.height + ALERT_LABEL_HEIGHT;
    self.alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, alertLabelH, SCREEN_WIDTH, ALERT_LABEL_HEIGHT)];
    [self.alertLabel setTextAlignment:NSTextAlignmentCenter];
    self.alertLabel.text = [NSString stringWithFormat:@"已选择 0 张,最多添加%d张照片",IMAGE_LIMIT_COUNT];
    self.alertLabel.textColor = [UIColor lightGrayColor];
    [self.alertLabel setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:self.alertLabel];
    
    /* 圈子选择区域 */
    UIView * tmpChoseTribe = [[UIView alloc] initWithFrame:CGRectMake(0,alertLabelH + ALERT_LABEL_HEIGHT, SCREEN_WIDTH, CHOSE_TRIBE_VIEW_HEIGHT)];
    tmpChoseTribe.backgroundColor = [UIColor whiteColor];
    UIImageView * tmpChoseTribeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(TEXT_DISTANCE_FROM_EDGE, (CHOSE_TRIBE_VIEW_HEIGHT-CHOSE_TRIBE_ICON_SIZE)/2, CHOSE_TRIBE_ICON_SIZE, CHOSE_TRIBE_ICON_SIZE)];
    tmpChoseTribeIcon.image = [UIImage imageNamed:@"quanzi_tiezi_globe"];
    [tmpChoseTribe addSubview:tmpChoseTribeIcon];
    
    self.tribeLabel = [[UILabel alloc] initWithFrame:CGRectMake(TEXT_DISTANCE_FROM_EDGE + CHOSE_TRIBE_ICON_SIZE + TEXT_DISTANCE_FROM_EDGE, (CHOSE_TRIBE_VIEW_HEIGHT-CHOSE_TRIBE_ICON_SIZE)/2, CHOSE_LABEL_WIDTH, CHOSE_TRIBE_ICON_SIZE)];
    [self.tribeLabel setTextColor:[UIColor DDBlack333]];
    self.tribeLabel.text = _choseTribeName;
    [tmpChoseTribe addSubview:self.tribeLabel];
    
    self.tribeLabelButton = [[UIButton alloc] initWithFrame:CGRectMake(TEXT_DISTANCE_FROM_EDGE + CHOSE_TRIBE_ICON_SIZE + TEXT_DISTANCE_FROM_EDGE, (CHOSE_TRIBE_VIEW_HEIGHT-CHOSE_TRIBE_ICON_SIZE)/2, CHOSE_LABEL_WIDTH, CHOSE_TRIBE_ICON_SIZE)];
    self.tribeLabelButton.backgroundColor = [UIColor clearColor];
    
    self.tribeLabel.text = @"点击选择所在地区";
    self.tribeLabel.font = [UIFont systemFontOfSize:14];
    [self.tribeLabel setTextColor:[UIColor DDNavBarBlue]];
    [self.tribeLabelButton addTarget:self action:@selector(choseMoreTribe:) forControlEvents:UIControlEventTouchUpInside];
    
    [tmpChoseTribe addSubview:self.tribeLabelButton];
    
    self.choseTribeButton = [[UIButton alloc] initWithFrame:CGRectMake(TEXT_DISTANCE_FROM_EDGE + CHOSE_TRIBE_ICON_SIZE + TEXT_DISTANCE_FROM_EDGE + CHOSE_LABEL_WIDTH, (CHOSE_TRIBE_VIEW_HEIGHT-CHOSE_TRIBE_BUTTON_HEIGHT)/2, 7, CHOSE_TRIBE_BUTTON_HEIGHT)];
    [self.choseTribeButton setImage:[UIImage imageNamed:@"quanzi_tiezi_more"] forState:UIControlStateNormal];
    if ([self.choseTribeCode isEqualToString:@""]) {
        [self.choseTribeButton addTarget:self action:@selector(choseMoreTribe:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [tmpChoseTribe addSubview:self.choseTribeButton];
    [self.view addSubview:tmpChoseTribe];
}

-(void)configTextView
{
    if (![self.choseTribeCode isEqualToString:@""]) {
        Tribe * f = [Tribe MR_findFirstByAttribute:@"id" withValue:self.choseTribeCode];
        self.choseTribeName = f.name;
    }
    
    /* 帖子内容 */
    self.postDescribeTextView = [[UITextView alloc] initWithFrame:CGRectMake(TEXT_DISTANCE_FROM_EDGE, 0, SCREEN_WIDTH - TEXT_DISTANCE_FROM_EDGE*2, POST_DESCRIBE_TEXT_ITEM_HEIGHT)];
    self.postDescribeTextView.backgroundColor = [UIColor clearColor];
    self.postDescribeTextView.returnKeyType = UIReturnKeyDefault;
    self.postDescribeTextView.delegate = (id)self;
    [self.postDescribeTextView setFont:[UIFont systemFontOfSize:14]];
    
    self.placeHoldTextView = [[UITextView alloc] initWithFrame:CGRectMake(TEXT_DISTANCE_FROM_EDGE, 0, SCREEN_WIDTH - TEXT_DISTANCE_FROM_EDGE*2, POST_DESCRIBE_TEXT_ITEM_HEIGHT)];
    self.placeHoldTextView.backgroundColor = [UIColor clearColor];
    [self.placeHoldTextView setTextColor:[UIColor lightGrayColor]];
    self.placeHoldTextView.text = @"描述您在海那边的一天";
    [self.placeHoldTextView setFont:[UIFont systemFontOfSize:14]];
    
    [self.view addSubview:self.placeHoldTextView];
    [self.view addSubview:self.postDescribeTextView];
}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_selectedPhotos.count >= IMAGE_LIMIT_COUNT) {
        /*如果大于限定张数图，隐藏添加按钮*/
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
    if (indexPath.row == _selectedPhotos.count) {
        BOOL showSheet = YES;
        if (showSheet) {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册中选择", nil];
            [sheet showInView:self.view];
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
            [self presentViewController:vc animated:YES completion:nil];
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
                //预览图片中更改选择图片后，发送notification
                [self changeLabelPhotoNum];
            }];
            [self presentViewController:imagePickerVc animated:YES completion:nil];
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
        [self changeLabelPhotoNum];
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
    
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        _selectedAssets = [NSMutableArray arrayWithArray:assets];
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - UIImagePickerController

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
            [self presentViewController:_imagePickerVc animated:YES completion:nil];
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
                
                [self changeLabelPhotoNum];
            }];
            //保存图片至服务器
            self.imageArry = [NSMutableArray array];
            _imageNameArr = [NSMutableArray array];
            
            //                for (id tmpImageAsset in _selectedAssets) {
            for (int i = 0;i<_selectedAssets.count; i++) {
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        /*拍照*/
        if (_selectedPhotos.count < IMAGE_LIMIT_COUNT) {
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
    [self changeLabelPhotoNum];
}

// 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    _layout.itemCount = _selectedPhotos.count;
    
    // open this code to send video / 打开这段代码发送视频
    // [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
    // NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
    // Export completed, send video here, send by outputPath or NSData
    // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    
    // }];
    [_collectionView reloadData];
    [self changeLabelPhotoNum];
}
//更改提醒Label中已选择的照片数目
-(void)changeLabelPhotoNum
{
    self.alertLabel.text = [NSString stringWithFormat:@"已选择 %lu 张,还可以添加%lu张照片",(unsigned long)_selectedPhotos.count,IMAGE_LIMIT_COUNT-_selectedPhotos.count];
}

#pragma mark Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    //    [_selectedPhotos removeObjectAtIndex:sender.tag];
    //    [_selectedAssets removeObjectAtIndex:sender.tag];
    
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
    [self changeLabelPhotoNum];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_postDescribeTextView resignFirstResponder];
}

#pragma mark - choseMoreTribe
/* 选择圈子按钮点击 */
- (void)choseMoreTribe:(UIButton *)sender
{
    [_postDescribeTextView resignFirstResponder];
    [self initTribeData];
    
    NSMutableArray *tribesArry = [[NSMutableArray alloc] init];
    for (CODNation * f in self.nationArray) {
        [tribesArry addObject:f.name];
    }
    
    [ActionSheetStringPicker showPickerWithTitle:@"请选择所在地区"
                                            rows:tribesArry
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           if (self.nationArray.count <= 0) {
                                               /*数据防护，没有数据时不赋值*/
                                               NSLog(@"NO Nation Data");
                                           }else{
                                               CODNation * f = self.nationArray[selectedIndex];
                                               self.choseTribeName = f.name;
                                               self.choseTribeCode = f.id;
                                               
                                               self.tribeLabel.text = f.name;
                                           }
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     }
                                          origin:sender];
}

-(void) back_main
{
    if ([_postDescribeTextView.text length] > 0 || self.imageArry.count > 0) {
        UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:@"是否放弃编辑"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
        alterview.delegate = (id)self;
        [alterview show];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //确定放弃编辑
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/* 国家选择器数据初始化 */
- (void) initTribeData
{
    self.nationArray = [CODNation MR_findAllSortedBy:@"timestamp" ascending:YES];
    
    if (self.nationArray.count <= 0) {  //如果没数据尝试再次请求国家列表
        dispatch_group_t indexLoad = dispatch_group_create();
        dispatch_queue_t indexQueue = dispatch_queue_create("indexQueue", DISPATCH_QUEUE_CONCURRENT);
        
        //先重新请求国家列表数据
        dispatch_group_enter(indexLoad);
        [DataFetcher doGetAllNationAndMobieNationAllCODNationInfo:^(id JSON) {
            dispatch_group_leave(indexLoad);
        } withFailHandler:^(id error) {
            dispatch_group_leave(indexLoad);
        }];
        
        //再进行赋值
        dispatch_group_notify(indexLoad, indexQueue, ^{
            self.nationArray = [CODNation MR_findAllSortedBy:@"timestamp" ascending:YES];
        });
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    UIButton *v  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    v.backgroundColor = [UIColor clearColor];
    [v setTitle:@"发表" forState:UIControlStateNormal];
    [v setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [v setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [v addTarget:self action:@selector(postSubmit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:v];
    self.navigationItem.rightBarButtonItem = barButton;
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"btn_fanhui"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back_main);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    
    [MobClick beginLogPageView:@"PostTribe"];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"PostTribe"];
}

/* 发表帖子 */
-(void)postSubmit
{
    [_postDescribeTextView resignFirstResponder];
    /* 为空条件判断 */
    if ([self.postDescribeTextView.text isEqualToString:@""]) {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"内容为空" afterDelay:1.0 style:HNBToastHudFailure];
        return;
    }
    else if(self.choseTribeCode == Nil || [self.choseTribeCode isEqualToString:@""])
    {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"请选择地区" afterDelay:1.0 style:HNBToastHudFailure];
        return;
    }
    else if(self.imageArry == Nil || self.imageArry.count == 0)
    {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"请选择图片" afterDelay:1.0 style:HNBToastHudFailure];
        return;
    }
    NSArray * tmpPersonalInfoArry = [PersonalInfo MR_findAll];
    
    if (tmpPersonalInfoArry.count != 0) {
        
        [DataFetcher doPostCOD:self.postDescribeTextView.text ImageList:self.imageArry NationID:self.choseTribeCode withSucceedHandler:^(id JSON) {
            int errCode=   [[JSON valueForKey:@"state"] intValue];
            NSLog(@"errCode = %d",errCode);
            if (errCode == 0) {
                
                id josnMain = [JSON valueForKey:@"data"];
                NSString * url = [NSString  stringWithFormat:@"%@%@",@"http://xm.hinabian.com",[josnMain valueForKey:@"url"]];
                NSLog(@"url = %@",url);
                MyOnedayViewController *vc = [[MyOnedayViewController alloc] init];
                [self removeTopAndPushViewController:vc];
            }
            
        } withFailHandler:^(NSError *error) {
            NSLog(@"errCode = %ld",(long)error.code);
        }];
        
    }
    
    
}

- (void)removeTopAndPushViewController:(UIViewController *)viewController {
    NSMutableArray *viewControllers = self.navigationController.viewControllers.mutableCopy;
    [viewControllers removeObject:self.navigationController.topViewController];
    [viewControllers addObject:viewController];
    [self.navigationController setViewControllers:viewControllers.copy animated:YES];
}

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
            } withFailHandler:^(NSError *error) {
                [_selectedAssets removeObject:asset];
                [_selectedPhotos removeObject:photo];
                
                _layout.itemCount = _selectedAssets.count;
                [_collectionView reloadData];
                [self changeLabelPhotoNum];
                
                NSLog(@"errCode = %ld",(long)error.code);
            }];
            _isRepeat = NO;
        }
    }else{
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
        } withFailHandler:^(NSError *error) {
            [_selectedAssets removeObject:asset];
            [_selectedPhotos removeObject:photo];
            
            _layout.itemCount = _selectedAssets.count;
            [_collectionView reloadData];
            [self changeLabelPhotoNum];
            
            NSLog(@"errCode = %ld",(long)error.code);
        }];
    }
}

-(void) removeFromIndexArray:(NSMutableArray *) inputArray IndexArray:(NSMutableArray *)indexArray
{
    NSMutableArray * tmpArray = [[NSMutableArray alloc] init];
    for (NSString * i in indexArray) {
        id tmp = inputArray[[i intValue]];
        [tmpArray addObject:tmp];
    }
    [inputArray removeObjectsInArray:tmpArray];
}

-(void)done
{
    NSInteger selectedContinentIndex = [self.tribePickerView selectedRowInComponent:0];
    CODNation * f = self.nationArray[selectedContinentIndex];
    self.choseTribeName = f.name;
    self.choseTribeCode = f.id;
    self.tribeLabel.text = f.name;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(![text isEqualToString:@""])
    {
        [_placeHoldTextView setHidden:YES];
    }
    if([text isEqualToString:@""]&&range.length==1&&range.location==0){
        [_placeHoldTextView setHidden:NO];
    }
    
    if (1 == range.length) {//按下回格键
        return YES;
    }
    if ([textView.text length] < 500) {//判断字符个数
        return YES;
    }
    return NO;
}


@end
