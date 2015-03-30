export ARCHS = armv7 armv7s arm64
export TARGET = iphone:latest:8.1

TWEAK_NAME = 1passwordinjector

# Tweak/Hook
1passwordinjector_FILES = src/OnePasswordInjector.xm
1passwordinjector_FILES += src/UITextFieldHooks.xm

# Obj-C Requirements
1passwordinjector_FILES += src/onepassword-app-extension/OnePasswordExtension.m
1passwordinjector_FILES += src/OPInjectionButton.m

# Categories
1passwordinjector_FILES += src/categories/UITextField+HumanInput.m
1passwordinjector_FILES += src/categories/UIAlertView+Blocks.m
1passwordinjector_FILES += src/categories/UIView+FindViewController.m

1passwordinjector_FRAMEWORKS = UIKit WebKit MobileCoreServices CoreGraphics

BUNDLE_NAME = 1passwordinjector_bundle
1passwordinjector_bundle_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries

include theos/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include theos/makefiles/bundle.mk

