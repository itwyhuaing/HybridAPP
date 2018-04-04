//
//  SpecialListsViewController.m
//  hinabian
//
//  Created by 何松泽 on 16/7/28.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "SpecialListsViewController.h"
#import "RDVTabBarController.h"
#import "IMQuestionViewController.h"
#import "UserInfoController2.h"
#import "DataFetcher.h"
#import "QASpecialList.h"
//#import "UMSocial.h"

#define SCREEN_SCALE_IPHONE6    SCREEN_WIDTH/SCREEN_WIDTH_6
#define ICON_TO_LEFT    12*SCREEN_SCALE_IPHONE6
#define ICON_TO_TOP     15*SCREEN_SCALE_IPHONE6
#define ICON_SIZE       49*SCREEN_SCALE_IPHONE6
#define NAME_TO_ICON    5*SCREEN_SCALE_IPHONE6
#define LABEL_WIDTH     70*SCREEN_SCALE_IPHONE6
#define LABEL_HEIGHT    12*SCREEN_SCALE_IPHONE6
#define BUTTON_WIDTH    49*SCREEN_SCALE_IPHONE6
#define BUTTON_HEIGHT   25*SCREEN_SCALE_IPHONE6

#define CELL_HEIGHT     79*SCREEN_SCALE_IPHONE6

@interface SpecialListsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataArry;
}

@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *imageViewArray;   //专家头像
@property (strong, nonatomic) NSMutableArray *lableArray;       //专家标签
@property (strong, nonatomic) NSMutableArray *nameArray;        //专家姓名
@property (strong, nonatomic) NSMutableArray *signatureArray;   //专家签名
@property (strong, nonatomic) NSMutableArray *UIDArray;         //专家ID
@property (strong, nonatomic) NSMutableArray *vArray;           //专家v认证标签
@property (strong, nonatomic) NSMutableArray *buttonArray;

@end

@implementation SpecialListsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"专家列表";
    
    _imageViewArray = [[NSMutableArray alloc] init];
    _lableArray = [[NSMutableArray alloc] init];
    _nameArray = [[NSMutableArray alloc] init];
    _signatureArray = [[NSMutableArray alloc]init];
    _UIDArray = [[NSMutableArray alloc]init];
    _vArray = [[NSMutableArray alloc]init];
    _buttonArray = [[NSMutableArray alloc] init];
    dataArry = [[NSMutableArray alloc]init];
    
    CGRect rectNav = self.navigationController.navigationBar.frame;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - rectNav.size.height - rectStatus.size.height)];
    [_tableView setBackgroundColor:[UIColor DDNormalBackGround]];
    _tableView.delegate = (id)self;
    _tableView.dataSource = (id)self;
    _tableView.scrollEnabled = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self getSpecialListsDataThenReload];
    
    [self.view setBackgroundColor:[UIColor beigeColor]];
    [self.view addSubview:_tableView];
}

-(void)getSpecialListsDataThenReload
{
    
    NSArray *listArry = [QASpecialList MR_findAllSortedBy:@"timestamp" ascending:YES];
    dataArry = [NSMutableArray arrayWithArray:listArry];
    
    for (int i = 0; i < dataArry.count; i++) {
        /*获取专家头像*/
        QASpecialList *f = dataArry[i];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(ICON_TO_LEFT, ICON_TO_TOP, ICON_SIZE, ICON_SIZE)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:f.headurl]];
        imageView.layer.cornerRadius = CGRectGetHeight(imageView.frame) / 2.0;
        imageView.clipsToBounds = YES;
        [_imageViewArray addObject:imageView];
        
        /*获取专家名字*/
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.text = f.name;
        [nameLabel setFont:[UIFont systemFontOfSize:FONT_UI32PX*SCREEN_SCALE_IPHONE6]];
        CGSize size = [nameLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_UI32PX*SCREEN_SCALE_IPHONE6]}];
        [nameLabel setFrame:CGRectMake(ICON_TO_LEFT+ICON_SIZE+NAME_TO_ICON,ICON_TO_TOP - 5*SCREEN_SCALE_IPHONE6,size.width,size.height)];
