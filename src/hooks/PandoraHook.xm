#import "PandoraHook.h"
#import "../OnePasswordInjector.h"
#import "../UITextField+Transition.h"

%hook PMOnboardingController

- (void)viewDidAppear:(BOOL)animated {

	%orig(animated);

	[OnePasswordInjector injectButtonIntoPasswordField:self.passwordCell.textField viewController:self];
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
        
        [self.emailCell.textField setText:loginDict[AppExtensionUsernameKey] animated:YES];
        [self.passwordCell.textField setText:loginDict[AppExtensionPasswordKey] animated:YES];
        self.normalSignInButton.enabled = YES;
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    %orig(touches, event);

    [self.view endEditing:YES];
}

%end
