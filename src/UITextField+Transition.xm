#import "InjectionButton.h"
#import "UITextField+Transition.h"
#import <objc/runtime.h>

@implementation UITextField(Transition)

- (void)setText:(NSString *)text animated:(BOOL)animated {

    [UIView transitionWithView:self duration:animated ? 0.4 : 0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
        self.text = text;
        
    } completion:nil];
}

@end

@implementation UIView(FindViewController)

- (id)traverseResponderChainForUIViewController {

    id nextResponder = [self nextResponder];

    if ([nextResponder isKindOfClass:[UIViewController class]]) {

        return nextResponder;
    } 
    else if ([nextResponder isKindOfClass:[UIView class]]) {

        return [nextResponder traverseResponderChainForUIViewController];
    }

    return nil;
}

@end

@interface UIAlertView () <UIAlertViewDelegate>

@property (nonatomic, copy) UIAlertViewCompletionBlock completionBlock;

@end

@implementation UIAlertView (Utilities)

- (void)setCompletionBlock:(UIAlertViewCompletionBlock)completionBlock {
    
    objc_setAssociatedObject(self, @selector(completionBlock), completionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIAlertViewCompletionBlock)completionBlock {
    
    return objc_getAssociatedObject(self, @selector(completionBlock));
}

- (void)showWithCompletion:(void (^)(UIAlertView *, NSInteger))completionBlock {
    
    self.completionBlock = completionBlock;
    self.delegate = self;
    
    [self show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(self.completionBlock) {
        
        self.completionBlock(alertView, buttonIndex);
    }
}

@end

%hook UITextField 

- (void)addSubview:(UIView *)view {

	%orig(view);

	for(UIView *view in self.subviews) {

		if([view isKindOfClass:[InjectionButton class]]) {

			[self bringSubviewToFront:view];
			break;
		}
	}
}

%end
