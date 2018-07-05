//
//  SecurityViewController.m
//  SelfLearning
//
//  Created by kamal on 05/07/2018.
//  Copyright © 2018 Kamal. All rights reserved.
//

#import "SecurityViewController.h"
#import <Security/Security.h>
#import <CommonCrypto/CommonCrypto.h>

@interface SecurityViewController ()
{
    NSString *message1;
    NSString *message2;

}

@end

@implementation SecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.title = @"Security";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
