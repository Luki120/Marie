@import AudioToolbox.AudioServices;
@import ObjectiveC.message;
@import ObjectiveC.runtime;
@import Preferences.PSSpecifier;
@import Preferences.PSTableCell;
@import Preferences.PSListController;
#import <notify.h>
#import <spawn.h>
#import "../Headers/Common.h"


@interface OBWelcomeController : UIViewController
- (id)initWithTitle:(id)arg1 detailText:(id)arg2 icon:(id)arg3;
- (void)addBulletedListItemWithTitle:(id)arg1 description:(id)arg2 image:(id)arg3;
@end


@interface _UIBackdropViewSettings : NSObject
+ (id)settingsForStyle:(NSInteger)arg1;
@end


@interface _UIBackdropView : UIView
- (id)initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(id)arg3;
@end


@interface MarieVC : PSListController
@end


@interface MarieContributorsVC : PSListController
@end


@interface MarieLinksVC : PSListController
@end


@interface PSListController ()
- (BOOL)containsSpecifier:(PSSpecifier *)arg1;
@end
