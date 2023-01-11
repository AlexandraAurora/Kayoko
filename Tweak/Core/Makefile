TWEAK_NAME = KayokoCore
KayokoCore_FILES = KayokoCore.m $(wildcard ../../Manager/*.m Views/*.m ../../Utils/*.m)
KayokoCore_CFLAGS = -fobjc-arc -DTHEOS_LEAN_AND_MEAN
KayokoCore_FRAMEWORKS = UIKit AudioToolbox
KayokoCore_EXTRA_FRAMEWORKS = Cephei

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
include $(THEOS_MAKE_PATH)/tweak.mk
