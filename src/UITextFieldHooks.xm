
#import "OnePasswordInjector.h"
#import "OPInjectionButton.h"

#import "categories/UITextField+HumanInput.h"

static CGFloat const OPInjectionButtonScale = 0.95;
static CGFloat const OPInjectionButtonInset = 10;

%hook UITextField

// Hook to inject the injection button when secure text is set.
- (void)setSecureTextEntry:(BOOL)secure {

	%orig(secure);

	for(OPInjectionButton *button in self.subviews) {

		// If the textField already has an injection button, don't add another
		if([button isKindOfClass:[OPInjectionButton class]]) {

			return;
		}
	}

	if(secure) {

		[[OnePasswordInjector sharedInjector] injectButtonIntoPasswordField:self];
	}
}

// Hook to make sure the OPInjectionButton gets positioned.
- (void)layoutSubviews {

	%orig();

	if([OnePasswordInjector sharedInjector]) {

		for(OPInjectionButton *button in self.subviews) {

			if([button isKindOfClass:[OPInjectionButton class]]) {

				button.bounds = CGRectMake(0, 0, CGRectGetHeight(self.bounds) * OPInjectionButtonScale, CGRectGetHeight(self.bounds) * OPInjectionButtonScale);
				button.center = CGPointMake(CGRectGetWidth(self.bounds) - CGRectGetHeight(self.bounds) * OPInjectionButtonScale * 0.5 - OPInjectionButtonInset, CGRectGetHeight(self.bounds) / 2);
				break;
			}
		}
	}
}

// Hook to make sure the OPInjectionButton stays at the top of the view hierarchy so it's always tappable.
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