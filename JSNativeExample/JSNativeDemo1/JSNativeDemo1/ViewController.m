//
//  ViewController.m
//  JSNativeDemo1
//
//  Created by hnbwyh on 2017/9/22.
//  Copyright © 2017年 hainbwyh. All rights reserved.
//

#import "ViewController.h"
#import "UIWebVC.h"
#import "WKWebVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)clickUIWeb:(id)sender {
    [self.navigationController pushViewController:[[UIWebVC alloc] init] animated:TRUE];
}

- (IBAction)clickWKWeb:(id)sender {
    [self.navigationController pushViewController:[[WKWebVC alloc] init] animated:TRUE];
}

@end
