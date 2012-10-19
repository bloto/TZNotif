//
//  ViewController.m
//  TZNotifDemo
//
//  Created by Tomasz Zablocki on 19/10/2012.
//  Copyright (c) 2012 Tomasz Zablocki. All rights reserved.
//

#import "ViewController.h"
#import "TZNotif.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [TZNotif showString:@"Here I am, nice notification for you"];
    [TZNotif showString:@"But I am not alone"];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
