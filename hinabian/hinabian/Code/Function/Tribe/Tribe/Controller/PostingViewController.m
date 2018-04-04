//
//  PostingViewController.m
//  hinabian
//
//  Created by 余坚 on 15/7/9.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import "PostingViewController.h"
#import "RDVTabBarController.h"
#import "HNBCustomActionSheet.h"
#import "DataFetcher.h"
#import "Tribe.h"
#import "PersonalInfo.h"
#import "SWKTribeShowViewController.h"
#import "TribeDetailInfoViewController.h"
#import "HNBToast.h"
#import "ActionSheetPicker.h"

#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "IQKeyboardManager.h"
#import "RecentPhotoView.h"

@interface PostingViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UIPickerViewDelegate,UITextViewDelegate,UITextFieldDelegate, UIPopoverControllerDelegate, UIAlertViewDelegate, TZImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
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
    RecentPhotoView *_recentPHView;
}
@property (nonatomic, strong) UIImagePickerController   *imagePickerVc;
@property (nonatomic, strong) UICollectionView          *collectionView;
@property (strong, nonatomic) UIProgressView            *progressView; //传图进度条
@property (strong, nonatomic) UIPickerView              *tribepickerView;
@property (strong, nonatomic) UITextField               *titleTextField;
@property (strong, nonatomic) UITextView                *describeTextView;

@property (strong, nonatomic) UILabel   *tribeLabel;
@property (strong, nonatomic) UILabel   *alertLabel;
@property (strong, nonatomic) UIButton  *tribeLabelButton;
@property (strong, nonatomic) UIButton  *choseTribeButton;

@property (strong, nonatomic) NSMutableArray    *imageArry;
@property (strong, nonatomic) NSArray           *tribeArray;//圈子

@end

#define TEXT_DISTANCE_FROM_EDGE 8
#define POST_TITLE_TEXT_ITEM_HEIGHT 44
#define POST_DESCRIBE_TEXT_ITEM_HEIGHT        (SCREEN_HEIGHT <= 568 ? 155:210)      //200
#define POST_IMAGE_DISTANCE                   40*SCREEN_SCALE

#define IMAGE_FROM_EACHOTHER 8
#define ALERT_LABEL_HEIGHT 12

#define CHOSE_TRIBE_VIEW_HEIGHT 44

#define CHOSE_TRIBE_ICON_SIZE   18
#define CHOSE_LABEL_WIDTH 120

#define CHOSE_TRIBE_BUTTON_WIDTH   7
#define CHOSE_TRIBE_BUTTON_HEIGHT  4

#define IMAGE_LIMIT_COUNT    9
#define WORD_LIMIT_NUM      2000

#define IMAGE_DEFAULT_NAME    @"CAMER_PHOTO"


@implementation PostingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"发帖";
    // Do any additional setup after loading the view.
    
    [self configTextView];
    [self configCollectionView];
    
    self.imageArry  = [NSMutableArray array];
    _imageNameArr   = [NSMutableArray array];
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    _allImageArr    = [NSMutableArray array];
    _cellArr        = [NSMutableArray array];
    
    isRepeat = NO;
    isUploading = NO;
    postedPhotoNum = 0; //已传图片的数量
    
    [self changeLabelPhotoNum];
    
    if (![self.choseTribeCode isEqualToString:@""]) {
        Tribe * f = [Tribe MR_findFirstByAttribute:@"id" withValue:self.choseTribeCode];
        self.choseTribeName = f.name;
    }
}

