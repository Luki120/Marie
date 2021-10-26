@import UIKit;
#import <GcUniversal/GcImagePickerUtils.h>


@interface NSDistributedNotificationCenter : NSNotificationCenter
+ (instancetype)defaultCenter;
- (void)postNotificationName:(NSString *)name object:(NSString *)object userInfo:(NSDictionary *)userInfo;
@end


@interface CSPasscodeViewController : UIViewController
@property (nonatomic, strong) UIImageView *hotGoodLookingPasscodeImageView;
- (void)setPasscodeImage;
@end


@interface UIActivityContentViewController : UIViewController
@property (nonatomic, strong) UIImageView *hotGoodLookingShareSheetImageView;
- (void)setShareSheetImage;
@end


@interface PHHandsetDialerView : UIView
@property (nonatomic, strong) UIImageView *hotGoodLookingDialerImageView;
- (void)setDialerImage;
@end


static NSString *const prefsKeys = @"/var/mobile/Library/Preferences/me.luki.marieprefs.plist";
#define kUserInterfaceStyle (UIScreen.mainScreen.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark)

static BOOL yes;

UIImage *dialerDarkImage;
UIImage *dialerLightImage;
UIImage *passcodeDarkImage;
UIImage *passcodeLightImage;
UIImage *shareSheetDarkImage;
UIImage *shareSheetLightImage;

static void loadShit() {

	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:prefsKeys];
	NSMutableDictionary *prefs = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];
	yes = prefs[@"yes"] ? [prefs[@"yes"] boolValue] : NO;

}


%group Marie 


%hook PHHandsetDialerView

%property (nonatomic, strong) UIImageView *hotGoodLookingDialerImageView;

%new

- (void)setDialerImage { // self explanatory

	loadShit();

	dialerDarkImage = [GcImagePickerUtils imageFromDefaults:@"me.luki.marieprefs" withKey:@"dialerDarkImage"];
	dialerLightImage = [GcImagePickerUtils imageFromDefaults:@"me.luki.marieprefs" withKey:@"dialerLightImage"];

	[[self viewWithTag:120] removeFromSuperview];

	if(!yes) return;

	self.hotGoodLookingDialerImageView = [[UIImageView alloc] initWithFrame:self.bounds];
	self.hotGoodLookingDialerImageView.tag = 120;
	self.hotGoodLookingDialerImageView.image = kUserInterfaceStyle ? dialerDarkImage : dialerLightImage;
	self.hotGoodLookingDialerImageView.contentMode = UIViewContentModeScaleAspectFill;
	self.hotGoodLookingDialerImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self insertSubview:self.hotGoodLookingDialerImageView atIndex:0];

}


- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection { // handle transition between light/dark mode dynamically

	%orig;

	dialerDarkImage = [GcImagePickerUtils imageFromDefaults:@"me.luki.marieprefs" withKey:@"dialerDarkImage"];
	dialerLightImage = [GcImagePickerUtils imageFromDefaults:@"me.luki.marieprefs" withKey:@"dialerLightImage"];

	self.hotGoodLookingDialerImageView.image = kUserInterfaceStyle ? dialerDarkImage : dialerLightImage;

}


- (void)didMoveToSuperview { // create a notification observer

	%orig;

	[self setDialerImage];

	[NSDistributedNotificationCenter.defaultCenter removeObserver:self];
	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(setDialerImage) name:@"dialerImageApplied" object:nil];	

}


%end


%hook CSPasscodeViewController

%property (nonatomic, strong) UIImageView *hotGoodLookingPasscodeImageView;

%new

- (void)setPasscodeImage { // self explanatory

	loadShit();

	passcodeDarkImage = [GcImagePickerUtils imageFromDefaults:@"me.luki.marieprefs" withKey:@"passcodeBgDarkImage"];
	passcodeLightImage = [GcImagePickerUtils imageFromDefaults:@"me.luki.marieprefs" withKey:@"passcodeBgLightImage"];

	if(!yes) return;

	self.view.alpha = 0;

	self.hotGoodLookingPasscodeImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
	self.hotGoodLookingPasscodeImageView.alpha = 0;
	self.hotGoodLookingPasscodeImageView.image = kUserInterfaceStyle ? passcodeDarkImage : passcodeLightImage;
	self.hotGoodLookingPasscodeImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view insertSubview:self.hotGoodLookingPasscodeImageView atIndex:1];

}


- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection { // handle transition between light/dark mode dynamically

	%orig;

	passcodeDarkImage = [GcImagePickerUtils imageFromDefaults:@"me.luki.marieprefs" withKey:@"passcodeBgDarkImage"];
	passcodeLightImage = [GcImagePickerUtils imageFromDefaults:@"me.luki.marieprefs" withKey:@"passcodeBgLightImage"];

	self.hotGoodLookingPasscodeImageView.image = kUserInterfaceStyle ? passcodeDarkImage : passcodeLightImage;

}


- (void)viewWillAppear:(BOOL)animated { // animate the image when the view appears

	%orig;

	[UIView transitionWithView:self.view duration:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{

		self.hotGoodLookingPasscodeImageView.alpha = 1;

	} completion:nil];

}


- (void)viewDidLoad { // create a notification observer

	%orig;

	[self setPasscodeImage];

	[NSDistributedNotificationCenter.defaultCenter removeObserver:self];
	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(setPasscodeImage) name:@"passcodeImageApplied" object:nil];

}


%end


%hook UIActivityContentViewController

%property (nonatomic, strong) UIImageView *hotGoodLookingShareSheetImageView;

%new

- (void)setShareSheetImage { // self explanatory

	loadShit();

	shareSheetDarkImage = [GcImagePickerUtils imageFromDefaults:@"me.luki.marieprefs" withKey:@"shareSheetDarkImage"];
	shareSheetLightImage = [GcImagePickerUtils imageFromDefaults:@"me.luki.marieprefs" withKey:@"shareSheetLightImage"];

	if(!yes) return;

	self.hotGoodLookingShareSheetImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
	self.hotGoodLookingShareSheetImageView.image = kUserInterfaceStyle ? shareSheetDarkImage : shareSheetLightImage;
	self.hotGoodLookingShareSheetImageView.contentMode = UIViewContentModeScaleAspectFill;
	self.hotGoodLookingShareSheetImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view insertSubview:self.hotGoodLookingShareSheetImageView atIndex:1];

}


- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection { // handle transition between light/dark mode dynamically

	%orig;

	shareSheetDarkImage = [GcImagePickerUtils imageFromDefaults:@"me.luki.marieprefs" withKey:@"shareSheetDarkImage"];
	shareSheetLightImage = [GcImagePickerUtils imageFromDefaults:@"me.luki.marieprefs" withKey:@"shareSheetLightImage"];

	self.hotGoodLookingShareSheetImageView.image = kUserInterfaceStyle ? shareSheetDarkImage : shareSheetLightImage;

}


- (void)viewDidLoad { // create a notification observer

	%orig;

	[self setShareSheetImage];

	[NSDistributedNotificationCenter.defaultCenter removeObserver:self];
	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(setShareSheetImage) name:@"shareSheetImageApplied" object:nil];

}


%end
%end


%ctor {

	NSString *processName = [NSProcessInfo processInfo].processName;
	BOOL isSpringboard = [@"SpringBoard" isEqualToString:processName];

	bool shouldLoad = NO;
	NSArray *args = [[NSClassFromString(@"NSProcessInfo") processInfo] arguments];
	NSUInteger count = args.count;
	
	if(count != 0) {
		
		NSString *executablePath = args[0];
        
		if(executablePath) {
            
			NSString *processName = [executablePath lastPathComponent];
			BOOL isApplication = [executablePath rangeOfString:@"/Application/"].location != NSNotFound || [executablePath rangeOfString:@"/Applications/"].location != NSNotFound;
			BOOL isFileProvider = [[processName lowercaseString] rangeOfString:@"fileprovider"].location != NSNotFound;
			BOOL skip = [processName isEqualToString:@"AdSheet"]
						|| [processName isEqualToString:@"CoreAuthUI"]
						|| [processName isEqualToString:@"InCallService"]
						|| [processName isEqualToString:@"MessagesNotificationViewService"]
						|| [executablePath rangeOfString:@".appex/"].location != NSNotFound;
            
		if((!isFileProvider && isApplication && !skip) || isSpringboard) shouldLoad = YES;
        
		}
	
	}

	if(!shouldLoad) return;

	loadShit();
	%init(Marie);

}
