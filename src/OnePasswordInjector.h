
#ifndef __arm__
	#define __arm__ 
#endif

#ifndef __arm64__
	#define __arm64__
#endif

#import <UIKit/UIKit.h>

#import "onepassword-app-extension/OnePasswordExtension.h"

@interface OnePasswordInjector : NSObject

+ (void)injectButtonIntoPasswordField:(UITextField *)textField viewController:(UIViewController *)viewController;

@end
