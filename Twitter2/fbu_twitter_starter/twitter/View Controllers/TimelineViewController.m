//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"


@interface TimelineViewController () <UITableViewDataSource, ComposeViewControllerDelegate>
- (IBAction)didTapLogout:(id)sender;


@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timelineTableView.dataSource = self;
    
    // Refresh for the data in the tableview
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.timelineTableView insertSubview:refreshControl atIndex:0];
    [self.timelineTableView setAllowsSelection:NO];

    [self fetchTweets];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) fetchTweets {
    
    // Get timeline and print tweets that we found from the call
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            self.arrayOfTweets = tweets; //XXX is this warning of "Incompatible pointer types assigning to 'NSMutableArray *' from 'NSArray *'" ok??
        }
        else {
            [self presentNetworkErrorAlert];
        }

        [self.timelineTableView reloadData];
    }];
    
}

- (void) presentNetworkErrorAlert {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Network Error"
                                   message:@"Tweets failed to load. Check your connection."
                                   preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
       handler:^(UIAlertAction * action) {}];

    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//XXX is this the segue going TO this VC instead of FROM this vc to Compose
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //XXX How does this know what destinationVC is?? Shouldn't it be passed in to this method or something?
    // Get the new view controller using [segue destinationViewController].
    UINavigationController *navigationController = [segue destinationViewController];
    //XXX does this assume that we're coming from composeController? What if we had more VCs?
    ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
    // Tell composeController we can receive info about tweet composed
    composeController.delegate = self;
}

// Switch to loginVC when user taps logout
- (IBAction)didTapLogout:(id)sender {
    
    // Segue to LoginVC w appDelegate
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    // Clear authentication access tokens
    [[APIManager shared] logout];
}

// MARK: Refresh

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    
    // Get timeline and print tweets that we found from the call
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully refreshed home timeline");
            self.arrayOfTweets = tweets;
        }
        else {
            [self presentNetworkErrorAlert];
        }

        [self.timelineTableView reloadData];
        // Tell the refreshControl to stop spinning
         [refreshControl endRefreshing];
    }];

}


// MARK: Tableview
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    TweetCell *cell = [self.timelineTableView dequeueReusableCellWithIdentifier:@"tweetCell_ID" forIndexPath:indexPath];
    // Passes tweet data to TweetCell
    cell.tweet = tweet;

    // set profile pic
    NSString *URLString = tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    [cell.profileImageView setImageWithURL: url];
    // Make it a circle
    [cell.profileImageView.layer setCornerRadius:cell.profileImageView.frame.size.width/2];
    [cell.profileImageView.layer setMasksToBounds:YES];

    [cell formatHeaderAndBody];
    [cell formatFooter];
    [cell refreshData];
        
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfTweets.count;
}

// Receive tweet tweeted as a delegate of ComposeVC
- (void)didTweet:(nonnull Tweet *)tweet {
    // Add to our array of tweets to display and reload (and remove oldest being displayed)
    [self.arrayOfTweets insertObject:tweet atIndex:0];
    NSUInteger endOfArray = self.arrayOfTweets.count - 1;
    [self.arrayOfTweets removeObjectAtIndex:endOfArray];
    [self.timelineTableView reloadData];
}


@end
