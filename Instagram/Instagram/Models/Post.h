//
//  Post.h
//  Instagram
//
//  Created by Chaytan Inman on 6/22/22.
//


#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface Post : PFObject<PFSubclassing>

    @property (nonatomic, strong) NSString *postID;
    @property (nonatomic, strong) NSString *userID;
    @property (nonatomic, strong) NSString *caption;
    
    @property (nonatomic, strong) PFFileObject *image;

    @property (nonatomic, strong) PFUser *author;
    @property (nonatomic, strong) NSNumber *likeCount;
    @property (nonatomic, strong) NSNumber *commentCount;
    @property (nonatomic, strong) NSString *created;

    - (void) setFormattedCreatedAtString;
    + (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion;
    + (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image;


    
@end
NS_ASSUME_NONNULL_END
