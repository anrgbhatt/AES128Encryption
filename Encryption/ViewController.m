

#import "ViewController.h"
#import "NSData+AES128.h"
@interface ViewController ()

@end

@implementation ViewController
{
    NSString *key;
    NSString *iv;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    key = @"2018!123";
    iv = @"@1F6g7H8";
    
    NSData *cipherData;
    NSString *base64Text;
    NSString *plainText;
    
    // get you all parameters in dictionary(if you want to send it in api as paameters)
    NSDictionary *encryptDict = @{
                                  @"param 1"    :   @"one",
                                  @"parma 2"    :  @"two",
                                  };
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:encryptDict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);

    //Encyption starts
    plainText = jsonString;
    cipherData = [[plainText dataUsingEncoding:NSUTF8StringEncoding] AES128EncryptedDataWithKey:key iv:iv];
    ////----    AES128 -> base64
    // base 64 encryption
    base64Text = [cipherData base64EncodedStringWithOptions:0];
    NSLog(@"crypt AES128+base64: %@", base64Text);
    //encryption finsihed
    // send this encrypted string (base64Text) as parameters to API having key "token"
    }
    
    
    //For Decryption
    // If you get your response from API as NSDATA (here response is NSDATA)

   //NSDictionary *dictDecrypt = [self getDecryptDictData:response];

}


-(NSDictionary *)getDecryptDictData:(NSData*)response{
    if (response != nil && response.length > 0)
    {
        
        NSError *error;
        NSDictionary *jsonData    =    [NSJSONSerialization JSONObjectWithData:response options:0 error:&error];
        
        if ([jsonData objectForKey:@"token"] != nil) {
            NSString *encryptToken = [jsonData valueForKey:@"token"];
            jsonData = [self decryptDataFromResponse:encryptToken];
           
        }
         return jsonData;
    }else
    {
        return  nil;
    }
    
    
}
-(NSDictionary *)decryptDataFromResponse:(NSString *)encryptToken{
    NSData  *cipherData = [[NSData alloc] initWithBase64EncodedString:encryptToken
                                                              options:0];
    NSString *plainText  = [[NSString alloc] initWithData:[cipherData AES128DecryptedDataWithKey:key iv:iv]
                                                 encoding:NSUTF8StringEncoding];
    plainText = [self stringByRemovingControlCharacter:plainText];
    NSError *jsonError;
    NSData *objectData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:objectData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&jsonError];
    
    jsonData = [jsonData valueForKey:@"data"];
    
    return jsonData;
}
- (NSString *)stringByRemovingControlCharacter: (NSString *)inputString
{
    NSCharacterSet *controlChars = [NSCharacterSet controlCharacterSet];
    NSRange range = [inputString rangeOfCharacterFromSet:controlChars];
    if (range.location != NSNotFound) {
        NSMutableString *mutable = [NSMutableString stringWithString:inputString];
        while (range.location != NSNotFound) {
            [mutable deleteCharactersInRange:range];
            range = [mutable rangeOfCharacterFromSet:controlChars];
        }
        return mutable;
    }
    return inputString;
}


@end
