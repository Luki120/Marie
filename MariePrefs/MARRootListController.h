#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSListController.h>


@interface MarieTableCell : PSTableCell
@end


@interface MARRootListController : PSListController
@property (nonatomic, retain) NSMutableDictionary *savedSpecifiers;
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