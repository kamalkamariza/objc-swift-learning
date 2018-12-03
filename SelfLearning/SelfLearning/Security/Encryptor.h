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

@interface Encryptor : NSObject

+ (NSMutableData*) EncryptAES:(NSString *)key withData:(NSMutableData*)unencryptedData;
+ (NSMutableData*)DecryptAES: (NSString*)key forData:(NSMutableData*)encryptedData;

@end
