//
//  PersonalInfoViewController.m
//  hinabian
//
//  Created by 余坚 on 15/7/2.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "PersonalHeadImageItemTableViewCell.h"
#import "PersonalInfoItemTableViewCell.h"
#import "PersonaIInfoNoticeSetTableViewCell.h"
#import "RDVTabBarController.h"
#import "DownSheet.h"
#import "ChangeTextViewController.h"
#import "ChoseNationsNewViewController.h"
#import "PersonalInfo.h"
#import "DataFetcher.h"
 

@interface PersonalInfoViewController ()<UITableViewDelegate,UITableViewDataSource,DownSheetDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) NSArray *MenuList;
@property(nonatomic, strong) UIImageView *headImage;
@property (strong, nonatomic) ChangeTextViewController *vc;
@property (strong, nonatomic) ChoseNationsNewViewController *vc_n;
@property (strong, nonatomic) UILabel * NickNameLabel;
@property (strong, nonatomic) UILabel * LevelLabel;
@property (strong, nonatomic) UILabel * ImStateLabel; 
@property (strong, nonatomic) UILabel * ImStationLabel;
@property (strong, nonatomic) UILabel * SignatureLabel;
@property (strong, nonatomic) UILabel * SelfIntroductionLabel;
@property (strong, nonatomic) UILabel * InterestLabel;

@property(nonatomic, strong) NSData *fileData;
@end

#define TABLEVIEW_DISTANCE_FROM_TOP 20

@implementation PersonalInfoViewController

enum Item_name
{
    EN_NOTICE_HEAD = 0,
    EN_HEAD_IMAGE = 1,
    EN_NICK_NAME  = 2,
    EN_LEVEL = 3,
    EN_EMPTY_ONE = 4,
    EN_IM_STATE = 5,
    EN_IM_STATION = 6,
    EN_EMPTY_TWO = 7,
    EN_SIGNATURE = 8,
    EN_SELF_INTRODUCTION = 9,
    EN_INTEREST = 10
    
};
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    self.view.backgroundColor = [UIColor DDNormalBackGround];
    // Do any additional setup after loading the view.
    CGRect rectNav = self.navigationController.navigationBar.frame;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    //CGFloat tabBarHight = CGRectGetHeight(self.rdv_tabBarController.tabBar.frame);
    CGRect tableviewRect = [UIScreen mainScreen].bounds;
    //tableviewRect.origin.y += TABLEVIEW_DISTANCE_FROM_TOP;
    tableviewRect.size.height -= rectNav.size.height;
    tableviewRect.size.height -= rectStatus.size.height;
    //tableviewRect.size.height -= TABLEVIEW_DISTANCE_FROM_TOP;

    self.tableView = [[UITableView alloc]initWithFrame:tableviewRect];
    self.tableView.delegate = (id)self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.tableView];
    
    [self registerCellPrototype];


}

-(void)registerCellPrototype
{
    [self.tableView registerNib:[UINib nibWithNibName:cellNibName_PersonalInfoItemTableViewCell bundle:nil] forCellReuseIdentifier:cellNibName_PersonalInfoItemTableViewCell];
    [self.tableView registerNib:[UINib nibWithNibName:cellNibName_PersonalHeadImageItemTableViewCell bundle:nil] forCellReuseIdentifier:cellNibName_PersonalHeadImageItemTableViewCell];
    [self.tableView registerNib:[UINib nibWithNibName:cellNibName_PersonaIInfoNoticeSetTableViewCell bundle:nil] forCellReuseIdentifier:cellNibName_PersonaIInfoNoticeSetTableViewCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.tableView reloadData];
    
    //[self.navigationItem hidesBackButton];
    [self.navigationItem hidesBackButton];
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"btn_fanhui"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back_main);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    
}

