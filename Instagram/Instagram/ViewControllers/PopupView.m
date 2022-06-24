//
//  Popup.m
//  Instagram
//
//  Created by Chaytan Inman on 6/22/22.
//

#import "PopupView.h"
#import "Parse/Parse.h"
#import "HomeViewController.h"
#import "SnapKit/SnapKit-Swift.h"

@interface PopupView ()

//@property (strong, nonatomic) UIView* container;
@property (strong, nonatomic) UIButton* doneButton;
@property (strong, nonatomic) UIButton* cancelButton;
@property (strong, nonatomic) UIStackView* popupStackView;
@property (strong, nonatomic) UITextField* emailField;
@property (strong, nonatomic) UITextField* passwordField;

@end

@implementation PopupView

//UIView *picker = [[UIView alloc] initWithFrame:self.view.bounds];
//picker.backgroundColor=[UIColor blueColor];
//[self.view addSubview: picker];

- (instancetype)init
{
    self = [super init];
    if (self) {

        
        // Working to get contraints
        //XXX causes error: "Unable to activate constraint with anchors <NSLayoutXAxisAnchor:0x600003dd1a40 \"PopupView:0x160b052a0.centerX\"> and <NSLayoutXAxisAnchor:0x600003dd1c40 \"UIView:0x160b05630.centerX\"> because they have no common ancestor.  Does the constraint or its anchors reference items in different view hierarchies?  That's illegal."
//        NSLayoutConstraint *centerXConstraint = [self.centerXAnchor constraintEqualToAnchor:.centerXAnchor];
//        centerXConstraint.active = YES;
//        self.container.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        self.container.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        self.container.centerX
//        [self.container.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.7].active = YES;
//        [self.container.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.5].active = YES;
//        self.container.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true


    
//        [self formatContainerView];
//        [self addSubview:self.container];
//        [self addSubview:self.popupStackView];
//        [self addSubview:self.doneButton];
        
        self.alpha = 0.5;
        self.backgroundColor = UIColor.greenColor;
        self.layer.cornerRadius = 24;
        self.clipsToBounds = TRUE;
           
    }
    return self;
}

//- (void) awakeFromNib {
//    [super awakeFromNib];
//    [self formatPopupStackView];
//
//}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self formatDoneButton];
    [self formatEmailField];
    [self formatPasswordField];
    [self formatCancelButton];

    [self formatPopupStackView];

}
//
//- (void) formatContainerView {
//    //        self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
////    self.container = [[UILabel alloc] initWithFrame:self.bounds];
//    self.container = [UIView new];
//
//    // CGRect is x, y, width, height
//    self.container.backgroundColor = [UIColor blackColor];
//    UILabel* test = [UILabel new];
//    test.text = @"test";
//    test.textColor = [UIColor blackColor];
//    [self.container addSubview:test];
////    self.container.textColor = [UIColor whiteColor];
////    self.container.text = @"Test";
//    self.container.translatesAutoresizingMaskIntoConstraints = NO;
//    self.container.layer.cornerRadius = 24;
//
//}

- (void) formatDoneButton {
    
    self.doneButton = [UIButton new];
    self.doneButton.titleLabel.text = @"Done";
    self.doneButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.doneButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [self.doneButton setTitleColor:[UIColor blueColor] forState: UIControlStateNormal];
    [self.doneButton addTarget:self
                        action:@selector(doneButtonPressed:)
                        forControlEvents:UIControlEventTouchUpInside];
}

- (void) doneButtonPressed: (UIButton *) button {
    // TODO 
    NSLog(@"Done tapped!!!");
    //XXX todo if create user succeeds dismiss and go to home, otherwise present error and go to login
    // Todo, disable signup button on login when popup is in view
    [self removeFromSuperview];
    
}

- (void) formatCancelButton {
    
    self.cancelButton = [UIButton new];
    self.cancelButton.titleLabel.text = @"Done";
    self.cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cancelButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor blueColor] forState: UIControlStateNormal];
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
    self.emailField.placeholder = @"Email";
}

- (void) formatPasswordField {
    self.passwordField = [UITextField new];
    self.passwordField.placeholder = @"Create a password";
    self.passwordField.backgroundColor = [UIColor whiteColor];
//    self.passwordField.attributedPlaceholder
}

- (void) formatPopupStackView {
    self.popupStackView = [UIStackView new];
    [self.popupStackView addArrangedSubview: self.emailField];
    [self.popupStackView addArrangedSubview: self.passwordField];
    [self.popupStackView addArrangedSubview: self.doneButton];
    [self.popupStackView addArrangedSubview: self.cancelButton];

    self.popupStackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.popupStackView.axis = UILayoutConstraintAxisVertical;
    self.popupStackView.distribution = UIStackViewDistributionFillEqually;
    self.popupStackView.backgroundColor = [UIColor blueColor];
    
    [self.popupStackView setLayoutMargins:UIEdgeInsetsMake(8, 8, 8, 8)];
    [self.popupStackView setLayoutMarginsRelativeArrangement:YES];
    
    [self addSubview:self.popupStackView];
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
//    newUser.username = self.usernameField.text;
//    newUser.email = self.emailField.text;
//    newUser.password = self.passwordField.text;

    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");

            // manually segue to logged in view
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            HomeViewController *homeVC = [storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
        }
    }];
}


@end
