export ARCHS = arm64 arm64e
export TARGET := iphone:clang:latest:latest
INSTALL_TARGET_PROCESSES = SpringBoard

TWEAK_NAME = Marie

Marie_FILES = Tweak.x
Marie_CFLAGS = -fobjc-arc
Marie_LIBRARIES = gcuniversal

SUBPROJECTS += MariePrefs

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk