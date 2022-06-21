//
//  TimelineViewController.h
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimelineViewController : UIViewController

// MARK: Properties
@property (nonatomic, strong) NSMutableArray* arrayOfTweets;
@property (weak, nonatomic) IBOutlet UITableView *timelineTableView;

@end
