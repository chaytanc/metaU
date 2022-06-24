//
//  ProfileViewController.h
//  Instagram
//
//  Created by Chaytan Inman on 6/24/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *profilePicImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftNumDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *midNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *midNumDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightNumDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

NS_ASSUME_NONNULL_END
