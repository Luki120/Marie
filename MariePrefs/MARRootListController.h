#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSListController.h>
#import <AudioToolbox/AudioServices.h>
#import <spawn.h>


static NSString *const prefsKeys = @"/var/mobile/Library/Preferences/me.luki.marieprefs.plist";

#define tint [UIColor colorWithRed: 0.95 green: 0.46 blue: 0.60 alpha: 1.00]


@interface OBButtonTray : UIView
@property (nonatomic, strong) UIVisualEffectView *effectView;
- (void)addButton:(id)arg1;
- (void)addCaptionText:(id)arg1;
@end


@interface OBBoldTrayButton : UIButton
+ (id)buttonWithType:(long long)arg1;
- (void)setTitle:(id)arg1 forState:(unsigned long long)arg2;
@end


@interface OBWelcomeController : UIViewController
@property (nonatomic, strong) UIView *viewIfLoaded;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (assign, nonatomic) BOOL _shouldInlineButtontray;
- (OBButtonTray *)buttonTray;
- (id)initWithTitle:(id)arg1 detailText:(id)arg2 icon:(id)arg3;
- (void)addBulletedListItemWithTitle:(id)arg1 description:(id)arg2 image:(id)arg3;
@end


@interface _UIBackdropViewSettings : NSObject
+ (id)settingsForStyle:(long long)arg1;
@end


@interface _UIBackdropView : UIView
- (id)initWithSettings:(id)arg1;
- (id)initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(id)arg3;
@property (assign, nonatomic) BOOL blurRadiusSetOnce;
@property (assign, nonatomic) double _blurRadius;
@property (copy, nonatomic) NSString *_blurQuality;
@end


@interface MarieTableCell : PSTableCell
@end


@interface MARRootListController : PSListController {

	UITableView *_table;

}

@property (nonatomic, strong) OBWelcomeController *changelogController;
@property (nonatomic, strong) NSMutableDictionary *savedSpecifiers;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIImageView *headerImageView;
@end


@interface MarieContributorsRootListController : PSListController
@end


@interface MarieLinksRootListController : PSListController
@end


@interface PSListController (Private)
- (BOOL)containsSpecifier:(PSSpecifier *)arg1;
@end


@interface NSDistributedNotificationCenter : NSNotificationCenter
+ (instancetype)defaultCenter;
- (void)postNotificationName:(NSString *)name object:(NSString *)object userInfo:(NSDictionary *)userInfo;
@end
