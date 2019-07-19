//
//  ViewController.m
//  ZHYBlockDemo
//
//  Created by 赵宏亚 on 2019/7/17.
//  Copyright © 2019 赵宏亚. All rights reserved.
//

#import "ViewController.h"
#import "ZHBlockViewController.h"
#import "BlockTest.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[[BlockTest alloc] init] blockTestOne];
}


// 跳转页面
- (IBAction)jumpVC:(UIButton *)sender {
    
    [self.navigationController pushViewController:[[ZHBlockViewController alloc] init] animated:YES];
}




@end
