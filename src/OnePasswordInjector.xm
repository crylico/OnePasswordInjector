#import "OnePasswordInjector.h"
#import "InjectionButton.h"

static NSString * const kBundlePath = @"/Library/MobileSubstrate/DynamicLibraries/1passwordinjector_bundle.bundle";
static NSString * const kButtonImageName = @"onepassword-button";

static CGFloat const kButtonPadding = 10;

@implementation OnePasswordInjector

+ (void)injectButtonIntoPasswordField:(UITextField *)textField viewController:(UIViewController *)viewController {

	if([[OnePasswordExtension sharedExtension] isAppExtensionAvailable]) {

		InjectionButton *button = [InjectionButton buttonWithType:UIButtonTypeSystem];
		[button addTarget:viewController action:@selector(activateOnePasswordExtension:) forControlEvents:UIControlEventTouchUpInside];
		[button setImage:[self buttonImage] forState:UIControlStateNormal];

		button.bounds = CGRectMake(0, 0, CGRectGetHeight(textField.bounds) * 0.8, CGRectGetHeight(textField.bounds) * 0.8);
		button.center = CGPointMake(CGRectGetWidth(textField.bounds) - CGRectGetHeight(textField.bounds) * 0.4 - kButtonPadding, CGRectGetHeight(textField.bounds) / 2);

		button.alpha = 0;

		[textField addSubview:button];
		button.layer.zPosition = 1000;

		[UIView animateWithDuration:0.4 animations:^{

			button.alpha = 1;
		}];
	}
}

+ (UIImage *)buttonImage {

	NSBundle *bundle = [[NSBundle alloc] initWithPath:kBundlePath];

	UIImage *image = [UIImage imageNamed:kButtonImageName inBundle:bundle compatibleWithTraitCollection:nil];

	return image;
}

@end
