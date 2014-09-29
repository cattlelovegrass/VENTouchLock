#import "VENTouchLockCreatePasscodeViewController.h"
#import "VENTouchLock.h"

static CGFloat const VENTouchLockCreatePasscodeViewControllerAnimationDuration = 0.2;

@interface VENTouchLockCreatePasscodeViewController ()
@property (strong, nonatomic) NSString *firstPasscode;
@end

@implementation VENTouchLockCreatePasscodeViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = [[VENTouchLock sharedInstance] appearance].enterPasscodeViewControllerTitle;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.passcodeView.title = [[VENTouchLock sharedInstance] appearance].createPasscodeInitialLabelText;
}

- (void)enteredPasscode:(NSString *)passcode;
{
    [super enteredPasscode:passcode];
    if (self.firstPasscode) {
        if ([passcode isEqualToString:self.firstPasscode]) {
            [[VENTouchLock sharedInstance] setPasscode:passcode];
            [self finishWithResult:YES animated:YES];
        }
        else {
            [self.passcodeView shakeAndVibrateCompletion:^{
                self.firstPasscode = nil;
                [self showFirstPasscodeView];
            }];
        }
    }
    else {
        self.firstPasscode = passcode;
        [self showConfirmPasscodeView];
    }
}

- (void)showConfirmPasscodeView
{
    VENTouchLockPasscodeView *firstPasscodeView = self.passcodeView;
    CGFloat passcodeViewWidth = CGRectGetWidth(firstPasscodeView.frame);
    CGRect confirmInitialFrame = CGRectMake(passcodeViewWidth,
                                     CGRectGetMinY(firstPasscodeView.frame),
                                     passcodeViewWidth,
                                     CGRectGetHeight(firstPasscodeView.frame));
    CGRect confirmEndFrame = firstPasscodeView.frame;
    CGRect firstEndFrame = CGRectMake(-passcodeViewWidth,
                                        CGRectGetMinY(firstPasscodeView.frame),
                                        passcodeViewWidth,
                                        CGRectGetHeight(firstPasscodeView.frame));
    NSString *confirmPasscodeTitle = [[VENTouchLock sharedInstance] appearance].createPasscodeConfirmLabelText;
    VENTouchLockPasscodeView *confirmPasscodeView = [[VENTouchLockPasscodeView alloc]
                                                     initWithTitle:confirmPasscodeTitle
                                                     frame:confirmInitialFrame];
    [self.view addSubview:confirmPasscodeView];
    [UIView animateWithDuration: VENTouchLockCreatePasscodeViewControllerAnimationDuration
                          delay: 0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         firstPasscodeView.frame = firstEndFrame;
                         confirmPasscodeView.frame = confirmEndFrame;
                     }
                     completion:^(BOOL finished) {
                         [firstPasscodeView removeFromSuperview];
                         self.passcodeView = confirmPasscodeView;
                     }];

}

- (void)showFirstPasscodeView
{
    VENTouchLockPasscodeView *confirmPasscodeView = self.passcodeView;
    CGFloat passcodeViewWidth = CGRectGetWidth(confirmPasscodeView.frame);
    CGRect firstInitialFrame = CGRectMake(-passcodeViewWidth,
                                     CGRectGetMinY(confirmPasscodeView.frame),
                                     passcodeViewWidth,
                                     CGRectGetHeight(confirmPasscodeView.frame));
    CGRect firstEndFrame = confirmPasscodeView.frame;
    CGRect confirmEndFrame = CGRectMake(passcodeViewWidth,
                                        CGRectGetMinY(confirmPasscodeView.frame),
                                        passcodeViewWidth,
                                        CGRectGetHeight(confirmPasscodeView.frame));
    NSString *firstPasscodeTitle = [[VENTouchLock sharedInstance] appearance].createPasscodeMismatchedLabelText;
    VENTouchLockPasscodeView *firstPasscodeView = [[VENTouchLockPasscodeView alloc] initWithTitle:firstPasscodeTitle
                                                                                            frame:firstInitialFrame];
    [self.view addSubview:firstPasscodeView];
    [UIView animateWithDuration: VENTouchLockCreatePasscodeViewControllerAnimationDuration
                          delay: 0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         confirmPasscodeView.frame = confirmEndFrame;
                         firstPasscodeView.frame = firstEndFrame;
                     }
                     completion:^(BOOL finished) {
                         [confirmPasscodeView removeFromSuperview];
                         self.passcodeView = firstPasscodeView;
                     }];
}

@end