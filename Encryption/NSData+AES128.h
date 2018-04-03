

#import <Foundation/Foundation.h>

@interface NSData (AES128)
- (NSData *)AES128EncryptedDataWithKey:(NSString *)key;

- (NSData *)AES128DecryptedDataWithKey:(NSString *)key;

- (NSData *)AES128EncryptedDataWithKey:(NSString *)key iv:(NSString *)iv;

- (NSData *)AES128DecryptedDataWithKey:(NSString *)key iv:(NSString *)iv;

@end
