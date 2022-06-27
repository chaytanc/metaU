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

- (void) layoutSubviews {
    [super layoutSubviews];
    [self formatAuthorLabel];
    [self formatCaptionLabel];
    [self formatPicImageView];
}

- (void) formatAuthorLabel {
    [self.authorLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
}

- (void) formatCaptionLabel {
    
}

- (void) formatPicImageView {
    // Make it rounded
    [self.picImageView.layer setCornerRadius:self.picImageView.frame.size.width/20];
    [self.picImageView.layer setMasksToBounds:YES];
}

// Set up caption, author, image of feedTableView cell
- (void) refreshData {
    NSString *URLString = self.post.image.url;
    NSURL *url = [NSURL URLWithString:URLString];
    [self.picImageView setImageWithURL: url];
    self.captionLabel.text = self.post.caption;
    [self.post.author fetchIfNeeded];
    self.authorLabel.text = self.post.author.username;
}

@end
