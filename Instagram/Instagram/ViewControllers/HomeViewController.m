//
//  HomeViewController.m
//  Instagram
//
//  Created by Chaytan Inman on 6/22/22.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "AppDelegate.h"
#import "SceneDelegate.h"
#import "UIViewController+PresentError.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Refresh for the data in the tableview
//    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
//    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
//    [self. insertSubview:refreshControl atIndex:0];
}

- (IBAction)didTapLogout:(id)sender {
    NSLog(@"Logout Tapped");
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        if(error != nil) {
            [self presentError:@"Logout Failed" message:@"Unable to logout user." error:error];
        }
        else {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            appDelegate.window.rootViewController
//            id<UIWindowSceneDelegate> sceneDelegate = [UIApplication sharedApplication].delegate;
//            UIWindow* window = [[UIApplication sharedApplication] keyWindow];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            
//            window.window.rootViewController = loginViewController;
//            [window.window setRootViewController:loginViewController];

            
            appDelegate.window.rootViewController = loginViewController;
//            sceneDelegate.window.rootViewController = loginViewController;

        }
    }];
}
@end
