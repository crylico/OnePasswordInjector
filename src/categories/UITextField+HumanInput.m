#import "UITextField+HumanInput.h"

@implementation UITextField(HumanInput)

- (void)simulateHumanInput:(NSString *)input {

    // First clear the textfield (self)
    self.text = @"";

    // Make the textfield become first responder so that it's in `editing` mode
    [self becomeFirstResponder];

    // Insert the string in the same way the keyboard would so that delegate methods get called as appropriate
    [self insertText:input];

    // resign first responder since we're done editing
    [self resignFirstResponder];
    
    // In case the app's textfield overrides the -setText: function, set the text explicitly.
    [self setText:input];
}

@end
