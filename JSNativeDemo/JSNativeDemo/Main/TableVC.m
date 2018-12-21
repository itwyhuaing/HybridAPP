//
//  TableVC.m
//  JSNativeDemo
//
//  Created by wangyinghua on 2018/4/9.
//  Copyright © 2018年 ZhiXing. All rights reserved.
//

#import "TableVC.h"
#import "WKWebVC.h"
#import "UIBaseFuncVC.h"
#import "InterceptURLVC.h"
#import "JSCoreVC.h"
#import "JSBridgeVC.h"
#import "MsgHandlerVC.h"

@interface TableVC ()

@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation TableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *tmpData = @[@"URL 拦截",@"JavaScriptCore ",@"WebViewJavascriptBridge + WKWebView",@"MessageHandler - WK 特有",@"WKDemo 效果"];
    _dataSource = [[NSMutableArray alloc] initWithArray:tmpData];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc;
    NSInteger location = FunctionInterceptVCType + indexPath.row;
    switch (location) {
        case FunctionInterceptVCType:
            vc = [[InterceptURLVC alloc] init];
            break;
        case FunctionJSCoreVCType:
            vc = [[JSCoreVC alloc] init];
            break;
        case FunctionJSBridgeVCType:
            vc = [[JSBridgeVC alloc] init];
            break;
        case FunctionMsgHandlerVCType:
            vc = [[MsgHandlerVC alloc] init];
            break;
        case FunctionWKDemoShowType:
            vc = [[WKWebVC alloc] init];
            break;
            
        default:
            break;
    }
    [self.navigationController pushViewController:vc animated:TRUE];
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
