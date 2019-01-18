//
//  SelfLearningTests.m
//  SelfLearningTests
//
//  Created by weeclicks on 30/03/2018.
//  Copyright © 2018 Kamal. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "../SelfLearning/Security/Encryptor.h"

@interface SelfLearningTests : XCTestCase

@end

@implementation SelfLearningTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
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
    NSData *base64Data = [data base64EncodedDataWithOptions:0];
    
    NSString *hexKey1 = [self createRandomKeyBytes:32];
    NSString *ivKey1 = [self createRandomKeyBytes:16];
    
    NSData *encrypted64Data = [Encryptor encodeAndPrintData:base64Data usingHexKey:hexKey1 hexIV:ivKey1];
    
    NSData *unencrypted64Data = [Encryptor decodeAndPrintCipher64Data:encrypted64Data usingHexKey:hexKey1 hexIV:ivKey1];
    
    NSData *unencryptedData = [[NSData alloc]initWithBase64EncodedData:unencrypted64Data options:0];
    
    XCTAssertEqual(data, unencryptedData);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
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

@end
