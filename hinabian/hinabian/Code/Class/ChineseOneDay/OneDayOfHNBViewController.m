//
//  OneDayOfHNBViewController.m
//  hinabian
//
//  Created by 何松泽 on 15/9/19.
//  Copyright © 2015年 &#20313;&#22362;. All rights reserved.
//

#define RESOLUTION          SCREEN_HEIGHT/568
#define BUTTON_X            80*RESOLUTION
#define BUTTON_RADIUS       30*RESOLUTION
#define IMAGE_LIMIT_COUNT   12

#import "OneDayOfHNBViewController.h"
#import "RDVTabBarController.h"
#import "HNBLoadingMask.h"
#import "LoginViewController.h"
#import "HNBUtils.h"
#import "PostMyDayViewController.h"
#import "CTAssetsPickerController.h"
#import "CTAssetsPageViewController.h"
#import "ActionSheetPicker.h"
#import "TipMaskView.h"
#import "MyOnedayViewController.h"
#import "RefreshControl.h"

#import "TZImageManager.h"
#import "TZImagePickerController.h"

@interface OneDayOfHNBViewController ()<UITabBarDelegate,UIWebViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UIPickerViewDelegate,CTAssetsPickerControllerDelegate, UIPopoverControllerDelegate, RefreshControlDelegate,TZImagePickerControllerDelegate>

@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) UIPopoverController *popover;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@property (nonatomic, strong) RefreshControl *refreshControl;

@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, assign) BOOL isBack;
@end


@implementation OneDayOfHNBViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    CGRect rectNav = self.navigationController.navigationBar.frame;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat tabBarHight = CGRectGetHeight(self.rdv_tabBarController.tabBar.frame);
    
    self.title = @"海那边一天";
    
    NSString *URLStr = [NSString stringWithFormat:@"%@/cnd/square",H5URL];
    self.URL = [[NSURL alloc] withOutNilString:URLStr];
    NSURLRequest *req = [NSURLRequest requestWithURL:self.URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    self.wkWebView = [[HNBWKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                                                delegate:self
                                               superView:self.view
                                                     req:req
                                                  config:nil];
    
    UIButton *cameraBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-BUTTON_X,SCREEN_HEIGHT - rectNav.size.height - rectStatus.size.height - tabBarHight - BUTTON_RADIUS, BUTTON_RADIUS*2, BUTTON_RADIUS*2)];
    
    [cameraBtn setBackgroundImage:[UIImage imageNamed:@"OneDay_btn_issueoneday"] forState:UIControlStateNormal];
    [cameraBtn addTarget:self action:@selector(touchCamera) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:cameraBtn];
    
    if([HNBUtils sandBoxGetInfo:[NSString class] forKey:user_first_load_oneday] == nil) //第一次进入
    {
        [HNBUtils sandBoxSaveInfo:@"1" forKey:user_first_load_oneday];
        //高亮蒙版
        TipMaskView *tipMaskView = [[TipMaskView alloc]initWithFrame:cameraBtn.frame message:@"来发布我的一天吧" andButtonRect:cameraBtn.frame textColor:nil bubbleColor:nil isCustom:TRUE image:[UIImage imageNamed:@"OneDay_btn_issueoneday"]];
        tipMaskView.popTipView.backgroundColor = [UIColor clearColor];
        tipMaskView.popTipView.textColor = [UIColor whiteColor];
        tipMaskView.popTipView.borderColor = [UIColor clearColor];
        tipMaskView.alpha = 0.0f;
        [self.view addSubview:tipMaskView];
        //蒙版初始动画
        [UIView animateWithDuration:1.0f animations:^{
            tipMaskView.alpha = 0.01f;
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5f animations:^{
                tipMaskView.alpha = 1.0f;
            }];
        }];
    }
    
    _refreshControl=[[RefreshControl alloc] initWithScrollView:self.wkWebView.scrollView delegate:self];
    _refreshControl.topEnabled=YES;
}

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection) direction
{
    if (direction==RefreshDirectionTop) {
        [[NSURLCache  sharedURLCache ]removeAllCachedResponses];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isRefresh = TRUE;
            [self.wkWebView webReload];
            [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
        });
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //添加我的一天
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"我的一天" style:UIBarButtonItemStylePlain target:self action:@selector(toMyOneDay)];
    NSArray *itemsArr = @[rightItem];
    self.navigationItem.rightBarButtonItems = itemsArr;
}

- (void)toMyOneDay
{
    if (![HNBUtils isLogin]) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    MyOnedayViewController *vc = [[MyOnedayViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //清除UIWebView的缓存
    [[NSURLCache  sharedURLCache ]removeAllCachedResponses];
    
    [[HNBLoadingMask shareManager] dismiss];
    
}

//点击相机
- (void)touchCamera
{
    if (![HNBUtils isLogin]) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    [self takePictureClick];
}

-(void)takePictureClick
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照",@"从手机相册中选择",nil];
    [actionSheet showInView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0://照相机
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = (id)self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
            
        case 1://本地相簿
        {
            [self pickAssets];
        }
            break;
            
        default:
            break;
    }
}

- (void)pickAssets
{
    if (!self.assets)
        self.assets = [[NSMutableArray alloc] init];
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:IMAGE_LIMIT_COUNT delegate:self];
    
    // 1.如果你需要将拍照按钮放在外面，不要传这个参数
    imagePickerVc.selectedAssets = self.assets; // optional, 可选的
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        self.assets = [NSMutableArray arrayWithArray:assets];
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark -
#pragma UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeImage]) {
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
                
                NSMutableArray *array = [NSMutableArray array];
                [array addObject:assetModel.asset];
                NSMutableArray *imageArray = [NSMutableArray array];
                [imageArray addObject:image];
                PostMyDayViewController *vc = [[PostMyDayViewController alloc]initWithCamerImage:array image:imageArray];
                [self.navigationController pushViewController:vc animated:YES];
            }];
        }];
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Popover Controller Delegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.popover = nil;
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    NSMutableArray *assetsArr = [NSMutableArray arrayWithArray:assets];
    NSMutableArray *photosArr = [NSMutableArray arrayWithArray:photos];
    
    PostMyDayViewController * vc = [[PostMyDayViewController alloc] initWithPickeImage:assetsArr image:photosArr];

    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark ------ Base Publick

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    if (!self.isBack &&!self.isRefresh) {
        [[HNBLoadingMask shareManager] loadingMaskWithSuperView:self.view
                                                loadingMaskType:LoadingMaskTypeExtendTabBar
                                                        yoffset:0.0];
    }
    if (self.isRefresh) {//如果是刷新就不用蒙版
        self.isRefresh = FALSE;
    }
    self.isBack = false;
    
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [[HNBLoadingMask shareManager] dismiss];
    
}

@end
