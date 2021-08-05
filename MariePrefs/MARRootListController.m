#include "MARRootListController.h"


static NSString *prefsKeys = @"/var/mobile/Library/Preferences/me.luki.marieprefs.plist";

#define tint [UIColor colorWithRed: 1.00 green: 0.89 blue: 0.76 alpha: 1.00]


static void postNSNotification() {


	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"passcodeImageApplied" object:nil];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"shareSheetImageApplied" object:nil];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"dialerImageApplied" object:nil];


}


@implementation MARRootListController

- (NSArray *)specifiers {

	if (!_specifiers) {
	
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
		
		NSArray *chosenIDs = @[@"GroupCell1", @"DialerImage", @"PasscodeImage", @"ShareSheetImage"];
		self.savedSpecifiers = (self.savedSpecifiers) ?: [[NSMutableDictionary alloc] init];
		
		for(PSSpecifier *specifier in _specifiers)
            
			if([chosenIDs containsObject:[specifier propertyForKey:@"id"]])
            
				[self.savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];
	
	}

	return _specifiers;

}



- (void)reloadSpecifiers {

	[super reloadSpecifiers];


	if(![[self readPreferenceValue:[self specifierForID:@"EnableSwitch"]] boolValue])

		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell1"], self.savedSpecifiers[@"DialerImage"], self.savedSpecifiers[@"PasscodeImage"], self.savedSpecifiers[@"ShareSheetImage"]] animated:NO];


	else if(![self containsSpecifier:self.savedSpecifiers[@"GroupCell1"]])

		[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell1"], self.savedSpecifiers[@"DialerImage"], self.savedSpecifiers[@"PasscodeImage"], self.savedSpecifiers[@"ShareSheetImage"]] afterSpecifierID:@"EnableSwitch" animated:NO];


}


- (void)viewDidLoad {

	[super viewDidLoad];
	[self reloadSpecifiers];

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)postNSNotification, CFSTR("me.luki.marieprefs/passcodeImageChanged"), NULL, 0);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)postNSNotification, CFSTR("me.luki.marieprefs/shareSheetImageChanged"), NULL, 0);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)postNSNotification, CFSTR("me.luki.marieprefs/dialerImageChanged"), NULL, 0);

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

	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"passcodeImageApplied" object:nil];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"shareSheetImageApplied" object:nil];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"dialerImageApplied" object:nil];


	NSString *key = [specifier propertyForKey:@"key"];

	if([key isEqualToString:@"letsGo"]) {

	
	if(![[self readPreferenceValue:[self specifierForID:@"EnableSwitch"]] boolValue])

		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell1"], self.savedSpecifiers[@"DialerImage"], self.savedSpecifiers[@"PasscodeImage"], self.savedSpecifiers[@"ShareSheetImage"]] animated:YES];


	else if(![self containsSpecifier:self.savedSpecifiers[@"GroupCell1"]])

		[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell1"], self.savedSpecifiers[@"DialerImage"], self.savedSpecifiers[@"PasscodeImage"], self.savedSpecifiers[@"ShareSheetImage"]] afterSpecifierID:@"EnableSwitch" animated:YES];

	}

}


@end


@implementation MarieContributorsRootListController


- (NSArray *)specifiers {

	if (!_specifiers) {

		_specifiers = [self loadSpecifiersFromPlistName:@"MarieContributors" target:self];
    
	}

    
	return _specifiers;

}


@end


@implementation MarieLinksRootListController


- (NSArray *)specifiers {

	if (!_specifiers) {

		_specifiers = [self loadSpecifiersFromPlistName:@"MarieLinks" target:self];

	}

	return _specifiers;

}


- (void)discord {


	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://discord.gg/jbE3avwSHs"] options:@{} completionHandler:nil];


}


- (void)paypal {


	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://paypal.me/Luki120"] options:@{} completionHandler:nil];


}


- (void)github {


	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/Luki120/Aria"] options:@{} completionHandler:nil];


}


- (void)arizona {


	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://repo.twickd.com/get/com.twickd.luki120.arizona"] options:@{} completionHandler:nil];


}


- (void)elixir {


	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://luki120.github.io/"] options:@{} completionHandler:nil];


}


- (void)meredith {


	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://repo.twickd.com/get/com.twickd.luki120.meredith"] options:@{} completionHandler:nil];


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

    if ([self respondsToSelector:@selector(tintColor)]) {

        self.textLabel.textColor = tint;
        self.textLabel.highlightedTextColor = tint;

    }
}


@end