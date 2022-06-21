//
//  TweetCell.m
//  twitter
//
//  Created by Chaytan Inman on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didTapMessage:(id)sender {
    NSLog(@"Message Icon tapped!");
}

- (IBAction)didTapFav:(id)sender {
    NSLog(@"Favorite Icon tapped!");

}

- (IBAction)didTapRetweet:(id)sender {
    NSLog(@"Retweet Icon tapped!");

}

- (IBAction)didTapComment:(id)sender {
    NSLog(@"Comment Icon tapped!");

}

@end
