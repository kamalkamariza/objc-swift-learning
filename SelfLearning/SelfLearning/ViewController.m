//
//  ViewController.m
//  SelfLearning
//
//  Created by weeclicks on 30/03/2018.
//  Copyright © 2018 Kamal. All rights reserved.
//

#import "ViewController.h"
#import "ContactMainViewController.h"
#import "YapdbVC.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Home";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Contacts" forState:UIControlStateNormal];
    [button sizeToFit];
    button.frame = CGRectMake(100, 100, 80, 20);
    [button addTarget:self action:@selector(go:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)go:(id)sender{
//    ContactMainViewController *destVC = [[ContactMainViewController alloc]init];
    YapdbVC *destVC = [[YapdbVC alloc]init];
    
    [self.navigationController pushViewController:destVC animated:YES];
}


@end
