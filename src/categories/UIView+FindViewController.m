#import "UIView+FindViewController.h"

@implementation UIView(FindViewController)

- (UIViewController *)traverseResponderChainForUIViewController {

    id nextResponder = [self nextResponder];

    if ([nextResponder isKindOfClass:[UIViewController class]]) {

        return (UIViewController *)nextResponder;
    } 
    else if ([nextResponder isKindOfClass:[UIView class]]) {

        return [nextResponder traverseResponderChainForUIViewController];
    }

    return nil;
}

@end
