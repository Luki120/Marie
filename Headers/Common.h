#import <rootless.h>

#define rootlessPathC(cPath) ROOT_PATH(cPath)
#define rootlessPathNS(path) ROOT_PATH_NS(path)

static NSString *const kPath = rootlessPathNS(@"/var/mobile/Library/Preferences/me.luki.marieprefs.plist");

static NSNotificationName const MarieApplyDialerImageNotification = @"MarieApplyDialerImageNotification";
static NSNotificationName const MarieApplyPasscodeImageNotification = @"MarieApplyPasscodeImageNotification";
static NSNotificationName const MarieApplyShareSheetImageNotification = @"MarieApplyShareSheetImageNotification";

@interface NSDistributedNotificationCenter : NSNotificationCenter
@end
