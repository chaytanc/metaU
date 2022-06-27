//
//  HomePicCell.h
//  Instagram
//
//  Created by Chaytan Inman on 6/24/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomePicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) Post* post;

- (void) refreshData;

@end

NS_ASSUME_NONNULL_END
