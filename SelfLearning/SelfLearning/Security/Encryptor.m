//
//  Encryptor.m
//  SelfLearning
//
//  Created by kamal on 03/12/2018.
//  Copyright © 2018 Kamal. All rights reserved.
//

#import "Encryptor.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

#define HMAC256_KEY_LENGTH 32
#define HMAC256_OUTPUT_LENGTH 32
#define AES_CBC_IV_LENGTH 16
#define AES_KEY_SIZE 32
#define RSA_KEY_BITS_SIZE 2048

@interface NSData (AES256Encryption)
- (NSData *)encryptedDataWithHexKey:(NSString*)hexKey hexIV:(NSString *)hexIV;
- (NSData *)originalDataWithHexKey:(NSString*)hexKey hexIV:(NSString *)hexIV;
@end

@implementation NSData (AES256Encryption)

/**
    Catergory for NSData + AESEncryption
 **/

+ (NSData *)dataFromHexString:(NSString *)string
{
    string = string.lowercaseString;
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:string.length/2];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i = 0;
    NSUInteger length = string.length;
    while (i < length-1) {
        char c = [string characterAtIndex:i++];
        if (c < '0' || (c > '9' && c < 'a') || c > 'f')
            continue;
        byte_chars[0] = c;
        byte_chars[1] = [string characterAtIndex:i++];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    return data;
}

+ (void)fillDataArray:(char **)dataPtr length:(NSUInteger)length usingHexString:(NSString *)hexString
{
    NSData *data = [NSData dataFromHexString:hexString];
    NSAssert((data.length + 1) == length, @"The hex provided didn't decode to match length");
    
    unsigned long total_bytes = (length + 1) * sizeof(char);
    
    *dataPtr = malloc(total_bytes);
    bzero(*dataPtr, total_bytes);
    memcpy(*dataPtr, data.bytes, data.length);
}

