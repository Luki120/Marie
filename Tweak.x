@import UIKit;
#import "GcImagePickerUtils.h"


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



static NSString *prefsKeys = @"/var/mobile/Library/Preferences/me.luki.marieprefs.plist";


static BOOL letsGo;


static void howPrefsShouldBeDone() {


	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:prefsKeys];
	NSMutableDictionary *prefs = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];
	letsGo = prefs[@"letsGo"] ? [prefs[@"letsGo"] boolValue] : NO;


}



%group Marie 


%hook CSPasscodeViewController


%property (nonatomic, strong) UIImageView *hotGoodLookingPasscodeImageView;


%new


- (void)setPasscodeImage {


	howPrefsShouldBeDone();

	if(letsGo) {


		self.view.alpha = 0;

		self.hotGoodLookingPasscodeImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
		self.hotGoodLookingPasscodeImageView.image = [GcImagePickerUtils imageFromDefaults:@"me.luki.marieprefs" withKey:@"passcodeBgImage"];
		self.hotGoodLookingPasscodeImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

		[self.view insertSubview:self.hotGoodLookingPasscodeImageView atIndex:1];


	}


}


- (void)viewDidLoad {


	%orig;

	[self setPasscodeImage];

	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(setPasscodeImage) name:@"passcodeImageApplied" object:nil];


}


%end




%hook UIActivityContentViewController


%property (nonatomic, strong) UIImageView *hotGoodLookingShareSheetImageView;


%new


- (void)setShareSheetImage {


	howPrefsShouldBeDone();

	if(letsGo) {


		self.hotGoodLookingShareSheetImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
		self.hotGoodLookingShareSheetImageView.image = [GcImagePickerUtils imageFromDefaults:@"me.luki.marieprefs" withKey:@"shareSheetImage"];
		self.hotGoodLookingShareSheetImageView.contentMode = UIViewContentModeScaleAspectFill;
		self.hotGoodLookingShareSheetImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

		[self.view insertSubview:self.hotGoodLookingShareSheetImageView atIndex:1];


	}


}


- (void)viewDidLoad {


	%orig;

	[self setShareSheetImage];

	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(setShareSheetImage) name:@"shareSheetImageApplied" object:nil];


}


%end




%hook PHHandsetDialerView

%property (nonatomic, strong) UIImageView *hotGoodLookingDialerImageView;


%new


- (void)setDialerImage {


	howPrefsShouldBeDone();

	[[self viewWithTag:120] removeFromSuperview];

	if(letsGo) {


    	self.hotGoodLookingDialerImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    	self.hotGoodLookingDialerImageView.tag = 120;
		self.hotGoodLookingDialerImageView.image = [GcImagePickerUtils imageFromDefaults:@"me.luki.marieprefs" withKey:@"dialerImage"];
		self.hotGoodLookingDialerImageView.contentMode = UIViewContentModeScaleAspectFill;
    	self.hotGoodLookingDialerImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    	[self insertSubview:self.hotGoodLookingDialerImageView atIndex:0];


    }


}


- (void)didMoveToSuperview {


	%orig;

	[self setDialerImage];

	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(setDialerImage) name:@"dialerImageApplied" object:nil];	


}

%end
%end




%ctor {


	howPrefsShouldBeDone();

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

	%init(Marie);

}