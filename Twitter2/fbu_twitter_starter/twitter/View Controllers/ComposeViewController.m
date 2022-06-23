//
//  ComposeViewController.m
//  twitter
//
//  Created by Chaytan Inman on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"
//#import "RSKPlaceholderTextView/RSKPlaceholderTextView-umbrella.h"

@interface ComposeViewController ()
@property (nonatomic, weak) UITextView* textView;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tweetTextView.delegate = self; // So we can set respond to editing and update char count
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)textViewDidChange:(UITextView *)textView {
    [self checkTweetLength:^(BOOL goodLengthTweet, NSUInteger length) {
        if(goodLengthTweet) {
            self.charCountLabel.textColor = [UIColor grayColor];
        }
        else {
            self.charCountLabel.textColor = [UIColor redColor];
        }
        self.charCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)length];
    }];
}

- (void) checkTweetLength: (void(^)(BOOL goodLengthTweet, NSUInteger len))completion {
    NSUInteger length = [self.tweetTextView.text length];
    if(length > 280) {
        // Too long
        completion(NO, length);
    }
    else {
        completion(YES, length);
    }
}

- (IBAction)didTapClose:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)didTapTweet:(id)sender {
    [self checkTweetLength:^(BOOL goodLengthTweet, NSUInteger length) {
        // Make network post call if good length, otherwise present error
        if(goodLengthTweet) {
            NSString* text = self.tweetTextView.text;
            [[APIManager shared] postStatusWithText:text completion:^(Tweet* tweet, NSError* error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(tweet) {
                        NSLog(@"Tweet success!");
                        [self.delegate didTweet:tweet];
                        [self dismissViewControllerAnimated:true completion:nil];
                    }
                    else {
                        NSLog(@"%@", error);
                        [self presentNetworkErrorAlert: error];
                    }
                });
            }];
        }
        else {
            [self presentTweetLengthErrorAlert];
        }
    }];

}


- (void) presentTweetLengthErrorAlert {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Too Long!"
                                   message:@"They say brevity is a virtue or something like that"
                                   preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
       handler:^(UIAlertAction * action) {}];

    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

// NOTE: Ideally this func would be in some shared imported class since I had to copy paste it from timelineVC
- (void) presentNetworkErrorAlert: (NSError *) error {
    NSLog(@"%@", error);
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Network Error"
                                   message:@"Tweet failed to post. Check your connection."
                                   preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
       handler:^(UIAlertAction * action) {}];

    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