//        [nameLabel setBackgroundColor:[UIColor redColor]];
        
        nameLabel.textColor = [UIColor DDNavBarBlue];
        [_nameArray addObject:nameLabel];
        
        /*获取专家标签*/
        UILabel *specialistLabel = [[UILabel alloc]initWithFrame:CGRectMake(ICON_TO_LEFT + ICON_SIZE + NAME_TO_ICON, nameLabel.frame.origin.y + nameLabel.frame.size.height + NAME_TO_ICON, LABEL_WIDTH, LABEL_HEIGHT)];
        
        [[specialistLabel layer] setCornerRadius:LABEL_HEIGHT/2];
        specialistLabel.clipsToBounds = YES;
        [[specialistLabel layer] setBorderWidth:0.5f];
        [specialistLabel layer].borderColor = [UIColor black75PercentColor].CGColor;
//        [specialistLabel setBackgroundColor:[UIColor whiteColor]];
        specialistLabel.textColor = [UIColor colorWithRed:234/255.f green:86/255.f blue:20/255.f alpha:1.f];
        specialistLabel.font = [UIFont systemFontOfSize:FONT_UI20PX*SCREEN_SCALE_IPHONE6];
        specialistLabel.textAlignment = NSTextAlignmentCenter;
        specialistLabel.text = f.expertLabel;
        
        CGSize tribeSize = [specialistLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_UI20PX*SCREEN_SCALE_IPHONE6]}];
        [specialistLabel setFrame:CGRectMake(specialistLabel.frame.origin.x, specialistLabel.frame.origin.y, tribeSize.width + 12*SCREEN_SCALE, specialistLabel.frame.size.height)];
        
        [_lableArray addObject:specialistLabel];
        
        /*获取专家签名*/
        UILabel *signatureLabel = [[UILabel alloc]initWithFrame:CGRectMake(ICON_TO_LEFT + ICON_SIZE + NAME_TO_ICON, specialistLabel.frame.origin.y + specialistLabel.frame.size.height, SCREEN_WIDTH - (ICON_TO_LEFT+ICON_SIZE+NAME_TO_ICON) - (22*SCREEN_SCALE_IPHONE6 + 47*SCREEN_SCALE_IPHONE6 + NAME_TO_ICON), CELL_HEIGHT - (specialistLabel.frame.origin.y + specialistLabel.frame.size.height+NAME_TO_ICON))];
        signatureLabel.text = f.signature;
        [signatureLabel setFont:[UIFont systemFontOfSize:FONT_UI24PX *SCREEN_SCALE_IPHONE6]];
        signatureLabel.textColor = [UIColor DDTextGrey];
        [_signatureArray addObject:signatureLabel];
//        [signatureLabel setBackgroundColor:[UIColor greenColor]];
        if (signatureLabel.text.length > 17) {
            signatureLabel.numberOfLines = 2;
        }
        /*容错处理*/
        if ([f.certified_type isEqualToString:@""] || [f.certified_type isEqualToString:@"(null)"] || !f.certified_type || [f.certified_type integerValue] < 0) {
            f.certified_type = @"";
        }
        if ([f.certified isEqualToString:@"(null)"] || !f.certified || [f.certified integerValue] < 0) {
            f.certified = @"";
        }
        
        [_vArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:f.certified_type,@"certified_type",f.certified,@"certified", nil]];
        
        /*获取提问button*/
        UIButton *askBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - ICON_TO_LEFT - BUTTON_WIDTH, (CELL_HEIGHT-BUTTON_HEIGHT)/2, BUTTON_WIDTH, BUTTON_HEIGHT)];
        [[askBtn layer] setCornerRadius:5.f];
        askBtn.tag = i;
        [askBtn setBackgroundColor:[UIColor DDNavBarBlue]];
        [askBtn setTitle:@"提问" forState:UIControlStateNormal];
//        [askBtn.titleLabel setTextColor:[UIColor whiteColor]];
        [askBtn.titleLabel setFont:[UIFont systemFontOfSize:FONT_UI22PX]];
        [askBtn addTarget:self action:@selector(createNewQa:) forControlEvents:UIControlEventTouchUpInside];
        [_UIDArray addObject:f.userid];
        [_buttonArray addObject:askBtn];
    }
}

