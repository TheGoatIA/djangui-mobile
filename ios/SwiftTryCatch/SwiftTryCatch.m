#import "SwiftTryCatch.h"

@implementation SwiftTryCatch

+ (void)tryBlock:(void (^)(void))tryBlock
      catchBlock:(void (^)(NSException *exception))catchBlock
    finallyBlock:(void (^)(void))finallyBlock {
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
