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
#import "../Encryption.pbobjc.h"

@interface SecurityViewController ()
{
    NSString *message1;
    NSString *message2;
    UIImageView *iv1;
    UIImageView *iv2;
    UIImageView *iv3;
}

@end

@implementation SecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.title = @"Security";
    // Do any additional setup after loading the view.
    
    iv1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 70, 50, 50)];
    iv2 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 140, 50, 50)];
    iv3 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 210, 50, 50)];
    
    [self.view addSubview:iv1];
    [self.view addSubview:iv2];
    [self.view addSubview:iv3];
    
    [iv3 setImage:[UIImage imageNamed:@"a.png"]];
    
    //test server key
    [self testServerKey];
    
    //  Simple AES
//    [self simpleAES];

      //Advanced AES
//    [self advancedAES];
    
    //custom AES
//    [self customAES];
    
    //fileSharing
//    [self testFileSharing];
    
    
    //Create random keys
//    [self createRandomKeyBytes:16];
//    [self createRandomKeyBytes:32];
    
    //TestRSA
//    [self testRSA];
    
//    [Encryptor createPubPrivKeys:^(NSString *private, NSString *public) {
//        NSLog(@"Public KEY %@", public);
//        NSLog(@"Private KEY %@", private);
//    }];
    
//    [self testProtobuf];
}

-(void)testServerKey{
    NSString *privServerKey = @"-----BEGIN RSA PRIVATE KEY-----MIIEpQIBAAKCAQEA1xi385BHpxTw5lW1bbMAGeqD59FPT6bpT9k58isgfRrLYEsYUlMgRiGRm38qrYGzceb3Uz6syWqoJJypbDLNgJzCOczekR4HDRe4xLxQhuZ8RHzzcTAUC3aKLOqZcLmdZxiL0D3aNmukF2VFbKWNl5Qt5a2uOoGJTvITbkHuAw+adn3YxbK0iK0JO030MNH3Z1LkyDcSKHw8YzSCB5WTILRyrmfOTrpz7yld8fDNoaCpyQJ4G0hwm55S9E25j735h0/+nM4wZKUBJ6RD0k9ar9sg+J3IvuibG13Lj9Pfk+5XW9TI+BN6CSM3yZ3FwM1M6O8nFGiPISvAg4Fpvo2p5QIDAQABAoIBAQDLyIVu4kCgUTyyXH1ZAv+TjhWOKUWkxxPALKOzhZxwKlSIVF0kkdC/4Mncsiwy2fCydwnW+kglQ0Et/qac9bywntN8g1ZR0ksH4nORIICCbhdJo7/Yep5jBdl/GHxqydAQfrbngdIdQPnjmHSfrHFrLF4XfebVUyhNfRdfnGLszbu1COgqpxDbtbFe57eDBVq7Qrgz662APW2MdZbEhCN8yLKXg7QpHym0kJWDxATqbodUPWbQX6v8vvQiug2KELOTH7CpbNTtuCfrwcbOU3vuemaYBldLQ3XRt4Ceo4lm3xw3YBr4EjuiHiVY325OcQcMfdoVTq64inBcif/O5Iu5AoGBANmKdk76xmrBlhPygFJ6whfRAl2F09u/ed25SetlrBQ7j9S7Tf3R6mA4cShaVLWRyk4XpJI47e3HSiZNu35Euv/DzYLJyhRwiQI3ucoikndg1hrVqrEi7efnr15anMfk3h7u0Uag6dNODMhyWkD3NEF/ZcIioE5O5zhmQjvNdHgHAoGBAP0foYdz3Sib1BHSV/do6HELtU5bz41XQoRbasbyJq6DMfY06WUJnAH8W0zemBNJF55mjAW08LhtY5D1HU8kEHe9cZBHOvgQdHg80ftr/rcmp1PSO6LL9+zDVMPyrURiXUR2j7UzoBU6HqAg+fvBIcAcZAmByfOoWRf/Dm1XoxuzAoGAA23MSZhoUjx06iGTZjlrH8b6m5DFcxxEhnsqMBytJrB9puPA6fRKFnQtTG6IEUiYAL0cqfVdwra2c34cK3RX4joq3hniJopTjoZkVkxPNLSBC3E8vIgJafNb70fMWtY/rgsjn1Jf/SWoy+wJgiajWzjv2KyFDFbwDBKIjrrBUDcCgYEA5KH5iRvCm7eFKkPQaQ09Rz7IGWscYhJ7ZoocPG7lOaQPMNBCMJ0paTHEVf6JZoIS72S4/T6eYDeOQ5TjUGTG6yEWvrdYMFDMov5svKijflNPuIqgiz+pRRZ6LjO5BZfDnt9olsd2xTWmDAU9R4T/M0NxqJSvEYLyVpZvNZx/G7kCgYEAym+h49n5//pZ6p3DydJj758TjGMpbPwUSgEbKYL6a0jbbqp4N+5vCuQgRqAzVqL0gWLaQUaxH0LRyUjixGToNqBPVlPbXsQcr820F196HfX4GS4puSiYtHHMSYRo+4FNANS39uVV7lL1L3lzXcnPDBrdcFc6xa4XNuEMtpMyHvw=-----END RSA PRIVATE KEY-----";
    
    __block NSString *pubServerKey;
    
    [self getPublicKeyFromServer:^(NSString * _Nullable key) {
        pubServerKey = key;
        NSLog(@"%@", key);
        
        NSError *error;
        NSData *testData = [self createDataMessage];
        NSData *encryptedData = [RSA encryptData:testData publicKey:pubServerKey];
        NSData *testData64 = [encryptedData base64EncodedDataWithOptions:0];
        testData = nil;
        
        DataMessage *dataReader1 = [DataMessage parseFromData:testData error:&error];
        
        NSString *body = dataReader1.body;
        NSString *sender = dataReader1.sender;
        NSString *recipient = dataReader1.recipient;
        BOOL hasMedia = dataReader1.attachment;
        
        NSLog(@"Body %@", body);
        NSLog(@"sender %@", sender);
        NSLog(@"recipient %@", recipient);
        NSLog(@"media %d", hasMedia);
        
        //    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        testData = [[NSData alloc]initWithBase64EncodedData:testData64 options:0];
        
        NSLog(@"encrypted length %lu", encryptedData.length);
        NSLog(@"testData length %lu", testData.length);
        
        NSData *unencryptedData = [RSA decryptData:testData privateKey:privServerKey];
        
        NSLog(@"encrypted length %lu", encryptedData.length);
        NSLog(@"testData length %lu", testData.length);
        
        DataMessage *dataReader2 = [DataMessage parseFromData:unencryptedData error:&error];
        
        body = dataReader2.body;
        sender = dataReader2.sender;
        recipient = dataReader2.recipient;
        hasMedia = dataReader2.attachment;
        
        NSLog(@"Body2 %@", body);
        NSLog(@"sender2 %@", sender);
        NSLog(@"recipient2 %@", recipient);
        NSLog(@"media2 %d", hasMedia);
    }];
}

