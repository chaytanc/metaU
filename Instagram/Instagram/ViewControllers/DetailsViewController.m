//
//  DetailsViewController.m
//  Instagram
//
//  Created by Chaytan Inman on 6/27/22.
//

#import "DetailsViewController.h"
#import "HomeViewController.h"
#import "UIImageView+AFNetworking.h"
#import "SceneDelegate.h"


@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addImageTapRecognizer];

}

- (void) viewWillAppear:(BOOL)animated {
    [self refreshData];
}


- (void) formatPicImageView {
    // Make it rounded
    [self.picImageView.layer setCornerRadius:self.picImageView.frame.size.width/20];
    [self.picImageView.layer setMasksToBounds:YES];
}

// Set up caption, author, image of feedTableView cell
- (void) refreshData {
    self.numLikesLabel.text = [NSString stringWithFormat:@"%@", self.post.likeCount];
    [self.post setFormattedCreatedAtString];
    self.timestampLabel.text = self.post.created;
    
    // Set picture
    NSString *URLString = self.post.image.url;
    NSURL *url = [NSURL URLWithString:URLString];
    [self.picImageView setImageWithURL: url];
    [self.post.author fetchIfNeeded];
    
    // Combines caption and username into the same string and bold fonts the username
    NSString *usernameString = [self.post.author.username stringByAppendingFormat:@"   "];
    NSRange selectedRange = NSMakeRange(0, usernameString.length - 1); // len characters, starting at index 0
    NSString *string = [usernameString stringByAppendingString: self.post.caption];
    NSRange captionRange = NSMakeRange(usernameString.length, string.length - usernameString.length);
    
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:string];
    [attributed beginEditing];
    [attributed addAttribute:NSFontAttributeName
               value:[UIFont fontWithName:@"Helvetica-Bold" size:14.0]
               range:selectedRange];
    [attributed addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0] range:captionRange];
    [attributed endEditing];
    self.captionLabel.attributedText = attributed;
    
    // If liked by user, set heart to be filled in
    if([self.post.likedBy containsObject:[PFUser currentUser].username]) {
        [self.likeImageView setImage:[UIImage systemImageNamed:@"heart.fill"]];
    }
    else {
        [self.likeImageView setImage:[UIImage systemImageNamed:@"heart"]];
    }
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *destController = [segue destinationViewController];
    destController.modalPresentationStyle = UIModalPresentationFullScreen;
}


- (void) addImageTapRecognizer {

    [self.picImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer new] initWithTarget:self action:@selector(imageDoubleTapped:)];
    [tapGesture setNumberOfTapsRequired:2];
    [self.picImageView addGestureRecognizer:tapGesture];

}

- (void) imageDoubleTapped: (UITapGestureRecognizer*) tapGestureRecognizer {

    // If we already liked the post
    NSString* username = [PFUser currentUser].username;
    // If already liked, remove, otherwise add
    if([self.post.likedBy containsObject:username]) {
        [self.post.likedBy removeObject:username];
    }
    else {
        [self.post.likedBy addObject:username];
    }
    self.post.likeCount = @(self.post.likedBy.count);
    // Note: This line was unintuitively necessary to update the database w likedBy
    self.post[@"likedBy"] = self.post.likedBy;
    
    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            NSLog(@"Like count updated!");
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self refreshData];
    }];
}


- (IBAction)backButtonTapped:(id)sender {
    
    SceneDelegate *sceneDelegate = (SceneDelegate * ) UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *loginViewController = (UITabBarController*) [storyboard instantiateViewControllerWithIdentifier:@"HomeTabController"];

    [sceneDelegate.window setRootViewController:loginViewController];
}

@end
