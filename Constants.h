@import UIKit;
#import <GcUniversal/GcImagePickerUtils.h>


static NSString *const kPath = @"/var/mobile/Library/Preferences/me.luki.marieprefs.plist";
static NSString *const kDefaults = @"me.luki.marieprefs";
static NSString *const kImagesPath = @"/var/mobile/Library/Preferences/me.luki.marieprefs/";
#define kMarieTintColor [UIColor colorWithRed: 0.95 green: 0.46 blue: 0.60 alpha: 1.0]
#define kUserInterfaceStyle UIScreen.mainScreen.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark


// common

@interface NSDistributedNotificationCenter : NSNotificationCenter
@end
