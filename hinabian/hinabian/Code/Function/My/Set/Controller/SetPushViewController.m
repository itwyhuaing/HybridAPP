//
//  SetPushViewController.m
//  hinabian
//
//  Created by 余坚 on 15/12/8.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import "SetPushViewController.h"
#import "RDVTabBarController.h"
#import "PushSetTableViewCell.h"
#import "DataFetcher.h"

#define TABLEVIEW_DISTANCE_FROM_TOP 20
#define INPUT_ITEM_TO_EDGE 20

enum Item_name
{
    EN_TRIBE = 0,
    EN_NULLONE = 1,
    EN_QA = 2,
    EN_DEFAULT = 3,

};

@interface SetPushViewController () <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView * tableView;
@end

@implementation SetPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推送设置";
    self.view.backgroundColor = [UIColor DDNormalBackGround];
    
    
    
    CGRect tableviewRect = [UIScreen mainScreen].bounds;
    CGRect rectNav = self.navigationController.navigationBar.frame;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    tableviewRect.origin.y += TABLEVIEW_DISTANCE_FROM_TOP;
    tableviewRect.size.height -= rectNav.size.height;
    tableviewRect.size.height -= rectStatus.size.height;
    tableviewRect.size.height -= TABLEVIEW_DISTANCE_FROM_TOP;
    
    self.tableView = [[UITableView alloc]initWithFrame:tableviewRect];
    self.tableView.delegate = (id)self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    } else {
        // Fallback on earlier versions
        
    }
    
    [self.view addSubview:self.tableView];
    
    [self registerCellPrototype];
}

-(void)registerCellPrototype
{
    [self.tableView registerNib:[UINib nibWithNibName:cellNibName_PushSetTableViewCell bundle:nil] forCellReuseIdentifier:cellNibName_PushSetTableViewCell];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  @author &#20313;&#22362;, 15-12-08 14:12:10
 *
 *  圈子推送开关
 *
 *  @param sender
 */
-(void)switchTribeAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        [DataFetcher doSetPushSwitch:@"tribe" Switch:@"1" withSucceedHandler:^(id JSON) {
            int errCode = [[JSON valueForKey:@"state"] intValue];
            NSLog(@"errCode = %d",errCode);
            if (errCode == 0) {
                [HNBUtils sandBoxSaveInfo:@"1" forKey:push_tribe_switch];
            }

        } withFailHandler:^(NSError * error) {
            NSLog(@"errCode = %ld",(long)error.code);
        }];

    }else {
        [DataFetcher doSetPushSwitch:@"tribe" Switch:@"0" withSucceedHandler:^(id JSON) {
            int errCode = [[JSON valueForKey:@"state"] intValue];
            NSLog(@"errCode = %d",errCode);
            if (errCode == 0) {
                [HNBUtils sandBoxSaveInfo:@"0" forKey:push_tribe_switch];
            }
        } withFailHandler:^(NSError * error) {
            NSLog(@"errCode = %ld",(long)error.code);
        }];

    }
}

/**
 *  @author &#20313;&#22362;, 15-12-08 14:12:28
 *
 *  问答推送开关
 *
 *  @param sender
 */
-(void)switchQAAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        [DataFetcher doSetPushSwitch:@"qa" Switch:@"1" withSucceedHandler:^(id JSON) {
            int errCode = [[JSON valueForKey:@"state"] intValue];
            NSLog(@"errCode = %d",errCode);
            if (errCode == 0) {
                [HNBUtils sandBoxSaveInfo:@"1" forKey:push_qa_switch];
            }
            
        } withFailHandler:^(NSError * error) {
            NSLog(@"errCode = %ld",(long)error.code);
            
        }];
    }else {
        [DataFetcher doSetPushSwitch:@"qa" Switch:@"0" withSucceedHandler:^(id JSON) {
            int errCode = [[JSON valueForKey:@"state"] intValue];
            NSLog(@"errCode = %d",errCode);
            if (errCode == 0) {
                [HNBUtils sandBoxSaveInfo:@"0" forKey:push_qa_switch];
            }
            
        } withFailHandler:^(NSError * error) {
            NSLog(@"errCode = %ld",(long)error.code);
        }];
    }
}

#pragma --UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return EN_DEFAULT;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *returnCellPtr = [[UITableViewCell alloc] init];
    if (indexPath.row == EN_TRIBE) {
        PushSetTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellNibName_PushSetTableViewCell];
        [cell setTitle:@"圈子消息提醒"];
        [cell.choseSwitch addTarget:self action:@selector(switchTribeAction:) forControlEvents:UIControlEventValueChanged];
        NSString * isOn = [HNBUtils sandBoxGetInfo:[NSString class] forKey:push_tribe_switch];
        if (isOn == nil) {
            isOn = @"1";
        }
        if ([isOn isEqualToString:@"1"]) {
            [cell.choseSwitch setOn:YES];
        }
        else
        {
            [cell.choseSwitch setOn:NO];
        }
        returnCellPtr = cell;
        
    }
    else if(indexPath.row == EN_NULLONE)
    {
        returnCellPtr = [[UITableViewCell alloc] init];
        returnCellPtr.accessoryType = UITableViewCellAccessoryNone;
        returnCellPtr.backgroundColor = [UIColor clearColor];
    }
    else if(indexPath.row == EN_QA)
    {
        PushSetTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellNibName_PushSetTableViewCell];
        [cell setTitle:@"问答消息提醒"];
        [cell.choseSwitch addTarget:self action:@selector(switchQAAction:) forControlEvents:UIControlEventValueChanged];
        NSString * isOn = [HNBUtils sandBoxGetInfo:[NSString class] forKey:push_qa_switch];
        if (isOn == nil) {
            isOn = @"1";
        }
        if ([isOn isEqualToString:@"1"]) {
            [cell.choseSwitch setOn:YES];
        }
        else
        {
            [cell.choseSwitch setOn:NO];
        }
        returnCellPtr = cell;
    }
    returnCellPtr.selectionStyle = UITableViewCellSelectionStyleNone;
    return returnCellPtr;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == EN_NULLONE) {
        return 22;
    }
    return 44;
}


@end
