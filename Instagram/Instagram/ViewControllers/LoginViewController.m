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
    popup.frame = CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 150, 150);
    [self.view addSubview:popup];
    //XXX this does not currently show anything on the LoginVC when I tap sign up but does run this code
    
    //XXX eventually working to get transformation
//    popup.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
//    popup.transform = CGAffineTransformMake(<#CGFloat a#>, <#CGFloat b#>, <#CGFloat c#>, <#CGFloat d#>, <#CGFloat tx#>, <#CGFloat ty#>)
    [UIView animateWithDuration:1 animations:^{
        // animations
//        popup.transform = .identity
        popup.alpha = 1;
    }];
}

- (IBAction)didTapLogin:(id)sender {
    NSLog(@"Login tapped");
    [self loginUser];
}

@end
