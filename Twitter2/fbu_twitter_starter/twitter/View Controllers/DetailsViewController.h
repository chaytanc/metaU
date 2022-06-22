//
//  DetailsViewController.h
//  Pods
//
//  Created by Chaytan Inman on 6/21/22.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;

@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *numCommentsLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UILabel *numRetweetsLabel;
@property (weak, nonatomic) IBOutlet UIButton *favButton;
@property (weak, nonatomic) IBOutlet UILabel *numFavLabel;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;

@property (weak, nonatomic) Tweet* tweet;
- (IBAction)didTapRetweet:(id)sender;
- (IBAction)didTapFav:(id)sender;
- (void)refreshData;


@end

NS_ASSUME_NONNULL_END
