//
//  TweetCell.h
//  twitter
//
//  Created by Chaytan Inman on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface TweetCell : UITableViewCell
// MARK: Properties
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
// Header
@property (weak, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
// Tweet
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) Tweet* tweet;
// Buttons bar
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *numCommentsLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UILabel *numRetweetsLabel;
@property (weak, nonatomic) IBOutlet UIButton *favButton;
@property (weak, nonatomic) IBOutlet UILabel *numFavLabel;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;

// MARK: Methods

- (IBAction)didTapComment:(id)sender;
- (IBAction)didTapRetweet:(id)sender;
- (IBAction)didTapFav:(id)sender;
- (IBAction)didTapMessage:(id)sender;
- (void)refreshData;

@end

NS_ASSUME_NONNULL_END
