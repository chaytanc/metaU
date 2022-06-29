//
//  Popup.h
//  Instagram
//
//  Created by Chaytan Inman on 6/22/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PopupView : UIView
@property (strong, nonatomic) UITextField* usernameField;
@property (strong, nonatomic) UITextField* emailField;
@property (strong, nonatomic) UITextField* passwordField;
@end

NS_ASSUME_NONNULL_END
