//
//  movieCell.m
//  Flixster
//
//  Created by Chaytan Inman on 6/15/22.
//

#import "MovieCell.h"

@implementation MovieCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
