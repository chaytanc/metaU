//
//  UIViewController+ResignKeyboard.m
//  Instagram
//
//  Created by Chaytan Inman on 6/29/22.
//

#import "UIViewController+ResignKeyboard.h"

@implementation UIViewController (ResignKeyboard)
+ (void)dismissKeyboard {
    [self globalResignFirstResponder];
}

+ (void) globalResignFirstResponder {
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    for (UIView * view in [window subviews]){
        [self globalResignFirstResponderRec:view];
    }
}

+ (void) globalResignFirstResponderRec:(UIView*) view {
    if ([view respondsToSelector:@selector(resignFirstResponder)]){
        [view resignFirstResponder];
    }
    for (UIView * subview in [view subviews]){
        [self globalResignFirstResponderRec:subview];
    }
}
@end
