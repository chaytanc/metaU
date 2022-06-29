//
//  ProfileViewController.m
//  Instagram
//
//  Created by Chaytan Inman on 6/24/22.
//

#import "ProfileViewController.h"
#import "Parse/Parse.h"
#import "Post.h"
#import "UIImageView+AFNetworking.h"
#import "ProfileImagesCell.h"
#import "UIViewController+PresentError.h"

@interface ProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UIImagePickerController* imagePickerVC;
@property (nonatomic, strong) PFUser* user;
@property (nonatomic, strong) NSArray* userPosts;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imagePickerVC = [UIImagePickerController new];
    self.imagePickerVC.delegate = self;
    self.imagePickerVC.allowsEditing = YES;
    
    self.profilePhotosCollectionView.delegate = self;
    self.profilePhotosCollectionView.dataSource = self;
    
    // Make it rounded
    [self.profilePicImageView.layer setCornerRadius:self.profilePicImageView.frame.size.width/2]; 
    [self.profilePicImageView.layer setMasksToBounds:YES];

    
    self.user = [PFUser currentUser];
    [self addImageTapRecognizer];
    [self getUserPosts];
    
    // Refresh for the data in the tableview
    //XXX not working
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.profilePhotosCollectionView insertSubview:refreshControl atIndex:0];
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self getUserPosts];
    [refreshControl endRefreshing];
}

//XXX todo duplicate code from composeVC
- (void) addImageTapRecognizer {
    [self.profilePicImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer new] initWithTarget:self action:@selector(imageTapped:)];
    [self.profilePicImageView addGestureRecognizer:tapGesture];

}

- (void) imageTapped: (UITapGestureRecognizer*) tapGestureRecognizer {
    [self getPhoto];
}

- (void) getPhoto {
    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:self.imagePickerVC animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    [self.profilePicImageView setImage: editedImage];
    // trying to make pffileobject from nsimage adn upload it
    self.user[@"profilePic"] = [Post getPFFileFromImage:editedImage];
    // push to database??
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            NSLog(@"user profile pic updated!");
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
        // Update profile with new photo
        [self setProfileData];
    }];
    // Dismiss UIImagePickerController to go back to composing post
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (int) calcNumLikes {
    int totalLikes = 0;
    for(Post* post in self.userPosts) {
        totalLikes += [post.likeCount integerValue];
    }
    return totalLikes;
}

- (void) getUserPosts {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"author" equalTo:self.user];
//    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.userPosts = posts;
        } else {
            NSLog(@"%@", error.localizedDescription);
            [self presentError:@"Failed to retrieve user posts" message:error.localizedDescription error:error];
        }
        [self.profilePhotosCollectionView reloadData];
        [self setProfileData];
    }];
}

- (void) setProfileData {
    self.user = [PFUser currentUser];
    PFFileObject* imageObj = (PFFileObject*) self.user[@"profilePic"];
    NSString *URLString = imageObj.url;
    NSURL *url = [NSURL URLWithString:URLString];
    [self.profilePicImageView setImageWithURL:url];
    
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:self.user.username];
    [attributed beginEditing];
    [attributed addAttribute:NSFontAttributeName
               value:[UIFont fontWithName:@"Helvetica-Bold" size:14.0]
                range:NSRangeFromString(self.user.username)];
    [attributed endEditing];
    
    self.nameLabel.attributedText = attributed;
    self.leftNumLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.userPosts.count]; // num posts
    self.rightNumLabel.text = [NSString stringWithFormat:@"%d", [self calcNumLikes]]; // num likes
}

// MARK: CollectionView

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Post* post = self.userPosts[indexPath.row];
    NSURL *url = [NSURL URLWithString:post.image.url];
    ProfileImagesCell* cell = [self.profilePhotosCollectionView dequeueReusableCellWithReuseIdentifier:@"profileImagesCell" forIndexPath:indexPath];
    [cell.profileImagesImageView setImageWithURL: url];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.userPosts.count;
}

@end
