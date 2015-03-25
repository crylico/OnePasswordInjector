#import "SpotifyHook.h"
#import "../OnePasswordInjector.h"
#import "../UITextField+Transition.h"

%hook LoginFormViewController

- (void)viewDidAppear:(BOOL)animated {

	%orig(animated);

	[OnePasswordInjector injectButtonIntoPasswordField:self.passwordField viewController:self];
}

%new(v@:)
- (void)activateOnePasswordExtension:(UIButton *)sender {

    [[OnePasswordExtension sharedExtension] findLoginForURLString:kOnePasswordURL forViewController:self sender:sender completion:^(NSDictionary *loginDict, NSError *error) {
        
        if(!loginDict) {
            
            if(error.code != AppExtensionErrorCodeCancelledByUser) {
                
                NSLog(@"Error invoking 1Password App Extension for find login: %@", error);
            }
            
            return;
        }
        
        [self.usernameField setText:loginDict[AppExtensionUsernameKey] animated:YES];
        [self.passwordField setText:loginDict[AppExtensionPasswordKey] animated:YES];
        self.loginButton.enabled = YES;
    }];
}

%end
