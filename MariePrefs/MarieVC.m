#import "MarieVC.h"


@implementation MarieVC {

	UITableView *_table;
	UIImageView *iconView;
	UILabel *versionLabel;
	UIStackView *navBarStackView;
	UIView *headerView;
	UIImageView *headerImageView;
	NSMutableDictionary *savedSpecifiers;
	OBWelcomeController *changelogController;

}


#pragma mark Lifecycle

- (NSArray *)specifiers {

	if(!_specifiers) {

		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];

		NSArray *chosenIDs = @[

			@"GroupCell1",
			@"DialerImage",
			@"PasscodeImage",
			@"ShareSheetImage",
			@"GroupCell2", 
			@"DialerLightImage", 
			@"PasscodeLightImage",
			@"ShareSheetLightImage"

		];

		savedSpecifiers = (savedSpecifiers) ?: [NSMutableDictionary new];

		for(PSSpecifier *specifier in _specifiers)

			if([chosenIDs containsObject:[specifier propertyForKey:@"id"]])

				[savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];

	}

	return _specifiers;

}


- (id)init {

	self = [super init];

	if(self) {

		[self setupUI];

		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)postNSNotification, CFSTR("me.luki.marieprefs/dialerImageChanged"), NULL, 0);
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)postNSNotification, CFSTR("me.luki.marieprefs/passcodeImageChanged"), NULL, 0);
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)postNSNotification, CFSTR("me.luki.marieprefs/shareSheetImageChanged"), NULL, 0);

	}

	return self;

}


- (void)viewDidLoad {

	[super viewDidLoad];
	[self reloadSpecifiers];

}


- (void)reloadSpecifiers {

	[super reloadSpecifiers];

	if(![[self readPreferenceValue:[self specifierForID:@"EnableSwitch"]] boolValue])

		[self removeContiguousSpecifiers:@[savedSpecifiers[@"GroupCell1"], savedSpecifiers[@"DialerImage"], savedSpecifiers[@"PasscodeImage"], savedSpecifiers[@"ShareSheetImage"], savedSpecifiers[@"GroupCell2"], savedSpecifiers[@"DialerLightImage"], savedSpecifiers[@"PasscodeLightImage"], savedSpecifiers[@"ShareSheetLightImage"]] animated:NO];

	else if(![self containsSpecifier:savedSpecifiers[@"GroupCell1"]])

		[self insertContiguousSpecifiers:@[savedSpecifiers[@"GroupCell1"], savedSpecifiers[@"DialerImage"], savedSpecifiers[@"PasscodeImage"], savedSpecifiers[@"ShareSheetImage"], savedSpecifiers[@"GroupCell2"], savedSpecifiers[@"DialerLightImage"], savedSpecifiers[@"PasscodeLightImage"], savedSpecifiers[@"ShareSheetLightImage"]] afterSpecifierID:@"EnableSwitch" animated:NO];

}


- (void)setupUI {

	UIImage *iconImage = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/MariePrefs.bundle/Assets/Marie@2x.png"];
	UIImage *bannerImage = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/MariePrefs.bundle/Assets/MarieBanner.png"];
	UIImage *changelogButtonImage = [UIImage systemImageNamed:@"atom"];

	self.navigationItem.titleView = [UIView new];

	navBarStackView = [UIStackView new];
	navBarStackView.axis = UILayoutConstraintAxisVertical;
	navBarStackView.spacing = 0.5;
	navBarStackView.alignment = UIStackViewAlignmentCenter;
	navBarStackView.distribution = UIStackViewDistributionFill;
	navBarStackView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.navigationItem.titleView addSubview:navBarStackView];

	iconView = [UIImageView new];
	iconView.image = iconImage;
	iconView.contentMode = UIViewContentModeScaleAspectFit;
	iconView.translatesAutoresizingMaskIntoConstraints = NO;
	[navBarStackView addArrangedSubview:iconView];

	versionLabel = [UILabel new];
	versionLabel.text = @"Marie 1.0.4";
	versionLabel.font = [UIFont boldSystemFontOfSize:12];
	versionLabel.textAlignment = NSTextAlignmentCenter;
	[navBarStackView addArrangedSubview:versionLabel];

	UIButton *changelogButton =  [UIButton buttonWithType:UIButtonTypeCustom];
	changelogButton.tintColor = kMarieTintColor;
	[changelogButton setImage : changelogButtonImage forState:UIControlStateNormal];
	[changelogButton addTarget : self action:@selector(showWtfChangedInThisVersion) forControlEvents:UIControlEventTouchUpInside];

	UIBarButtonItem *changelogButtonItem = [[UIBarButtonItem alloc] initWithCustomView:changelogButton];
	self.navigationItem.rightBarButtonItem = changelogButtonItem;

	headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,200,200)];
	headerImageView = [UIImageView new];
	headerImageView.image = bannerImage;
	headerImageView.contentMode = UIViewContentModeScaleAspectFill;
	headerImageView.clipsToBounds = YES;
	headerImageView.translatesAutoresizingMaskIntoConstraints = NO;
	[headerView addSubview:headerImageView];

	_table.tableHeaderView = headerView;

	[self layoutUI];

}


