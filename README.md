#Universal 1Password Injector

This tweak injects the 1Password extension into any secure-entry `UITextField`.

The 'starting' place for this tweak is in `src/UITextFieldHooks.xm`, but most of the interesting stuff happens in `OnePasswordInjector.xm`.

Special thanks to the awesome guys at [1Password](https://agilebits.com) and the other awesome guys who make [Reveal](https://ittybittyapps.com). Without Reveal, I'd have spent triple the time I did.

#Usage

Any secure `UITextField` gets injected with the injection button.  Once you've retrieved your password using the extension, the password field will be automatically populated and your username will be copied to the device's clipboard so you can paste it into the username field.

There are no options to configure. (yet!)


#Installation

Install my fork of theos or equivalent, then `make package install`
