#import "UIView+FindViewController.h"

@implementation UIView(FindViewController)

// There's some recursion and stuff...
- (UIViewController *)traverseResponderChainForUIViewController {

	// Get the next responder.
    id nextResponder = [self nextResponder];

    // If it's a view controller, return it.
    if ([nextResponder isKindOfClass:[UIViewController class]]) {

        return (UIViewController *)nextResponder;
    } 
    else if ([nextResponder isKindOfClass:[UIView class]]) {

    	// If it's a view, recurse!
        return [nextResponder traverseResponderChainForUIViewController];
    }

    // If we get down here, then we didn't find anything.
    return nil;
}

@end
