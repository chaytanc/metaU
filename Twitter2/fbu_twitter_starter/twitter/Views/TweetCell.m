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
