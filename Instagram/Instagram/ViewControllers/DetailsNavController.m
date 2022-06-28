//
//  DetailsNavController.m
//  Instagram
//
//  Created by Chaytan Inman on 6/27/22.
//

#import "DetailsNavController.h"
#import "DetailsViewController.h"

@interface DetailsNavController ()

@end

@implementation DetailsNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navigationController = [segue destinationViewController];
    navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailsViewController *detailsViewController = [storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    detailsViewController.post = self.post;
}


@end
