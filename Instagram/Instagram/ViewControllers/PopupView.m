//
//  Popup.m
//  Instagram
//
//  Created by Chaytan Inman on 6/22/22.
//

#import "PopupView.h"
#import "Parse/Parse.h"
#import "HomeViewController.h"

@interface PopupView ()

@property (strong, nonatomic) UIView* container;
@property (strong, nonatomic) UIButton* doneButton;
@property (weak, nonatomic) UIButton* popupStackView;

@end

@implementation PopupView

//UIView *picker = [[UIView alloc] initWithFrame:self.view.bounds];
//picker.backgroundColor=[UIColor blueColor];
//[self.view addSubview: picker];

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.container = [[UIView alloc] init];
        self.container.backgroundColor = [UIColor grayColor];
        self.container.translatesAutoresizingMaskIntoConstraints = NO;
        self.container.layer.cornerRadius = 24;
        self.alpha = 0.5;
        
        // Working to get contraints
        //XXX causes error: "Unable to activate constraint with anchors <NSLayoutXAxisAnchor:0x600003dd1a40 \"PopupView:0x160b052a0.centerX\"> and <NSLayoutXAxisAnchor:0x600003dd1c40 \"UIView:0x160b05630.centerX\"> because they have no common ancestor.  Does the constraint or its anchors reference items in different view hierarchies?  That's illegal."
        NSLayoutConstraint *centerXConstraint = [self.centerXAnchor constraintEqualToAnchor:self.container.centerXAnchor];
        centerXConstraint.active = YES;
//        self.container.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        self.container.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        self.container.centerX
//        [self.container.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.7].active = YES;
//        [self.container.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.5].active = YES;
//        self.container.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        
        self.doneButton = [UIButton new];
        self.doneButton.titleLabel.text = @"Done";
        self.doneButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self.doneButton setTitle:@"Ok" forState:UIControlStateNormal];
        [self.doneButton setTitleColor:[UIColor blueColor] forState: UIControlStateNormal];
        [self.doneButton addTarget:self
                            action:@selector(doneButtonPressed:)
                            forControlEvents:UIControlEventTouchUpInside];
        
        UIStackView* popupStackView = [UIStackView new];
        [popupStackView addArrangedSubview:self.doneButton];
        popupStackView.translatesAutoresizingMaskIntoConstraints = NO;
        popupStackView.axis = UIAxisVertical;
        popupStackView.distribution = UIStackViewDistributionFillEqually;
           
    }
    return self;

}

- (void) doneButtonPressed: (UIButton *) button {
    // TODO 
    NSLog(@"Done tapped!!!");
    
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
