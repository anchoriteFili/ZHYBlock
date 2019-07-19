//
//  main.c
//  blocktest
//
//  Created by 赵宏亚 on 2019/7/18.
//  Copyright © 2019 赵宏亚. All rights reserved.
//

#include <stdio.h>

int main(int argc, const char * argv[]) {
    
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
    
    return 0;
}
