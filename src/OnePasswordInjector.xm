#import <UIKit/UIKit.h>

#import "OnePasswordInjector.h"

#import "onepassword-app-extension/OnePasswordExtension.h"
#import "OPInjectionButton.h"

#import "categories/UITextField+HumanInput.h"
#import "categories/UIAlertView+Blocks.h"
#import "categories/UIView+FindViewController.h"

static NSString * const kBundlePath = @"/Library/MobileSubstrate/DynamicLibraries/1passwordinjector_bundle.bundle";

static NSString * const kButtonImageName = @"onepassword-button";

static NSString * const kOnePasswordInjectorAuthURLKey = @"kOnePasswordInjectorAuthURLKey";
static NSString * const kOnePasswordInjectorAuthURLVerified = @"kOnePasswordInjectorAuthURLVerified";

@implementation OnePasswordInjector

+ (instancetype)sharedInjector {

	static OnePasswordInjector *sharedInjector;
	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{

		if([self shouldInject]) {

			sharedInjector = [[OnePasswordInjector alloc] init];
		}
	});

	return sharedInjector;
}

+ (BOOL)shouldInject {

	// We should only inject if the app extension is available 
	// AND the app doesn't already contain the `OnePasswordExtension` class
	// AND the app doesn't contain the `OPPasswordEntryView` class (i.e. it is the 1Password app itself)

	return [[OnePasswordExtension sharedExtension] isAppExtensionAvailable] &&
			![self classExistsInApp:[OnePasswordExtension class]] &&
			![[self class]classExistsInApp:[%c(OPPasswordEntryView) class]];
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

- (void)injectButtonIntoPasswordField:(UITextField *)textField {

	OPInjectionButton *button = [OPInjectionButton buttonWithType:UIButtonTypeSystem];
	[button addTarget:self action:@selector(onePasswordButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[button setImage:[self buttonImage] forState:UIControlStateNormal];

	[textField addSubview:button];
}

- (UIImage *)buttonImage {

	NSBundle *bundle = [[NSBundle alloc] initWithPath:kBundlePath];

	UIImage *image = [UIImage imageNamed:kButtonImageName inBundle:bundle compatibleWithTraitCollection:nil];

	return image;
}

- (void)onePasswordButtonPressed:(OPInjectionButton *)sender {

	if(![[NSUserDefaults standardUserDefaults] boolForKey:kOnePasswordInjectorAuthURLVerified]) {

		[((UIViewController *)[sender traverseResponderChainForUIViewController]).view endEditing:YES];

		UIAlertView *alert = [[UIAlertView alloc] init];
		alert.title = self.authURL;
		alert.message = @"Is this the right Auth URL?";
		[alert addButtonWithTitle:@"No"];
		[alert addButtonWithTitle:@"Yes"];
		[alert addButtonWithTitle:@"Remember"];

		[alert showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {

			if([[alert buttonTitleAtIndex:buttonIndex] isEqualToString:@"Yes"]) {

				[self fireOnePasswordExtension:sender];
			}
			else if([[alert buttonTitleAtIndex:buttonIndex] isEqualToString:@"Remember"]) {

				[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kOnePasswordInjectorAuthURLVerified];
				[self fireOnePasswordExtension:sender];
			}
			else {

				[self changeAuthURL:sender];
			}
		}];
	}
	else {

		[self fireOnePasswordExtension:sender];
	}
}

- (void)changeAuthURL:(OPInjectionButton *)sender {

	UIAlertView *alert = [[UIAlertView alloc] init];
	alert.title = @"Change Auth URL";
	alert.message = @"Please enter the proper auth URL:";
	alert.alertViewStyle = UIAlertViewStylePlainTextInput;
	[alert addButtonWithTitle:@"Cancel"];
	[alert addButtonWithTitle:@"Change Once"];
	[alert addButtonWithTitle:@"Change Forever"];

	UITextField *textField = [alert textFieldAtIndex:0];
	[textField becomeFirstResponder];

	[alert showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {

		if([[alert buttonTitleAtIndex:buttonIndex] isEqualToString:@"Change Once"]) {

			self.authURL = textField.text;
			[[NSUserDefaults standardUserDefaults] setObject:self.authURL forKey:kOnePasswordInjectorAuthURLKey];

			[self fireOnePasswordExtension:sender];
		}
		else if([[alert buttonTitleAtIndex:buttonIndex] isEqualToString:@"Change Forever"]) {

			self.authURL = textField.text;

			[[NSUserDefaults standardUserDefaults] setObject:self.authURL forKey:kOnePasswordInjectorAuthURLKey];
			[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kOnePasswordInjectorAuthURLVerified];

			[self fireOnePasswordExtension:sender];
		}
	}];
}

- (void)fireOnePasswordExtension:(OPInjectionButton *)sender {

    [[OnePasswordExtension sharedExtension] findLoginForURLString:self.authURL forViewController:[sender traverseResponderChainForUIViewController] sender:sender completion:^(NSDictionary *loginDict, NSError *error) {
        
        if(!loginDict) {
            
            if(error.code != AppExtensionErrorCodeCancelledByUser) {
                
                NSLog(@"Error invoking 1Password App Extension for find login: %@", error);
            }
            
            return;
        }

        UITextField *passwordField = (UITextField *)sender.superview;
        [passwordField simulateHumanInput:loginDict[AppExtensionPasswordKey]];

		[[UIPasteboard generalPasteboard] setString:(NSString *)loginDict[AppExtensionUsernameKey]];
    }];
}

@end