-(void)testFileSharing{
    NSString *privKey3 = @"-----BEGIN PRIVATE KEY-----MIIEogIBAAKCAQEAh9FqJEc21S1hEMoOHevlNxsKCcAlkDWS+OLgKi3/0xHaq5scuZdDx5wViCEI644MvrBzxZ1fGcLNtDy1iafHpDZ3pDyu5KxZpY6j7ne6TGY9/AKpFsCYTi+9ZFi6eP4v85SoWkzhpi5ikiMoaxnJPFs5VDVe3TR9WJxdyRAEfPaw+UyaR4UxyXS6rec+Z2FVsuNAgKEXRH7U+2zl7vAnTSf9hlFH/SHXBdDrK9zn/46Wcxi9kJHuT9Yj6o5n9dTPcuKbKsm6OAqtvP3+tmxge8lIpcEoYY8W4xzwUaKfvavRlB/JF5Ed8VWwy7xDWLPWxg3gij+mhVf3+8qwEcjTVwIDAQABAoIBACKwS1ZBtBEFepWhrbJZthz5dHpiD5YCAOw9cfiD8COWG04aG1+RcVfRlzRCD7et+7ZWdfNCivAW75f5q3ohlp1r5enWL+sq0+izgk4dWUE7Gdi8SziK7zuE+O/gs5vEfDXPwaHyoe1iSn29qgyUtO+L8xv9V6HSzrLrmQ6J30OVFQU7GbJrr+Lc0k38GO245dUciisnxUUoS+513GpfYD70QpnU7lBl3nUsZCiSNxPIWIQhL3X3+yT8Nx4oEyL6qTgmLpbGQuiQ808uowfX54A5MTxVQvju1xJKWYcY5K5461R7Km5PQ6MQtGAiMbk58IjiciDG4FCiYT7Svv7ePvUCgYEAuuLab3yjfiNPmvVDaQnbluwm5nmi9kwtAvj+uv44HCRneWb1ynBu3hy/KpXYJrJLitR5ggQE/kdAWkF5JyRc0uS9tb/lDant0OQgT3He1V/AwnYRI5ay067AcrW5vDIDYmdZAojtboE5SXO0+pzwxbaX4Te0tt57riaRapN3MJsCgYEAugvE0zvKv4/1MJAgoHk3DHZj5tZCT5pOTSVXnlaWndb1jCh61VsFaNzKXqajNQg7tRIerUQMwZX/EB9Npz3sEMrPQs3Lc4ils2P3aebazcg4AVlhGLmsN1GscXlWsjOEQGJaCTl2stX40qo3wNTZdAQLUDOoAEqmRYRRck+dXfUCgYBx+Gyb9tfB0gj3CEG+6fsXlBa5EU73g0cj+/Nk2Cohx3WvDMIyXdTO8ZsHfnBeUPdOx/r99jORWqR9JlabL0rIdiTXlRo79fiJHsYxjNEHMSjdrqEPIhUWkQjeK8MEaT+1IC+hIx4g+P+VstGY0GLpQExpVc6Igy/L6ctewmW6pwKBgB4xgsP1VDY6msRC38irY2+2VwhDhYd9t291u/6Kdu8uz7LrbuPpXbti+cTarmoQ5/++7ROZk6hnO3nWWrflqMYg4/ong/lAGARBGQoq2R/EerJdWxC0MWrY6m+QDa3mBnScgZg1pznm1/b4gQvef1wAvAVMHNvPQaTOkJlIqnVxAoGAS0w5PT8k/UOONyCHKp5lCzV1wW62vy9IT46Lh0q9FTWAfoIBKHm9fAKrk6vomgBrEzqV4W6ZBwFT4s/lLWmDbsGLnzA22Bu+3StAl9UJQP1B0zPdhsULRUvn+zeSS2bAw+WOwMW39NymnO5ojbnR96L/v8+GjblUmHgt63fxVEQ=-----END PRIVATE KEY-----";
    
    NSString *pubKey3 = @"-----BEGIN PUBLIC KEY-----\nMIIBCgKCAQEAh9FqJEc21S1hEMoOHevlNxsKCcAlkDWS+OLgKi3/0xHaq5scuZdDx5wViCEI644MvrBzxZ1fGcLNtDy1iafHpDZ3pDyu5KxZpY6j7ne6TGY9/AKpFsCYTi+9ZFi6eP4v85SoWkzhpi5ikiMoaxnJPFs5VDVe3TR9WJxdyRAEfPaw+UyaR4UxyXS6rec+Z2FVsuNAgKEXRH7U+2zl7vAnTSf9hlFH/SHXBdDrK9zn/46Wcxi9kJHuT9Yj6o5n9dTPcuKbKsm6OAqtvP3+tmxge8lIpcEoYY8W4xzwUaKfvavRlB/JF5Ed8VWwy7xDWLPWxg3gij+mhVf3+8qwEcjTVwIDAQAB\n-----END PUBLIC KEY-----";
    NSData *key = [Encryptor generateRandomKeysWithIV:16 withHexKey:32];
    NSString *fileName = @"IMG1.JPG";
    
    __block dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"a.png"], 0.1);
    NSData *encryptedData = [Encryptor encryptDataAES:imageData usingKeyData:key];
    NSUInteger middle = encryptedData.length / 2;
    NSUInteger length = encryptedData.length;
    
    NSData *firstPart = [encryptedData subdataWithRange:NSMakeRange(0, middle)];
    NSData *lastPart = [encryptedData subdataWithRange:NSMakeRange(middle, length - middle)];
    
    [iv2 setImage:[UIImage imageWithData:imageData]];
    
//    for(NSUInteger u = 0; u < 2 ; u++ ){
//        if(u == 0){
//            [self storeFileName:@"file1.jpg" withFileKey:encryptedData completion:^(BOOL success) {
//                if(success){
//                    NSLog(@"First Part Successful");
//                    dispatch_semaphore_signal(sema);
//                } else {
//                    NSLog(@"First Not Part Successful");
//                }
//            }];
//        } else {
//            [self storeFileName:@"file1.jpg_last" withFileKey:lastPart completion:^(BOOL success) {
//                if(success){
//                    NSLog(@"Last Part Successful");
//                    dispatch_semaphore_signal(sema);
//                } else {
//                    NSLog(@"Last Not Part Successful");
//                }
//            }];
//        }
//    }
    
    NSString *base64String = [key base64EncodedStringWithOptions:0];
    NSString *encryptedKey = [RSA encryptString:base64String publicKey:pubKey3];
    
    [self storeFileName:@"file1.jpg" withFileKey:encryptedKey completion:^(BOOL success) {
        if(success){
            NSLog(@"First Part Successful");
            dispatch_semaphore_signal(sema);
        } else {
            NSLog(@"First Not Part Successful");
        }
    }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    __block NSData *getFirstPart;
    __block NSData *getLastPart;
    
    dispatch_group_t group = dispatch_group_create();
    
//    dispatch_group_enter(group);
//    [self getFileKey:@"file1.jpg" completion:^(NSString * _Nullable key) {
//        if(key){
//            getFirstPart = [[NSData alloc]initWithBase64EncodedString:key options:0];
//            NSLog(@"First Get Successful");
//            dispatch_group_leave(group);           // leave if successful
//        } else {
//            NSLog(@"First Get Not Successful");
//        }
//    }];
//
//    dispatch_group_enter(group);
//    [self getFileKey:@"file1.jpg_last" completion:^(NSString * _Nullable key) {
//        if(key){
//            getLastPart = [[NSData alloc]initWithBase64EncodedString:key options:0];
//            NSLog(@"Last Get Successful");
//            dispatch_group_leave(group);           // leave if successful
//        } else {
//            NSLog(@"Last Get Not Successful");
//        }
//    }];
    
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        NSMutableData *finalData = [[NSMutableData alloc]init];
//
//        [finalData appendData:getFirstPart];
//        [finalData appendData:getLastPart];
//
//        NSData *unencryptedData = [Encryptor decryptCipherDataAES:finalData usingKeyData:key];
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [iv1 setImage:[UIImage imageWithData:unencryptedData]];
//            [self.view setNeedsDisplay];
//            [self.view setNeedsLayout];
//            [self.view setNeedsUpdateConstraints];
//        });
//    });
    
    [self getFileKey:@"file1.jpg" completion:^(NSString * _Nullable key) {
        if(key){
            NSString *unencryptedKey = [RSA decryptString:key privateKey:privKey3];
            NSData *newKey = [[NSData alloc]initWithBase64EncodedString:unencryptedKey options:0];
            NSLog(@"First Get Successful");
            NSData *unencryptedData = [Encryptor decryptCipherDataAES:encryptedData usingKeyData:newKey];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [iv1 setImage:[UIImage imageWithData:unencryptedData]];
                [self.view setNeedsDisplay];
                [self.view setNeedsLayout];
                [self.view setNeedsUpdateConstraints];
            });
        } else {
            NSLog(@"First Get Not Successful");
        }
    }];
    
    
    
