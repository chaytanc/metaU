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

@implementation Post
    
// Dynamic means it may be nil at compile time but during runtime we will populate with some data, so
// tells the compiler to shut up for the time being
@dynamic postID;
@dynamic userID;
@dynamic caption;
@dynamic image;

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
    
    [newPost saveInBackgroundWithBlock: completion];
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
    //XXX is this naming it image.png or referencing a file presumed to already exist?
    PFFileObject* file = [PFFileObject fileObjectWithName:@"image.png" data:imageData];
    return file;
}

@end
