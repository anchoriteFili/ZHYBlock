#### 循环引用处理
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

#### __block简单验证


### C

```c
    __block int b = 10;
    printf("b前 %p\n",&b);
    void (^blockTwo)(void) = ^{
        b++;
        printf("b中 %p\n",&b);
    };
    blockTwo();
    
    printf("b后 %p\n",&b);
    printf("b的值 *** %d\n",b);
    
    
    
    int a = 20;
    printf("a前 *** %d--%p\n",a,&a);
    void (^blockA)(void) = ^{
        printf("a中 *** %d--%p\n",a,&a);
    };
    
    blockA();
    
    printf("a后 *** %d--%p\n",a,&a);
```

```ruby
b前 0x7ffeefbff568
b中 0x7ffeefbff568
b后 0x7ffeefbff568
b的值 *** 11
a前 *** 20--0x7ffeefbff51c
a中 *** 20--0x7ffeefbff508
a后 *** 20--0x7ffeefbff51c
```

> 结论：使用__block修饰，指针不进行copy，不使用__block修饰，指针进行copy

### OC

1. __block修饰int,并在block内进行赋值

```objc
    __block int b = 10;
    printf("testOne前 *** %d--%p\n",b,&b);
    void (^blockTwo)(void) = ^{
        b++;
        printf("testOne中 *** %d--%p\n",&b);
    };
    
    blockTwo();
    printf("testOne后 *** %d--%p\n",b,&b);
```

```ruby
testOne前 *** 10--0x7ffee8207128
testOne中 *** 11--0x600001f68058
testOne后 *** 11--0x600001f68058
```

> 结论：指针的地址发生了变化及指针发生了copy

2. __block修饰int，不在block内赋值

```objc
    __block int b = 10;
    printf("testOne前 *** %d--%p\n",b,&b);
    void (^blockTwo)(void) = ^{
//        b++;
        printf("testOne中 *** %d--%p\n",b,&b);
    };
    
    blockTwo();
    printf("testOne后 *** %d--%p\n",b,&b);
```

```ruby
testOne前 *** 10--0x7ffee1484288
testOne中 *** 10--0x6000032200b8
testOne后 *** 10--0x6000032200b8
```

> 结论：指针本身从栈区到了堆区，指针被copy

3. __block修饰NSString类型，并在block中修改NSString

```objc
    __block NSString *b = @"haha";
    printf("testTwo前1 *** %p--%p\n",b,&b);
    
    b = @"hani";
    printf("testTwo前2 *** %p--%p\n",b,&b);
    
    void (^blockTwo)(void) = ^{
        b = @"niha";
        printf("testTwo中 *** %p--%p\n",b,&b);
    };
    
    blockTwo();
    printf("testTwo后 *** %p--%p\n",b,&b);
```

```ruby
testTwo前1 *** 0x10d3441a0--0x7ffee28bb278
testTwo前2 *** 0x10d344220--0x7ffee28bb278
testTwo中 *** 0x10d344240--0x600002a18c58
testTwo后 *** 0x10d344240--0x600002a18c58
```
> 结论：字符串指针和内存地址都发生了变化，通过前1和前2对比发现，NSString重新赋值地址就会变化。基本推论，进行了浅拷贝。

4. __block修饰NSString类型，不在block中修饰NSString

```objc
    __block NSString *b = @"haha";
    printf("testTwo前 *** %p--%p\n",b,&b);
    void (^blockTwo)(void) = ^{
//        b = @"nihao";
        printf("testTwo中 *** %p--%p\n",b,&b);
    };
    
    blockTwo();
    printf("testTwo后 *** %p--%p\n",b,&b);
```

```ruby
testTwo前 *** 0x10e2ca1a0--0x7ffee1935288
testTwo中 *** 0x10e2ca1a0--0x6000025b02f8
testTwo后 *** 0x10e2ca1a0--0x6000025b02f8
```

> 结论：指针从栈区到了堆区，指针被copy，而字符串物理内存地址没变

5. 不用block修饰一个model，并在block中进行赋值

```objc
    Model *modelOne = [[Model alloc] init];
    modelOne.name = @"张三";
    printf("testThree前 *** %p--%p\n",modelOne,&modelOne);
    NSLog(@"testThree前 **** %@",modelOne.name);
    void (^blockTwo)(void) = ^{
        modelOne.name = @"lisi";
        printf("testThree中 *** %p--%p\n",modelOne,&modelOne);
        NSLog(@"testThree中 **** %@",modelOne.name);
    };
    blockTwo();
    printf("testThree后 *** %p--%p\n",modelOne,&modelOne);
    NSLog(@"testThree后 **** %@",modelOne.name);
```