//    [self storeFileName:fileName withFileKey:key completion:^(BOOL success) {
//        if(success){
//            [self getFileKey:fileName completion:^(NSString * _Nullable key) {
//                NSData *newKey = [[NSData alloc] initWithBase64EncodedString:key options:0];
//                NSData *unencryptedData = [Encryptor decryptCipherDataAES:encryptedData usingKeyData:newKey];
//
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [iv1 setImage:[UIImage imageWithData:unencryptedData]];
//                    [self.view setNeedsDisplay];
//                    [self.view setNeedsLayout];
//                    [self.view setNeedsUpdateConstraints];
//                });
//                NSLog(@"Finish");
//            }];
//        } else {
//            NSLog(@"Fail Success");
//        }
//    }];
}

-(void) customAES{
    
    NSString *privKey3 = @"-----BEGIN PRIVATE KEY-----MIIEogIBAAKCAQEAh9FqJEc21S1hEMoOHevlNxsKCcAlkDWS+OLgKi3/0xHaq5scuZdDx5wViCEI644MvrBzxZ1fGcLNtDy1iafHpDZ3pDyu5KxZpY6j7ne6TGY9/AKpFsCYTi+9ZFi6eP4v85SoWkzhpi5ikiMoaxnJPFs5VDVe3TR9WJxdyRAEfPaw+UyaR4UxyXS6rec+Z2FVsuNAgKEXRH7U+2zl7vAnTSf9hlFH/SHXBdDrK9zn/46Wcxi9kJHuT9Yj6o5n9dTPcuKbKsm6OAqtvP3+tmxge8lIpcEoYY8W4xzwUaKfvavRlB/JF5Ed8VWwy7xDWLPWxg3gij+mhVf3+8qwEcjTVwIDAQABAoIBACKwS1ZBtBEFepWhrbJZthz5dHpiD5YCAOw9cfiD8COWG04aG1+RcVfRlzRCD7et+7ZWdfNCivAW75f5q3ohlp1r5enWL+sq0+izgk4dWUE7Gdi8SziK7zuE+O/gs5vEfDXPwaHyoe1iSn29qgyUtO+L8xv9V6HSzrLrmQ6J30OVFQU7GbJrr+Lc0k38GO245dUciisnxUUoS+513GpfYD70QpnU7lBl3nUsZCiSNxPIWIQhL3X3+yT8Nx4oEyL6qTgmLpbGQuiQ808uowfX54A5MTxVQvju1xJKWYcY5K5461R7Km5PQ6MQtGAiMbk58IjiciDG4FCiYT7Svv7ePvUCgYEAuuLab3yjfiNPmvVDaQnbluwm5nmi9kwtAvj+uv44HCRneWb1ynBu3hy/KpXYJrJLitR5ggQE/kdAWkF5JyRc0uS9tb/lDant0OQgT3He1V/AwnYRI5ay067AcrW5vDIDYmdZAojtboE5SXO0+pzwxbaX4Te0tt57riaRapN3MJsCgYEAugvE0zvKv4/1MJAgoHk3DHZj5tZCT5pOTSVXnlaWndb1jCh61VsFaNzKXqajNQg7tRIerUQMwZX/EB9Npz3sEMrPQs3Lc4ils2P3aebazcg4AVlhGLmsN1GscXlWsjOEQGJaCTl2stX40qo3wNTZdAQLUDOoAEqmRYRRck+dXfUCgYBx+Gyb9tfB0gj3CEG+6fsXlBa5EU73g0cj+/Nk2Cohx3WvDMIyXdTO8ZsHfnBeUPdOx/r99jORWqR9JlabL0rIdiTXlRo79fiJHsYxjNEHMSjdrqEPIhUWkQjeK8MEaT+1IC+hIx4g+P+VstGY0GLpQExpVc6Igy/L6ctewmW6pwKBgB4xgsP1VDY6msRC38irY2+2VwhDhYd9t291u/6Kdu8uz7LrbuPpXbti+cTarmoQ5/++7ROZk6hnO3nWWrflqMYg4/ong/lAGARBGQoq2R/EerJdWxC0MWrY6m+QDa3mBnScgZg1pznm1/b4gQvef1wAvAVMHNvPQaTOkJlIqnVxAoGAS0w5PT8k/UOONyCHKp5lCzV1wW62vy9IT46Lh0q9FTWAfoIBKHm9fAKrk6vomgBrEzqV4W6ZBwFT4s/lLWmDbsGLnzA22Bu+3StAl9UJQP1B0zPdhsULRUvn+zeSS2bAw+WOwMW39NymnO5ojbnR96L/v8+GjblUmHgt63fxVEQ=-----END PRIVATE KEY-----";
    
    NSString *pubKey3 = @"-----BEGIN PUBLIC KEY-----\nMIIBCgKCAQEAh9FqJEc21S1hEMoOHevlNxsKCcAlkDWS+OLgKi3/0xHaq5scuZdDx5wViCEI644MvrBzxZ1fGcLNtDy1iafHpDZ3pDyu5KxZpY6j7ne6TGY9/AKpFsCYTi+9ZFi6eP4v85SoWkzhpi5ikiMoaxnJPFs5VDVe3TR9WJxdyRAEfPaw+UyaR4UxyXS6rec+Z2FVsuNAgKEXRH7U+2zl7vAnTSf9hlFH/SHXBdDrK9zn/46Wcxi9kJHuT9Yj6o5n9dTPcuKbKsm6OAqtvP3+tmxge8lIpcEoYY8W4xzwUaKfvavRlB/JF5Ed8VWwy7xDWLPWxg3gij+mhVf3+8qwEcjTVwIDAQAB\n-----END PUBLIC KEY-----";
    
    NSData *keys = [Encryptor generateRandomKeysWithIV:16 withHexKey:32];
    
    NSData *encryptedKeys = [RSA encryptData:keys publicKey:pubKey3];
    NSData *unencryptedKeys = [RSA decryptData:encryptedKeys privateKey:privKey3];
    
    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"a.png"], 0.1);
    NSData *encryptedData = [Encryptor encryptDataAES:imageData usingKeyData:keys];
    
    NSData *unencryptedData = [Encryptor decryptCipherDataAES:encryptedData usingKeyData:unencryptedKeys];
    
    [iv1 setImage:[UIImage imageWithData:unencryptedData]];
    [iv2 setImage:[UIImage imageWithData:imageData]];
    
    NSLog(@"Length %lu", imageData.length);
    NSLog(@"Length %lu", unencryptedData.length);
    
    [self.view setNeedsDisplay];
    [self.view setNeedsLayout];
    [self.view setNeedsUpdateConstraints];
    
    if(unencryptedData == imageData){
        NSLog(@"Same");
    } else {
        NSLog(@"Nil");
    }
}

