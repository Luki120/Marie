#import <GcUniversal/GcImagePickerUtils.h>
#import "Headers/Common.h"


@interface PHAbstractDialerView : UIView
@end


@interface PHHandsetDialerView : PHAbstractDialerView
@end


@interface DialerController : UIViewController
@property (nonatomic, strong) PHAbstractDialerView *dialerView;
- (void)setDialerImage;
@end


@interface CSPasscodeViewController : UIViewController
- (void)setPasscodeImage;
- (void)updatePasscodeImage;
@end


@interface UIActivityContentViewController : UIViewController
- (void)setShareSheetImage;
@end
