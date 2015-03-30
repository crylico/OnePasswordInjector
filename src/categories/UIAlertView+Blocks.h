
#ifndef __arm__
	#define __arm__ 
#endif

#ifndef __arm64__
	#define __arm64__
#endif

#import <UIKit/UIKit.h>

typedef void (^UIAlertViewCompletionBlock)(UIAlertView *alert, NSInteger index);

@interface UIAlertView (Utilities)

- (void)showWithCompletion:(UIAlertViewCompletionBlock)completionBlock;

@end