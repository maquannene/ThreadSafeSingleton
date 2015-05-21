//
//  MaquanSingleton.m
//  ThreadSafeSingleton
//
//  Created by 马权 on 3/9/15.
//  Copyright (c) 2015 maquan. All rights reserved.
//

#import "MaquanSingleton.h"

@interface MaquanSingleton ()

@property (retain, nonatomic) dispatch_queue_t maquanQueue;         //  单例读写处理并发队列
@property (retain, nonatomic) NSString *name;

@end

@implementation MaquanSingleton

static MaquanSingleton *shareMaquan = nil;

@synthesize name = _name;

- (void)dealloc
{
    [_name release];
    _name = nil;
    [super dealloc];
}

+ (instancetype)shareMaquan {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareMaquan = [[MaquanSingleton alloc] init];
        shareMaquan.maquanQueue = dispatch_queue_create("singleton.maqan", DISPATCH_QUEUE_CONCURRENT);
        shareMaquan.name = @"maquan";
        
    });
    return shareMaquan;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

//  读操作在maquanQueue中并发执行。
- (NSString *)name {
    __block NSString *mName = nil;
    dispatch_sync(self.maquanQueue, ^{
        mName = _name;
    });
    return mName;
}

//  写操作在并发队列maquanQueue中运用栅栏异步执行。
//  使在写操作时等同串行。
- (void)setName:(NSString *)name {
    dispatch_barrier_async(self.maquanQueue, ^{
        if (name != _name) {
            [_name release];
            _name = [name retain];
            sleep(3);
        }
    });
}

//  重写方法
//  防止防止生成新的地址， 不管shareMaquan 还是 alloc都会跑这里申请内存，但是内存只申请一次。永远无法被创建。
+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareMaquan = [super allocWithZone:zone];
    });
    return shareMaquan;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (oneway void)release
{
    
}

- (instancetype)autorelease
{
    return self;
}

@end
