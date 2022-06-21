//
//  Tweet.m
//  twitter
//
//  Created by Chaytan Inman on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "Tweet.h"
#import "User.h"

@implementation Tweet

// Tweet factory method for iterating over array of tweet dictionaries (from API call) and returning an array of [Tweet]
+ (NSMutableArray *)tweetsWithArray:(NSArray *)dictionaries {
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:dictionary];
        [tweets addObject:tweet];
    }
    return tweets;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];

    if (self) {
        // Check if this is this a re-tweet
        NSDictionary *originalTweet = dictionary[@"retweeted_status"];
        if (originalTweet != nil) {
            NSDictionary *userDictionary = dictionary[@"user"];
            self.retweetedByUser = [[User alloc] initWithDictionary:userDictionary];

            // Change tweet to original tweet
            dictionary = originalTweet;
        }
        //XXX what happens if it was a retweet?? By default a tweet's user is set to user unless it's a retweet in which case the user is 
        self.idStr = dictionary[@"id_str"];
        self.text = dictionary[@"text"];
        self.favoriteCount = [dictionary[@"favorite_count"] intValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.retweetCount = [dictionary[@"retweet_count"] intValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        self.commentCount = [dictionary[@"reply_count"] intValue];

        // TODO: initialize user
        self.user = [[User alloc] initWithDictionary: dictionary[@"user"]];

        // TODO: Format and set createdAtString
        NSString *createdAtOriginalString = dictionary[@"created_at"];
        [self setFormattedCreatedAtString: createdAtOriginalString];

    }
    return self;
}

- (void) setFormattedCreatedAtString: (NSString*) createdAtOriginalString {
    // Format createdAt date string
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // Configure the input format to parse the date string
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    // Convert String to Date
    NSDate *date = [formatter dateFromString:createdAtOriginalString];
    // Configure output format
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    self.createdAtString = [formatter stringFromDate:date];
}

@end