-(void)testProtobuf{
    __block dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    __block NSString *pubKeyBlack;
    NSString *privKeyBlack = @"-----BEGIN PRIVATE KEY-----MIIEpAIBAAKCAQEAtrZanMlQg6K3AAU3foCcwK29qhD/26UduHdN4LeUrDsW4MtBXTKC3QDO7k29zPjv35FA/pG+DtUK6v/VY+znld59IjwG+0Q3+51NVz+LLtKdAo/eGPrWYRto11gjfWOrsvf24C6IZPz5g06MYyYXFtBww8wwVxpQGxnCt/zNFSXZwMwCKjZnofDTHG4JoG+ztO5hOmOrBQ9saKXVDMHq8nD8Kb+Vro44uW21ceQXbZM6LUwHD4z/XZy2Fdn1QYRIT5OfztKCQ081R8GAeBRlJy87ozgyzK2AK4fh6+6d21RBmn/ibu4ty8EyZLJ4qOpwZUAf4f6MlBKRkXoMRf58FQIDAQABAoIBACNgbu59DyURsAeluu84NUGcUkUXugZ786N4HCDWwsdPQJiBWlRSd6KVabub21RQ3dcGj5RKwUcrakwCgX1xzQxIUie7AioL9R/3ftZWFBuahXKNyxXAmZofPb82TlbUodXK66bP87JEBgatwoJfCWjuLmtGwZRX4KtCo2BO5yGBCGFBDUNg5dRWlcyPPXBwzsIt3C1PNohB/gR8OkQ3Wld0EUwJOiO05oei4W31dKvkEtA/xaTQ+vnbnoSudbwzTACnN3NotGLX2tGYfbfQoXN/Ci5h2buZd6s7Cxp5RmvED8AGijNnqSboStcDiEpeuJao4fYzyWylMjSM66GVQiECgYEA96kKKqimpOhQOftb2vYrYmvLb1ykWeRQgalxhqWiPithqWB1srpM0ZgEgpOe0eK0xKzTvQljHGVHeN3T1k3rdKqHD2z4VSCCIb4i0PkrM301EPV2lCXzwsVznUzQ7od4QfxCpbgNDPCJh/6hxRZk+9jbnotmK9IeddvF2KD1TXUCgYEAvN1ty1UId0MwdIJq4oHu1XrQX4v7aPb5ToKyJSB3CNz7OXcSX2mMrzqFHSnlsSqujOXXG1Aqm2ORo6OVwqjo/cUsMhLgNSTvSgKHooMlRLnzWq49aJMKjb9bfh0X6DBRM8hgxSQRIKSi5LjiZlYFyqAk4d8umvFCrQ//ZhNxgCECgYEAtKnbgMMGzcWqwKFcoJ5zh5ibDuHGAs1K7UtuRYsOj8uVsrlrIrZE06DRqW+GrBV1SQPKclwmsNAxEzq/DdZJrRG49MfJYFAWngbV3xvlJ+pui7CEkA4fhDYF4PnocBji4T/kXn+lBYtyyII4AE4V3KKVk1KdddoR3mg0K5M/XwECgYARg0LUEO15CZzroNBCcqPv3bSGt5c3c3dIpWvZb3o6MyuEd5sXh9UIxpdjTehDll6bKBDbMoLQ59mwX9HaPAlmxqrDdeaeZu9dYICtPBXvmoKLTQ7arI/U9wKH3jDCUgClmZYHkcGY0ktchBxSOvXMhS8GVsiei3KQU6RuFa13oQKBgQDtFF/NIAdaiOpzLBbcVE23WOoBM0L7W0xqdrHFC/Ph2dH3RYi/nrR+QE6zkQh7GzKEOamUrYYqZvFjqvFlgI3eIDo1rnHBR+bwF42xroYyXGgA2nWFyiyXgpM3vFK0/Cyy/SaIG8+xy4XvgA3Pxi5BgWfJT1ukad6y+vy4VrCZ4w==-----END PRIVATE KEY-----";
    
    [self getPublicKeyFromPerson:@"+60173312939" completion:^(NSString * _Nullable key) {
        NSLog(@"Key %@", key);
        pubKeyBlack = key;
        dispatch_semaphore_signal(sema);
    }];
    
    NSString *privKey3 = @"-----BEGIN PRIVATE KEY-----MIIEogIBAAKCAQEAh9FqJEc21S1hEMoOHevlNxsKCcAlkDWS+OLgKi3/0xHaq5scuZdDx5wViCEI644MvrBzxZ1fGcLNtDy1iafHpDZ3pDyu5KxZpY6j7ne6TGY9/AKpFsCYTi+9ZFi6eP4v85SoWkzhpi5ikiMoaxnJPFs5VDVe3TR9WJxdyRAEfPaw+UyaR4UxyXS6rec+Z2FVsuNAgKEXRH7U+2zl7vAnTSf9hlFH/SHXBdDrK9zn/46Wcxi9kJHuT9Yj6o5n9dTPcuKbKsm6OAqtvP3+tmxge8lIpcEoYY8W4xzwUaKfvavRlB/JF5Ed8VWwy7xDWLPWxg3gij+mhVf3+8qwEcjTVwIDAQABAoIBACKwS1ZBtBEFepWhrbJZthz5dHpiD5YCAOw9cfiD8COWG04aG1+RcVfRlzRCD7et+7ZWdfNCivAW75f5q3ohlp1r5enWL+sq0+izgk4dWUE7Gdi8SziK7zuE+O/gs5vEfDXPwaHyoe1iSn29qgyUtO+L8xv9V6HSzrLrmQ6J30OVFQU7GbJrr+Lc0k38GO245dUciisnxUUoS+513GpfYD70QpnU7lBl3nUsZCiSNxPIWIQhL3X3+yT8Nx4oEyL6qTgmLpbGQuiQ808uowfX54A5MTxVQvju1xJKWYcY5K5461R7Km5PQ6MQtGAiMbk58IjiciDG4FCiYT7Svv7ePvUCgYEAuuLab3yjfiNPmvVDaQnbluwm5nmi9kwtAvj+uv44HCRneWb1ynBu3hy/KpXYJrJLitR5ggQE/kdAWkF5JyRc0uS9tb/lDant0OQgT3He1V/AwnYRI5ay067AcrW5vDIDYmdZAojtboE5SXO0+pzwxbaX4Te0tt57riaRapN3MJsCgYEAugvE0zvKv4/1MJAgoHk3DHZj5tZCT5pOTSVXnlaWndb1jCh61VsFaNzKXqajNQg7tRIerUQMwZX/EB9Npz3sEMrPQs3Lc4ils2P3aebazcg4AVlhGLmsN1GscXlWsjOEQGJaCTl2stX40qo3wNTZdAQLUDOoAEqmRYRRck+dXfUCgYBx+Gyb9tfB0gj3CEG+6fsXlBa5EU73g0cj+/Nk2Cohx3WvDMIyXdTO8ZsHfnBeUPdOx/r99jORWqR9JlabL0rIdiTXlRo79fiJHsYxjNEHMSjdrqEPIhUWkQjeK8MEaT+1IC+hIx4g+P+VstGY0GLpQExpVc6Igy/L6ctewmW6pwKBgB4xgsP1VDY6msRC38irY2+2VwhDhYd9t291u/6Kdu8uz7LrbuPpXbti+cTarmoQ5/++7ROZk6hnO3nWWrflqMYg4/ong/lAGARBGQoq2R/EerJdWxC0MWrY6m+QDa3mBnScgZg1pznm1/b4gQvef1wAvAVMHNvPQaTOkJlIqnVxAoGAS0w5PT8k/UOONyCHKp5lCzV1wW62vy9IT46Lh0q9FTWAfoIBKHm9fAKrk6vomgBrEzqV4W6ZBwFT4s/lLWmDbsGLnzA22Bu+3StAl9UJQP1B0zPdhsULRUvn+zeSS2bAw+WOwMW39NymnO5ojbnR96L/v8+GjblUmHgt63fxVEQ=-----END PRIVATE KEY-----";
    
    NSString *pubKey3 = @"-----BEGIN PUBLIC KEY-----\nMIIBCgKCAQEAh9FqJEc21S1hEMoOHevlNxsKCcAlkDWS+OLgKi3/0xHaq5scuZdDx5wViCEI644MvrBzxZ1fGcLNtDy1iafHpDZ3pDyu5KxZpY6j7ne6TGY9/AKpFsCYTi+9ZFi6eP4v85SoWkzhpi5ikiMoaxnJPFs5VDVe3TR9WJxdyRAEfPaw+UyaR4UxyXS6rec+Z2FVsuNAgKEXRH7U+2zl7vAnTSf9hlFH/SHXBdDrK9zn/46Wcxi9kJHuT9Yj6o5n9dTPcuKbKsm6OAqtvP3+tmxge8lIpcEoYY8W4xzwUaKfvavRlB/JF5Ed8VWwy7xDWLPWxg3gij+mhVf3+8qwEcjTVwIDAQAB\n-----END PUBLIC KEY-----";
    

    NSError *error;
    NSData *testData = [self createDataMessage];
    NSData *encryptedData = [RSA encryptData:testData publicKey:pubKey3];
    NSData *testData64 = [encryptedData base64EncodedDataWithOptions:0];
    testData = nil;
    
    DataMessage *dataReader1 = [DataMessage parseFromData:testData error:&error];
    
    NSString *body = dataReader1.body;
    NSString *sender = dataReader1.sender;
    NSString *recipient = dataReader1.recipient;
    BOOL hasMedia = dataReader1.attachment;
    
    NSLog(@"Body %@", body);
    NSLog(@"sender %@", sender);
    NSLog(@"recipient %@", recipient);
    NSLog(@"media %d", hasMedia);
    
//    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    testData = [[NSData alloc]initWithBase64EncodedData:testData64 options:0];
    
    NSLog(@"encrypted length %lu", encryptedData.length);
    NSLog(@"testData length %lu", testData.length);
    
    NSData *unencryptedData = [RSA decryptData:testData privateKey:privKey3];
    
    NSLog(@"encrypted length %lu", encryptedData.length);
    NSLog(@"testData length %lu", testData.length);
    
    DataMessage *dataReader2 = [DataMessage parseFromData:unencryptedData error:&error];
    
    body = dataReader2.body;
    sender = dataReader2.sender;
    recipient = dataReader2.recipient;
    hasMedia = dataReader2.attachment;
    
    NSLog(@"Body2 %@", body);
    NSLog(@"sender2 %@", sender);
    NSLog(@"recipient2 %@", recipient);
    NSLog(@"media2 %d", hasMedia);
    
}