#pragma mark - TABLEVIEW_DELEGATE&DATASOURCE
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = [[UITableViewCell alloc]init];
    
    if (dataArry.count > 0) {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        [cell setBackgroundColor:[UIColor whiteColor]];
         [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if (indexPath.row < dataArry.count) {
            UIImageView *imageView = _imageViewArray[indexPath.row];
            UILabel *nameLabel = _nameArray[indexPath.row];
            UILabel *signatureLabel = _signatureArray[indexPath.row];
            UILabel *label = _lableArray[indexPath.row];
            UIButton *askBtn = _buttonArray[indexPath.row];
            UIView * separatorLine = [[UIView alloc] initWithFrame:CGRectMake(-1, CELL_HEIGHT - 1, SCREEN_WIDTH + 2, 0.5)];
            separatorLine.backgroundColor = [UIColor clearColor];
            separatorLine.layer.borderWidth = 0.5;
            separatorLine.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1.f].CGColor;
            
            /*头像灰色边框*/
            UIView *roundView  = [[UIView alloc]initWithFrame:CGRectMake(imageView.frame.origin.x - 0.5, imageView.frame.origin.y -  0.5, imageView.frame.size.width + 1, imageView.frame.size.height + 1)];
            [roundView layer].cornerRadius = roundView.frame.size.width/2;
            [roundView layer].borderColor = [UIColor black75PercentColor].CGColor;
            [roundView layer].borderWidth = 0.5f;
            
            /*专家认证图标*/
            UIImageView *vImageView = [[UIImageView alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x + nameLabel.frame.size.width + 5, nameLabel.frame.origin.y + 4*SCREEN_SCALE_IPHONE6, 24*SCREEN_SCALE_IPHONE6, FONT_UI24PX*SCREEN_SCALE_IPHONE6)];
            
            if ([[[_vArray objectAtIndex:indexPath.row] valueForKey:@"certified_type"] isEqualToString:@"specialist"]) {
                [vImageView setImage:[UIImage imageNamed:@"specialist"]];
                vImageView.hidden = NO;
            }else if ([[[_vArray objectAtIndex:indexPath.row] valueForKey:@"certified_type"] isEqualToString:@"authority"]){
                [vImageView setImage:[UIImage imageNamed:@"authority"]];
                vImageView.hidden = NO;
            }else{
                NSString *str = [[_vArray objectAtIndex:indexPath.row] valueForKey:@"certified"];
                if (str.length != 0) {
                    [vImageView setImage:[UIImage imageNamed:@"tribe_talent"]];
                    vImageView.hidden = NO;
                }else{
                    vImageView.hidden = YES;
                }
            }
            
            [cell addSubview:roundView];
            [cell addSubview:separatorLine];
            [cell addSubview:imageView];
            [cell addSubview:nameLabel];
            [cell addSubview:vImageView];
            [cell addSubview:signatureLabel];
            [cell addSubview:label];
            [cell addSubview:askBtn];
        }
        returnCell = cell;
    }
    
    
    return returnCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < dataArry.count) {
        //统计代码
        NSString *personURL = [NSString stringWithFormat:@"%@/personal_userinfo/user/%@",H5URL,_UIDArray[indexPath.row]];
        NSDictionary *clickDic = @{personURL : _UIDArray[indexPath.row]};
        [HNBClick event:@"132001" Content:clickDic];
        
        UserInfoController2 *vc = [[UserInfoController2 alloc]init];
        vc.personid = _UIDArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dataArry.count != 0) {
        return dataArry.count;
    }
    return 0;
}

- (void)createNewQa:(id)sender
{
    UIButton *tagBtn = sender;
    UILabel *nameLabel = _nameArray[tagBtn.tag];
    NSString * uidString = _UIDArray[tagBtn.tag];
    NSString * nameString = nameLabel.text;
    
    IMQuestionViewController *vc = [[IMQuestionViewController alloc] init];
    vc.answererUid = uidString;
    vc.answererName = nameString;
    
    //统计代码
    NSString *personURL = [NSString stringWithFormat:@"%@/personal_userinfo/user/%@",H5URL,uidString];
    NSDictionary *clickDic = @{personURL : uidString};
    [HNBClick event:@"132002" Content:clickDic];
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void) back_main
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"btn_fanhui"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back_main);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
}


@end
