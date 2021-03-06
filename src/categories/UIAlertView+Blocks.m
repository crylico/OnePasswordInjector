#import "UIAlertView+Blocks.h"
#import <objc/runtime.h>

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
    
    // Set the completion block and delegate
    self.completionBlock = completionBlock;
    self.delegate = self;
    
    [self show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // If the completion block exists, call it
    if(self.completionBlock) {
        
        self.completionBlock(alertView, buttonIndex);
    }
}

@end
