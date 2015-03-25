#import <UIKit/UIKit.h>

static NSString * const kOnePasswordURL = @"https://pandora.com";

@interface PMOnboardingTextCell : UITableViewCell

- (UITextField *)textField;

@end

@interface PMOnboardingTextField : UITextField
@end

@interface PMOnboardingController : UIViewController

- (void)setPasswordCell:(PMOnboardingTextCell *)passwordCell;

- (PMOnboardingTextCell *)emailCell;
- (PMOnboardingTextCell *)passwordCell;
- (UIButton *)normalSignInButton;

@end
