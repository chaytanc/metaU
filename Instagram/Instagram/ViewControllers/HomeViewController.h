//
//  HomeViewController.h
//  Instagram
//
//  Created by Chaytan Inman on 6/22/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
- (IBAction)didTapLogout:(id)sender;

@end

NS_ASSUME_NONNULL_END
