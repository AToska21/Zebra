//
//  UIAlertController+Zebra.h
//  Zebra
//
//  Created by Wilson Styres on 4/10/20.
//  Copyright © 2020 Wilson Styres. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (Zebra)
+ (id)alertControllerWithError:(NSError *)error;
- (void)show;
- (void)show:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
