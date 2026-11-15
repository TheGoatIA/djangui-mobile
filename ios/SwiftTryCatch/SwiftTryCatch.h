#import <Foundation/Foundation.h>

@interface SwiftTryCatch : NSObject

// Nom Swift figé : flutter_dynamic_icon_plus appelle `SwiftTryCatch.try(_:catch:finally:)`.
// Les Xcode récents ne raccourcissent plus « finallyBlock » en « finally » automatiquement
// (erreur « expected '_:catch:finallyBlock:' ») ; ce nom explicite marche sur toutes les versions.
+ (void)tryBlock:(void (^)(void))tryBlock
      catchBlock:(void (^)(NSException *exception))catchBlock
    finallyBlock:(void (^)(void))finallyBlock NS_SWIFT_NAME(try(_:catch:finally:));

@end