- (NSData *)encryptedDataWithHexKey:(NSString*)hexKey hexIV:(NSString *)hexIV
{
    // Fetch key data and put into C string array padded with \0
    char *keyPtr;
    [NSData fillDataArray:&keyPtr length:kCCKeySizeAES256+1 usingHexString:hexKey];
    
    // Fetch iv data and put into C string array padded with \0
    char *ivPtr;
    [NSData fillDataArray:&ivPtr length:kCCKeySizeAES128+1 usingHexString:hexIV];
    
    // For block ciphers, the output size will always be less than or equal to the input size plus the size of one block because we add padding.
    // That's why we need to add the size of one block here
    NSUInteger dataLength = self.length;
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc( bufferSize );
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          ivPtr /* initialization vector */,
                                          [self bytes], [self length], /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    free(keyPtr);
    free(ivPtr);
    
    if(cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return nil;
}

- (NSData *)originalDataWithHexKey:(NSString*)hexKey hexIV:(NSString *)hexIV
{
    // Fetch key data and put into C string array padded with \0
    char *keyPtr;
    [NSData fillDataArray:&keyPtr length:kCCKeySizeAES256+1 usingHexString:hexKey];
    
    // Fetch iv data and put into C string array padded with \0
    char *ivPtr;
    [NSData fillDataArray:&ivPtr length:kCCKeySizeAES128+1 usingHexString:hexIV];
    
    // For block ciphers, the output size will always be less than or equal to the input size plus the size of one block because we add padding.
    // That's why we need to add the size of one block here
    NSUInteger dataLength = self.length;
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc( bufferSize );
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt( kCCDecrypt, kCCAlgorithmAES, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          ivPtr,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted );
    free(keyPtr);
    free(ivPtr);
    
    if( cryptStatus == kCCSuccess )
    {
        // The returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    return nil;
}


+ (void)fillDataArray:(char **)dataPtr length:(NSUInteger)length usingHexStringData:(NSData *)hexStringData
{
    NSData *data = hexStringData;
    NSAssert((data.length + 1) == length, @"The hex provided didn't decode to match length");
    
    unsigned long total_bytes = (length + 1) * sizeof(char);
    
    *dataPtr = malloc(total_bytes);
    bzero(*dataPtr, total_bytes);
    memcpy(*dataPtr, data.bytes, data.length);
}

- (NSData *)encryptedDataWithHexKeyData:(NSData*)hexKey hexIVData:(NSData *)hexIV
{
    // Fetch key data and put into C string array padded with \0
    char *keyPtr;
    //    [NSData fillDataArray:&keyPtr length:kCCKeySizeAES256+1 usingHexString:hexKey];
    [NSData fillDataArray:&keyPtr length:kCCKeySizeAES256+1 usingHexStringData:hexKey];
    
    // Fetch iv data and put into C string array padded with \0
    char *ivPtr;
    //    [NSData fillDataArray:&ivPtr length:kCCKeySizeAES128+1 usingHexString:hexIV];
    [NSData fillDataArray:&ivPtr length:kCCKeySizeAES128+1 usingHexStringData:hexIV];
    
    // For block ciphers, the output size will always be less than or equal to the input size plus the size of one block because we add padding.
    // That's why we need to add the size of one block here
    NSUInteger dataLength = self.length;
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc( bufferSize );
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          ivPtr /* initialization vector */,
                                          [self bytes], [self length], /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    free(keyPtr);
    free(ivPtr);
    
    if(cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return nil;
}

- (NSData *)originalDataWithHexKeyData:(NSData*)hexKey hexIVData:(NSData *)hexIV
{
    // Fetch key data and put into C string array padded with \0
    char *keyPtr;
    [NSData fillDataArray:&keyPtr length:kCCKeySizeAES256+1 usingHexStringData:hexKey];
    
    // Fetch iv data and put into C string array padded with \0
    char *ivPtr;
    [NSData fillDataArray:&ivPtr length:kCCKeySizeAES128+1 usingHexStringData:hexIV];
    
    // For block ciphers, the output size will always be less than or equal to the input size plus the size of one block because we add padding.
    // That's why we need to add the size of one block here
    NSUInteger dataLength = self.length;
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc( bufferSize );
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt( kCCDecrypt, kCCAlgorithmAES, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          ivPtr,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted );
    free(keyPtr);
    free(ivPtr);
    
    if( cryptStatus == kCCSuccess )
    {
        // The returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    return nil;
}

@end

@implementation Encryptor

/**
    CommonCrypto Library
    Advanced AES Encryption - Block Chaining
    Key - 256
    IV Hex - YES
 **/

//- (void)runMe
//{
//    NSString *hexKey = @"2034F6E32958647FDFF75D265B455EBF40C80E6D597092B3A802B3E5863F878C";
//    NSString *cipherText = nil;
//    NSString *hexIV = nil;
//
//    cipherText = @"9/0FGE21YYBl8NvlCp1Ft8j1V7BiIpCIlNa/zbYwL5LWyemd/7QEu0tkVz9/f0JG";
//    hexIV = @"AD0ACC568C88C116D57B273D98FB92C0";
//    [self decodeAndPrintCipherBase64Data:cipherText usingHexKey:hexKey hexIV:hexIV];
//
//    cipherText = @"S6flMkdMeC77p/7pokXZkHT0is7Lp57Zgkokg/O99puZloTB/ZUzp0FwH8sWFekg";
//    hexIV = @"0F0AFF0F0AFF0F0AFF0F0AFF0F0AFF00";
//    [self decodeAndPrintCipherBase64Data:cipherText usingHexKey:hexKey hexIV:hexIV];
//
//    NSString *plainText = @"Thank you Mr Warrender, Reinforcements have arrived! Send biscuits";
//    hexIV = @"010932650CDD998833CC0AFF9AFF00FF";
//    [self encodeAndPrintPlainText:plainText usingHexKey:hexKey hexIV:hexIV];
//}

+ (NSData*)decodeAndPrintCipherBase64Data:(NSString *)cipherText
                           usingHexKey:(NSString *)hexKey
                                 hexIV:(NSString *)hexIV
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:cipherText options:0];
    NSAssert(data != nil, @"Couldn't base64 decode cipher text");
    
    NSData *decryptedPayload = [data originalDataWithHexKey:hexKey
                                                      hexIV:hexIV];
    
    if (decryptedPayload) {
        NSString *plainText = [[NSString alloc] initWithData:decryptedPayload encoding:NSUTF8StringEncoding];
        NSLog(@"Decrypted Result: %@", plainText);
        return decryptedPayload;
    } else {
        return nil;
    }
}

+ (NSData*)encodeAndPrintPlainText:(NSString *)plainText
                    usingHexKey:(NSString *)hexKey
                          hexIV:(NSString *)hexIV
{
    NSData *data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *encryptedPayload = [data encryptedDataWithHexKey:hexKey
                                                       hexIV:hexIV];
    
    if (encryptedPayload) {
        NSString *cipherText = [encryptedPayload base64EncodedStringWithOptions:0];
        NSLog(@"Encryped Result: %@", cipherText);
        return encryptedPayload;
    } else {
        return nil;
    }
}

+ (NSData*)encodeAndPrintData:(NSData *)plainData
                  usingHexKey:(NSString *)hexKey
                        hexIV:(NSString *)hexIV{
    
    NSData *encryptedPayload = [plainData encryptedDataWithHexKey:hexKey
                                                       hexIV:hexIV];
    
    if (encryptedPayload) {
        NSString *cipherText = [encryptedPayload base64EncodedStringWithOptions:0];
        NSLog(@"Encryped Result: %@", cipherText);
        return encryptedPayload;
    } else {
        return nil;
    }
}

+ (NSData*)decodeAndPrintCipher64Data:(NSData *)cipherData
                          usingHexKey:(NSString *)hexKey
                                hexIV:(NSString *)hexIV{
    
//    NSData *data = [[NSData alloc] initWithBase64EncodedData:cipherData options:0];
//    NSAssert(data != nil, @"Couldn't base64 decode cipher text");
    
    NSData *decryptedPayload = [cipherData originalDataWithHexKey:hexKey
                                                      hexIV:hexIV];
    
    if (decryptedPayload) {
        NSString *plainText = [[NSString alloc] initWithData:decryptedPayload encoding:NSUTF8StringEncoding];
        NSLog(@"Decrypted Result: %@", plainText);
        return decryptedPayload;
    } else {
        return nil;
    }
}

/**
    CommonCrypto Library
    Simple AES Encryption
    Key - 256
    IV Hex - NULL
 **/
 
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
    
    CCCryptorStatus result = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                     keyPtr, kCCKeySizeAES256,
                                     NULL,
                                     [unencryptedData mutableBytes], [unencryptedData length],
                                     buffer, bufferSize,
                                     &numBytesEncrypted);
    
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
    
    CCCryptorStatus result = CCCrypt(kCCDecrypt , kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                     keyPtr, kCCKeySizeAES256,
                                     NULL, [encryptedData mutableBytes], [encryptedData length],
                                     buffer_decrypt, bufferSize,
                                     &numBytesEncrypted);
    
    output_decrypt = [NSMutableData dataWithBytesNoCopy:buffer_decrypt length:numBytesEncrypted];
    
    if(result == kCCSuccess) {
        return output_decrypt;
    }
    return NULL;
}

