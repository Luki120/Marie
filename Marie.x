#import "Headers/Marie.h"
@import LocalAuthentication;


@class SBUIPasscodeLockViewBase;

#define kUserInterfaceStyle UIScreen.mainScreen.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark

static UIImage *dialerDarkImage;
static UIImage *dialerLightImage;
static UIImage *passcodeDarkImage;
static UIImage *passcodeLightImage;
static UIImage *shareSheetDarkImage;
static UIImage *shareSheetLightImage;

static UIImageView *dialerImageView;
static UIImageView *passcodeImageView;
static UIImageView *shareSheetImageView;

static NSString *const kDefaults = @"me.luki.marieprefs";
static NSNotificationName const MarieFadeInPasscodeImageNotification = @"MarieFadeInPasscodeImageNotification";

static BOOL yes;

static void loadShit() {

	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: kPath];
	NSMutableDictionary *prefs = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];
	yes = prefs[@"yes"] ? [prefs[@"yes"] boolValue] : NO;

}


// Reusable

static UIImageView *createImageViewWithImage(UIImage *image) {

	UIImageView *imageView = [UIImageView new];
	imageView.image = image;
	imageView.contentMode = UIViewContentModeScaleAspectFill;
	imageView.clipsToBounds = YES;
	imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	return imageView;

}

static void (*origVWA)(CSPasscodeViewController *, SEL, BOOL);
static void overrideVWA(CSPasscodeViewController *self, SEL _cmd, BOOL animated) {

	origVWA(self, _cmd, animated);
	[self fadeInPasscodeImage];

}


%hook DialerController

%new

- (void)setDialerImage { // self explanatory

	loadShit();

	[[self.dialerView viewWithTag: 120] removeFromSuperview];

	if(!yes) return;

	dialerDarkImage = [GcImagePickerUtils imageFromDefaults:kDefaults withKey:@"dialerDarkImage"];
	dialerLightImage = [GcImagePickerUtils imageFromDefaults:kDefaults withKey:@"dialerLightImage"];

	dialerImageView = createImageViewWithImage(kUserInterfaceStyle ? dialerDarkImage : dialerLightImage);
	dialerImageView.tag = 120;
	dialerImageView.frame = self.view.bounds;
	[self.dialerView insertSubview:dialerImageView atIndex:0];

}


- (void)viewDidLoad { // create a notification observer

	%orig;

	[self setDialerImage];
	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(setDialerImage) name:MarieApplyDialerImageNotification object:nil];	

}

%end


%hook CSPasscodeViewController

%new

- (void)setPasscodeImage { // self explanatory

	loadShit();

	if(!yes) return;
	if(passcodeImageView) [passcodeImageView removeFromSuperview];

	passcodeDarkImage = [GcImagePickerUtils imageFromDefaults:kDefaults withKey:@"passcodeBgDarkImage"];
	passcodeLightImage = [GcImagePickerUtils imageFromDefaults:kDefaults withKey:@"passcodeBgLightImage"];

	self.view.alpha = 0;

	passcodeImageView = createImageViewWithImage(kUserInterfaceStyle ? passcodeDarkImage : passcodeLightImage);
	passcodeImageView.alpha = 0;
	passcodeImageView.frame = self.view.bounds;
	[self.view insertSubview:passcodeImageView atIndex:1];

}

%new

- (void)fadeInPasscodeImage {

	[UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{

		passcodeImageView.alpha = 1;

	} completion:nil];

}

%new

- (void)updatePasscodeImage {

	passcodeImageView.image = kUserInterfaceStyle ? passcodeDarkImage : passcodeLightImage;

}


- (void)viewDidLoad { // create a notification observer

	%orig;

	[self setPasscodeImage];
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(fadeInPasscodeImage) name:MarieFadeInPasscodeImageNotification object:nil];
	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(updatePasscodeImage) name:MarieApplyPasscodeImageNotification object:nil];

}


- (void)viewWillDisappear:(BOOL)animated {

	%orig;
	passcodeImageView.alpha = 0;

}

%end


%hook SBUIPasscodeLockViewBase

- (void)updateForTransitionToPasscodeView:(BOOL)update animated:(BOOL)animated {

	[NSNotificationCenter.defaultCenter postNotificationName:MarieFadeInPasscodeImageNotification object:nil];
	%orig(update, animated);

}

%end


%hook UIActivityContentViewController

%new

- (void)setShareSheetImage { // self explanatory

	loadShit();

	if(!yes) return;
	if(shareSheetImageView) [shareSheetImageView removeFromSuperview];

	shareSheetDarkImage = [GcImagePickerUtils imageFromDefaults:kDefaults withKey:@"shareSheetDarkImage"];
	shareSheetLightImage = [GcImagePickerUtils imageFromDefaults:kDefaults withKey:@"shareSheetLightImage"];

	shareSheetImageView = createImageViewWithImage(kUserInterfaceStyle ? shareSheetDarkImage : shareSheetLightImage);
	shareSheetImageView.frame = self.view.bounds;
	[self.view insertSubview:shareSheetImageView atIndex:1];

}


- (void)viewDidLoad { // create a notification observer

	%orig;

	[self setShareSheetImage];
	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(setShareSheetImage) name:MarieApplyShareSheetImageNotification object:nil];

}

%end


%hook UIScreen

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {

	%orig;
	dialerImageView.image = kUserInterfaceStyle ? dialerDarkImage : dialerLightImage;
	passcodeImageView.image = kUserInterfaceStyle ? passcodeDarkImage : passcodeLightImage;
	shareSheetImageView.image = kUserInterfaceStyle ? shareSheetDarkImage : shareSheetLightImage;

}

%end


%ctor {

	loadShit();

	LAContext *context = [LAContext new];
	if([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil] &&
		context.biometryType == LABiometryTypeFaceID) return;
	MSHookMessageEx(NSClassFromString(@"CSPasscodeViewController"), @selector(viewWillAppear:), (IMP) &overrideVWA, (IMP *) &origVWA);

}