- (void)layoutUI {

	[iconView.widthAnchor constraintEqualToConstant : 30].active = YES;
	[iconView.heightAnchor constraintEqualToConstant : 30].active = YES;

	[navBarStackView.topAnchor constraintEqualToAnchor : self.navigationItem.titleView.topAnchor constant : -0.5].active = YES;
	[navBarStackView.bottomAnchor constraintEqualToAnchor : self.navigationItem.titleView.bottomAnchor].active = YES;
	[navBarStackView.leadingAnchor constraintEqualToAnchor : self.navigationItem.titleView.leadingAnchor].active = YES;
	[navBarStackView.trailingAnchor constraintEqualToAnchor : self.navigationItem.titleView.trailingAnchor].active = YES;

	[headerImageView.topAnchor constraintEqualToAnchor : headerView.topAnchor].active = YES;
	[headerImageView.bottomAnchor constraintEqualToAnchor : headerView.bottomAnchor].active = YES;
	[headerImageView.leadingAnchor constraintEqualToAnchor : headerView.leadingAnchor].active = YES;
	[headerImageView.trailingAnchor constraintEqualToAnchor : headerView.trailingAnchor].active = YES;	

}


- (void)showWtfChangedInThisVersion {

	AudioServicesPlaySystemSound(1521);

	UIImage *tweakIconImage = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/MariePrefs.bundle/Assets/MarieIcon.png"];
	UIImage *checkmarkImage = [UIImage systemImageNamed:@"checkmark.circle.fill"];

	changelogController = [[OBWelcomeController alloc] initWithTitle:@"Marie" detailText:@"1.0.4" icon: tweakIconImage];

	[changelogController addBulletedListItemWithTitle:@"Code" description:@"Prefs code refactoring." image: checkmarkImage];
	[changelogController addBulletedListItemWithTitle:@"Tweak" description:@"Fixed banner & passcode image not clipping to bounds." image: checkmarkImage];

	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

	_UIBackdropView *backdropView = [[_UIBackdropView alloc] initWithSettings:settings];
	backdropView.clipsToBounds = YES;
	backdropView.layer.masksToBounds = YES;
	backdropView.translatesAutoresizingMaskIntoConstraints = NO;
	[changelogController.viewIfLoaded insertSubview:backdropView atIndex:0];

	[backdropView.topAnchor constraintEqualToAnchor : changelogController.viewIfLoaded.topAnchor].active = YES;
	[backdropView.bottomAnchor constraintEqualToAnchor : changelogController.viewIfLoaded.bottomAnchor].active = YES;
	[backdropView.leadingAnchor constraintEqualToAnchor : changelogController.viewIfLoaded.leadingAnchor].active = YES;
	[backdropView.trailingAnchor constraintEqualToAnchor : changelogController.viewIfLoaded.trailingAnchor].active = YES;

	changelogController.view.tintColor = kMarieTintColor;
	changelogController.viewIfLoaded.backgroundColor = UIColor.clearColor;
	changelogController.modalInPresentation = NO;
	changelogController.modalPresentationStyle = UIModalPresentationPageSheet;
	[self presentViewController:changelogController animated:YES completion:nil];

}


