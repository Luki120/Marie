#include "MARRootListController.h"


static void postNSNotification() {

	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"dialerImageApplied" object:nil];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"passcodeImageApplied" object:nil];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"shareSheetImageApplied" object:nil];

}


@implementation MARRootListController


- (NSArray *)specifiers {

	if(!_specifiers) {

		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
		
		NSArray *chosenIDs = @[@"GroupCell1", @"DialerImage", @"PasscodeImage", @"ShareSheetImage", @"GroupCell2", @"DialerLightImage", @"PasscodeLightImage", @"ShareSheetLightImage"];
		self.savedSpecifiers = (self.savedSpecifiers) ?: [NSMutableDictionary new];

		for(PSSpecifier *specifier in _specifiers)

			if([chosenIDs containsObject:[specifier propertyForKey:@"id"]])

				[self.savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];

	}

	return _specifiers;

}


- (instancetype)init {

	self = [super init];

	if(self) {

		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)postNSNotification, CFSTR("me.luki.marieprefs/dialerImageChanged"), NULL, 0);
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)postNSNotification, CFSTR("me.luki.marieprefs/passcodeImageChanged"), NULL, 0);
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)postNSNotification, CFSTR("me.luki.marieprefs/shareSheetImageChanged"), NULL, 0);

		UIImage *banner = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/MariePrefs.bundle/Assets/MarieBanner.png"];
		UIImage *icon = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/MariePrefs.bundle/Assets/Marie@2x.png"];

		self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,200,200)];
		self.headerImageView = [UIImageView new];
		self.headerImageView.image = banner;
		self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
		self.headerImageView.translatesAutoresizingMaskIntoConstraints = NO;
		[self.headerView addSubview:self.headerImageView];

		self.navigationItem.titleView = [UIView new];
		self.iconView = [UIImageView new];
		self.iconView.alpha = 1;
		self.iconView.image = icon;
		self.iconView.contentMode = UIViewContentModeScaleAspectFit;
		self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
		[self.navigationItem.titleView addSubview:self.iconView];

		UILabel *versionLabel = [UILabel new];
		versionLabel.text = @"Marie 1.0.3";
		versionLabel.font = [UIFont boldSystemFontOfSize:12];
		versionLabel.textAlignment = NSTextAlignmentCenter;
		versionLabel.translatesAutoresizingMaskIntoConstraints = NO;
		[self.navigationItem.titleView addSubview:versionLabel];

		UIButton *changelogButton =  [UIButton buttonWithType:UIButtonTypeCustom];
		changelogButton.tintColor = tint;
		[changelogButton setImage : [UIImage systemImageNamed:@"atom"] forState:UIControlStateNormal];
		[changelogButton addTarget : self action:@selector(showWtfChangedInThisVersion:) forControlEvents:UIControlEventTouchUpInside];

		UIBarButtonItem *changelogButtonItem = [[UIBarButtonItem alloc] initWithCustomView:changelogButton];
		self.navigationItem.rightBarButtonItem = changelogButtonItem;

		[NSLayoutConstraint activateConstraints:@[

			[self.headerImageView.topAnchor constraintEqualToAnchor:self.headerView.topAnchor],
			[self.headerImageView.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor],
			[self.headerImageView.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor],
			[self.headerImageView.bottomAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],
			[self.iconView.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor constant : -12],
			[self.iconView.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
			[self.iconView.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
			[self.iconView.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],
			[versionLabel.topAnchor constraintEqualToAnchor:self.iconView.bottomAnchor],
			[versionLabel.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
			[versionLabel.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],

		]];

		_table.tableHeaderView = self.headerView;

	}

	return self;

}


- (void)showWtfChangedInThisVersion:(id)sender {

	AudioServicesPlaySystemSound(1521);

	self.changelogController = [[OBWelcomeController alloc] initWithTitle:@"Marie" detailText:@"1.0.3" icon:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/MariePrefs.bundle/Assets/MarieIcon.png"]];

	[self.changelogController addBulletedListItemWithTitle:@"Tweak" description:@"Added light mode images." image:[UIImage systemImageNamed:@"checkmark.circle.fill"]];

	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

	_UIBackdropView *backdropView = [[_UIBackdropView alloc] initWithSettings:settings];
	backdropView.clipsToBounds = YES;
	backdropView.layer.masksToBounds = YES;
	backdropView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.changelogController.viewIfLoaded insertSubview:backdropView atIndex:0];

	[backdropView.bottomAnchor constraintEqualToAnchor : self.changelogController.viewIfLoaded.bottomAnchor].active = YES;
	[backdropView.leadingAnchor constraintEqualToAnchor : self.changelogController.viewIfLoaded.leadingAnchor].active = YES;
	[backdropView.trailingAnchor constraintEqualToAnchor : self.changelogController.viewIfLoaded.trailingAnchor].active = YES;
	[backdropView.topAnchor constraintEqualToAnchor : self.changelogController.viewIfLoaded.topAnchor].active = YES;

	self.changelogController.modalInPresentation = NO;
	self.changelogController.modalPresentationStyle = UIModalPresentationPageSheet;
	self.changelogController.view.tintColor = tint;
	self.changelogController.viewIfLoaded.backgroundColor = UIColor.clearColor;
	[self presentViewController:self.changelogController animated:YES completion:nil];

}


- (void)dismissVC {

	[self.changelogController dismissViewControllerAnimated:YES completion:nil];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	tableView.tableHeaderView = self.headerView;
	return [super tableView:tableView cellForRowAtIndexPath:indexPath];

}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

	CGFloat offsetY = scrollView.contentOffset.y;

	if(offsetY > 0) offsetY = 0;

	self.headerImageView.frame = CGRectMake(0, offsetY, self.headerView.frame.size.width, 200 - offsetY);

}


