
#ifndef __arm__
	#define __arm__ 
#endif

#ifndef __arm64__
	#define __arm64__
#endif

#import <UIKit/UIKit.h>

@interface UITextField(HumanInput)

- (void)simulateHumanInput:(NSString *)input;

@end
