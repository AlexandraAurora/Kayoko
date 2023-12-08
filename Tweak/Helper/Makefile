TWEAK_NAME = KayokoHelper
KayokoHelper_FILES = KayokoHelper.m $(wildcard ../../Manager/*.m ../../Utils/*.m)
KayokoHelper_CFLAGS = -fobjc-arc -DTHEOS_LEAN_AND_MEAN
KayokoHelper_FRAMEWORKS = UIKit
KayokoHelper_LIBRARIES = Sandy

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
include $(THEOS_MAKE_PATH)/tweak.mk