-(void) testRSA{
    
    NSString *pubkey = @"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDI2bvVLVYrb4B0raZgFP60VXY\ncvRmk9q56QiTmEm9HXlSPq1zyhyPQHGti5FokYJMzNcKm0bwL1q6ioJuD4EFI56D\na+70XdRz1CjQPQE3yXrXXVvOsmq9LsdxTFWsVBTehdCmrapKZVVx6PKl7myh0cfX\nQmyveT/eqyZK1gYjvQIDAQAB\n-----END PUBLIC KEY-----";
    
    NSString *privkey = @"-----BEGIN PRIVATE KEY-----\nMIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMMjZu9UtVitvgHS\ntpmAU/rRVdhy9GaT2rnpCJOYSb0deVI+rXPKHI9Aca2LkWiRgkzM1wqbRvAvWrqK\ngm4PgQUjnoNr7vRd1HPUKNA9ATfJetddW86yar0ux3FMVaxUFN6F0KatqkplVXHo\n8qXubKHRx9dCbK95P96rJkrWBiO9AgMBAAECgYBO1UKEdYg9pxMX0XSLVtiWf3Na\n2jX6Ksk2Sfp5BhDkIcAdhcy09nXLOZGzNqsrv30QYcCOPGTQK5FPwx0mMYVBRAdo\nOLYp7NzxW/File//169O3ZFpkZ7MF0I2oQcNGTpMCUpaY6xMmxqN22INgi8SHp3w\nVU+2bRMLDXEc/MOmAQJBAP+Sv6JdkrY+7WGuQN5O5PjsB15lOGcr4vcfz4vAQ/uy\nEGYZh6IO2Eu0lW6sw2x6uRg0c6hMiFEJcO89qlH/B10CQQDDdtGrzXWVG457vA27\nkpduDpM6BQWTX6wYV9zRlcYYMFHwAQkE0BTvIYde2il6DKGyzokgI6zQyhgtRJ1x\nL6fhAkB9NvvW4/uWeLw7CHHVuVersZBmqjb5LWJU62v3L2rfbT1lmIqAVr+YT9CK\n2fAhPPtkpYYo5d4/vd1sCY1iAQ4tAkEAm2yPrJzjMn2G/ry57rzRzKGqUChOFrGs\nlm7HF6CQtAs4HC+2jC0peDyg97th37rLmPLB9txnPl50ewpkZuwOAQJBAM/eJnFw\nF5QAcL4CYDbfBKocx82VX/pFXng50T7FODiWbbL4UnxICE0UBFInNNiWJxNEb6jL\n5xd0pcy9O2DOeso=\n-----END PRIVATE KEY-----";
    
    NSString *privKey3 = @"-----BEGIN RSA PRIVATE KEY-----MIICWwIBAAKBgQCnc4X+GdZy+bCo22csH1WWS5tJS7/YUHoZTZTo7mwfT8PdLVBJ1enmD6lBd1El9CuN0WGGPiyQQJt8TooJBbUBC5peYst5bLGtwBgZSqgD3Hcp0U9Qbg/YmS2gBkw1XlfMdyMALkfqIb0tm62Byv8p+AOpdeTWXoMgE17pc0g4AwIDAQABAoGAa6ugkM7UUYGz0h+hq4FKayWaZ/rJFLJKkFKOWWhVJZ0IeANXCOL/TurrDilGiH0ENGBZsRPxW5/vWnK11y9QPp2DV1ctbl/gVMQX6e5jpMA+XGJRLEODbV2ErSLWvalr75OAYUvECNH+t5ww9IVnrKKJRXNNxc1FMv6ZB7BvGiECQQDTIKndoKuzyDA2hn+EtF8peufcVzAcJ4nH20oyqk3foZQ1nH4c0kPEqiXJTEajPJ4VORJ3i2mnXpYR9GROnLwVAkEAywp0bQhcc8lcqC68dae2EwYxSHRU+UmTQ8+DMpjvPuPyOhcD2nXwGgJgFfqVcImAhj7de/Xiph1SBQlhGPbxtwJAYbbwZ38BeQfiKJo/UrAYix4zSaugvKcgAbvgr2pa+HHUIqv3QmeerdsB+hSvbMWVdMUhYurHT4tbcZvnAOtRsQJAVa2guY3IrZdwAQxPvHo768U2MLPeU5+HhBrh6wz8EBbSVU728k3INsF/2GZ4fxeW449NmQyGSsCepr9xeL5j+wJABtMmXTXrHZ+7pBVquSBWJCvmhDkPhrMrB3WRR0im2lNNtnL99S7kmKBPioP6go2gi8a/VwRm9K/D+Td2ugwQdQ==-----END RSA PRIVATE KEY-----";
    
    NSString *pubKey3 = @"-----BEGIN PUBLIC KEY-----MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnc4X+GdZy+bCo22csH1WWS5tJS7/YUHoZTZTo7mwfT8PdLVBJ1enmD6lBd1El9CuN0WGGPiyQQJt8TooJBbUBC5peYst5bLGtwBgZSqgD3Hcp0U9Qbg/YmS2gBkw1XlfMdyMALkfqIb0tm62Byv8p+AOpdeTWXoMgE17pc0g4AwIDAQAB-----END PUBLIC KEY-----";
    
    __block NSString *privKey2;
    __block NSString *pubKey2;
    
    NSString *privKeyMal = @"-----BEGIN PRIVATE KEY-----MIIEogIBAAKCAQEAh9FqJEc21S1hEMoOHevlNxsKCcAlkDWS+OLgKi3/0xHaq5scuZdDx5wViCEI644MvrBzxZ1fGcLNtDy1iafHpDZ3pDyu5KxZpY6j7ne6TGY9/AKpFsCYTi+9ZFi6eP4v85SoWkzhpi5ikiMoaxnJPFs5VDVe3TR9WJxdyRAEfPaw+UyaR4UxyXS6rec+Z2FVsuNAgKEXRH7U+2zl7vAnTSf9hlFH/SHXBdDrK9zn/46Wcxi9kJHuT9Yj6o5n9dTPcuKbKsm6OAqtvP3+tmxge8lIpcEoYY8W4xzwUaKfvavRlB/JF5Ed8VWwy7xDWLPWxg3gij+mhVf3+8qwEcjTVwIDAQABAoIBACKwS1ZBtBEFepWhrbJZthz5dHpiD5YCAOw9cfiD8COWG04aG1+RcVfRlzRCD7et+7ZWdfNCivAW75f5q3ohlp1r5enWL+sq0+izgk4dWUE7Gdi8SziK7zuE+O/gs5vEfDXPwaHyoe1iSn29qgyUtO+L8xv9V6HSzrLrmQ6J30OVFQU7GbJrr+Lc0k38GO245dUciisnxUUoS+513GpfYD70QpnU7lBl3nUsZCiSNxPIWIQhL3X3+yT8Nx4oEyL6qTgmLpbGQuiQ808uowfX54A5MTxVQvju1xJKWYcY5K5461R7Km5PQ6MQtGAiMbk58IjiciDG4FCiYT7Svv7ePvUCgYEAuuLab3yjfiNPmvVDaQnbluwm5nmi9kwtAvj+uv44HCRneWb1ynBu3hy/KpXYJrJLitR5ggQE/kdAWkF5JyRc0uS9tb/lDant0OQgT3He1V/AwnYRI5ay067AcrW5vDIDYmdZAojtboE5SXO0+pzwxbaX4Te0tt57riaRapN3MJsCgYEAugvE0zvKv4/1MJAgoHk3DHZj5tZCT5pOTSVXnlaWndb1jCh61VsFaNzKXqajNQg7tRIerUQMwZX/EB9Npz3sEMrPQs3Lc4ils2P3aebazcg4AVlhGLmsN1GscXlWsjOEQGJaCTl2stX40qo3wNTZdAQLUDOoAEqmRYRRck+dXfUCgYBx+Gyb9tfB0gj3CEG+6fsXlBa5EU73g0cj+/Nk2Cohx3WvDMIyXdTO8ZsHfnBeUPdOx/r99jORWqR9JlabL0rIdiTXlRo79fiJHsYxjNEHMSjdrqEPIhUWkQjeK8MEaT+1IC+hIx4g+P+VstGY0GLpQExpVc6Igy/L6ctewmW6pwKBgB4xgsP1VDY6msRC38irY2+2VwhDhYd9t291u/6Kdu8uz7LrbuPpXbti+cTarmoQ5/++7ROZk6hnO3nWWrflqMYg4/ong/lAGARBGQoq2R/EerJdWxC0MWrY6m+QDa3mBnScgZg1pznm1/b4gQvef1wAvAVMHNvPQaTOkJlIqnVxAoGAS0w5PT8k/UOONyCHKp5lCzV1wW62vy9IT46Lh0q9FTWAfoIBKHm9fAKrk6vomgBrEzqV4W6ZBwFT4s/lLWmDbsGLnzA22Bu+3StAl9UJQP1B0zPdhsULRUvn+zeSS2bAw+WOwMW39NymnO5ojbnR96L/v8+GjblUmHgt63fxVEQ=-----END PRIVATE KEY-----";
    
    NSString *privKeyBlack = @"-----BEGIN PRIVATE KEY-----MIIEpAIBAAKCAQEAtrZanMlQg6K3AAU3foCcwK29qhD/26UduHdN4LeUrDsW4MtBXTKC3QDO7k29zPjv35FA/pG+DtUK6v/VY+znld59IjwG+0Q3+51NVz+LLtKdAo/eGPrWYRto11gjfWOrsvf24C6IZPz5g06MYyYXFtBww8wwVxpQGxnCt/zNFSXZwMwCKjZnofDTHG4JoG+ztO5hOmOrBQ9saKXVDMHq8nD8Kb+Vro44uW21ceQXbZM6LUwHD4z/XZy2Fdn1QYRIT5OfztKCQ081R8GAeBRlJy87ozgyzK2AK4fh6+6d21RBmn/ibu4ty8EyZLJ4qOpwZUAf4f6MlBKRkXoMRf58FQIDAQABAoIBACNgbu59DyURsAeluu84NUGcUkUXugZ786N4HCDWwsdPQJiBWlRSd6KVabub21RQ3dcGj5RKwUcrakwCgX1xzQxIUie7AioL9R/3ftZWFBuahXKNyxXAmZofPb82TlbUodXK66bP87JEBgatwoJfCWjuLmtGwZRX4KtCo2BO5yGBCGFBDUNg5dRWlcyPPXBwzsIt3C1PNohB/gR8OkQ3Wld0EUwJOiO05oei4W31dKvkEtA/xaTQ+vnbnoSudbwzTACnN3NotGLX2tGYfbfQoXN/Ci5h2buZd6s7Cxp5RmvED8AGijNnqSboStcDiEpeuJao4fYzyWylMjSM66GVQiECgYEA96kKKqimpOhQOftb2vYrYmvLb1ykWeRQgalxhqWiPithqWB1srpM0ZgEgpOe0eK0xKzTvQljHGVHeN3T1k3rdKqHD2z4VSCCIb4i0PkrM301EPV2lCXzwsVznUzQ7od4QfxCpbgNDPCJh/6hxRZk+9jbnotmK9IeddvF2KD1TXUCgYEAvN1ty1UId0MwdIJq4oHu1XrQX4v7aPb5ToKyJSB3CNz7OXcSX2mMrzqFHSnlsSqujOXXG1Aqm2ORo6OVwqjo/cUsMhLgNSTvSgKHooMlRLnzWq49aJMKjb9bfh0X6DBRM8hgxSQRIKSi5LjiZlYFyqAk4d8umvFCrQ//ZhNxgCECgYEAtKnbgMMGzcWqwKFcoJ5zh5ibDuHGAs1K7UtuRYsOj8uVsrlrIrZE06DRqW+GrBV1SQPKclwmsNAxEzq/DdZJrRG49MfJYFAWngbV3xvlJ+pui7CEkA4fhDYF4PnocBji4T/kXn+lBYtyyII4AE4V3KKVk1KdddoR3mg0K5M/XwECgYARg0LUEO15CZzroNBCcqPv3bSGt5c3c3dIpWvZb3o6MyuEd5sXh9UIxpdjTehDll6bKBDbMoLQ59mwX9HaPAlmxqrDdeaeZu9dYICtPBXvmoKLTQ7arI/U9wKH3jDCUgClmZYHkcGY0ktchBxSOvXMhS8GVsiei3KQU6RuFa13oQKBgQDtFF/NIAdaiOpzLBbcVE23WOoBM0L7W0xqdrHFC/Ph2dH3RYi/nrR+QE6zkQh7GzKEOamUrYYqZvFjqvFlgI3eIDo1rnHBR+bwF42xroYyXGgA2nWFyiyXgpM3vFK0/Cyy/SaIG8+xy4XvgA3Pxi5BgWfJT1ukad6y+vy4VrCZ4w==-----END PRIVATE KEY-----";
    
    __block NSString *pubKeyMal;
    __block NSString *pubKeyBlack;
    
    NSString *originString = @"This is a secret message!";
    
    NSData *testData = [originString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
//    dispatch_group_t group = dispatch_group_create();
    
//    dispatch_group_enter(group);
    
    [self getPublicKeyFromPerson:@"+60104288252" completion:^(NSString * _Nullable key) {
        NSLog(@"Key %@", key);
        pubKeyMal = key;
//        dispatch_group_leave(group);           // leave if successful
    }];
    
//    dispatch_group_enter(group);
    
    [self getPublicKeyFromPerson:@"+60173312939" completion:^(NSString * _Nullable key) {
        NSLog(@"Key %@", key);
        pubKeyBlack = key;
//        dispatch_group_leave(group);           // leave if successful
    }];
    
    [Encryptor createPubPrivKeys:^(NSString *private, NSString *public) {
        privKey2 = private;
        pubKey2 = public;
    }];
    
    __block NSData *a;    //encrypt with pub key
    __block NSData *b;    //decrypt with priv key
    NSString *c;    //encrypt with priv key
    NSString *d;    //decrypt with pub key
    NSString *e;    //decrypt server with priv key
    NSString *f;    //decrypt server with pub key
    NSString *server;
    
    Byte sharedBytes []      =
    {
        (Byte) 0x32, (Byte) 0x5f, (Byte) 0x23, (Byte) 0x93, (Byte) 0x28,
        (Byte) 0x94, (Byte) 0x1c, (Byte) 0xed, (Byte) 0x6e, (Byte) 0x67,
        (Byte) 0x3b, (Byte) 0x86, (Byte) 0xba, (Byte) 0x41, (Byte) 0x01,
        (Byte) 0x74, (Byte) 0x48, (Byte) 0xe9, (Byte) 0x9b, (Byte) 0x64,
        (Byte) 0x9a, (Byte) 0x9c, (Byte) 0x38, (Byte) 0x06, (Byte) 0xc1,
        (Byte) 0xdd, (Byte) 0x7c, (Byte) 0xa4, (Byte) 0xc4, (Byte) 0x77,
        (Byte) 0xe6, (Byte) 0x29, (Byte) 0x29, (Byte) 0xe6, (Byte) 0x29,
        (Byte) 0x3b, (Byte) 0x86, (Byte) 0xba, (Byte) 0x41, (Byte) 0x01,
        (Byte) 0x3b, (Byte) 0x86, (Byte) 0xba, (Byte) 0x41, (Byte) 0x01,
        (Byte) 0x3b, (Byte) 0x86, (Byte) 0xba, (Byte) 0x41, (Byte) 0x01,
        (Byte) 0x3b, (Byte) 0x86, (Byte) 0xba, (Byte) 0x41, (Byte) 0x01,
        (Byte) 0x3b, (Byte) 0x86, (Byte) 0xba, (Byte) 0x41, (Byte) 0x01,
        (Byte) 0x3b, (Byte) 0x86, (Byte) 0xba, (Byte) 0x41
    };
    
    NSData *base64data = [NSData dataWithBytes:sharedBytes length:64];
    
    if(base64data){
        NSLog(@"intiial data %@", base64data);
        NSLog(@"Initial data %lu", (unsigned long)base64data.length);
    }
    
    NSLog(@"Text Input %@", originString);
    
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        a = [RSA encryptString:originString privateKey:privKeyMal];
//        NSLog(@"privkey 2 a: %@", a);
//        a = [RSA encryptString:a publicKey:pubKeyBlack];
//        NSLog(@"privkey 3 a: %@", a);
//        b = [RSA decryptString:a privateKey:privKeyBlack];
//        NSLog(@"pubkey 3 b: %@", b);
//        b = [RSA decryptString:b publicKey:pubKeyMal];
//        NSLog(@"pubkey 2 b: %@", b);
        
//        a = [RSA encryptData:base64data privateKey:privKeyMal];
//        NSLog(@"privkey 2 a: %@", a);
//        a = [RSA encryptData:a publicKey:pubKeyBlack];
//        NSLog(@"privkey 3 a: %@", a);
//        b = [RSA decryptData:a privateKey:privKeyBlack];
//        NSLog(@"pubkey 3 b: %@", b);
//        b = [RSA decryptData:b publicKey:pubKeyMal];
//        NSLog(@"pubkey 2 b: %@", b);
    
//        if(b){
//            NSString *string = [[NSString alloc]initWithData:b encoding:NSUTF8StringEncoding];
//            NSLog(@"Final String %@", string);
//        } else {
//            NSLog(@"length %lu", (unsigned long)b.length);
//        }

//        if(b){
//            NSLog(@"initial data \n%@", base64data);
//            NSLog(@"last data \n%@", b);
//            NSLog(@"length %lu", (unsigned long)b.length);
//        } else {
//            NSLog(@"length %lu", (unsigned long)b.length);
//        }
//    });
    
//    a = [RSA encryptString:originString publicKey:pubkey];
//    NSLog(@"a: %@", a);
//    a = [RSA encryptString:originString privateKey:privKey2];
//    NSLog(@"privkey 2 a: %@", a);
//    a = [RSA encryptString:a publicKey:pubKey3];
//    NSLog(@"privkey 3 a: %@", a);
//    b = [RSA decryptString:a privateKey:privKey3];
//    NSLog(@"pubkey 3 b: %@", b);
//    b = [RSA decryptString:b publicKey:pubKey2];
//    NSLog(@"pubkey 2 b: %@", b);
//    b = nil;
//    a = [RSA encryptString:originString privateKey:privkey];
//    NSLog(@"privkey a: %@", a);
//    b = [RSA decryptString:a publicKey:pubkey];
//    NSLog(@"b: %@", b);
//    b = nil;
//    b = [RSA decryptString:a privateKey:privkey];
//    NSLog(@"b: %@", b);

    NSLog(@"Finish");
    /*
        encrypt string with public key and decrypt with private key
    
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
    
        encrypt with private key and decrypt with public key
    
//    encWithPrivKey = [RSA encryptString:originString privateKey:privkey];
//    NSLog(@"Enctypted with private key: %@", encWithPrivKey);
//    decWithPublicKey = [RSA decryptString:encWithPrivKey publicKey:pubkey];
//    NSLog(@"(PHP enc)Decrypted with public key: %@", decWithPublicKey);
    
    c = [RSA encryptString:originString privateKey:privkey];
    NSLog(@"c: %@", c);
    d = [RSA decryptString:c publicKey:pubkey];
    NSLog(@"d: %@", d);
    
    ////////////////////////////////////////////////////////////////////////
    
        server encrypt with public key and decrypt with public/private key
    
    // by PHP
    server = @"CKiZsP8wfKlELNfWNC2G4iLv0RtwmGeHgzHec6aor4HnuOMcYVkxRovNj2r0Iu3ybPxKwiH2EswgBWsi65FOzQJa01uDVcJImU5vLrx1ihJ/PADUVxAMFjVzA3+Clbr2fwyJXW6dbbbymupYpkxRSfF5Gq9KyT+tsAhiSNfU6akgNGh4DENoA2AoKoWhpMEawyIubBSsTdFXtsHK0Ze0Cyde7oI2oh8ePOVHRuce6xYELYzmZY5yhSUoEb4+/44fbVouOCTl66ppUgnR5KjmIvBVEJLBq0SgoZfrGiA3cB08q4hb5EJRW72yPPQNqJxcQTPs8SxXa9js8ZryeSxyrw==";
    
    e = [RSA decryptString:server privateKey:privkey];
    NSLog(@"e: %@", e);
    
    // decrypt with public key
    f = [RSA decryptString:server publicKey:pubkey];
    NSLog(@"f: %@", f);
    */
}

-(NSData*)createDataMessage{
    DataMessage *builder = [[DataMessage alloc]init];
    
    builder.body = @"This message is sent for testing";
    builder.sender = @"Kamal";
    builder.recipient = @"Anon";
    builder.attachment = YES;
    
    return [builder data];
}

-(void) getPublicKeyFromServer:(void (^)(NSString * _Nullable key))completion{
    NSString *username = @"mamal";
    NSString *password =  @"mamal1234";
    NSData *basicAuth = [[NSString stringWithFormat:@"%@:%@", username,password]dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Auth = [basicAuth base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", base64Auth];
    
    NSString *url = [NSString stringWithFormat:@"http://192.168.0.197:8000/keys/get_serverKey/"];
    //    NSString *url = [NSString stringWithFormat:@"http://192.168.1.111:8000/keys/get_key?user_number=%@",person];
    NSLog(@"URL %@", url);
    //    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:[NSString stringWithFormat:@"%@%@",textSecureServerURL,kaiChatGetDeviceId]];
    //    NSString *url = urlComponents.URL.absoluteString;
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(data){
            NSError *errorr;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&errorr];
            NSLog(@"%@", dict);
            NSString *publicKey = [dict objectForKey:@"key"];
            completion(publicKey);
        } else if(error){
            completion(nil);
        }
    }];
    [task resume];
}