- (void)reloadSpecifiers {

	[super reloadSpecifiers];

	if(![[self readPreferenceValue:[self specifierForID:@"EnableSwitch"]] boolValue])

		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell1"], self.savedSpecifiers[@"DialerImage"], self.savedSpecifiers[@"PasscodeImage"], self.savedSpecifiers[@"ShareSheetImage"], self.savedSpecifiers[@"GroupCell2"], self.savedSpecifiers[@"DialerLightImage"], self.savedSpecifiers[@"PasscodeLightImage"], self.savedSpecifiers[@"ShareSheetLightImage"]] animated:NO];


	else if(![self containsSpecifier:self.savedSpecifiers[@"GroupCell1"]])

		[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell1"], self.savedSpecifiers[@"DialerImage"], self.savedSpecifiers[@"PasscodeImage"], self.savedSpecifiers[@"ShareSheetImage"], self.savedSpecifiers[@"GroupCell2"], self.savedSpecifiers[@"DialerLightImage"], self.savedSpecifiers[@"PasscodeLightImage"], self.savedSpecifiers[@"ShareSheetLightImage"]] afterSpecifierID:@"EnableSwitch" animated:NO];


}


- (void)viewDidLoad {

	[super viewDidLoad];
	[self reloadSpecifiers];

}


- (id)readPreferenceValue:(PSSpecifier*)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:prefsKeys]];
	return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];

}


- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
 
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:prefsKeys]];
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:prefsKeys atomically:YES];

	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"dialerImageApplied" object:nil];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"passcodeImageApplied" object:nil];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"shareSheetImageApplied" object:nil];

	NSString *key = [specifier propertyForKey:@"key"];

	if([key isEqualToString:@"yes"]) {
	
		if(![[self readPreferenceValue:[self specifierForID:@"EnableSwitch"]] boolValue])

			[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell1"], self.savedSpecifiers[@"DialerImage"], self.savedSpecifiers[@"PasscodeImage"], self.savedSpecifiers[@"ShareSheetImage"], self.savedSpecifiers[@"GroupCell2"], self.savedSpecifiers[@"DialerLightImage"], self.savedSpecifiers[@"PasscodeLightImage"], self.savedSpecifiers[@"ShareSheetLightImage"]] animated:YES];


		else if(![self containsSpecifier:self.savedSpecifiers[@"GroupCell1"]])

			[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell1"], self.savedSpecifiers[@"DialerImage"], self.savedSpecifiers[@"PasscodeImage"], self.savedSpecifiers[@"ShareSheetImage"], self.savedSpecifiers[@"GroupCell2"], self.savedSpecifiers[@"DialerLightImage"], self.savedSpecifiers[@"PasscodeLightImage"], self.savedSpecifiers[@"ShareSheetLightImage"]] afterSpecifierID:@"EnableSwitch" animated:YES];

	}

}


- (void)shatterThePrefsToPieces {

	AudioServicesPlaySystemSound(1521);

	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Marie" message:@"Do you wish to bring these images to the ground, punch them, destroy them and build some new ones upon a fresh respring?" preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Heck yeah" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {

		NSFileManager *fileManager = [NSFileManager defaultManager];

		BOOL success = [fileManager removeItemAtPath:@"var/mobile/Library/Preferences/me.luki.marieprefs.plist" error:nil];
		BOOL successTwo = [fileManager removeItemAtPath:@"var/mobile/Library/Preferences/me.luki.marieprefs" error:nil];
		
		if((success) || (successTwo)) [self blurEffect];

	}];

	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Later" style:UIAlertActionStyleCancel handler:nil];

	[alertController addAction:confirmAction];
	[alertController addAction:cancelAction];

	[self presentViewController:alertController animated:YES completion:nil];

}


- (void)blurEffect {

	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

	_UIBackdropView *backdropView = [[_UIBackdropView alloc] initWithSettings:settings];
	backdropView.alpha = 0;
	backdropView.frame = self.view.bounds;
	backdropView.clipsToBounds = YES;
	backdropView.layer.masksToBounds = YES;
	[self.view addSubview:backdropView];

	[UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

		backdropView.alpha = 1;

	} completion:^(BOOL finished) {

		[self resetPrefs];

	}];

}


- (void)resetPrefs {

	pid_t pid;
	const char* args[] = {"sbreload", NULL, NULL, NULL};
	posix_spawn(&pid, "/usr/bin/sbreload", NULL, NULL, (char* const*)args, NULL);

}


@end


@implementation MarieContributorsRootListController


- (NSArray *)specifiers {

	if(!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"MarieContributors" target:self];

	return _specifiers;

}


@end


@implementation MarieLinksRootListController


- (NSArray *)specifiers {

	if(!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"MarieLinks" target:self];

	return _specifiers;

}


- (void)discord {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://discord.gg/jbE3avwSHs"] options:@{} completionHandler:nil];

}


- (void)paypal {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://paypal.me/Luki120"] options:@{} completionHandler:nil];

}


- (void)github {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://github.com/Luki120/Marie"] options:@{} completionHandler:nil];

}


- (void)elixir {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://luki120.github.io/depictions/web/?p=me.luki.elixir"] options:@{} completionHandler:nil];

}


- (void)meredith {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://repo.twickd.com/get/com.twickd.luki120.meredith"] options:@{} completionHandler:nil];

}


@end


@implementation MarieTableCell


- (void)tintColorDidChange {

    [super tintColorDidChange];

    self.textLabel.textColor = tint;
    self.textLabel.highlightedTextColor = tint;

}


- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {

    [super refreshCellContentsWithSpecifier:specifier];

    if([self respondsToSelector:@selector(tintColor)]) {

        self.textLabel.textColor = tint;
        self.textLabel.highlightedTextColor = tint;

    }

}


@end
