
#import "OnePasswordInjector.h"
#import "OPInjectionButton.h"

#import "categories/UITextField+HumanInput.h"

%hook UITextField

- (void)setSecureTextEntry:(BOOL)secure {

	%orig(secure);

	if(secure) {

		[[OnePasswordInjector sharedInjector] injectButtonIntoPasswordField:self];
	}
}

- (void)layoutSubviews {

	%orig();

	if([OnePasswordInjector sharedInjector]) {

		for(OPInjectionButton *button in self.subviews) {

			if([button isKindOfClass:[OPInjectionButton class]]) {

				button.bounds = CGRectMake(0, 0, CGRectGetHeight(self.bounds) * 0.8, CGRectGetHeight(self.bounds) * 0.8);
				button.center = CGPointMake(CGRectGetWidth(self.bounds) - CGRectGetHeight(self.bounds) * 0.4 - 10, CGRectGetHeight(self.bounds) / 2);
				break;
			}
		}
	}
}

- (void)addSubview:(UIView *)view {

	%orig(view);

	if([OnePasswordInjector sharedInjector]) {

		for(UIView *view in self.subviews) {

			if([view isKindOfClass:[OPInjectionButton class]]) {

				[self bringSubviewToFront:view];
				break;
			}
		}
	}
}

%end