```ruby
testThree前 *** 0x60000065c250--0x7ffee22c9298
testThree前 **** 张三
testThree中 *** 0x60000065c250--0x600000a512e0
testThree中 **** lisi
testThree后 *** 0x60000065c250--0x7ffee22c9298
testThree后 **** lisi
```

> 结论：只是进行了浅拷贝，指针地址从栈区跑到了堆区。


6. 不用__block修饰一个model，不在block中赋值

```objc
    Model *modelOne = [[Model alloc] init];
    modelOne.name = @"张三";
    printf("testThree前 *** %p--%p\n",modelOne,&modelOne);
    NSLog(@"testThree前 **** %@",modelOne.name);
    void (^blockTwo)(void) = ^{
//        modelOne.name = @"lisi";
        printf("testThree中 *** %p--%p\n",modelOne,&modelOne);
        NSLog(@"testThree中 **** %@",modelOne.name);
    };
    blockTwo();
    printf("testThree后 *** %p--%p\n",modelOne,&modelOne);
    NSLog(@"testThree后 **** %@",modelOne.name);
```

```ruby
testThree前 *** 0x600002814270--0x7ffee2dbe298
testThree前 **** 张三
testThree中 *** 0x600002814270--0x6000024717c0
testThree中 **** 张三
testThree后 *** 0x600002814270--0x7ffee2dbe298
testThree后 **** 张三
```

> 结论：发生了浅拷贝，block内的指针为从栈区拷贝过来的

7. __block修饰model，并在block内对model进行修改

```objc
    __block Model *model = [[Model alloc] init];
    model.name = @"张三";
    
    printf("testfour前 *** %p--%p\n",model,&model);
    NSLog(@"testfour前 **** %@",model.name);
    void (^blockTwo)(void) = ^{
        model.name = @"李四";
        printf("testfour中 *** %p--%p\n",model,&model);
        NSLog(@"testfour中 **** %@",model.name);
    };
    blockTwo();
    printf("testfour后 *** %p--%p\n",model,&model);
    NSLog(@"testfour后 **** %@",model.name);
```

```ruby
testfour前 *** 0x6000011aeec0--0x7ffeef86c288
testfour前 **** 张三
testfour中 *** 0x6000011aeec0--0x600001da5138
testfour中 **** 李四
testfour后 *** 0x6000011aeec0--0x600001da5138
testfour后 **** 李四
```

> 结论：发生了浅拷贝，指针从栈区到了堆区，并且是永久性的改变

8. __block修饰model，不在block内对model修改

```objc
    __block Model *model = [[Model alloc] init];
    model.name = @"张三";
    
    printf("testfour前 *** %p--%p\n",model,&model);
    NSLog(@"testfour前 **** %@",model.name);
    void (^blockTwo)(void) = ^{
//        model.name = @"李四";
        printf("testfour中 *** %p--%p\n",model,&model);
        NSLog(@"testfour中 **** %@",model.name);
    };
    blockTwo();
    printf("testfour后 *** %p--%p\n",model,&model);
    NSLog(@"testfour后 **** %@",model.name);
```

```ruby
testfour前 *** 0x6000037dc3b0--0x7ffee387e288
testfour前 **** 张三
testfour中 *** 0x6000037dc3b0--0x600003b84268
testfour中 **** 张三
testfour后 *** 0x6000037dc3b0--0x600003b84268
testfour后 **** 张三
```

> 结论：发生了浅拷贝，指针从栈区到了堆区，并且是永久性的改变

#### 总结论

**OC中**
1. 局部变量进入block内，如果在block内进行重新赋值(走new方法等重新创建)，则必须加__block，否则报错。
2. 可变局部变量(NSMutable)进入block，在block内通过add/append等方法改变其值，外部局部变量值也会改变。
3. 局部变量进入block内，其指针都会从栈区copy一份到堆区(浅拷贝)，区别就是，__block修饰的局部变量copy出的指针会“替换”外部指针，而不用__block修饰，则外部指针不会被“替换”。

**C中**

* 使用__block修饰，指针直接不copy，不使用__block修饰，指针进行copy
