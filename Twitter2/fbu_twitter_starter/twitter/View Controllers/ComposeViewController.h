//
//  ComposeViewController.h
//  twitter
//
//  Created by Chaytan Inman on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

// Hypothesis: Things that subclass this delegate will receive information from ComposeVC and therefore must implement the following methods to be able to receive that info
@protocol ComposeViewControllerDelegate <NSObject>

- (void)didTweet:(Tweet *)tweet;

@end

@interface ComposeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (weak, nonatomic) IBOutlet UILabel *charCountLabel;
@property (weak, nonatomic) id<ComposeViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
