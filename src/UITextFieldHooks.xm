
#import "OnePasswordInjector.h"
#import "UITextField+Transition.h"
#import "InjectionButton.h"

%hook UITextField

- (void)setSecureTextEntry:(BOOL)secure {

	%orig(secure);

	if(secure) {

		[[OnePasswordInjector sharedInjector] injectButtonIntoPasswordField:self viewController:[self traverseResponderChainForUIViewController]];
	}
}

- (void)layoutSubviews {

	%orig();

	for(InjectionButton *button in self.subviews) {

		if([button isKindOfClass:[InjectionButton class]]) {

			button.bounds = CGRectMake(0, 0, CGRectGetHeight(self.bounds) * 0.8, CGRectGetHeight(self.bounds) * 0.8);
			button.center = CGPointMake(CGRectGetWidth(self.bounds) - CGRectGetHeight(self.bounds) * 0.4 - 10, CGRectGetHeight(self.bounds) / 2);
			break;
		}
	}
}

%end