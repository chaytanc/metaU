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


@interface TimelineViewController () <UITableViewDataSource>
- (IBAction)didTapLogout:(id)sender;


@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timelineTableView.dataSource = self;

    // Get timeline and print tweets that we found from the call
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            self.arrayOfTweets = tweets; //XXX is this warning of "Incompatible pointer types assigning to 'NSMutableArray *' from 'NSArray *'" ok??

            for (Tweet *tweet in tweets) {
                NSString *text = tweet.text;
                NSLog(@"%@", text);
            }
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.timelineTableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// Switch to loginVC when user taps logout
- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    // Clear authentication access tokens
    [[APIManager shared] logout];
}

// MARK: Tableview
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    TweetCell *cell = [self.timelineTableView dequeueReusableCellWithIdentifier:@"tweetCell_ID" forIndexPath:indexPath];

    // set profile pic
    NSString *URLString = tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    [cell.profileImageView setImageWithURL: url];

    // set display name, user name, createdAt
    NSString* username = [@"@" stringByAppendingString:tweet.user.screenName];
    cell.userNameLabel.text = username;
    [cell.userNameLabel setFont:[UIFont systemFontOfSize:14]];
    cell.userNameLabel.minimumScaleFactor = 0.5;
    cell.userNameLabel.adjustsFontSizeToFitWidth = YES;
    
    cell.displayNameLabel.text = tweet.user.name;
    [cell.displayNameLabel setFont:[UIFont boldSystemFontOfSize:14]];
    cell.displayNameLabel.minimumScaleFactor = 0.5;
    cell.displayNameLabel.adjustsFontSizeToFitWidth = YES;
    cell.displayNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.displayNameLabel.numberOfLines = 0;

    cell.createdAtLabel.text = tweet.createdAtString;
    [cell.createdAtLabel setFont:[UIFont systemFontOfSize:14]];
    cell.createdAtLabel.minimumScaleFactor = 0.5;
    cell.createdAtLabel.adjustsFontSizeToFitWidth = YES;
    
    // set retweet, fav icons images based on tweet status
    if (tweet.retweeted) {
        UIImage *retweetedImageIcon = [UIImage imageNamed: @"retweet-icon-green"];
        [cell.retweetButton setImage:retweetedImageIcon forState: UIControlStateNormal];
    }
    if (tweet.favorited) {
        UIImage *favoritedImageIcon = [UIImage imageNamed: @"favorite-icon-red"];
        [cell.favButton setImage:favoritedImageIcon forState: UIControlStateNormal];
    }

    // set tweet content
    cell.tweetLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.tweetLabel.numberOfLines = 0;
    cell.tweetLabel.minimumScaleFactor = 0.5;
    [cell.tweetLabel setFont:[UIFont systemFontOfSize:12]];
    cell.tweetLabel.text = tweet.text;

    // set num favs, retweets, comments
    cell.numFavLabel.text = [NSString stringWithFormat:@"%i", tweet.favoriteCount];
    cell.numFavLabel.minimumScaleFactor = 0.5;
    cell.numFavLabel.adjustsFontSizeToFitWidth = YES;
    [cell.numFavLabel setFont:[UIFont systemFontOfSize:10]];

    cell.numCommentsLabel.text = [NSString stringWithFormat:@"%i", tweet.commentCount];
    cell.numCommentsLabel.minimumScaleFactor = 0.5;
    cell.numCommentsLabel.adjustsFontSizeToFitWidth = YES;
    [cell.numCommentsLabel setFont:[UIFont systemFontOfSize:10]];
    
    cell.numRetweetsLabel.text = [NSString stringWithFormat:@"%i", tweet.retweetCount];
    cell.numRetweetsLabel.minimumScaleFactor = 0.5;
    cell.numRetweetsLabel.adjustsFontSizeToFitWidth = YES;
    [cell.numRetweetsLabel setFont:[UIFont systemFontOfSize:10]];
    
    // Fix button titles to be empty
    [cell.commentButton setTitle: @"" forState:UIControlStateNormal];
    [cell.retweetButton setTitle: @"" forState:UIControlStateNormal];
    [cell.favButton setTitle: @"" forState:UIControlStateNormal];
    [cell.messageButton setTitle: @"" forState:UIControlStateNormal];

    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfTweets.count;
}


@end
