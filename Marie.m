#import "Headers/Marie.h"
@import CydiaSubstrate;
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

static void new_setDialerImage(DialerController *self, SEL _cmd) {

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

static void (*origDialerVDL)(DialerController *, SEL);
static void overrideDialerVDL(DialerController *self, SEL _cmd) {

	origDialerVDL(self, _cmd);

	[self setDialerImage];
	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(setDialerImage) name:MarieApplyDialerImageNotification object:nil];	

}

static void new_setPasscodeImage(CSPasscodeViewController *self, SEL _cmd) {

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

static void new_fadeInPasscodeImage(CSPasscodeViewController *self, SEL _cmd) {

	[UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{

		passcodeImageView.alpha = 1;

	} completion:nil];

}

static void new_updatePasscodeImage(CSPasscodeViewController *self, SEL _cmd) {

	passcodeImageView.image = kUserInterfaceStyle ? passcodeDarkImage : passcodeLightImage;

}

static void (*origVWA)(CSPasscodeViewController *, SEL, BOOL);
static void overrideVWA(CSPasscodeViewController *self, SEL _cmd, BOOL animated) {

	origVWA(self, _cmd, animated);
	[self fadeInPasscodeImage];

}

static void (*origVWD)(CSPasscodeViewController *, SEL, BOOL);
static void overrideVWD(CSPasscodeViewController *self, SEL _cmd, BOOL animated) {

	origVWD(self, _cmd, animated);
	passcodeImageView.alpha = 0;

}

static void (*origPasscodeVDL)(CSPasscodeViewController *, SEL);
static void overridePasscodeVDL(CSPasscodeViewController *self, SEL _cmd) {

	origPasscodeVDL(self, _cmd);

	[self setPasscodeImage];
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(fadeInPasscodeImage) name:MarieFadeInPasscodeImageNotification object:nil];
	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(updatePasscodeImage) name:MarieApplyPasscodeImageNotification object:nil];

}

static void (*origUFTPV)(SBUIPasscodeLockViewBase *, SEL, BOOL, BOOL);
static void overrideUFTPV(SBUIPasscodeLockViewBase *self, SEL _cmd, BOOL update, BOOL animated) {

	[NSNotificationCenter.defaultCenter postNotificationName:MarieFadeInPasscodeImageNotification object:nil];
	origUFTPV(self, _cmd, update, animated);

}

static void new_setShareSheetImage(UIActivityContentViewController *self, SEL _cmd) {

	loadShit();

	if(!yes) return;
	if(shareSheetImageView) [shareSheetImageView removeFromSuperview];

	shareSheetDarkImage = [GcImagePickerUtils imageFromDefaults:kDefaults withKey:@"shareSheetDarkImage"];
	shareSheetLightImage = [GcImagePickerUtils imageFromDefaults:kDefaults withKey:@"shareSheetLightImage"];

	shareSheetImageView = createImageViewWithImage(kUserInterfaceStyle ? shareSheetDarkImage : shareSheetLightImage);
	shareSheetImageView.frame = self.view.bounds;
	[self.view insertSubview:shareSheetImageView atIndex:1];

}

static void (*origShareSheetVDL)(UIActivityContentViewController *, SEL);
static void overrideShareSheetVDL(UIActivityContentViewController *self, SEL _cmd) {

	origShareSheetVDL(self, _cmd);

	[self setShareSheetImage];
	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(setShareSheetImage) name:MarieApplyShareSheetImageNotification object:nil];

}

static void (*origTCDC)(UIScreen *, SEL, UITraitCollection *);
static void overrideTCDC(UIScreen *self, SEL _cmd, UITraitCollection *previousTrait) {

	origTCDC(self, _cmd, previousTrait);

	dialerImageView.image = kUserInterfaceStyle ? dialerDarkImage : dialerLightImage;
	passcodeImageView.image = kUserInterfaceStyle ? passcodeDarkImage : passcodeLightImage;
	shareSheetImageView.image = kUserInterfaceStyle ? shareSheetDarkImage : shareSheetLightImage;

}

__attribute__((constructor)) static void init(void) {

	loadShit();

	MSHookMessageEx(NSClassFromString(@"DialerController"), @selector(viewDidLoad), (IMP) &overrideDialerVDL, (IMP *) &origDialerVDL);
	MSHookMessageEx(NSClassFromString(@"CSPasscodeViewController"), @selector(viewWillDisappear:), (IMP) &overrideVWD, (IMP *) &origVWD);
	MSHookMessageEx(NSClassFromString(@"CSPasscodeViewController"), @selector(viewDidLoad), (IMP) &overridePasscodeVDL, (IMP *) &origPasscodeVDL);
	MSHookMessageEx(NSClassFromString(@"SBUIPasscodeLockViewBase"), @selector(updateForTransitionToPasscodeView:animated:), (IMP) &overrideUFTPV, (IMP *) &origUFTPV);
	MSHookMessageEx(NSClassFromString(@"UIActivityContentViewController"), @selector(viewDidLoad), (IMP) &overrideShareSheetVDL, (IMP *) &origShareSheetVDL);
	MSHookMessageEx(NSClassFromString(@"UIScreen"), @selector(traitCollectionDidChange:), (IMP) &overrideTCDC, (IMP *) &origTCDC);

	class_addMethod(NSClassFromString(@"DialerController"), @selector(setDialerImage), (IMP) &new_setDialerImage, "v@:");
	class_addMethod(NSClassFromString(@"CSPasscodeViewController"), @selector(setPasscodeImage), (IMP) &new_setPasscodeImage, "v@:");
	class_addMethod(NSClassFromString(@"CSPasscodeViewController"), @selector(fadeInPasscodeImage), (IMP) &new_fadeInPasscodeImage, "v@:");
	class_addMethod(NSClassFromString(@"CSPasscodeViewController"), @selector(updatePasscodeImage), (IMP) &new_updatePasscodeImage, "v@:");	
	class_addMethod(NSClassFromString(@"UIActivityContentViewController"), @selector(setShareSheetImage), (IMP) &new_setShareSheetImage, "v@:");	

	LAContext *context = [LAContext new];
	if([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil] &&
		context.biometryType == LABiometryTypeFaceID) return;
	MSHookMessageEx(NSClassFromString(@"CSPasscodeViewController"), @selector(viewWillAppear:), (IMP) &overrideVWA, (IMP *) &origVWA);

}
