
#ifndef __arm__
	#define __arm__ 
#endif

#ifndef __arm64__
	#define __arm64__
#endif

#import <UIKit/UIKit.h>

@interface UIView(FindViewController)

- (UIViewController *)traverseResponderChainForUIViewController;

@end
