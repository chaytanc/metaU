//
//  HomeViewController.h
//  Instagram
//
//  Created by Chaytan Inman on 6/22/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *feedTableView;
- (IBAction)didTapLogout:(id)sender;

@end

NS_ASSUME_NONNULL_END