-(void) getPublicKeyFromPerson:(NSString*)person
                    completion:(void (^)(NSString * _Nullable key))completion{
    NSString *username = @"mamal";
    NSString *password =  @"mamal1234";
    NSData *basicAuth = [[NSString stringWithFormat:@"%@:%@", username,password]dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Auth = [basicAuth base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", base64Auth];
    
    person = [person stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSString *url = [NSString stringWithFormat:@"http://192.168.0.197:8000/keys/get_key?user_number=%@",person];
    //    NSString *url = [NSString stringWithFormat:@"http://192.168.1.111:8000/keys/get_key?user_number=%@",person];
    NSLog(@"URL %@", url);
    NSLog(@"%@", person);
    //    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:[NSString stringWithFormat:@"%@%@",textSecureServerURL,kaiChatGetDeviceId]];
    //    NSString *url = urlComponents.URL.absoluteString;
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(data){
            NSError *errorr;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&errorr];
            NSLog(@"%@", dict);
            NSString *publicKey = [dict objectForKey:@"user_publicKey"];
            completion(publicKey);
        } else if(error){
            completion(nil);
        }
    }];
    [task resume];
}

-(void) storeFileName:(NSString*)fileName
        withFileKey:(NSString*)fileKey
          completion:(void (^)(BOOL success))completion{
    
    NSString *username = @"mamal";
    NSString *password =  @"mamal1234";
    NSData *basicAuth = [[NSString stringWithFormat:@"%@:%@", username,password]dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Auth = [basicAuth base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", base64Auth];
    
    NSString *url = [NSString stringWithFormat:@"http://192.168.0.197:8000/keys/store_filekey/"];
    NSLog(@"URL %@", url);
    NSLog(@"%@", fileName);
    NSLog(@"%lu", fileKey.length);
    
//    NSString *fileKeys = [fileKey base64EncodedStringWithOptions:0];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                 fileName,@"file_name",
                                 fileKey, @"file_key",
                                 nil];
    
    NSLog(@"Dict %@", dict);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:kNilOptions timeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    [request addValue:authValue forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil]];
    
    NSLog(@"Data %@", fileKey);
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSInteger statusCode = ((NSHTTPURLResponse*)response).statusCode;
        BOOL isValidResponse = (statusCode >= 200) && (statusCode < 400);
        
        if(isValidResponse){
            completion(YES);
        } else {
            completion(NO);
            NSLog(@"%ld", (long)statusCode);
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
//    [session uploadTaskWithRequest:request fromData:fileKey completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSInteger statusCode = ((NSHTTPURLResponse*)response).statusCode;
//        BOOL isValidResponse = (statusCode >= 200) && (statusCode < 400);
//
//        if(isValidResponse){
//            completion(YES);
//        } else {
//            completion(NO);
//            NSLog(@"%ld", (long)statusCode);
//            NSLog(@"%@", error.localizedDescription);
//        }
//        if(data){
//            NSError *errorr;
//            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&errorr];
//            NSLog(@"%@", dictionary);
//            completion(YES);
//        } else if(error){
//            completion(NO);
//        }
//    }];
    [task resume];
    
    /*
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(data){
            NSError *errorr;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&errorr];
            NSLog(@"%@", dict);
            NSData *fileKey = [dict objectForKey:@"file_name"];
            completion(fileKey);
        } else if(error){
            completion(nil);
        }
    }];
    [task resume];
     */
}

-(void) getFileKey:(NSString*)fileName
        completion:(void (^)(NSString * _Nullable key))completion{
    
    NSString *username = @"mamal";
    NSString *password =  @"mamal1234";
    NSData *basicAuth = [[NSString stringWithFormat:@"%@:%@", username,password]dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Auth = [basicAuth base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", base64Auth];
    
    NSString *url = [NSString stringWithFormat:@"http://192.168.0.197:8000/keys/get_filekey?file_name=%@",fileName];
    //    NSString *url = [NSString stringWithFormat:@"http://192.168.1.111:8000/keys/get_key?user_number=%@",person];
    NSLog(@"URL %@", url);
    NSLog(@"%@", fileName);
    //    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:[NSString stringWithFormat:@"%@%@",textSecureServerURL,kaiChatGetDeviceId]];
    //    NSString *url = urlComponents.URL.absoluteString;
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(data){
            NSError *errorr;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&errorr];
            NSLog(@"%@", dict);
            NSString *fileKey = [dict objectForKey:@"file_key"];
            completion(fileKey);
        } else if(error){
            completion(nil);
        }
    }];
    [task resume];
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

//    NSString *input  = @"This is the secret message for advanced AES";
    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"a.png"], 0.1);
    
