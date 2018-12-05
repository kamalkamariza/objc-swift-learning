//
//  SecurityViewController.m
//  SelfLearning
//
//  Created by kamal on 05/07/2018.
//  Copyright © 2018 Kamal. All rights reserved.
//

#import "SecurityViewController.h"
#import <Security/Security.h>
#import "RSA.h"

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
    
    //TestRSA
    [self testRSA];
    
    [Encryptor createPubPrivKeys];
}

-(void) testRSA{
    
    NSString *pubkey = @"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDI2bvVLVYrb4B0raZgFP60VXY\ncvRmk9q56QiTmEm9HXlSPq1zyhyPQHGti5FokYJMzNcKm0bwL1q6ioJuD4EFI56D\na+70XdRz1CjQPQE3yXrXXVvOsmq9LsdxTFWsVBTehdCmrapKZVVx6PKl7myh0cfX\nQmyveT/eqyZK1gYjvQIDAQAB\n-----END PUBLIC KEY-----";
    NSString *privkey = @"-----BEGIN PRIVATE KEY-----\nMIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMMjZu9UtVitvgHS\ntpmAU/rRVdhy9GaT2rnpCJOYSb0deVI+rXPKHI9Aca2LkWiRgkzM1wqbRvAvWrqK\ngm4PgQUjnoNr7vRd1HPUKNA9ATfJetddW86yar0ux3FMVaxUFN6F0KatqkplVXHo\n8qXubKHRx9dCbK95P96rJkrWBiO9AgMBAAECgYBO1UKEdYg9pxMX0XSLVtiWf3Na\n2jX6Ksk2Sfp5BhDkIcAdhcy09nXLOZGzNqsrv30QYcCOPGTQK5FPwx0mMYVBRAdo\nOLYp7NzxW/File//169O3ZFpkZ7MF0I2oQcNGTpMCUpaY6xMmxqN22INgi8SHp3w\nVU+2bRMLDXEc/MOmAQJBAP+Sv6JdkrY+7WGuQN5O5PjsB15lOGcr4vcfz4vAQ/uy\nEGYZh6IO2Eu0lW6sw2x6uRg0c6hMiFEJcO89qlH/B10CQQDDdtGrzXWVG457vA27\nkpduDpM6BQWTX6wYV9zRlcYYMFHwAQkE0BTvIYde2il6DKGyzokgI6zQyhgtRJ1x\nL6fhAkB9NvvW4/uWeLw7CHHVuVersZBmqjb5LWJU62v3L2rfbT1lmIqAVr+YT9CK\n2fAhPPtkpYYo5d4/vd1sCY1iAQ4tAkEAm2yPrJzjMn2G/ry57rzRzKGqUChOFrGs\nlm7HF6CQtAs4HC+2jC0peDyg97th37rLmPLB9txnPl50ewpkZuwOAQJBAM/eJnFw\nF5QAcL4CYDbfBKocx82VX/pFXng50T7FODiWbbL4UnxICE0UBFInNNiWJxNEb6jL\n5xd0pcy9O2DOeso=\n-----END PRIVATE KEY-----";
    
    NSString *originString = @"This is a secret message!";
    
    NSString *a;    //encrypt with pub key
    NSString *b;    //decrypt with priv key
    NSString *c;    //encrypt with priv key
    NSString *d;    //decrypt with pub key
    NSString *e;    //decrypt server with priv key
    NSString *f;    //decrypt server with pub key
    NSString *server;

    
    NSLog(@"Text Input %@", originString);
    
    /**
        encrypt string with public key and decrypt with private key
     **/
    
//    encWithPubKey = [RSA encryptString:originString publicKey:pubkey];
//    NSLog(@"Encrypted with public key: %@", encWithPubKey);
//    decWithPrivKey = [RSA decryptString:encWithPubKey privateKey:privkey];
//    NSLog(@"Decrypted with private key: %@", decWithPrivKey);
    
    // encrypt string with public key and decrypt with private key
    a = [RSA encryptString:originString publicKey:pubkey];
    NSLog(@"a: %@", a);
    b = [RSA decryptString:a privateKey:privkey];
    NSLog(@"b: %@", b);
    
    ////////////////////////////////////////////////////////////////////////
    
    /**
        encrypt with private key and decrypt with public key
     **/
    
//    encWithPrivKey = [RSA encryptString:originString privateKey:privkey];
//    NSLog(@"Enctypted with private key: %@", encWithPrivKey);
//    decWithPublicKey = [RSA decryptString:encWithPrivKey publicKey:pubkey];
//    NSLog(@"(PHP enc)Decrypted with public key: %@", decWithPublicKey);
    
    c = [RSA encryptString:originString privateKey:privkey];
    NSLog(@"c: %@", c);
    d = [RSA decryptString:c publicKey:pubkey];
    NSLog(@"d: %@", d);
    
    ////////////////////////////////////////////////////////////////////////
    
    /**
        server encrypt with public key and decrypt with public/private key
     **/
    
    // by PHP
    server = @"CKiZsP8wfKlELNfWNC2G4iLv0RtwmGeHgzHec6aor4HnuOMcYVkxRovNj2r0Iu3ybPxKwiH2EswgBWsi65FOzQJa01uDVcJImU5vLrx1ihJ/PADUVxAMFjVzA3+Clbr2fwyJXW6dbbbymupYpkxRSfF5Gq9KyT+tsAhiSNfU6akgNGh4DENoA2AoKoWhpMEawyIubBSsTdFXtsHK0Ze0Cyde7oI2oh8ePOVHRuce6xYELYzmZY5yhSUoEb4+/44fbVouOCTl66ppUgnR5KjmIvBVEJLBq0SgoZfrGiA3cB08q4hb5EJRW72yPPQNqJxcQTPs8SxXa9js8ZryeSxyrw==";
    
    e = [RSA decryptString:server privateKey:privkey];
    NSLog(@"e: %@", e);
    
    // decrypt with public key
    f = [RSA decryptString:server publicKey:pubkey];
    NSLog(@"f: %@", f);
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
