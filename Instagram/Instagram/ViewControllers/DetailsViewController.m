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
    // Do any additional setup after loading the view.
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
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *destController = [segue destinationViewController];
    destController.modalPresentationStyle = UIModalPresentationFullScreen;
}

- (IBAction)backButtonTapped:(id)sender {
    
    SceneDelegate *sceneDelegate = (SceneDelegate * ) UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *loginViewController = (UITabBarController*) [storyboard instantiateViewControllerWithIdentifier:@"HomeTabController"];

    [sceneDelegate.window setRootViewController:loginViewController];
}

@end
