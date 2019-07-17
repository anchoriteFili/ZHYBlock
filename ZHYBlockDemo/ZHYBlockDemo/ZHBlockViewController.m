//
//  ZHBlockViewController.m
//  ZHYBlockDemo
//
//  Created by 赵宏亚 on 2019/7/17.
//  Copyright © 2019 赵宏亚. All rights reserved.
//

#import "ZHBlockViewController.h"


typedef void(^ZHYBlock) (void);
typedef void(^ZHYBlockOne) (ZHBlockViewController *);


@interface ZHBlockViewController ()

@property (nonatomic,strong) NSString *name;

@property (nonatomic,copy) ZHYBlock block;
@property (nonatomic,copy) ZHYBlockOne blockOne;


@end

@implementation ZHBlockViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    self.name = @"张三";
    
    [self methodOne];
    [self methodTwo];
    [self methodThree];
    
}

// 第一种方法，使用weak
- (void)methodOne {
    
    __weak typeof(self) weakSelf = self;
    self.block = ^{
        // 如果block有延迟调用的可能，则进行strong处理
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            NSLog(@"名字1 **** %@",strongSelf.name);
        }
    };
    
    self.block();
}

// 第二种方法，使用__block
- (void)methodTwo {
    
    __block ZHBlockViewController *vc = self;
    self.block = ^{
        NSLog(@"名字2 ***** %@",vc.name);
        vc = nil;
    };
    self.block();
}

// 第三种方法，直接将VC当做block的参数，感觉这个挺6的
- (void)methodThree {
    
    self.blockOne = ^(ZHBlockViewController *vc) {
        NSLog(@"名字3 ***** %@",vc.name);
    };
    self.blockOne(self);
}


- (void)dealloc {
    NSLog(@"页面得到了释放。。。。。。");
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
