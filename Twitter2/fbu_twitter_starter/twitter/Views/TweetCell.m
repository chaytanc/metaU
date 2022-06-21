//
//  TweetCell.m
//  twitter
//
//  Created by Chaytan Inman on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) formatHeaderAndBody {
    [self.userNameLabel setFont:[UIFont systemFontOfSize:14]];
    self.userNameLabel.minimumScaleFactor = 0.5;
    self.userNameLabel.adjustsFontSizeToFitWidth = YES;
    
    [self.displayNameLabel setFont:[UIFont boldSystemFontOfSize:14]];
    self.displayNameLabel.minimumScaleFactor = 0.5;
    self.displayNameLabel.adjustsFontSizeToFitWidth = YES;
    self.displayNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.displayNameLabel.numberOfLines = 0;

    [self.createdAtLabel setFont:[UIFont systemFontOfSize:14]];
    self.createdAtLabel.minimumScaleFactor = 0.5;
    self.createdAtLabel.adjustsFontSizeToFitWidth = YES;
    
    // set tweet content
    //XXX despite these efforts, tweets still get cut off by ellipse after certain length instead of making new lines and wrapping or shrinking font size
    self.tweetLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.tweetLabel.numberOfLines = 0;
    self.tweetLabel.minimumScaleFactor = 0.5;
    [self.tweetLabel setFont:[UIFont systemFontOfSize:12]];
}

- (void) formatFooter {
    // format num favs, retweets, comments
    self.numFavLabel.minimumScaleFactor = 0.5;
    self.numFavLabel.adjustsFontSizeToFitWidth = YES;
    [self.numFavLabel setFont:[UIFont systemFontOfSize:10]];

    self.numCommentsLabel.minimumScaleFactor = 0.5;
    self.numCommentsLabel.adjustsFontSizeToFitWidth = YES;
    [self.numCommentsLabel setFont:[UIFont systemFontOfSize:10]];
    
    self.numRetweetsLabel.minimumScaleFactor = 0.5;
    self.numRetweetsLabel.adjustsFontSizeToFitWidth = YES;
    [self.numRetweetsLabel setFont:[UIFont systemFontOfSize:10]];
    
    // Fix button titles to be empty
    [self.commentButton setTitle: @"" forState:UIControlStateNormal];
    [self.retweetButton setTitle: @"" forState:UIControlStateNormal];
    [self.favButton setTitle: @"" forState:UIControlStateNormal];
    [self.messageButton setTitle: @"" forState:UIControlStateNormal];
}

- (void)refreshData{
    NSString* username = [@"@" stringByAppendingString:self.tweet.user.screenName];
    self.userNameLabel.text = username;
    self.displayNameLabel.text = self.tweet.user.name;
    self.createdAtLabel.text = self.tweet.createdAtString;
    self.tweetLabel.text = self.tweet.text;
    self.numFavLabel.text = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
    self.numCommentsLabel.text = [NSString stringWithFormat:@"%i", self.tweet.commentCount];
    self.numRetweetsLabel.text = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];

    // set retweet, fav icons images based on tweet status
    if (self.tweet.retweeted) {
        UIImage *retweetedImageIcon = [UIImage imageNamed: @"retweet-icon-green"];
        [self.retweetButton setImage:retweetedImageIcon forState: UIControlStateNormal];
    }
    else {
        UIImage *retweetedImageIcon = [UIImage imageNamed: @"retweet-icon"];
        [self.retweetButton setImage:retweetedImageIcon forState: UIControlStateNormal];
    }
    if (self.tweet.favorited) {
        UIImage *favoritedImageIcon = [UIImage imageNamed: @"favor-icon-red"];
        [self.favButton setImage:favoritedImageIcon forState: UIControlStateNormal];
    }
    else {
        UIImage *favoritedImageIcon = [UIImage imageNamed: @"favor-icon"];
        [self.favButton setImage:favoritedImageIcon forState: UIControlStateNormal];
    }

}

- (IBAction)didTapMessage:(id)sender {
    NSLog(@"Message Icon tapped!");
}

- (IBAction)didTapFav:(id)sender {
    NSLog(@"Favorite Icon tapped!");
    // Toggle favorited state and update count
    // Destroy favorite
    NSString* urlString;
    if(self.tweet.favorited) {
        urlString = @"1.1/favorites/destroy.json";
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
    }
    // Create favorite
    else {
        urlString = @"1.1/favorites/create.json";
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
    }
    [[APIManager shared] tweetButtonRequest:self.tweet urlString:urlString completion:^(Tweet * tweet, NSError * error) {
        if(error){
             NSLog(@"Error toggling favorite on tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully toggled favorite on the Tweet: %@", tweet.text);
        }
    }];

    [self refreshData];
}

- (IBAction)didTapRetweet:(id)sender {
    NSLog(@"Retweet Icon tapped!");
    // Toggle retweeted state and update count
    NSString* urlString;
    // Destroy retweet
    if(self.tweet.retweeted) {
        NSString* urlEnding = [self.tweet.idStr stringByAppendingString:@".json"];
        urlString = [@"1.1/statuses/unretweet/" stringByAppendingString:urlEnding];
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
    }
    // Create retweet
    else {
        NSString* urlEnding = [self.tweet.idStr stringByAppendingString:@".json"];
        urlString = [@"1.1/statuses/retweet/" stringByAppendingString:urlEnding];
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
    }
    [[APIManager shared] tweetButtonRequest:self.tweet urlString:urlString completion:^(Tweet * tweet, NSError * error) {
        if(error){
             NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
        }
    }];
    [self refreshData];

}

- (IBAction)didTapComment:(id)sender {
    NSLog(@"Comment Icon tapped!");

}

@end
