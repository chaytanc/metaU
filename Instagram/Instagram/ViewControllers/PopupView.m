//
//  Popup.m
//  Instagram
//
//  Created by Chaytan Inman on 6/22/22.
//

#import "PopupView.h"
#import "Parse/Parse.h"
#import "HomeViewController.h"
#import "SceneDelegate.h"
#import "AppDelegate.h"

@interface PopupView ()

@property (strong, nonatomic) UILabel* titleLabel;
@property (strong, nonatomic) UIButton* doneButton;
@property (strong, nonatomic) UIButton* cancelButton;
@property (strong, nonatomic) UIStackView* popupStackView;
// Fields are public in .h

@end

@implementation PopupView

- (instancetype)init
{
    self = [super init];
    if (self) {
                
        self.alpha = 0.5;
        self.backgroundColor = UIColor.greenColor;
        self.layer.cornerRadius = 24;
//        self.clipsToBounds = TRUE;

        [self.layer setShadowColor:[[UIColor systemCyanColor] CGColor]];
        [self.layer setShadowOffset:CGSizeMake(5, 5)];
        [self.layer setShadowRadius:5];
        [self.layer setShadowOpacity:0.9];
        
        // Create UI components
        [self formatTitleLabel];
        [self formatDoneButton];
        [self formatUsernameField];
        [self formatEmailField];
        [self formatPasswordField];
        [self formatCancelButton];
        [self formatPopupStackView];
           
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    // Frame based layouts here
    [self setStackViewConstraints];

}

// XXX todo later, rounded corners don't work if no clipping to bounds for shadow so make separate view
- (void) formatRoundedCornersMask {
//    // add the border to subview
//    let borderView = UIView()
//    borderView.frame = baseView.bounds
//    borderView.layer.cornerRadius = 10
//    borderView.layer.borderColor = UIColor.black.cgColor
//    borderView.layer.borderWidth = 1.0
//    borderView.layer.masksToBounds = true
//    baseView.addSubview(borderView)
}

- (void) formatTitleLabel {
    self.titleLabel = [UILabel new];
    self.titleLabel.text = @"Create an account";
    [UIFontDescriptor new];
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:19];
    [self.titleLabel setFont:font];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.minimumScaleFactor = 0.6;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void) formatDoneButton {
    
    self.doneButton = [UIButton new];
    self.doneButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.doneButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [self.doneButton setTitleColor:[UIColor systemBlueColor] forState: UIControlStateNormal];
    [self.doneButton addTarget:self
                        action:@selector(doneButtonPressed:)
                        forControlEvents:UIControlEventTouchUpInside];
}

- (void) doneButtonPressed: (UIButton *) button {
    // TODO 
    NSLog(@"Done tapped!!!");
    // if create user succeeds dismiss and go to home, otherwise present error and go to login
    // Todo, disable signup button on login when popup is in view
    [self registerUser];
}

- (void) formatCancelButton {
    
    self.cancelButton = [UIButton new];
    self.cancelButton.titleLabel.textColor = [UIColor systemBlueColor];
    self.cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor systemBlueColor] forState: UIControlStateNormal];
    [self.cancelButton addTarget:self
                        action:@selector(cancelButtonPressed:)
                        forControlEvents:UIControlEventTouchUpInside];
}

- (void) cancelButtonPressed: (UIButton *) button {
    // TODO
    NSLog(@"Cancel tapped!!!");
    [self removeFromSuperview];
}

- (void) formatEmailField {
    self.emailField = [UITextField new];
    self.emailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: [UIColor systemCyanColor]}];
}

- (void) formatPasswordField {
    self.passwordField = [UITextField new];
    self.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Create a password" attributes:@{NSForegroundColorAttributeName: [UIColor systemCyanColor]}];
    self.passwordField.textContentType = UITextContentTypeNewPassword;
    self.passwordField.secureTextEntry = YES;
}

- (void) formatUsernameField {
    self.usernameField = [UITextField new];
    self.usernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Set a username" attributes:@{NSForegroundColorAttributeName: [UIColor systemCyanColor]}];
}

- (void) formatPopupStackView {
    self.popupStackView = [UIStackView new];
    [self.popupStackView addArrangedSubview:self.titleLabel];
    [self.popupStackView addArrangedSubview: self.usernameField];
    [self.popupStackView addArrangedSubview: self.emailField];
    [self.popupStackView addArrangedSubview: self.passwordField];
    [self.popupStackView addArrangedSubview: self.doneButton];
    [self.popupStackView addArrangedSubview: self.cancelButton];

    self.popupStackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.popupStackView.distribution = UIStackViewDistributionFillEqually;
    self.popupStackView.backgroundColor = [UIColor whiteColor];

    
    [self addSubview:self.popupStackView];

    
}

- (void) setStackViewConstraints {
    self.popupStackView.axis = UILayoutConstraintAxisVertical;
    [self.popupStackView setLayoutMargins:UIEdgeInsetsMake(8, 8, 8, 8)];
    [self.popupStackView setLayoutMarginsRelativeArrangement:YES];
    
    // Constrain to sides
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.popupStackView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.popupStackView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.popupStackView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.popupStackView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];

//        [self.popupStackView.heightAnchor constraintEqualToConstant:self.frame.size.height].active = true;
//        [self.popupStackView.widthAnchor constraintEqualToConstant:self.frame.size.width].active = true;
    
    [self addConstraints:@[left, top, right, bottom]];
}

- (void)registerUser {
    // initialize a user object
    PFUser *newUser = [PFUser user];

//    // set user properties
    newUser.username = self.usernameField.text;
    newUser.email = self.emailField.text;
    newUser.password = self.passwordField.text;

    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            [self presentRegisterErrorAlert:error];
        } else {
            NSLog(@"User registered successfully");
            
            [self removeFromSuperview];
            // manually segue to logged in view
            
            SceneDelegate *sceneDelegate = (SceneDelegate * ) UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UITabBarController *homeViewController = (UITabBarController*) [storyboard instantiateViewControllerWithIdentifier:@"HomeTabController"];

            [sceneDelegate.window setRootViewController:homeViewController];
        }
    }];
}


- (void) presentRegisterErrorAlert: (NSError*) error {
    NSLog(@"%@", error);
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Registration Error"
                                                                   message:error.localizedDescription
                                   preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
       handler:^(UIAlertAction * action) {}];

    [alert addAction:defaultAction];
    UIViewController *root = (AppDelegate *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [root presentViewController:alert animated:YES completion:nil];

}


@end
