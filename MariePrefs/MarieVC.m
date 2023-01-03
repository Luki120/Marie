#import "MarieVC.h"


// ! Constants

static NSString *const kImagesPath = @"/var/mobile/Library/Preferences/me.luki.marieprefs/";

static const char *marie_dialer_image_changed = "me.luki.marieprefs/dialerImageChanged";
static const char *marie_passcode_image_changed = "me.luki.marieprefs/passcodeImageChanged";
static const char *marie_sharesheet_image_changed = "me.luki.marieprefs/shareSheetImageChanged";

#define kMarieTintColor [UIColor colorWithRed:0.95 green:0.46 blue:0.60 alpha:1.0]

@implementation MarieVC {

	UIImageView *iconImageView;
	UILabel *versionLabel;
	UIStackView *navBarStackView;
	UIView *headerView;
	UIImageView *headerImageView;
	NSMutableDictionary *savedSpecifiers;
	OBWelcomeController *changelogController;

}


// ! Lifecycle

- (NSArray *)specifiers {

	if(_specifiers) return nil;
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

	savedSpecifiers = savedSpecifiers ?: [NSMutableDictionary new];

	for(PSSpecifier *specifier in _specifiers)

		if([chosenIDs containsObject:[specifier propertyForKey:@"id"]])

			[savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];

	return _specifiers;

}


- (id)init {

	self = [super init];
	if(!self) return nil;

	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{ registerMarieTintCellClass(); });

	[self setupUI];
	[self setupObservers];

	return self;

}


- (void)setupUI {

	UIImage *iconImage = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/MariePrefs.bundle/Assets/Marie@2x.png"];
	UIImage *bannerImage = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/MariePrefs.bundle/Assets/MarieBanner.png"];
	UIImage *changelogButtonImage = [UIImage systemImageNamed:@"atom"];

	self.navigationItem.titleView = [UIView new];

	if(!navBarStackView) {
		navBarStackView = [UIStackView new];
		navBarStackView.axis = UILayoutConstraintAxisVertical;
		navBarStackView.spacing = 0.5;
		navBarStackView.alignment = UIStackViewAlignmentCenter;
		navBarStackView.distribution = UIStackViewDistributionFill;
		navBarStackView.translatesAutoresizingMaskIntoConstraints = NO;
		[self.navigationItem.titleView addSubview: navBarStackView];
	}

	if(!iconImageView) {
		iconImageView = [UIImageView new];
		iconImageView.image = iconImage;
		iconImageView.contentMode = UIViewContentModeScaleAspectFit;
		iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
		[navBarStackView addArrangedSubview: iconImageView];
	}

	if(!versionLabel) {
		versionLabel = [UILabel new];
		versionLabel.text = @"Marie 1.0.5";
		versionLabel.font = [UIFont boldSystemFontOfSize: 12];
		versionLabel.textAlignment = NSTextAlignmentCenter;
		[navBarStackView addArrangedSubview: versionLabel];
	}

	UIButton *changelogButton = [UIButton new];
	changelogButton.tintColor = kMarieTintColor;
	[changelogButton setImage:changelogButtonImage forState: UIControlStateNormal];
	[changelogButton addTarget:self action:@selector(showWtfChangedInThisVersion) forControlEvents: UIControlEventTouchUpInside];

	UIBarButtonItem *changelogButtonItem = [[UIBarButtonItem alloc] initWithCustomView: changelogButton];
	self.navigationItem.rightBarButtonItem = changelogButtonItem;

	if(!headerView) headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,200,200)];

	if(!headerImageView) {
		headerImageView = [UIImageView new];
		headerImageView.image = bannerImage;
		headerImageView.contentMode = UIViewContentModeScaleAspectFill;
		headerImageView.clipsToBounds = YES;
		headerImageView.translatesAutoresizingMaskIntoConstraints = NO;
		[headerView addSubview: headerImageView];
	}

	[self layoutUI];

}


