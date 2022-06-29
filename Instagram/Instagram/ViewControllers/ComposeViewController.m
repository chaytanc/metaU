//
//  ComposeViewController.m
//  Instagram
//
//  Created by Chaytan Inman on 6/23/22.
//

#import "ComposeViewController.h"
#import "Post.h"
#import "UIViewController+PresentError.h"

@interface ComposeViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, weak) UIImage* selectedImage;
@property (nonatomic, strong) UIImagePickerController* imagePickerVC;
@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imagePickerVC = [UIImagePickerController new];
    self.imagePickerVC.delegate = self;
    self.imagePickerVC.allowsEditing = YES;
    [self addImageTapRecognizer];
    // Automatically pull up photo picker on didLoad
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
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    [self.picImageView setImage: editedImage];
    self.selectedImage = editedImage;
    
    // Dismiss UIImagePickerController to go back to composing post
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) addImageTapRecognizer {
    [self.picImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer new] initWithTarget:self action:@selector(imageTapped:)];
    [self.picImageView addGestureRecognizer:tapGesture];

}

- (void) imageTapped: (UITapGestureRecognizer*) tapGestureRecognizer {
    [self getPhoto];
}

- (IBAction)didTapShare:(id)sender {
    // Posts to PFUser's currentUser account
    [Post postUserImage:self.selectedImage withCaption:self.captionField.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UITabBarController *homeViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeTabController"];
            homeViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:homeViewController animated:YES completion:nil];
        }
        else {
            [self presentError:@"Failed to Post" message:error.localizedDescription error:error];
        }
    }];
}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
