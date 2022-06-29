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
@dynamic likedBy;

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
    newPost.likedBy = [NSMutableArray new];
    
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

- (void) setFormattedCreatedAtString {
    // Convert String to Date
//    NSDate *date = [formatter dateFromString:createdAtOriginalString];
    NSDate* createdAtOriginalDate = self.createdAt;
    self.created = createdAtOriginalDate.shortTimeAgoSinceNow; // set post prop to have nicely formatted
}

@end
