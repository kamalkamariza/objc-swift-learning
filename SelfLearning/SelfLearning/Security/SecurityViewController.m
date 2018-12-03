//
//  SecurityViewController.m
//  SelfLearning
//
//  Created by kamal on 05/07/2018.
//  Copyright © 2018 Kamal. All rights reserved.
//

#import "SecurityViewController.h"
#import <Security/Security.h>

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
    
    NSString *key1 = @"key1";
    NSString *key2 = @"key2";
    
    NSString *input  = @"This is the message im sending";
    NSMutableData *inputData = [[NSMutableData alloc] initWithData:[input dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *encryptedInputData = [Encryptor EncryptAES:key1 withData:inputData];
    NSLog(@"Inputdata vs encrypted data length %lu %lu", inputData.length, encryptedInputData.length);
    
    NSMutableData *sourceEncData = [[NSMutableData alloc]initWithData:encryptedInputData];
    NSMutableData *unencryptedData = [Encryptor DecryptAES:key1 forData:sourceEncData];
    NSString *product = [[NSString alloc] initWithData:unencryptedData encoding:NSUTF8StringEncoding];
    NSLog(@"encrypted data  vs Inputdata length %lu %lu", sourceEncData.length, unencryptedData.length);

    NSMutableData *sourceEncrData = [[NSMutableData alloc]initWithData:encryptedInputData];
    NSMutableData *unencryptedDataTest = [Encryptor DecryptAES:key2 forData:sourceEncrData];
    NSString *productTest = [[NSString alloc] initWithData:unencryptedDataTest encoding:NSUTF8StringEncoding];
    
    NSLog(@"original input %@ with %@", input, key1);
    NSLog(@"product input %@ with %@", product, key1);
    NSLog(@"product input %@ with %@", productTest, key2);



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
