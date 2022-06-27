//
//  HomeViewController.m
//  Instagram
//
//  Created by Chaytan Inman on 6/22/22.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"
#import "UIViewController+PresentError.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Refresh for the data in the tableview
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.feedTableView insertSubview:refreshControl atIndex:0];
}

- (void) reloadData {
    
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    
    [self reloadData];
    [self.feedTableView reloadData];
}

- (IBAction)didTapLogout:(id)sender {
    NSLog(@"Logout Tapped");
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        if(error != nil) {
            [self presentError:@"Logout Failed" message:@"Unable to logout user." error:error];
        }
        else {
            SceneDelegate *sceneDelegate = (SceneDelegate * ) UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];

            [sceneDelegate.window setRootViewController:loginViewController];

        }
    }];
}
@end
