#import "InjectionButton.h"
#import "UITextField+Transition.h"

@implementation UITextField(Transition)

- (void)setText:(NSString *)text animated:(BOOL)animated {

    [UIView transitionWithView:self duration:animated ? 0.4 : 0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
        self.text = text;
        
    } completion:nil];
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
