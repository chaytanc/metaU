//
//  LoginViewController.m
//  Instagram
//
//  Created by Chaytan Inman on 6/22/22.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "HomeViewController.h"
#import "PopupView.h"
#import "SnapKit/SnapKit-Swift.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



// Dismiss keyboard when return button is hit
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//XXX TODO LOGOUT
//[PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
//    // PFUser.current() will now be nil
//}];

- (void)loginUser {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        //XXX add dispatch later
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            
            // display view controller that needs to shown after successful login
        }
    }];
}

- (IBAction)didTapSignup:(id)sender {
    NSLog(@"Sign up tapped");
    UIView* popup = [PopupView new];
    [self.view addSubview:popup];
    popup.frame = CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 150, 150);
//    NSLayoutConstraint *centerXConstraint = [popup.centerXAnchor constraintEqualToAnchor:.centerXAnchor];
    NSLayoutConstraint *centerXConstraint = [self.view.centerXAnchor constraintEqualToAnchor: popup.centerXAnchor];
    
    centerXConstraint.active = YES;
    [NSLayoutConstraint activateConstraints:@[centerXConstraint]];
    [self.view addConstraint:centerXConstraint];
     
    
//    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:100];
//    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:100];
//
//    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50];
//    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50];
//    [self.view addConstraints:@[left, top]];
//    [view addConstraints:@[height, width]];

    
    
    //XXX eventually working to get transformation
//    popup.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
//    popup.transform = CGAffineTransformMake(<#CGFloat a#>, <#CGFloat b#>, <#CGFloat c#>, <#CGFloat d#>, <#CGFloat tx#>, <#CGFloat ty#>)
    [UIView animateWithDuration:1 animations:^{
        // animations
//        popup.transform = .identity
        popup.alpha = 0.75;
    }];
}

- (IBAction)didTapLogin:(id)sender {
    NSLog(@"Login tapped");
    [self loginUser];
}

@end
