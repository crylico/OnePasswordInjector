export ARCHS = armv7 armv7s arm64
export TARGET = iphone:latest:8.1

TWEAK_NAME = 1passwordinjector
1passwordinjector_FILES = src/OnePasswordInjector.xm src/UITextField/UITextField+OnePasswordInjection.m src/onepassword-app-extension/OnePasswordExtension.m src/OPInjectionButton.m src/UITextField/UITextFieldHooks.xm
1passwordinjector_FRAMEWORKS = UIKit WebKit MobileCoreServices CoreGraphics

BUNDLE_NAME = 1passwordinjector_bundle
1passwordinjector_bundle_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries

include theos/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include theos/makefiles/bundle.mk

