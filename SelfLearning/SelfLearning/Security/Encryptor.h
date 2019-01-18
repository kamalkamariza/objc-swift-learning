//
//  Encryptor.h
//  SelfLearning
//
//  Created by kamal on 03/12/2018.
//  Copyright © 2018 Kamal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import <Security/Security.h>

@interface Encryptor : NSObject

/**
    CommonCrypto Library - Simple AES Encryption
 **/

+ (NSMutableData*) EncryptAES:(NSString *)key
                     withData:(NSMutableData*)unencryptedData;

+ (NSMutableData*) DecryptAES: (NSString*)key
                      forData:(NSMutableData*)encryptedData;

/**
    CommonCrypto Library - Advanced AES Encryption
 **/

+ (NSData*)encodeAndPrintPlainText:(NSString *)plainText
                    usingHexKey:(NSString *)hexKey
                          hexIV:(NSString *)hexIV;

+ (NSData*)decodeAndPrintCipherBase64Data:(NSString *)cipherText
                           usingHexKey:(NSString *)hexKey
                                 hexIV:(NSString *)hexIV;

+ (NSData*)encodeAndPrintData:(NSData *)plainData
                       usingHexKey:(NSString *)hexKey
                             hexIV:(NSString *)hexIV;

+ (NSData*)decodeAndPrintCipher64Data:(NSData *)cipherData
                              usingHexKey:(NSString *)hexKey
                                    hexIV:(NSString *)hexIV;

/**
    Security Framework - RSA Algorithm, public and private key
 **/

+(void) TestEncryptDecrpt;
+(void) createPubPrivKeys:(void (^)(NSString *private, NSString* public))completionHandler;

+ (NSMutableData *_Nonnull)generateRandomKeysWithIV:(NSUInteger)lengthIV withHexKey:(NSUInteger)lengthHex;
+ (NSData*_Nonnull)decryptCipherDataAES:(NSData *_Nonnull)cipherData
                           usingKeyData:(NSData *_Nonnull)keyData;
+ (NSData*_Nonnull)encryptDataAES:(NSData *_Nonnull)base64Data
                     usingKeyData:(NSData *_Nonnull)keyData;

@end
