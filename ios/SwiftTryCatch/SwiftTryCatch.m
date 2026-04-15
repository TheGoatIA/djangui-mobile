#import "SwiftTryCatch.h"

@implementation SwiftTryCatch

+ (void)try:(void (^)(void))tryBlock
      catch:(void (^)(NSException *exception))catchBlock
    finally:(void (^)(void))finallyBlock {
    @try {
        if (tryBlock) tryBlock();
    }
    @catch (NSException *exception) {
        if (catchBlock) catchBlock(exception);
    }
    @finally {
        if (finallyBlock) finallyBlock();
    }
}

@end
