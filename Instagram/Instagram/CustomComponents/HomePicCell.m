//
//  HomePicCell.m
//  Instagram
//
//  Created by Chaytan Inman on 6/24/22.
//

#import "HomePicCell.h"
#import "UIImageView+AFNetworking.h"
//#import "GenericUtility.h"

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
    [self.post.author fetchIfNeeded];

//    self.captionLabel.text = self.post.caption;
    
    // Combines caption and username into the same string and bold fonts the username
//    NSDictionary *parameters = @{@"id": tweet.idStr};
    NSString *usernameString = [self.post.author.username stringByAppendingFormat:@"   "];
    NSRange selectedRange = NSMakeRange(0, usernameString.length - 1); // len characters, starting at index 0
    NSString *string = [usernameString stringByAppendingString: self.post.caption];
    NSRange captionRange = NSMakeRange(usernameString.length, string.length - usernameString.length);
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:string];
    
    [attributed beginEditing];
    [attributed addAttribute:NSFontAttributeName
               value:[UIFont fontWithName:@"Helvetica-Bold" size:14.0]
               range:selectedRange];
    [attributed addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0] range:captionRange];
    [attributed endEditing];

    self.captionLabel.attributedText = attributed;
}
@end
