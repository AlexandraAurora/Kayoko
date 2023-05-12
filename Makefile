export ARCHS = arm64 arm64e
export SYSROOT = $(THEOS)/sdks/iPhoneOS14.4.sdk

ifneq ($(THEOS_PACKAGE_SCHEME), rootless)
export TARGET = iphone:clang:14.4:13.0
export PREFIX = $(THEOS)/toolchain/Xcode.xctoolchain/usr/bin/
else
export TARGET = iphone:clang:14.4:15.0
endif

INSTALL_TARGET_PROCESSES = SpringBoard
SUBPROJECTS = Tweak/Core Tweak/Helper Daemon Preferences

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