-(void) back_main
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //清除UIWebView的缓存
    [[NSURLCache  sharedURLCache ]removeAllCachedResponses];
    //显示tabbar
    [[self rdv_tabBarController] setTabBarHidden:FALSE animated:YES];
    
}

/* 移民状态 */
-(void)initSexualData{
    DownSheetModel *Model_1 = [[DownSheetModel alloc]init];
    Model_1.title = @"已移民";
//    DownSheetModel *Model_2 = [[DownSheetModel alloc]init];
//    Model_2.title = @"移民中";
    DownSheetModel *Model_3 = [[DownSheetModel alloc]init];
    Model_3.title = @"想移民";
    
    _MenuList = [[NSArray alloc]init];
    //_MenuList = @[Model_1,Model_2,Model_3];
    _MenuList = @[Model_1,Model_3];
}


-(void)clickMenu{
    DownSheet *sheet = [[DownSheet alloc]initWithlist:_MenuList height:0];
    sheet.delegate = self;
    [sheet showInView:self.view];
}

-(void)didSelectIndex:(NSInteger)index{
    DownSheetModel *Model = _MenuList[index];

    /* 上传服务器 */
    NSArray * tmpPersonalInfoArry = [PersonalInfo MR_findAll];
    PersonalInfo * UserInfo = nil;
    if (tmpPersonalInfoArry.count != 0) {
        
        UserInfo = tmpPersonalInfoArry[0];
        [DataFetcher doUpdateUserInfo:UserInfo.id NickName:nil Motto:nil Indroduction:nil Hobby:nil Im_state:[self CodeForIMStateForCode:Model.title] Im_nation:nil withSucceedHandler:^(id JSON) {
            int errCode = [[JSON valueForKey:@"state"] intValue];
            NSLog(@"errCode = %d",errCode);
            if (errCode == 0) {
                /* 修改本地数据库兴趣爱好 */
                //NSLog(@"111 ====== > %@",UserInfo.im_state_cn);
                UserInfo.im_state_cn = Model.title;
                if ([UserInfo.im_state_cn isEqualToString:@"移民中"]) {
                    UserInfo.im_state_cn = @"已移民";
                }
                [HNBUtils sandBoxSaveInfo:[self CodeForIMStateForCode:Model.title] forKey:IM_INTENTION_LOCAL];
                [HNBUtils sandBoxSaveInfo:UserInfo.is_assess forKey:USER_ASSESSED_IMMIGRANT];
                self.ImStateLabel.text = Model.title;
            }
            
        }  withFailHandler:^(NSError* error) {
            NSLog(@"errCode = %ld",(long)error.code);
        }];
        
        
    }
    
    
}

