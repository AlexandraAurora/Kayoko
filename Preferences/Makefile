BUNDLE_NAME = KayokoPreferences
KayokoPreferences_FILES = $(wildcard Controllers/*.m Cells/*.m ../Manager/*.m) $(wildcard ../Utils/*.m)
KayokoPreferences_FRAMEWORKS = UIKit
KayokoPreferences_PRIVATE_FRAMEWORKS = Preferences
KayokoPreferences_INSTALL_PATH = /Library/PreferenceBundles
KayokoPreferences_CFLAGS = -fobjc-arc -DTHEOS_LEAN_AND_MEAN

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/bundle.mk
