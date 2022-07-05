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
#import "SceneDelegate.h"
#import "UIViewController+PresentError.h"

@interface LoginViewController () <UITextFieldDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    self.passwordField.secureTextEntry = YES;

}

// Dismiss keyboard when return button is hit
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)loginUser {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {        
        // Username: Test, Password: Test
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            [self presentError:@"Login failed" message:@"Failed to login." error:error];
        } else {
            NSLog(@"User logged in successfully");
            
            SceneDelegate *sceneDelegate = (SceneDelegate * ) UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UITabBarController *homeViewController = (UITabBarController*) [storyboard instantiateViewControllerWithIdentifier:@"HomeTabController"];

                
            [sceneDelegate.window setRootViewController:homeViewController];
        }
    }];
}

- (IBAction)didTapSignup:(id)sender {
    NSLog(@"Sign up tapped");
    PopupView* popup = [PopupView new];
    //XXX working here to resign VC NOTE these are nil because they are currently setup in layoutsubviews
    popup.usernameField.delegate = self;
    popup.passwordField.delegate = self;
    popup.emailField.delegate = self;
    [self.view addSubview:popup];

    int frameHeight = self.view.frame.size.height * 0.80;
    int frameWidth = self.view.frame.size.width * 0.80;
    popup.frame = CGRectMake(self.view.center.x - (frameWidth/2), self.view.center.y - (frameHeight/2), frameWidth, frameHeight);

    //XXX eventually working to get transformation
//    popup.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
//    popup.transform = CGAffineTransformMake(<#CGFloat a#>, <#CGFloat b#>, <#CGFloat c#>, <#CGFloat d#>, <#CGFloat tx#>, <#CGFloat ty#>)
    [UIView animateWithDuration:1 animations:^{
        // animations
//        popup.transform = .identity
        popup.alpha = 0.95;
    }];
}

- (IBAction)didTapLogin:(id)sender {
    NSLog(@"Login tapped");
    [self loginUser];
}

@end
