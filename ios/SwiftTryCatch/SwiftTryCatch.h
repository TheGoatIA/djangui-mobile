#import <Foundation/Foundation.h>

@interface SwiftTryCatch : NSObject

+ (void)tryBlock:(void (^)(void))tryBlock
      catchBlock:(void (^)(NSException *exception))catchBlock
    finallyBlock:(void (^)(void))finallyBlock;

@end