/**
    Security Framework
    Generate Public and Private Key
    RSA Algorithm
 **/

+ (void) createPubPrivKeys:(void (^)(NSString *private, NSString* public))completionHandler{
    OSStatus status;

    SecKeyRef publicKey;
    SecKeyRef privateKey;
    
    NSData  *pubKeyTag = [@"com.kaichat2.beta.public" dataUsingEncoding:NSUTF8StringEncoding];
    NSData  *privKeyTag = [@"com.kaichat2.beta.public" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *privAttr = @{(id)kSecAttrIsPermanent:    @YES,
                               (id)kSecAttrApplicationTag: privKeyTag,
                               };
    
    NSDictionary *pubAttr = @{(id)kSecAttrIsPermanent:    @YES,
                              (id)kSecAttrApplicationTag: pubKeyTag,
                               };
    
    NSDictionary* attributes =
    @{ (id)kSecAttrKeyType:               (id)kSecAttrKeyTypeRSA,
       (id)kSecAttrKeySizeInBits:         @1024,
       (id)kSecPublicKeyAttrs:            pubAttr,
       (id)kSecPrivateKeyAttrs:           privAttr,
       };

    status = SecKeyGeneratePair((__bridge CFDictionaryRef)attributes, &publicKey, &privateKey );
    
    if(status == noErr){
        NSLog(@"Process done");
        if(publicKey && privateKey){
            NSLog(@"Keys generated");
            
            CFTypeRef resultPrivKey;
            CFTypeRef resultPubKey;
            OSStatus getPrivate;
            OSStatus getPublic;
            CFErrorRef error;
            NSData *publicKeyOutput;
            NSData *privateKeyOutput;
            
            NSString *publicKeyString;
            NSString *privateKeyString;
            
            getPublic = SecItemCopyMatching((__bridge CFDictionaryRef)pubAttr, &resultPubKey);
            getPrivate = SecItemCopyMatching((__bridge CFDictionaryRef)privAttr, &resultPrivKey);
            
            publicKeyOutput = (NSData*)CFBridgingRelease(SecKeyCopyExternalRepresentation(publicKey, &error));
            privateKeyOutput = (NSData*)CFBridgingRelease(SecKeyCopyExternalRepresentation(privateKey, &error));
            
            publicKeyString = [publicKeyOutput base64EncodedStringWithOptions:0];
            privateKeyString = [privateKeyOutput base64EncodedStringWithOptions:0];
            
            completionHandler(privateKeyString, publicKeyString);
            
            NSLog(@"Public Key %@", publicKeyString);
            NSLog(@"Private Key %@", privateKeyString);
        }
    }
}

+(void) TestEncryptDecrpt{
    OSStatus status;
    NSString *tagInput = @"com.kaichat2.beta";
    NSData* tag = [tagInput dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* attributes =
    @{ (id)kSecAttrKeyType:               (id)kSecAttrKeyTypeRSA,
       (id)kSecAttrKeySizeInBits:         @1024,
       (id)kSecPrivateKeyAttrs:
           @{ (id)kSecAttrIsPermanent:    @YES,
              (id)kSecAttrApplicationTag: tag,
              },
       };
    
    CFErrorRef error = NULL;
    SecKeyRef privateKey = SecKeyCreateRandomKey((__bridge CFDictionaryRef)attributes, &error);
    SecKeyRef publicKey = SecKeyCopyPublicKey(privateKey);
    
    NSLog(@"%@", [NSString stringWithFormat:@"\n\nPrivate Key%@\nPublic Key %@", privateKey, publicKey]);
    
    // *** it will work if I generate the key by SecKeyGeneratePair ***
     status = SecKeyGeneratePair( (__bridge CFDictionaryRef)attributes, &publicKey, &privateKey );
    
    // start encrypt and decrypt a message
    static char const kMessage[] = "This is a secret!\n";
    NSString *inputText = @"This is a secret a message!";
    
    NSLog(@"Actual input %@", inputText);

    SecKeyAlgorithm algorithm = kSecKeyAlgorithmRSAEncryptionRaw;
    BOOL canEncrypt = SecKeyIsAlgorithmSupported(publicKey, kSecKeyOperationTypeEncrypt, algorithm);
    
    NSData *base64Data = [inputText dataUsingEncoding:NSUTF8StringEncoding];
    NSData *plainData = [base64Data base64EncodedDataWithOptions:0];
    NSLog(@"Base64 input %@", [plainData base64EncodedStringWithOptions:0]);

//    NSData* plainData = [NSData dataWithBytes:kMessage length:sizeof(kMessage)];
    canEncrypt &= ([plainData length] < (SecKeyGetBlockSize(publicKey)-130));
    
    NSData* cipherText = nil;
    if (canEncrypt) {
        CFErrorRef error = NULL;
        cipherText = (NSData*)CFBridgingRelease( SecKeyCreateEncryptedData(publicKey, algorithm, (__bridge CFDataRef)plainData, &error));
        cipherText = [cipherText base64EncodedDataWithOptions:0];
        NSLog(@"Encrypted input %@", [cipherText base64EncodedStringWithOptions:0]);
        if (!cipherText) {
            NSError *err = CFBridgingRelease(error);  // ARC takes ownership
            // Handle the error. . .
            NSLog(@"error = %@, %@", [err userInfo], [err localizedDescription]);
        }
        
        if(cipherText){
            NSLog(@"Cipher text exist");
            NSLog(@"Encrypted output %@", [cipherText base64EncodedStringWithOptions:0]);
            NSData *unencryptedData = [cipherText base64EncodedDataWithOptions:0];
            NSLog(@"64 output %@", [unencryptedData base64EncodedStringWithOptions:0]);
            unencryptedData = (NSData*)CFBridgingRelease(SecKeyCreateDecryptedData(privateKey, algorithm, (__bridge CFDataRef)unencryptedData, &error));
            
            if(unencryptedData){
                NSLog(@"Decrypt output %@", [unencryptedData base64EncodedStringWithOptions:0]);

                NSData *unencryptedDataTest = (NSData*)CFBridgingRelease(SecKeyCreateDecryptedData(privateKey, algorithm, (__bridge CFDataRef)cipherText, &error));
                
                
                NSString *retTest = [[NSString alloc] initWithData:unencryptedDataTest encoding:NSUTF8StringEncoding];
                NSString *ret = [[NSString alloc] initWithData:unencryptedData encoding:NSUTF8StringEncoding];
                
                NSLog(@"Actual message is %@", ret);
                NSLog(@"Actual message is %@", retTest);
            }
        }
    }
}

+ (NSMutableData *_Nonnull)generateRandomKeysWithIV:(NSUInteger)lengthIV withHexKey:(NSUInteger)lengthHex{
    NSMutableData *data = [NSMutableData new];
    
    NSData *key = [self generateRandomBytes:lengthHex];
    NSData *iv = [self generateRandomBytes:lengthIV];
    
    [data appendData:iv];
    [data appendData:key];
    
    return data;
}

+ (NSMutableData *)generateRandomBytes:(NSUInteger)numberBytes {
    /* used to generate db master key, and to generate signaling key, both at install */
    NSMutableData *randomBytes = [NSMutableData dataWithLength:numberBytes];
    int err                    = 0;
    err                        = SecRandomCopyBytes(kSecRandomDefault, numberBytes, [randomBytes mutableBytes]);
    if (err != noErr) {
        @throw [NSException exceptionWithName:@"random problem" reason:@"problem generating the random " userInfo:nil];
    }
    return randomBytes;
}

+ (NSData*_Nonnull)encryptDataAES:(NSData *_Nonnull)base64Data
                     usingKeyData:(NSData *_Nonnull)keyData
{
    NSData *hexIV = [keyData subdataWithRange:NSMakeRange(0, AES_CBC_IV_LENGTH)];
    NSData *hexKey = [keyData subdataWithRange:NSMakeRange(AES_CBC_IV_LENGTH, AES_KEY_SIZE)];
    
    NSData *encryptedPayload = [base64Data encryptedDataWithHexKeyData:hexKey
                                                             hexIVData:hexIV];
    
    if (encryptedPayload) {
        return encryptedPayload;
    } else {
        return nil;
    }
}

+ (NSData*_Nonnull)decryptCipherDataAES:(NSData *_Nonnull)cipherData
                           usingKeyData:(NSData *_Nonnull)keyData
{
    NSData *hexIV = [keyData subdataWithRange:NSMakeRange(0, AES_CBC_IV_LENGTH)];
    NSData *hexKey = [keyData subdataWithRange:NSMakeRange(AES_CBC_IV_LENGTH, AES_KEY_SIZE)];
    
    //base64 decoded Data
    NSData *decryptedPayload = [cipherData originalDataWithHexKeyData:hexKey
                                                            hexIVData:hexIV];
    
    if (decryptedPayload) {
        return decryptedPayload;
    } else {
        return nil;
    }
}

@end
