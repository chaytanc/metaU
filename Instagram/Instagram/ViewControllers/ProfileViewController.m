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
    
    self.user = [PFUser currentUser];
    [self addImageTapRecognizer];
    [self setProfileData];
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

// Todo: set profile, username, followers, etc
// Todo: set collection view

- (void) getUserPosts {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    // If we want to get more than 20, query based on date and store latest date or post taht was fetched
//    [query whereKey:@"likesCount" greaterThan:@100];
    //XXX todo when loading more than 20, have to store latest shown
//    [query orderByDescending:@"createdAt" whereKey:"createdAt" greaterThan:lastLoaded];
    [query whereKey:@"author" matchesText:[PFUser currentUser].objectId];
//    [query orderByDescending:@"createdAt"];
//    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.userPosts = posts;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.profilePhotosCollectionView reloadData];
    }];
}

- (void) setProfileData {
    self.user = [PFUser currentUser];
    PFFileObject* imageObj = (PFFileObject*) self.user[@"profilePic"];
    NSString *URLString = imageObj.url;
    NSURL *url = [NSURL URLWithString:URLString];
    [self.profilePicImageView setImageWithURL:url];
    
//    NSString *usernameString = [self.user.username stringByAppendingFormat:@"   "];
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:self.user.username];
    [attributed beginEditing];
    [attributed addAttribute:NSFontAttributeName
               value:[UIFont fontWithName:@"Helvetica-Bold" size:14.0]
                range:NSRangeFromString(self.user.username)];
    [attributed endEditing];
    self.nameLabel.attributedText = attributed;
//    self.leftNumLabel = // num posts
//    self.rightNumLabel = // num likes
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