//WX版图片选择器
- (void)configCollectionView {
    _layout = [[LxGridViewFlowLayout alloc] init];
    _margin = 4;
    _itemWH = (self.view.tz_width - 2 * _margin - 4) / 4 - _margin;
    _layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    _layout.minimumInteritemSpacing = _margin;
    _layout.minimumLineSpacing = _margin;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, POST_TITLE_TEXT_ITEM_HEIGHT + POST_DESCRIBE_TEXT_ITEM_HEIGHT +  POST_IMAGE_DISTANCE, self.view.tz_width, _layout.itemSize.height + 10) collectionViewLayout:_layout];
    _collectionView.alwaysBounceHorizontal = YES;
    _collectionView.alwaysBounceVertical = NO;
    
    CGFloat rgb = 255 / 255.0;
    _collectionView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    [self.view addSubview:_collectionView];
    
    /*AlertLabel提醒剩余照片数量标签*/
    float alertLabelH = CGRectGetMaxY(_collectionView.frame) + ALERT_LABEL_HEIGHT/3;
    _alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, alertLabelH, SCREEN_WIDTH, ALERT_LABEL_HEIGHT)];
    _alertLabel.textAlignment = NSTextAlignmentCenter;
    _alertLabel.text = [NSString stringWithFormat:@"已选择 0 张,最多添加%d张照片",IMAGE_LIMIT_COUNT];
    _alertLabel.textColor = [UIColor lightGrayColor];
    _alertLabel.font = [UIFont systemFontOfSize:FONT_UI32PX];
    [self.view addSubview:self.alertLabel];
    
    /*进度条*/
    float progressH = CGRectGetMaxY(_alertLabel.frame) + 6;
    _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, progressH, SCREEN_WIDTH, 5)];
    _progressView.tintColor = [UIColor DDNavBarBlue];
    _progressView.progress = 0.f;
    _progressView.hidden = YES;
    [self.view addSubview:_progressView];
    
    /* 圈子选择区域 */
    UIView * tmpChoseTribe = [[UIView alloc] initWithFrame:CGRectMake(0, self.alertLabel.frame.origin.y+ALERT_LABEL_HEIGHT*2 , SCREEN_WIDTH, CHOSE_TRIBE_VIEW_HEIGHT)];
    tmpChoseTribe.backgroundColor = [UIColor whiteColor];
    UIImageView * tmpChoseTribeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(TEXT_DISTANCE_FROM_EDGE, (CHOSE_TRIBE_VIEW_HEIGHT-CHOSE_TRIBE_ICON_SIZE)/2, CHOSE_TRIBE_ICON_SIZE, CHOSE_TRIBE_ICON_SIZE)];
    tmpChoseTribeIcon.image = [UIImage imageNamed:@"quanzi_tiezi_globe"];
    [tmpChoseTribe addSubview:tmpChoseTribeIcon];
    
    _tribeLabel = [[UILabel alloc] initWithFrame:CGRectMake(TEXT_DISTANCE_FROM_EDGE + CHOSE_TRIBE_ICON_SIZE + TEXT_DISTANCE_FROM_EDGE, (CHOSE_TRIBE_VIEW_HEIGHT-CHOSE_TRIBE_ICON_SIZE)/2, CHOSE_LABEL_WIDTH, CHOSE_TRIBE_ICON_SIZE)];
    _tribeLabel.textColor = [UIColor DDBlack333];
    _tribeLabel.text = _choseTribeName;
    [tmpChoseTribe addSubview:_tribeLabel];
    
    _tribeLabelButton = [[UIButton alloc] initWithFrame:CGRectMake(TEXT_DISTANCE_FROM_EDGE + CHOSE_TRIBE_ICON_SIZE + TEXT_DISTANCE_FROM_EDGE, (CHOSE_TRIBE_VIEW_HEIGHT-CHOSE_TRIBE_ICON_SIZE)/2, CHOSE_LABEL_WIDTH, CHOSE_TRIBE_ICON_SIZE)];
    _tribeLabelButton.backgroundColor = [UIColor clearColor];
    if([_choseTribeCode isEqualToString:@""])
    {
        self.tribeLabel.text = @"点击选择圈子";
        [_tribeLabelButton addTarget:self action:@selector(choseMoreTribe:) forControlEvents:UIControlEventTouchUpInside];
    }
    [tmpChoseTribe addSubview:_tribeLabelButton];
    
    
    _choseTribeButton = [[UIButton alloc] initWithFrame:CGRectMake(TEXT_DISTANCE_FROM_EDGE + CHOSE_TRIBE_ICON_SIZE + TEXT_DISTANCE_FROM_EDGE + CHOSE_LABEL_WIDTH, (CHOSE_TRIBE_VIEW_HEIGHT-CHOSE_TRIBE_BUTTON_HEIGHT)/2, CHOSE_TRIBE_BUTTON_WIDTH, CHOSE_TRIBE_BUTTON_HEIGHT)];
    [_choseTribeButton setImage:[UIImage imageNamed:@"quanzi_tiezi_more"] forState:UIControlStateNormal];
    if ([_choseTribeCode isEqualToString:@""]) {
        [_choseTribeButton addTarget:self action:@selector(choseMoreTribe:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [tmpChoseTribe addSubview:_choseTribeButton];
    [self.view addSubview:tmpChoseTribe];
}

-(void)configTextView
{
    if (![self.choseTribeCode isEqualToString:@""]) {
        Tribe * f = [Tribe MR_findFirstByAttribute:@"id" withValue:self.choseTribeCode];
        self.choseTribeName = f.name;
    }
    
    /* 帖子主题 */
    _titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(TEXT_DISTANCE_FROM_EDGE, 0,SCREEN_WIDTH - TEXT_DISTANCE_FROM_EDGE*2, POST_TITLE_TEXT_ITEM_HEIGHT)];
    _titleTextField.backgroundColor = [UIColor whiteColor];
    _titleTextField.placeholder = @"标题";
    _titleTextField.delegate = (id)self;
    [_titleTextField setReturnKeyType:UIReturnKeyNext];

    /* 帖子内容 */
    _describeTextView = [[UITextView alloc] initWithFrame:CGRectMake(TEXT_DISTANCE_FROM_EDGE, POST_TITLE_TEXT_ITEM_HEIGHT, SCREEN_WIDTH - TEXT_DISTANCE_FROM_EDGE*2, POST_DESCRIBE_TEXT_ITEM_HEIGHT)];
    _describeTextView.backgroundColor = [UIColor clearColor];
    _describeTextView.delegate = (id)self;
    [_describeTextView setReturnKeyType:UIReturnKeyDefault];
    
    /* 图片数目Label */
    _alertLabel.textAlignment = NSTextAlignmentCenter;
    _alertLabel.textColor = [UIColor lightGrayColor];
    _alertLabel.text = [NSString stringWithFormat:@"已选择 0 张,最多添加%d张照片",IMAGE_LIMIT_COUNT];
    _alertLabel.font = [UIFont systemFontOfSize:FONT_UI32PX];
    
    
    UIView * StrokeView = [[UIView alloc] initWithFrame:CGRectMake(-1, POST_TITLE_TEXT_ITEM_HEIGHT, SCREEN_WIDTH+2, POST_DESCRIBE_TEXT_ITEM_HEIGHT + (self.view.tz_width) / 4 + POST_IMAGE_DISTANCE + ALERT_LABEL_HEIGHT + 15)];
    StrokeView.backgroundColor = [UIColor clearColor];
    StrokeView.layer.borderWidth = 1;
    StrokeView.layer.borderColor = [UIColor DDEdgeGray].CGColor;
    
    
    [self.view addSubview:StrokeView];
    [self.view addSubview:_titleTextField];
    [self.view addSubview:_describeTextView];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_titleTextField resignFirstResponder];
    [_describeTextView resignFirstResponder];
}