- (void)layoutUI {

	[iconImageView.widthAnchor constraintEqualToConstant: 30].active = YES;
	[iconImageView.heightAnchor constraintEqualToConstant: 30].active = YES;

	[navBarStackView.topAnchor constraintEqualToAnchor: self.navigationItem.titleView.topAnchor constant: -0.5].active = YES;
	[navBarStackView.bottomAnchor constraintEqualToAnchor: self.navigationItem.titleView.bottomAnchor].active = YES;
	[navBarStackView.leadingAnchor constraintEqualToAnchor: self.navigationItem.titleView.leadingAnchor].active = YES;
	[navBarStackView.trailingAnchor constraintEqualToAnchor: self.navigationItem.titleView.trailingAnchor].active = YES;

	[headerImageView.topAnchor constraintEqualToAnchor: headerView.topAnchor].active = YES;
	[headerImageView.bottomAnchor constraintEqualToAnchor: headerView.bottomAnchor].active = YES;
	[headerImageView.leadingAnchor constraintEqualToAnchor: headerView.leadingAnchor].active = YES;
	[headerImageView.trailingAnchor constraintEqualToAnchor: headerView.trailingAnchor].active = YES;	

}


- (void)setupObservers {

	int register_token = 0;
	notify_register_dispatch(marie_dialer_image_changed, &register_token, dispatch_get_main_queue(), ^(int _) {
		[NSDistributedNotificationCenter.defaultCenter postNotificationName:MarieApplyDialerImageNotification object:nil];
	});
	notify_register_dispatch(marie_passcode_image_changed, &register_token, dispatch_get_main_queue(), ^(int _) {
		[NSDistributedNotificationCenter.defaultCenter postNotificationName:MarieApplyPasscodeImageNotification object:nil];
	});
	notify_register_dispatch(marie_sharesheet_image_changed, &register_token, dispatch_get_main_queue(), ^(int _) {
		[NSDistributedNotificationCenter.defaultCenter postNotificationName:MarieApplyShareSheetImageNotification object:nil];		
	});

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

// ! Selectors

- (void)showWtfChangedInThisVersion {

	AudioServicesPlaySystemSound(1521);

	UIImage *tweakIconImage = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/MariePrefs.bundle/Assets/MarieIcon.png"];
	UIImage *checkmarkImage = [UIImage systemImageNamed:@"checkmark.circle.fill"];

	if(changelogController) { [self presentViewController:changelogController animated:YES completion:nil]; return; }
	changelogController = [[OBWelcomeController alloc] initWithTitle:@"Marie" detailText:@"1.0.5" icon: tweakIconImage];
	changelogController.view.tintColor = kMarieTintColor;
	changelogController.view.backgroundColor = UIColor.clearColor;
	changelogController.modalInPresentation = NO;
	changelogController.modalPresentationStyle = UIModalPresentationPageSheet;
	[changelogController addBulletedListItemWithTitle:@"Code" description:@"Tweak & prefs code refactoring ⇝ everything works the same, but better." image: checkmarkImage];
	[changelogController addBulletedListItemWithTitle:@"Tweak" description:@"Fixed animation glitch when leaving the passcode view without authenticating." image: checkmarkImage];

	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

	_UIBackdropView *backdropView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
	backdropView.clipsToBounds = YES;
	[changelogController.viewIfLoaded insertSubview:backdropView atIndex:0];

	[self presentViewController:changelogController animated:YES completion:nil];

}


- (void)shatterThePrefsToPieces {

	AudioServicesPlaySystemSound(1521);

	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Marie" message:@"Do you wish to bring these images to the ground, punch them, destroy them and build some new ones upon a fresh respring?" preferredStyle: UIAlertControllerStyleAlert];
	UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Heck yeah" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

		[[NSFileManager defaultManager] removeItemAtPath:kPath error:nil];
		[[NSFileManager defaultManager] removeItemAtPath:kImagesPath error:nil];

		[self crossDissolveBlur];

	}];

	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Later" style:UIAlertActionStyleDefault handler:nil];

	[alertController addAction: confirmAction];
	[alertController addAction: cancelAction];

	[self presentViewController:alertController animated:YES completion:nil];

}


