
#ifndef __arm__
	#define __arm__ 
#endif

#ifndef __arm64__
	#define __arm64__
#endif

#import <UIKit/UIKit.h>

@interface UITextField(Transition)

- (void)setText:(NSString *)text animated:(BOOL)animated;
- (void)simulateHumanInput:(NSString *)input;

@end

@interface UIView(FindViewController)

- (id)traverseResponderChainForUIViewController;

@end

typedef void (^UIAlertViewCompletionBlock)(UIAlertView *alert, NSInteger index);

@interface UIAlertView (Utilities)

- (void)showWithCompletion:(UIAlertViewCompletionBlock)completionBlock;

@end