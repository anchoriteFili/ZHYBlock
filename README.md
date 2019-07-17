#### 简单示例
---

```objc
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
```


```objc
2019-07-17 16:00:07.842359+0800 ZHYBlockDemo[35142:4280742] 名字1 **** 张三
2019-07-17 16:00:07.842638+0800 ZHYBlockDemo[35142:4280742] 名字2 ***** 张三
2019-07-17 16:00:07.842860+0800 ZHYBlockDemo[35142:4280742] 名字3 ***** 张三
2019-07-17 16:00:10.398817+0800 ZHYBlockDemo[35142:4280742] 页面得到了释放。。。。。。
```