//    [iv1 setImage:[UIImage imageWithData:imageData]];
    
    NSData *base64ImageData = [imageData base64EncodedDataWithOptions:0];
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    Byte sharedBytes []      =
    {
        (Byte) 0x32, (Byte) 0x5f, (Byte) 0x23, (Byte) 0x93, (Byte) 0x28,
        (Byte) 0x94, (Byte) 0x1c, (Byte) 0xed, (Byte) 0x6e, (Byte) 0x67,
        (Byte) 0x3b, (Byte) 0x86, (Byte) 0xba, (Byte) 0x41, (Byte) 0x01,
        (Byte) 0x74, (Byte) 0x48, (Byte) 0xe9, (Byte) 0x9b, (Byte) 0x64,
        (Byte) 0x9a, (Byte) 0x9c, (Byte) 0x38, (Byte) 0x06, (Byte) 0xc1,
        (Byte) 0xdd, (Byte) 0x7c, (Byte) 0xa4, (Byte) 0xc4, (Byte) 0x77,
        (Byte) 0xe6, (Byte) 0x29
    };
    
    NSData *data = [NSData dataWithBytes:sharedBytes length:32];
    NSData *base64Data = [imageData base64EncodedDataWithOptions:0];
    
    NSData *encrypted64Data = [Encryptor encodeAndPrintData:base64Data usingHexKey:hexKey1 hexIV:ivKey1];
    
    NSData *unencrypted64Data = [Encryptor decodeAndPrintCipher64Data:encrypted64Data usingHexKey:hexKey1 hexIV:ivKey1];
    
    NSData *unencryptedData = [[NSData alloc]initWithBase64EncodedData:unencrypted64Data options:0];
    
