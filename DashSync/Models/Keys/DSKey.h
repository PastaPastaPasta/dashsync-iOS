//
//  DSKey.h
//  DashSync
//
//  Created by Sam Westrich on 2/14/19.
//

#import <Foundation/Foundation.h>
#import "BigIntTypes.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DSKeyType) {
    DSKeyType_Unknown = 0,
    DSKeyType_ECDSA = 1,
    DSKeyType_BLS = 2,
};

@class DSChain;

@interface DSKey : NSObject

@property (nullable, nonatomic, readonly) NSData *extendedPublicKeyData;
@property (nullable, nonatomic, readonly) NSData *extendedPrivateKeyData;
@property (nullable, nonatomic, readonly) NSData *publicKeyData;
@property (nullable, nonatomic, readonly) NSData *privateKeyData;
@property (nonatomic,readonly) UInt160 hash160;
@property (nonatomic,readonly) NSString * secretKeyString;
@property (nonatomic,readonly) DSKeyType keyType;
@property (nonatomic,readonly) NSString * localizedKeyType;

- (BOOL)verify:(UInt256)messageDigest signatureData:(NSData*)signature;
- (NSString *)addressForChain:(DSChain*)chain;
+ (NSString *)randomAddressForChain:(DSChain*)chain;
+ (NSString *)addressWithPublicKeyData:(NSData*)data forChain:(DSChain*)chain;
- (NSString * _Nullable)privateKeyStringForChain:(DSChain*)chain;
+ (nullable instancetype)keyWithPublicKeyData:(NSData*)data forKeyType:(DSKeyType)keyType;
+ (nullable instancetype)keyWithPrivateKeyData:(NSData*)data forKeyType:(DSKeyType)keyType;
+ (nullable instancetype)keyWithExtendedPrivateKeyData:(NSData*)extendedPrivateKeyData forKeyType:(DSKeyType)keyType;
+ (nullable instancetype)keyWithExtendedPublicKeyData:(NSData*)extendedPublicKeyData forKeyType:(DSKeyType)keyType;

- (nullable instancetype)privateDeriveToPath:(NSIndexPath*)derivationPath;
- (nullable instancetype)publicDeriveToPath:(NSIndexPath*)derivationPath;

@end

NS_ASSUME_NONNULL_END
