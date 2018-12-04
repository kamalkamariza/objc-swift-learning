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
    
    //  Simple AES
    [self simpleAES];

    //  Advanced AES
    [self advancedAES];
    
    //Create random keys
    [self createRandomKeyBytes:16];
    [self createRandomKeyBytes:32];
}

-(void)simpleAES{
    NSString *key1 = @"key1";
    NSString *key2 = @"key2";
    NSString *input  = @"This is the secret message for simple AES";
    NSMutableData *inputData = [[NSMutableData alloc] initWithData:[input dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *encryptedInputData = [Encryptor EncryptAES:key1 withData:inputData];
    
    NSMutableData *sourceEncData = [[NSMutableData alloc]initWithData:encryptedInputData];
    NSMutableData *unencryptedData = [Encryptor DecryptAES:key1 forData:sourceEncData];
    NSString *product = [[NSString alloc] initWithData:unencryptedData encoding:NSUTF8StringEncoding];
    
    NSMutableData *sourceEncrData = [[NSMutableData alloc]initWithData:encryptedInputData];
    NSMutableData *unencryptedDataTest = [Encryptor DecryptAES:key2 forData:sourceEncrData];
    NSString *productTest = [[NSString alloc] initWithData:unencryptedDataTest encoding:NSUTF8StringEncoding];
    
    NSString *title = @"Simple AES Testing";
    
    NSLog(@"%@",[NSString stringWithFormat:@"\n\n%@ \nKey 1: %@\nKey 2: %@\nSecret Message: %@\nOutput %@ with %@\nOutput %@ with %@\n\n", title, key1,key2, input, product,key1,productTest,key2]);
}

-(void)advancedAES{
//    NSString *hexKey1 = @"2034F6E32958647FDFF75D265B455EBF40C80E6D597092B3A802B3E5863F878C";
//    NSString *ivKey1 = @"AD0ACC568C88C116D57B273D98FB92C0";
    
    NSString *hexKey1 = [self createRandomKeyBytes:32];
    NSString *ivKey1 = [self createRandomKeyBytes:16];
    
//    NSString *hexKey2 = @"2034F6E32958647FDFF75D265B455EBF40C80E6D597092B3A802B3E5863F878A";
//    NSString *ivKey2 = @"AD0ACC568C88C116D57B273D98FB92C1";
    
    NSString *hexKey2 = [self createRandomKeyBytes:32];
    NSString *ivKey2 = [self createRandomKeyBytes:16];

    NSString *input  = @"This is the secret message for advanced AES";
    
    NSData *encryptedData = [Encryptor encodeAndPrintPlainText:input usingHexKey:hexKey1 hexIV:ivKey1];
    
    NSString *base64EncodedString = [encryptedData base64EncodedStringWithOptions:0];
    
    NSData *unencryptedDataKey1 = [Encryptor decodeAndPrintCipherBase64Data:base64EncodedString usingHexKey:hexKey1 hexIV:ivKey1];
    NSData *unencryptedDataKey2 = [Encryptor decodeAndPrintCipherBase64Data:base64EncodedString usingHexKey:hexKey2 hexIV:ivKey2];
    
    NSString *unencryptedStringKey1 = [[NSString alloc] initWithData:unencryptedDataKey1 encoding:NSUTF8StringEncoding];
    NSString *unencryptedStringKey2 = [[NSString alloc] initWithData:unencryptedDataKey2 encoding:NSUTF8StringEncoding];
    
    NSString *title = @"Advanced AES Testing";
    
    NSLog(@"%@",[NSString stringWithFormat:@"\n\n%@\nSecret Message: %@\nHexKey1: %@\nIVKey1: %@\nHexKey2: %@\nIVKey2: %@\nOUTPUT %@ WITH HEXKEY %@ and IVKEY %@\nOUTPUT %@ WITH HEXKEY %@ and IVKEY %@", title,input, hexKey1, ivKey1, hexKey2, ivKey2,unencryptedStringKey1, hexKey1, ivKey1,unencryptedStringKey2, hexKey2, ivKey2]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*)createRandomKeyBytes:(NSUInteger)byteLength{
    uint8_t randomBytes[byteLength];
    int result = SecRandomCopyBytes(kSecRandomDefault, byteLength, randomBytes);
    if(result == 0) {
        NSMutableString *uuidStringReplacement = [[NSMutableString alloc] initWithCapacity:byteLength*2];
        for(NSInteger index = 0; index < byteLength; index++)
        {
            [uuidStringReplacement appendFormat: @"%02x", randomBytes[index]];
        }
        NSLog(@"uuidStringReplacement is %@", uuidStringReplacement);
        return uuidStringReplacement;
    } else {
        NSLog(@"SecRandomCopyBytes failed for some reason");
        return nil;
    }
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
