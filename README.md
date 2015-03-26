#Universal 1Password Injector

This tweak injects the 1Password extension into any secure-entry `UITextField`.

The 'starting' place for this tweak is in `UITextField/UITextFieldHooks.xm`, but most of the interesting stuff happens in `OnePasswordInjector.xm`.

Special thanks to the awesome guys at [1Password](https://agilebits.com) and the other awesome guys who make [Reveal](https://ittybittyapps.com). Without Reveal, I'd have spent triple the time I did.


#Installation

Install my fork of theos or equivalent, then `make package install`

#Side Note

`UITextField+OnePasswordInjection.(h)(xm)` is a very busy file (3 categories on 3 different classes), so I'll make that sane at some point.


