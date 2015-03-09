//
//  ViewController.m
//  ThreadSafeSingleton
//
//  Created by 马权 on 3/9/15.
//  Copyright (c) 2015 maquan. All rights reserved.
//

#import "ViewController.h"
#import "MaquanSingleton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MaquanSingleton *maquan1 = [MaquanSingleton shareMaquan];
    MaquanSingleton *maquan2 = [[MaquanSingleton alloc] init];
    NSLog(@"%p , %p , 两个地址形同。", maquan1, maquan2);
    
    //1.
    maquan1.name = @"maquanNew";
    NSLog(@"%@", maquan2.name);
    
    //2.
    NSLog(@"%@", maquan1.name);
    maquan1.name = @"maquanNewNew";     //  虽然这个操作是异步的，但是栅栏保证写的时候不会进行读。
    NSLog(@"%@", maquan1.name);
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