- (void)shatterThePrefsToPieces {

	AudioServicesPlaySystemSound(1521);

	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Marie" message:@"Do you wish to bring these images to the ground, punch them, destroy them and build some new ones upon a fresh respring?" preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Heck yeah" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

		NSFileManager *fileM = [NSFileManager defaultManager];

		[fileM removeItemAtPath:kPath error:nil];
		[fileM removeItemAtPath:kImagesPath error:nil];

		[self crossDissolveBlur];

	}];

	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Later" style:UIAlertActionStyleDefault handler:nil];

	[alertController addAction:confirmAction];
	[alertController addAction:cancelAction];

	[self presentViewController:alertController animated:YES completion:nil];

}


- (void)crossDissolveBlur {

	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

	_UIBackdropView *backdropView = [[_UIBackdropView alloc] initWithSettings:settings];
	backdropView.alpha = 0;
	backdropView.frame = self.view.bounds;
	backdropView.clipsToBounds = YES;
	backdropView.layer.masksToBounds = YES;
	[self.view addSubview:backdropView];

	[UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

		backdropView.alpha = 1;

	} completion:^(BOOL finished) { [self launchRespring]; }];

}


- (void)launchRespring {

	pid_t pid;
	const char* args[] = {"sbreload", NULL, NULL, NULL};
	posix_spawn(&pid, "/usr/bin/sbreload", NULL, NULL, (char* const*)args, NULL);

}


- (id)readPreferenceValue:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:kPath]];
	return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];

}


- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
 
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:kPath]];
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:kPath atomically:YES];

	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"dialerImageApplied" object:nil];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"passcodeImageApplied" object:nil];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"shareSheetImageApplied" object:nil];

	NSString *key = [specifier propertyForKey:@"key"];

	if([key isEqualToString:@"yes"]) {
	
	if(![[self readPreferenceValue:[self specifierForID:@"EnableSwitch"]] boolValue])

		[self removeContiguousSpecifiers:@[savedSpecifiers[@"GroupCell1"], savedSpecifiers[@"DialerImage"], savedSpecifiers[@"PasscodeImage"], savedSpecifiers[@"ShareSheetImage"], savedSpecifiers[@"GroupCell2"], savedSpecifiers[@"DialerLightImage"], savedSpecifiers[@"PasscodeLightImage"], savedSpecifiers[@"ShareSheetLightImage"]] animated:YES];

	else if(![self containsSpecifier:savedSpecifiers[@"GroupCell1"]])

		[self insertContiguousSpecifiers:@[savedSpecifiers[@"GroupCell1"], savedSpecifiers[@"DialerImage"], savedSpecifiers[@"PasscodeImage"], savedSpecifiers[@"ShareSheetImage"], savedSpecifiers[@"GroupCell2"], savedSpecifiers[@"DialerLightImage"], savedSpecifiers[@"PasscodeLightImage"], savedSpecifiers[@"ShareSheetLightImage"]] afterSpecifierID:@"EnableSwitch" animated:YES];

	}

}


static void postNSNotification() {

	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"dialerImageApplied" object:nil];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"passcodeImageApplied" object:nil];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"shareSheetImageApplied" object:nil];

}


#pragma mark Table View Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	tableView.tableHeaderView = headerView;
	return [super tableView:tableView cellForRowAtIndexPath:indexPath];

}


@end


@implementation MarieContributorsVC


- (NSArray *)specifiers {

	if(!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"MarieContributors" target:self];

	return _specifiers;

}


@end


@implementation MarieLinksVC


- (NSArray *)specifiers {

	if(!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"MarieLinks" target:self];

	return _specifiers;

}


- (void)launchDiscord {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://discord.gg/jbE3avwSHs"] options:@{} completionHandler:nil];

}


- (void)launchPayPal {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://paypal.me/Luki120"] options:@{} completionHandler:nil];

}


- (void)launchGitHub {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://github.com/Luki120/Marie"] options:@{} completionHandler:nil];

}


- (void)launchElixir {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://luki120.github.io/depictions/web/?p=me.luki.elixir"] options:@{} completionHandler:nil];

}


- (void)launchMeredith {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://repo.twickd.com/get/com.twickd.luki120.meredith"] options:@{} completionHandler:nil];

}


@end


@implementation MarieTintCell


- (void)setTitle:(NSString *)t {

	[super setTitle:t];

	self.titleLabel.textColor = kMarieTintColor;

}


@end
