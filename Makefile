export TARGET := iphone:clang:latest:latest
INSTALL_TARGET_PROCESSES = SpringBoard

TWEAK_NAME = Marie

Marie_FILES = Marie.m
Marie_CFLAGS = -fobjc-arc
Marie_LIBRARIES = gcuniversal

SUBPROJECTS = MariePrefs

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
