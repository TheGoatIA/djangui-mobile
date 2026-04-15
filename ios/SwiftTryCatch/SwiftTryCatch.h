#import <Foundation/Foundation.h>

@interface SwiftTryCatch : NSObject

+ (void)try:(void (^)(void))tryBlock
      catch:(void (^)(NSException *exception))catchBlock
    finally:(void (^)(void))finallyBlock;

@end
