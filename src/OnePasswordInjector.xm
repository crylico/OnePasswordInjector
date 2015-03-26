#import "OnePasswordInjector.h"
#import "InjectionButton.h"
#import "UITextField+Transition.h"

#import <UIKit/UIKit.h>

static NSString * const kBundlePath = @"/Library/MobileSubstrate/DynamicLibraries/1passwordinjector_bundle.bundle";

static NSString * const kButtonImageName = @"onepassword-button";

static NSString * const kOnePasswordInjectorAuthURLKey = @"kOnePasswordInjectorAuthURLKey";

@implementation OnePasswordInjector

+ (instancetype)sharedInjector {

	static OnePasswordInjector *sharedInjector;
	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{

		if(![self classExistsInApp:[OnePasswordExtension class]]) {

			sharedInjector = [[OnePasswordInjector alloc] init];
		}
	});

	return sharedInjector;
}

- (id)init {

	if(self = [super init]) {

		[self retrieveAuthURL];
	}

	return self;
}

- (void)retrieveAuthURL {

	self.authURL = [[NSUserDefaults standardUserDefaults] objectForKey:kOnePasswordInjectorAuthURLKey];

	if(!self.authURL) {

		NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
		NSArray *components = [bundleID componentsSeparatedByString:@"."];

		if(components.count >= 2) {

			self.authURL = [NSString stringWithFormat:@"%@.%@", components[1], components[0]];
		}
	}
}

+ (BOOL)classExistsInApp:(Class)clazz {

	int count = 0;

	for(NSBundle *bundle in [NSBundle allBundles]) {

		if([bundle classNamed:NSStringFromClass(clazz)]) {

			if(![bundle isEqual:[NSBundle bundleForClass:[self class]]]) {

				count++;
			}
		}
	}

	for(NSBundle *bundle in [NSBundle allFrameworks]) {

		if([bundle classNamed:NSStringFromClass(clazz)]) {

			if(![bundle isEqual:[NSBundle bundleForClass:[self class]]]) {

				count++;
			}
		}
	}

	return count > 0;
}

- (void)injectButtonIntoPasswordField:(UITextField *)textField viewController:(UIViewController *)viewController {

	if([[OnePasswordExtension sharedExtension] isAppExtensionAvailable] &&
		![[self class]classExistsInApp:[%c(OPPasswordEntryView) class]]) {

		InjectionButton *button = [InjectionButton buttonWithType:UIButtonTypeSystem];
		[button addTarget:self action:@selector(onePasswordButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[button setImage:[self buttonImage] forState:UIControlStateNormal];

		button.alpha = 0;

		[textField addSubview:button];

		[UIView animateWithDuration:0.4 animations:^{

			button.alpha = 1;
		}];
	}
}

- (UIImage *)buttonImage {

	NSBundle *bundle = [[NSBundle alloc] initWithPath:kBundlePath];

	UIImage *image = [UIImage imageNamed:kButtonImageName inBundle:bundle compatibleWithTraitCollection:nil];

	return image;
}

- (void)onePasswordButtonPressed:(InjectionButton *)sender {

	[((UIViewController *)[sender traverseResponderChainForUIViewController]).view endEditing:YES];

	UIAlertView *alert = [[UIAlertView alloc] init];
	alert.title = self.authURL;
	alert.message = @"Is this the right Auth URL?";
	[alert addButtonWithTitle:@"No"];
	[alert addButtonWithTitle:@"Yes"];

	[alert showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {

		if([[alert buttonTitleAtIndex:buttonIndex] isEqualToString:@"Yes"]) {

			[self fireOnePasswordExtension:sender];
		}
		else {

			[self changeAuthURL:sender];
		}
	}];
}

- (void)changeAuthURL:(InjectionButton *)sender {

	UIAlertView *alert = [[UIAlertView alloc] init];
	alert.title = @"Change Auth URL";
	alert.message = @"Please enter the proper auth URL:";
	alert.alertViewStyle = UIAlertViewStylePlainTextInput;
	[alert addButtonWithTitle:@"Cancel"];
	[alert addButtonWithTitle:@"Change"];

	UITextField *textField = [alert textFieldAtIndex:0];
	[textField becomeFirstResponder];

	[alert showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {

		if([[alert buttonTitleAtIndex:buttonIndex] isEqualToString:@"Change"]) {

			self.authURL = textField.text;
			[[NSUserDefaults standardUserDefaults] setObject:self.authURL forKey:kOnePasswordInjectorAuthURLKey];

			[self fireOnePasswordExtension:sender];
		}
	}];
}

- (void)fireOnePasswordExtension:(InjectionButton *)sender {

    [[OnePasswordExtension sharedExtension] findLoginForURLString:self.authURL forViewController:[sender traverseResponderChainForUIViewController] sender:sender completion:^(NSDictionary *loginDict, NSError *error) {
        
        if(!loginDict) {
            
            if(error.code != AppExtensionErrorCodeCancelledByUser) {
                
                NSLog(@"Error invoking 1Password App Extension for find login: %@", error);
            }
            
            return;
        }

        UITextField *passwordField = (UITextField *)sender.superview;

		[passwordField setText:loginDict[AppExtensionPasswordKey] animated:YES];
		[[UIPasteboard generalPasteboard] setString:(NSString *)loginDict[AppExtensionUsernameKey]];
    }];
}

@end
