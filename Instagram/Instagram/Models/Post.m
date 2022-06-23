//
//  Post.m
//  Instagram
//
//  Created by Chaytan Inman on 6/22/22.
//

#import <Foundation/Foundation.h>


//Post.m
#import "Post.h"
@implementation Post
    
    @dynamic postID;
    @dynamic userID;
    @dynamic caption;
    @dynamic image;

    + (nonnull NSString *)parseClassName {
        return @"Post";
    }
    
@end
