//
//  MaquanSingleton.h
//  ThreadSafeSingleton
//
//  Created by 马权 on 3/9/15.
//  Copyright (c) 2015 maquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaquanSingleton : NSObject

+ (instancetype)shareMaquan;

- (NSString *)name;

- (void)setName:(NSString *)name;

@end