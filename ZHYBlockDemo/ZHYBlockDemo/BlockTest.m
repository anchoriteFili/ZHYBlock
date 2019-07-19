//
//  block.m
//  ZHYBlockDemo
//
//  Created by 赵宏亚 on 2019/7/18.
//  Copyright © 2019 赵宏亚. All rights reserved.
//

#import "BlockTest.h"

@implementation Model


@end


@implementation BlockTest

- (void)blockTestOne {
    
    [self testThree];
    [self testfour];
    [self testOne];
    [self testTwo];
    [self stringCopy];
    [self stringMutableCopy];
    [self testArray];
    [self testString];
    
    
    
}

// 浅拷贝
- (void)stringCopy {
    NSString *srcStr = [NSString stringWithFormat:@"age is %d",10];
    NSString *copyStr = [srcStr copy];
    
    printf("内存地址%p----%p\n",srcStr,copyStr);
    printf("指针地址%p----%p\n",&srcStr,&copyStr);
    
}

// 深拷贝
- (void)stringMutableCopy {
    
    NSString *srcStr = [NSString stringWithFormat:@"age is %d",10];
    
    NSMutableString *copystr = [srcStr mutableCopy];
    [copystr appendString:@" hahaha"];
    
    NSLog(@"srcStr ==== %@  copystr === %@",srcStr,copystr);
    
    printf("内存地址%p----%p\n",srcStr,copystr);
    printf("指针地址%p----%p\n",&srcStr,&copystr);
}

// 局部变量进入block
- (void)testOne {
    
    __block int b = 10;
    printf("testOne前 *** %d--%p\n",b,&b);
    
    void (^blockTwo)(void) = ^{
//        b++;
        printf("testOne中 *** %d--%p\n",b,&b);
    };
    
    blockTwo();
    printf("testOne后 *** %d--%p\n",b,&b);
}

// 全局变量进入block
- (void)testTwo {
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

}

- (void)testString {
    
    __block NSMutableString *b = [NSMutableString stringWithFormat:@"lajflskjfls"];
    
    printf("testString前 *** %p--%p\n",b,&b);
    void (^blockTwo)(void) = ^{
        b = [NSMutableString stringWithFormat:@"lajflskjfls"];
        printf("testString中 *** %p--%p\n",b,&b);
    };
    
    blockTwo();
    printf("testString后 *** %p--%p\n",b,&b);
    
    NSLog(@"testString后 ***** %@",b);
    
    
    
}

- (void)testArray {
    
    NSMutableArray *b = [NSMutableArray arrayWithObjects:@"张三",@"李四",@"王五", nil];
    printf("testArray前 *** %p--%p\n",b,&b);
    void (^blockTwo)(void) = ^{
        [b addObject:@"赵四"];
        printf("testArray中 *** %p--%p\n",b,&b);
    };
    
    blockTwo();
    printf("testArray后 *** %p--%p\n",b,&b);
    
    NSLog(@"testArray后 ***** %@",b);
    
    
    
}




// 对象进入block不用__block
- (void)testThree {
    
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
    
}

// 对象进入block用__block，永久性的改变了指针指向
- (void)testfour {
    
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
}


@end
