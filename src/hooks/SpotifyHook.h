
#import <UIKit/UIKit.h>

static NSString * const kOnePasswordURL = @"https://spotify.com";

@interface SPFormTextField : UITextField
@end

@interface SPTActionButton : UIButton
@end

@interface LoginFormViewController : UIViewController

- (SPFormTextField *)passwordField;
- (SPFormTextField *)usernameField;
- (SPTActionButton *)loginButton;

@end