//    [iv2 setImage:[UIImage imageWithData:imageData]];
    
    NSLog(@"Length %lu", imageData.length);
    NSLog(@"Length %lu", unencryptedData.length);
    
    [self.view setNeedsDisplay];
    [self.view setNeedsLayout];
    [self.view setNeedsUpdateConstraints];
    
    if(unencryptedData == imageData){
        NSLog(@"Same");
    } else {
        NSLog(@"Nil");
    }
    
//    NSData *encryptedData = [Encryptor encodeAndPrintPlainText:input usingHexKey:hexKey1 hexIV:ivKey1];
//
//    NSString *base64EncodedString = [encryptedData base64EncodedStringWithOptions:0];
//
//    NSData *unencryptedDataKey1 = [Encryptor decodeAndPrintCipherBase64Data:base64EncodedString usingHexKey:hexKey1 hexIV:ivKey1];
//    NSData *unencryptedDataKey2 = [Encryptor decodeAndPrintCipherBase64Data:base64EncodedString usingHexKey:hexKey2 hexIV:ivKey2];
//
//    NSString *unencryptedStringKey1 = [[NSString alloc] initWithData:unencryptedDataKey1 encoding:NSUTF8StringEncoding];
//    NSString *unencryptedStringKey2 = [[NSString alloc] initWithData:unencryptedDataKey2 encoding:NSUTF8StringEncoding];
    
//    NSString *title = @"Advanced AES Testing";
//    
//    NSLog(@"%@",[NSString stringWithFormat:@"\n\n%@\nSecret Message: %@\nHexKey1: %@\nIVKey1: %@\nHexKey2: %@\nIVKey2: %@\nOUTPUT %@ WITH HEXKEY %@ and IVKEY %@\nOUTPUT %@ WITH HEXKEY %@ and IVKEY %@", title,input, hexKey1, ivKey1, hexKey2, ivKey2,unencryptedStringKey1, hexKey1, ivKey1,unencryptedStringKey2, hexKey2, ivKey2]);
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
