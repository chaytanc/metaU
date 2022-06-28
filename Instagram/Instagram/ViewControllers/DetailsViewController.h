//
//  DetailsViewController.h
//  Instagram
//
//  Created by Chaytan Inman on 6/27/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
@property (strong, nonatomic) Post* post;
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
@property (weak, nonatomic) IBOutlet UILabel *numLikesLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
- (IBAction)backButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;

@end

NS_ASSUME_NONNULL_END
