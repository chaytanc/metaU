//
//  DetailsNavController.h
//  Instagram
//
//  Created by Chaytan Inman on 6/27/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsNavController : UINavigationController
@property (strong, nonatomic) Post* post;
@end

NS_ASSUME_NONNULL_END
