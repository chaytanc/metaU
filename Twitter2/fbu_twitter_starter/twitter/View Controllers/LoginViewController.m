//
//  LoginViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "LoginViewController.h"
#import "APIManager.h"
#import "TimelineViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapLogin:(id)sender {
    // Unsure how APIManager has the function loginWithCompletion since it seems to be in BDBOAuth...
    [[APIManager shared] loginWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
//            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
//            self.modalPresentationStyle = UIModalPresentationFullScreen;
//            TimelineViewController *timelineVC = [[TimelineViewController alloc] init];
//            [self.navigationController pushViewController:timelineVC animated:YES];

            //XXX for some reason the above attempts to show the home timeline were not working when relogging in
            // so this brute force approach was necessary
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            TimelineViewController *timelineViewController = [storyboard instantiateViewControllerWithIdentifier:@"TimelineNavigationController"];
            appDelegate.window.rootViewController = timelineViewController;

        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
