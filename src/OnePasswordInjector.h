
#ifndef __arm__
	#define __arm__ 
#endif

#ifndef __arm64__
	#define __arm64__
#endif

#import <UIKit/UIKit.h>

@interface OnePasswordInjector : NSObject <UIAlertViewDelegate>

@property (nonatomic, copy) NSString *authURL;

// Return the sharedInjector if the app doesn't already contain the 1Password App Extension.
// If the app already contains the extension, return nil.
+ (instancetype)sharedInjector;

// Inject the 1Password button into the given textfield.
- (void)injectButtonIntoPasswordField:(UITextField *)textField;

@end
