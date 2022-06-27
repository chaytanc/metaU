//
//  ComposeViewController.m
//  Instagram
//
//  Created by Chaytan Inman on 6/23/22.
//

#import "ComposeViewController.h"

@interface ComposeViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, weak) UIImage* selectedImage;
@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    //XXX todo Do something with the images (based on your use case)
    [self.picImageView setImage: editedImage];
    self.selectedImage = editedImage;
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

// todo tap imageview and pull up imagepickercontroller again
//- (void)

- (IBAction)didTapShare:(id)sender {
    //xxx post w caption and image
    // where do we get currently logged in user id from?
    // post.image = selectedImage;
}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
