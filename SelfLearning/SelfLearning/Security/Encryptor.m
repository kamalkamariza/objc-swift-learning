//
//  Encryptor.m
//  SelfLearning
//
//  Created by kamal on 03/12/2018.
//  Copyright © 2018 Kamal. All rights reserved.
//

#import "Encryptor.h"

@implementation Encryptor


+ (NSMutableData*) EncryptAES:(NSString *)key
                     withData:(NSMutableData *)unencryptedData{
    char keyPtr[kCCKeySizeAES256+1];
    bzero( keyPtr, sizeof(keyPtr) );
    
    [key getCString: keyPtr maxLength: sizeof(keyPtr) encoding: NSUTF16StringEncoding];
    size_t numBytesEncrypted = 0;
    
    NSUInteger dataLength = [unencryptedData length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    NSMutableData *output = [[NSMutableData alloc] init];
    
    CCCryptorStatus result = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding, keyPtr, kCCKeySizeAES256, NULL, [unencryptedData mutableBytes], [unencryptedData length], buffer, bufferSize, &numBytesEncrypted);
    
    output = [NSMutableData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    
    if(result == kCCSuccess) {
        return output;
    }
    return NULL;
}

+ (NSMutableData*)DecryptAES:(NSString*)key
                     forData:(NSMutableData*)encryptedData {
    
    char  keyPtr[kCCKeySizeAES256+1];
    bzero( keyPtr, sizeof(keyPtr) );
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF16StringEncoding];
    
    size_t numBytesEncrypted = 0;
    
    NSUInteger dataLength = [encryptedData length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer_decrypt = malloc(bufferSize);
    
    NSMutableData *output_decrypt = [[NSMutableData alloc] init];
    CCCryptorStatus result = CCCrypt(kCCDecrypt , kCCAlgorithmAES128, kCCOptionPKCS7Padding, keyPtr, kCCKeySizeAES256, NULL, [encryptedData mutableBytes], [encryptedData length], buffer_decrypt, bufferSize, &numBytesEncrypted);
    
    output_decrypt = [NSMutableData dataWithBytesNoCopy:buffer_decrypt length:numBytesEncrypted];
    
    if(result == kCCSuccess) {
        return output_decrypt;
    }
    return NULL;
}

@end