- (void)crossDissolveBlur {

	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

	_UIBackdropView *backdropView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
	backdropView.alpha = 0;
	backdropView.clipsToBounds = YES;
	[self.view addSubview: backdropView];

	[UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

		backdropView.alpha = 1;

	} completion:^(BOOL finished) { [self launchRespring]; }];

}


- (void)launchRespring {

	pid_t pid;
	const char* args[] = {"killall", "SpringBoard", NULL};
	posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);

}

// ! UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	tableView.tableHeaderView = headerView;
	return [super tableView:tableView cellForRowAtIndexPath:indexPath];

}

// ! Preferences

- (id)readPreferenceValue:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile: kPath]];
	return settings[specifier.properties[@"key"]] ?: specifier.properties[@"default"];

}


- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile: kPath]];
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:kPath atomically:YES];

	[super setPreferenceValue:value specifier:specifier];

	[NSDistributedNotificationCenter.defaultCenter postNotificationName:MarieApplyDialerImageNotification object:nil];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:MarieApplyPasscodeImageNotification object:nil];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:MarieApplyShareSheetImageNotification object:nil];

	NSString *key = [specifier propertyForKey:@"key"];
	if(![key isEqualToString:@"yes"]) return;

	if(![[self readPreferenceValue:[self specifierForID:@"EnableSwitch"]] boolValue])

		[self removeContiguousSpecifiers:@[savedSpecifiers[@"GroupCell1"], savedSpecifiers[@"DialerImage"], savedSpecifiers[@"PasscodeImage"], savedSpecifiers[@"ShareSheetImage"], savedSpecifiers[@"GroupCell2"], savedSpecifiers[@"DialerLightImage"], savedSpecifiers[@"PasscodeLightImage"], savedSpecifiers[@"ShareSheetLightImage"]] animated:YES];

	else if(![self containsSpecifier:savedSpecifiers[@"GroupCell1"]])

		[self insertContiguousSpecifiers:@[savedSpecifiers[@"GroupCell1"], savedSpecifiers[@"DialerImage"], savedSpecifiers[@"PasscodeImage"], savedSpecifiers[@"ShareSheetImage"], savedSpecifiers[@"GroupCell2"], savedSpecifiers[@"DialerLightImage"], savedSpecifiers[@"PasscodeLightImage"], savedSpecifiers[@"ShareSheetLightImage"]] afterSpecifierID:@"EnableSwitch" animated:YES];

}

// ! Dark juju

static void marie_setTitle(PSTableCell *self, SEL _cmd, NSString *title) {

	struct objc_super superSetTitle = {
		self,
		[self superclass]
	};

	id (*superCall)(struct objc_super *, SEL, NSString *) = (void *)objc_msgSendSuper;
	superCall(&superSetTitle, _cmd, title);

	self.titleLabel.textColor = kMarieTintColor;

}

static void registerMarieTintCellClass() {

	Class MarieTintCellClass = objc_allocateClassPair([PSTableCell class], "MarieTintCell", 0);
	Method method = class_getInstanceMethod([PSTableCell class], @selector(setTitle:));
	const char *typeEncoding = method_getTypeEncoding(method);
	class_addMethod(MarieTintCellClass, @selector(setTitle:), (IMP) marie_setTitle, typeEncoding);

	objc_registerClassPair(MarieTintCellClass);

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


- (void)launchDiscord { [self launchURL: [NSURL URLWithString: @"https://discord.gg/jbE3avwSHs"]]; }
- (void)launchGitHub { [self launchURL: [NSURL URLWithString: @"https://github.com/Luki120/Marie"]]; }
- (void)launchPayPal { [self launchURL: [NSURL URLWithString: @"https://paypal.me/Luki120"]]; }
- (void)launchElixir { [self launchURL: [NSURL URLWithString: @"https://luki120.github.io/depictions/web/?p=me.luki.elixir"]]; }
- (void)launchMeredith { [self launchURL: [NSURL URLWithString: @"https://repo.twickd.com/get/com.twickd.luki120.meredith"]]; }

- (void)launchURL:(NSURL *)url { [UIApplication.sharedApplication openURL:url options:@{} completionHandler:nil]; }

@end