-(NSString *) CodeForIMStateForCode : (NSString*)IMState
{
    NSString * tmpCodeString;

    if([IMState isEqualToString:@"想移民"])
    {
        tmpCodeString = @"WANT_IM";
    }else{
        tmpCodeString = @"IMED";
    }
    
    
    return tmpCodeString;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return EN_INTEREST+1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCellPtr;
    
    if(indexPath.row == EN_NOTICE_HEAD)
    {
        if([HNBUtils isNationOrINtentionEmpty])
        {
            PersonaIInfoNoticeSetTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellNibName_PersonaIInfoNoticeSetTableViewCell];
            returnCellPtr = cell;
        }
        else
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            [cell setBackgroundColor:[UIColor DDNormalBackGround]];
            returnCellPtr = cell;
        }

    }
    else if(indexPath.row == EN_HEAD_IMAGE){
        PersonalHeadImageItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNibName_PersonalHeadImageItemTableViewCell];
        
        NSArray * tmpPersonalInfoArry = [PersonalInfo MR_findAll];
        PersonalInfo * UserInfo = nil;
        if (tmpPersonalInfoArry.count != 0) {
            UserInfo = tmpPersonalInfoArry[0];
        }
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:UserInfo.head_url]];

        self.headImage = cell.headImageView;
        returnCellPtr = cell;
        returnCellPtr.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if(indexPath.row == EN_EMPTY_ONE || indexPath.row == EN_EMPTY_TWO)
    {
        returnCellPtr = [[UITableViewCell alloc] init];
        returnCellPtr.accessoryType = UITableViewCellAccessoryNone;
        returnCellPtr.backgroundColor = [UIColor clearColor];
    }
    else{
        NSArray * tmpPersonalInfoArry = [PersonalInfo MR_findAll];
        PersonalInfo * UserInfo = nil;
        if (tmpPersonalInfoArry.count != 0) {
            UserInfo = tmpPersonalInfoArry[0];
        }
        NSString * imNation = nil;
        NSString *level = [NSString stringWithFormat:@"Lv%@",[UserInfo.levelInfo returnValueWithKey:@"level"]];
        
        PersonalInfoItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNibName_PersonalInfoItemTableViewCell];
        switch (indexPath.row) {
            case EN_NICK_NAME:
                [cell setTitleAndContent:@"昵称" content:UserInfo.name];
                self.NickNameLabel = cell.contentLabel;
                break;
            case EN_LEVEL:
                [cell setTitleAndContent:@"等级" content:level];
                self.LevelLabel = cell.contentLabel;
                break;
            case EN_IM_STATE:
                if([UserInfo.im_state_cn isEqualToString:@""] || !UserInfo.im_state_cn)
                {
                    [cell setTitleAndContent:@"移民状态" content:@"点击选择"];
                }
                else
                {
                    if ([UserInfo.im_state_cn isEqualToString:@"移民中"]) {
                        // V 3.0 版本将移民中并入已移民状态
                        UserInfo.im_state_cn = @"已移民";
                    }
                    [cell setTitleAndContent:@"移民状态" content:UserInfo.im_state_cn];
                }
                
                self.ImStateLabel = cell.contentLabel;
                break;
            case EN_IM_STATION:
                imNation = UserInfo.im_nation_cn;
                if ([UserInfo.im_nation_cn isEqualToString:@""] || !UserInfo.im_nation_cn) {
                    [cell setTitleAndContent:@"目标国家" content:@"点击选择"];
                }
                else
                {
                    NSRange range = [imNation rangeOfString:@","];
                    if (range.length > 0) {
                        imNation = [imNation substringToIndex:range.location];
                    }
                    [cell setTitleAndContent:@"目标国家" content:imNation];
                }
                
                self.ImStationLabel = cell.contentLabel;
                break;
            case EN_SIGNATURE:
                [cell setTitleAndContent:@"个性签名" content:UserInfo.motto];
                self.SignatureLabel = cell.contentLabel;
                break;
            case EN_SELF_INTRODUCTION:
                [cell setTitleAndContent:@"自我介绍" content:UserInfo.indroduction];
                self.SelfIntroductionLabel = cell.contentLabel;
                break;
            case EN_INTEREST:
                [cell setTitleAndContent:@"兴趣爱好" content:UserInfo.hobby];
                self.InterestLabel = cell.contentLabel;
                break;
                
            default:
                break;
        }
        cell.layer.borderWidth = 0.5;
        cell.layer.borderColor = [[UIColor DDNormalBackGround] CGColor];
        returnCellPtr = cell;
        returnCellPtr.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
    }
    //returnCellPtr = cell;
    
    returnCellPtr.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return returnCellPtr;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == EN_NOTICE_HEAD) {
        if([HNBUtils isNationOrINtentionEmpty])
        {
            return 44;
        }
        else
        {
            return TABLEVIEW_DISTANCE_FROM_TOP;
        }
    }
    else if(indexPath.row == EN_HEAD_IMAGE){
        
        return 60;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * tmpPersonalInfoArry = [PersonalInfo MR_findAll];
    PersonalInfo * UserInfo = nil;
    if (tmpPersonalInfoArry.count != 0) {
        UserInfo = tmpPersonalInfoArry[0];
    }
    NSMutableArray * tmpArray = [NSMutableArray arrayWithArray:[UserInfo.im_nation componentsSeparatedByString: @","]];
    switch (indexPath.row) {
        case EN_HEAD_IMAGE:
            [HNBClick event:@"158011" Content:nil];
            [self takePictureClick];
            break;
        case EN_NICK_NAME:
            [HNBClick event:@"158012" Content:nil];
            _vc = [[ChangeTextViewController alloc] init];
            _vc.tilteString = @"昵称";
            [_vc setIsTextField:TRUE];
            _vc.changeString = self.NickNameLabel.text;
            [self.navigationController pushViewController:_vc animated:YES];

            break;
        case EN_LEVEL:
            {
                NSString *tmpString = [NSString stringWithFormat:@"%@/native/mylevel",H5URL];
 
                SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
                vc.URL = [vc.webManger configNativeNavWithURLString:tmpString ctle:@"1" csharedBtn:@"0" ctel:@"0" cfconsult:@"0"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        case EN_IM_STATE:
            [HNBClick event:@"158013" Content:nil];
            [self initSexualData];
            [self clickMenu];
            break;
        case EN_IM_STATION:
            [HNBClick event:@"158014" Content:nil];
            _vc_n = [[ChoseNationsNewViewController alloc] init];
            if (tmpArray.count == 1) {
                if ([tmpArray[0] isEqualToString:@""]) {
                    tmpArray = Nil;
                }
            }
            _vc_n.nationsArray = tmpArray;
            [self.navigationController pushViewController:_vc_n animated:YES];
            break;
        case EN_SIGNATURE:
            [HNBClick event:@"158015" Content:nil];
            _vc = [[ChangeTextViewController alloc] init];
            _vc.tilteString = @"签名";
            [_vc setIsTextField:FALSE];
            _vc.changeString = self.SignatureLabel.text;
            [self.navigationController pushViewController:_vc animated:YES];
            break;
        case EN_SELF_INTRODUCTION:
            [HNBClick event:@"158016" Content:nil];
            _vc = [[ChangeTextViewController alloc] init];
            _vc.tilteString = @"自我介绍";
            [_vc setIsTextField:FALSE];
            _vc.changeString = self.SelfIntroductionLabel.text;
            [self.navigationController pushViewController:_vc animated:YES];
            break;
        case EN_INTEREST:
            [HNBClick event:@"158017" Content:nil];
            _vc = [[ChangeTextViewController alloc] init];
            _vc.tilteString = @"兴趣爱好";
            [_vc setIsTextField:FALSE];
            _vc.changeString = self.InterestLabel.text;
            [self.navigationController pushViewController:_vc animated:YES];
            break;
        default:
            break;
    }

}


//从相册获取图片
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

#pragma mark -
#pragma UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"buttonIndex = [%d]",buttonIndex);
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
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = (id)self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [[imagePicker navigationBar] setTintColor:[UIColor blackColor]];
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
    }
    else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeMovie]) {
        NSString *videoPath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        self.fileData = [NSData dataWithContentsOfFile:videoPath];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image {
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    NSLog(@"imageFile->>%@",imageFilePath);
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
        NSLog(@" %d",success);
    }
    //    UIImage *smallImage=[self scaleFromImage:image toSize:CGSizeMake(80.0f, 80.0f)];//将图片尺寸改为80*80
    UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(150, 150)];
    [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件

    
    /* 上传服务器 */
    [DataFetcher updateUserImage:selfPhoto WithSucceedHandler:^(id JSON) {
        int errCode=   [[JSON valueForKey:@"errcode"] intValue];
        NSLog(@"errCode = %d",errCode);
        self.headImage.image = selfPhoto;
    } withFailHandler:^(NSError *error) {
        NSLog(@"errCode = %ld",(long)error.code);
    }];

}

// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


//2.保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
