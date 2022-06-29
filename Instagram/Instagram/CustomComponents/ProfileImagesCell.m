//
//  profileImagesCellCollectionViewCell.m
//  Instagram
//
//  Created by Chaytan Inman on 6/24/22.
//

#import "ProfileImagesCell.h"

@implementation ProfileImagesCell

- (void) layoutSubviews {
    // Make it rounded
    [self.profileImagesImageView.layer setCornerRadius:self.profileImagesImageView.frame.size.width/20];
    [self.profileImagesImageView.layer setMasksToBounds:YES];
}



@end
