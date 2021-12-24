#import "../Constants.h"
#import <spawn.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
#import <AudioToolbox/AudioServices.h>
#import <Preferences/PSListController.h>


@interface OBWelcomeController : UIViewController
@property (assign, nonatomic) BOOL _shouldInlineButtontray;
- (id)initWithTitle:(id)arg1 detailText:(id)arg2 icon:(id)arg3;
- (void)addBulletedListItemWithTitle:(id)arg1 description:(id)arg2 image:(id)arg3;
@end


@interface _UIBackdropViewSettings : NSObject
+ (id)settingsForStyle:(long long)arg1;
@end


@interface _UIBackdropView : UIView
- (id)initWithSettings:(id)arg1;
@end


@interface MarieVC : PSListController
@end


@interface MarieContributorsVC : PSListController
@end


@interface MarieLinksVC : PSListController
@end


@interface PSTableCell ()
- (void)setTitle:(NSString *)t;
@end


@interface MarieTintCell : PSTableCell
@end


@interface PSListController (Private)
- (BOOL)containsSpecifier:(PSSpecifier *)arg1;
@end
