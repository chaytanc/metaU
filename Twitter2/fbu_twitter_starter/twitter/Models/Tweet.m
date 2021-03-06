//
//  Tweet.m
//  twitter
//
//  Created by Chaytan Inman on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "Tweet.h"
#import "User.h"
#import "DateTools.h"

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
  
        self.idStr = dictionary[@"id_str"];
        self.text = dictionary[@"full_text"];
        self.favoriteCount = [dictionary[@"favorite_count"] intValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.retweetCount = [dictionary[@"retweet_count"] intValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        //XXX note that this currently displays reply_count=0 because it is a premium developer feature
        self.commentCount = [dictionary[@"reply_count"] intValue];

        self.user = [[User alloc] initWithDictionary: dictionary[@"user"]];
        // Format and set createdAtString
        NSString *createdAtOriginalString = dictionary[@"created_at"];
        NSDateFormatter* formatter = [Tweet dateFormatter];
        [self setFormattedCreatedAtString:createdAtOriginalString :formatter];

    }
    return self;
}

NSString * const kCachedDateFormatterKey = @"CachedDateFormatterKey";

+ (NSDateFormatter *)dateFormatter {
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *formatter = [threadDictionary objectForKey:kCachedDateFormatterKey];
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [formatter setLocale:enUSPOSIXLocale];
        // Configure the input format to parse the date string
        formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
        // Configure output format
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        [threadDictionary setObject:formatter forKey:kCachedDateFormatterKey];
    }
    return formatter;
}

- (void) setFormattedCreatedAtString: (NSString*) createdAtOriginalString: (NSDateFormatter *) formatter {
    // Configure the input format to parse the date string
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    // Convert String to Date
    NSDate *date = [formatter dateFromString:createdAtOriginalString];
    self.createdAtString = date.shortTimeAgoSinceNow;
}


@end
