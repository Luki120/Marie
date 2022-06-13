#import "Constants.h"


@interface CSPasscodeViewController : UIViewController
@property (nonatomic, strong) UIImageView *passcodeImageView;
- (void)setPasscodeImage;
@end


@interface UIActivityContentViewController : UIViewController
@property (nonatomic, strong) UIImageView *shareSheetImageView;
- (void)setShareSheetImage;
@end


@interface PHHandsetDialerView : UIView
@property (nonatomic, strong) UIImageView *dialerImageView;
- (void)setDialerImage;
@end


static BOOL yes;

static UIImage *dialerDarkImage;
static UIImage *dialerLightImage;
static UIImage *passcodeDarkImage;
static UIImage *passcodeLightImage;
static UIImage *shareSheetDarkImage;
static UIImage *shareSheetLightImage;

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


%group Marie 


%hook PHHandsetDialerView

%property (nonatomic, strong) UIImageView *dialerImageView;

%new

- (void)setDialerImage { // self explanatory

	loadShit();

	[[self viewWithTag: 120] removeFromSuperview];

	if(!yes) return;

	dialerDarkImage = [GcImagePickerUtils imageFromDefaults:kDefaults withKey:@"dialerDarkImage"];
	dialerLightImage = [GcImagePickerUtils imageFromDefaults:kDefaults withKey:@"dialerLightImage"];	

	UIImage *image = kUserInterfaceStyle ? dialerDarkImage : dialerLightImage;

	self.dialerImageView = createImageViewWithImage(image);
	self.dialerImageView.tag = 120;
	self.dialerImageView.frame = self.bounds;
	[self insertSubview:self.dialerImageView atIndex:0];

}


- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection { // handle transition between light/dark mode dynamically

	%orig;
	self.dialerImageView.image = kUserInterfaceStyle ? dialerDarkImage : dialerLightImage;

}


- (void)didMoveToSuperview { // create a notification observer

	%orig;
	[self setDialerImage];

	[NSDistributedNotificationCenter.defaultCenter removeObserver:self];
	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(setDialerImage) name:@"dialerImageApplied" object:nil];	

}


%end


%hook CSPasscodeViewController

%property (nonatomic, strong) UIImageView *passcodeImageView;

%new

- (void)setPasscodeImage { // self explanatory

	loadShit();

	if(!yes) return;

	passcodeDarkImage = [GcImagePickerUtils imageFromDefaults:kDefaults withKey:@"passcodeBgDarkImage"];
	passcodeLightImage = [GcImagePickerUtils imageFromDefaults:kDefaults withKey:@"passcodeBgLightImage"];

	self.view.alpha = 0;

	UIImage *image = kUserInterfaceStyle ? passcodeDarkImage : passcodeLightImage;

	self.passcodeImageView = createImageViewWithImage(image);
	self.passcodeImageView.alpha = 0;
	self.passcodeImageView.frame = self.view.bounds;
	[self.view insertSubview:self.passcodeImageView atIndex:1];

}


- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection { // handle transition between light/dark mode dynamically

	%orig;
	self.passcodeImageView.image = kUserInterfaceStyle ? passcodeDarkImage : passcodeLightImage;

}


- (void)viewWillAppear:(BOOL)animated { // animate the image when the view appears

	%orig;

	[UIView transitionWithView:self.view duration:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{

		self.passcodeImageView.alpha = 1;

	} completion:nil];

}


- (void)viewWillDisappear:(BOOL)animated {

	%orig;

	[UIView transitionWithView:self.view duration:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{

		self.passcodeImageView.alpha = 0;

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

%property (nonatomic, strong) UIImageView *shareSheetImageView;

%new

- (void)setShareSheetImage { // self explanatory

	loadShit();

	if(!yes) return;

	shareSheetDarkImage = [GcImagePickerUtils imageFromDefaults:kDefaults withKey:@"shareSheetDarkImage"];
	shareSheetLightImage = [GcImagePickerUtils imageFromDefaults:kDefaults withKey:@"shareSheetLightImage"];

	UIImage *image = kUserInterfaceStyle ? shareSheetDarkImage : shareSheetLightImage;

	self.shareSheetImageView = createImageViewWithImage(image);
	self.shareSheetImageView.frame = self.view.bounds;
	[self.view insertSubview:self.shareSheetImageView atIndex:1];

}


- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection { // handle transition between light/dark mode dynamically

	%orig;
	self.shareSheetImageView.image = kUserInterfaceStyle ? shareSheetDarkImage : shareSheetLightImage;

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
	BOOL isSpringboard = [@"SpringBoard" isEqualToString: processName];

	BOOL shouldLoad = NO;
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