/* 选择圈子按钮点击 */
- (void)choseMoreTribe:(UIButton *)sender
{
    [_titleTextField resignFirstResponder];
    [_describeTextView resignFirstResponder];
    [self initTribeData];

    NSMutableArray *tribesArry = [[NSMutableArray alloc] init];
    for (Tribe * f in self.tribeArray) {
        [tribesArry addObject:f.name];
    }
    
    
    [ActionSheetStringPicker showPickerWithTitle:@"请选择圈子"
                                            rows:tribesArry
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           if (tribesArry.count <= 0) {
                                               /*数据防护，没有数据时不赋值*/
                                               NSLog(@"NO Tribe Data");
                                           }else{
                                               Tribe * f = _tribeArray[selectedIndex];
                                               _choseTribeName = f.name;
                                               _choseTribeCode = f.id;
                                               
                                               _tribeLabel.text = f.name;
                                           }
                                           
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     }
                                          origin:sender];
}

-(void) back_main
{
    if ([_describeTextView.text length] > 0 || [_titleTextField.text length] > 0 || self.imageArry.count > 0) {
        UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:@"是否放弃编辑"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
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
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/* 圈子选择器数据初始化 */
- (void) initTribeData
{
    self.tribeArray = [Tribe MR_findAllSortedBy:@"timestamp" ascending:YES];
    if (self.tribeArray.count <= 0) {   //如果没数据尝试再次请求数据
        
        dispatch_group_t indexLoad  = dispatch_group_create();
        dispatch_queue_t indexQueue = dispatch_queue_create("indexQueue", DISPATCH_QUEUE_CONCURRENT);
        
        //先重新请求圈子列表数据
        dispatch_group_enter(indexLoad);
        [DataFetcher doGetAllTribes:^(id JSON) {
            dispatch_group_leave(indexLoad);
        } withFailHandler:^(id error) {
            dispatch_group_leave(indexLoad);
        }];
        
        //再进行赋值
        dispatch_group_notify(indexLoad, indexQueue, ^{
            self.tribeArray = [Tribe MR_findAllSortedBy:@"timestamp" ascending:YES];
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
    //键盘出现ToolBar
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    UIButton *postBtn  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [postBtn setBackgroundColor:[UIColor clearColor]];
    [postBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [postBtn setTitle:@"发表" forState:UIControlStateNormal];
    [postBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [postBtn addTarget:self action:@selector(postSubmit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:postBtn];
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
    
    //键盘隐藏ToolBar
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    [MobClick endLogPageView:@"PostTribe"];
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

/* 发表帖子 */
-(void)postSubmit
{
    [_titleTextField resignFirstResponder];
    [_describeTextView resignFirstResponder];
    /* 为空条件判断 */
    if ([_titleTextField.text isEqualToString:@""] || [_describeTextView.text isEqualToString:@""]) {
        //显示HUD
         [[HNBToast shareManager] toastWithOnView:nil msg:@"内容为空" afterDelay:1.0 style:HNBToastHudFailure];
        return;
    }
    if ([self.choseTribeCode isEqualToString:@""] || self.choseTribeCode == nil) {
        //显示HUD
        [[HNBToast shareManager] toastWithOnView:nil msg:@"圈子未选择" afterDelay:1.0 style:HNBToastHudFailure];
        return;
    }
    if (isUploading) {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"正在上传图片，请稍后操作" afterDelay:0.5 style:HNBToastHudFailure];
        return;
    }
    NSArray * tmpPersonalInfoArry = [PersonalInfo MR_findAll];
    PersonalInfo * UserInfo = nil;
    if (tmpPersonalInfoArry.count != 0) {
        UserInfo = tmpPersonalInfoArry[0];
        [DataFetcher doPostTribe:UserInfo.id TID:self.choseTribeCode Title:_titleTextField.text content:_describeTextView.text ImageList:self.imageArry withSucceedHandler:^(id JSON) {
            int errCode = [[JSON valueForKey:@"state"] intValue];
            
            if (errCode == 0) {
                /* 回答发布的帖子 */
                id josnMain = [JSON valueForKey:@"data"];
                
                NSString *url = [NSString  stringWithFormat:@"%@/%@",H5URL,[josnMain valueForKey:@"url"]];
                NSString *isNativeString = [HNBUtils sandBoxGetInfo:[NSString class] forKey:TRIBEDETAILTHEME_NATIVEUI_WEB];
                if ([isNativeString isEqualToString:@"1"]) {
                    
                    TribeDetailInfoViewController *vc = [[TribeDetailInfoViewController alloc] init];
                    vc.URL = [[NSURL alloc] withOutNilString:url];
                    [self removeTopAndPushViewController:vc];
                    
                } else {
                    
                    SWKTribeShowViewController *vc = [[SWKTribeShowViewController alloc] init];
                    vc.URL = [[NSURL alloc] withOutNilString:url];
                    vc.T_ID = [josnMain valueForKey:@"id"];
                    [self removeTopAndPushViewController:vc];
                    
                }

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

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_selectedPhotos.count >= IMAGE_LIMIT_COUNT) {
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
    if (isUploading) {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"正在上传图片，请稍后操作" afterDelay:0.5 style:HNBToastHudFailure];
        return;
    }
    if (indexPath.row == _selectedPhotos.count) {
        BOOL showSheet = YES;
        if (showSheet) {
            [_titleTextField resignFirstResponder];
            [_describeTextView resignFirstResponder];
            if (!_recentPHView) {
                float height = 322;
                _recentPHView = [[RecentPhotoView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-height, SCREEN_WIDTH, height) superViewController:self];
                [self.view addSubview:_recentPHView];
            }else {
                [_recentPHView showRecentPhoto];
            }
//            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册中选择", nil];
//            [sheet showInView:self.view];
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
                            postedPhotoNum --;  //除去删除的照片
                            [_imageNameArr removeObjectAtIndex:i];
                            [self.imageArry removeObjectAtIndex:i];
                            break;
                        }
                    }
                }
                
                _selectedPhotos = [NSMutableArray arrayWithArray:photos];
                _selectedAssets = [NSMutableArray arrayWithArray:assets];
                _isSelectOriginalPhoto = isSelectOriginalPhoto;
                
                _layout.itemCount = _selectedAssets.count;
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

#pragma mark -- TZImagePickerController

- (void)pushImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:IMAGE_LIMIT_COUNT delegate:self];
    
#pragma mark -- 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    // 如果需要将拍照按钮放在外面，不要传这个参数
    imagePickerVc.selectedAssets = _selectedAssets; // optional, 可选的
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    // 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    // 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
#pragma mark -- 到这里为止
    
    // 通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        _selectedAssets = [NSMutableArray arrayWithArray:assets];
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark -- UIImagePickerController

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
            //NSLog(@"模拟器中无法打开照相机,请在真机中使用");
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
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
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
                    postedPhotoNum = 0;
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
        }];
    }
    
}


#pragma mark -- UIActionSheetDelegate

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

#pragma mark -- TZImagePickerControllerDelegate

/* 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
 如果isSelectOriginalPhoto为YES，表明用户选择了原图
 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
 photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它*/
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    _layout.itemCount = _selectedPhotos.count;
    
    // 保存图片至服务器
    self.imageArry = [NSMutableArray array];
    _imageNameArr = [NSMutableArray array];
    
//    for (id tmpImageAsset in assets) {
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
//    [self changeLabelPhotoNum];
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
    _layout.itemCount = _selectedAssets.count;
    
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

#pragma mark -- Click Event

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
    
}

-(void)done{
    
    NSInteger selectedContinentIndex = [self.tribepickerView selectedRowInComponent:0];
    Tribe * f = self.tribeArray[selectedContinentIndex];
    self.choseTribeName = f.name;
    self.choseTribeCode = f.id;
    
    self.tribeLabel.text = f.name;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_describeTextView becomeFirstResponder];
    
    /*一定要返回NO啊，不然会执行下一个textfield的Return*/
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //    if (1 == range.length) {//按下回格键
    //        return YES;
    //    }
    //    if ([text isEqualToString:@"\n"] && isNextTextField) {//按下return键
    //这里隐藏键盘，不做任何处理
    //        [textView resignFirstResponder];
    //        return NO;
    //    }
    //    else {
    //        if ([textView.text length] < WORD_LIMIT_NUM) {//判断字符个数
    //            return YES;
    //        }
    //    }
    
    /*不对发帖字数做限制*/
    return YES;
}

@end
