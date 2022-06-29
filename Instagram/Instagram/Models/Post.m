//
//  Post.m
//  Instagram
//
//  Created by Chaytan Inman on 6/22/22.
//

#import <Foundation/Foundation.h>


//Post.m
#import "Post.h"
#import "Parse/Parse.h"
#import "DateTools.h"

@implementation Post
    
// Dynamic means it may be nil at compile time but during runtime we will populate with some data, so
// tells the compiler to shut up for the time being
@dynamic postID;
@dynamic userID;
@dynamic caption;
@dynamic image;

@dynamic created;
//@dynamic createdAt;

@dynamic author;
@dynamic likeCount;
@dynamic commentCount;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

// Create a post with a specific image and caption, with initial like and comment count of 0
+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Post *newPost = [Post new];
    newPost.image = [self getPFFileFromImage:image];
    newPost.author = [PFUser currentUser];
    newPost.caption = caption;
    newPost.likeCount = @(0);
    newPost.commentCount = @(0);
    
    [newPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            NSLog(@"new post save created!");
            [newPost setFormattedCreatedAtString];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
        completion(succeeded, error);
    }];

}

// Load image data into a file object and return it
+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
 
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    PFFileObject* file = [PFFileObject fileObjectWithName:@"image.png" data:imageData];
    return file;
}


//NSString * const kCachedDateFormatterKey = @"CachedDateFormatterKey";
//
//+ (NSDateFormatter *)dateFormatter {
//    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
//    NSDateFormatter *formatter = [threadDictionary objectForKey:kCachedDateFormatterKey];
//    if (!formatter) {
//        formatter = [[NSDateFormatter alloc] init];
//        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
//        [formatter setLocale:enUSPOSIXLocale];
//        // Configure the input format to parse the date string
//        // 2022-06-27 22:00:15 +0000
//        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss ZZZZZ";
//        // Configure output format
//        formatter.dateStyle = NSDateFormatterShortStyle;
//        formatter.timeStyle = NSDateFormatterNoStyle;
//        [threadDictionary setObject:formatter forKey:kCachedDateFormatterKey];
//    }
//    return formatter;
//}


- (void) setFormattedCreatedAtString {
    // Convert String to Date
//    NSDate *date = [formatter dateFromString:createdAtOriginalString];
    NSDate* createdAtOriginalDate = self.createdAt;
    self.created = createdAtOriginalDate.shortTimeAgoSinceNow; // set post prop to have nicely formatted
}

@end
