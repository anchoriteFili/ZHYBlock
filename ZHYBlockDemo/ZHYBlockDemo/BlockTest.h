//
//  block.h
//  ZHYBlockDemo
//
//  Created by 赵宏亚 on 2019/7/18.
//  Copyright © 2019 赵宏亚. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Model : NSObject
@property (nonatomic,strong) NSString * name;
@end

@interface BlockTest : NSObject

@property (nonatomic,assign) int a;
@property (nonatomic,strong) Model *testModel;

@property (nonatomic,strong) NSString *name;

- (void)blockTestOne;

@end

NS_ASSUME_NONNULL_END
