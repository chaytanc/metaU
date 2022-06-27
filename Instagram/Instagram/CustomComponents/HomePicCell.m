//
//  HomePicCell.m
//  Instagram
//
//  Created by Chaytan Inman on 6/24/22.
//

#import "HomePicCell.h"
#import "UIImageView+AFNetworking.h"

@implementation HomePicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// Set up caption, author, image of feed cell
- (void) refreshData {
    NSString *URLString = self.post.image.url;
    NSURL *url = [NSURL URLWithString:URLString];
    [self.picImageView setImageWithURL: url];
    self.captionLabel.text = self.post.caption;
    self.authorLabel.text = self.post.author.username;
    
}


@end
