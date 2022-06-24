//
//  ComposeViewController.h
//  Instagram
//
//  Created by Chaytan Inman on 6/23/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ComposeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UITextView *captionField;
- (IBAction)didTapCancel:(id)sender;
- (IBAction)didTapShare:(id)sender;

@end

NS_ASSUME_NONNULL_END
