//
//  ZBPackageActions.h
//  Zebra
//
//  Created by Thatchapon Unprasert on 13/5/2019
//  Copyright © 2019 Wilson Styres. All rights reserved.
//

@class ZBPackage;
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Queue/ZBQueueType.h>

#import "ZBPackageActionType.h"

@interface ZBPackageActions : NSObject
+ (NSArray <UITableViewRowAction *> *)rowActionsForPackage:(ZBPackage *)package inViewController:(UITableViewController *)controller atIndexPath:(NSIndexPath *)indexPath;
+ (NSArray <UIAlertAction *> *)alertActionsForPackage:(ZBPackage *)package inViewController:(UIViewController *)vc;

// Might end up condensing these two
+ (NSArray <UIPreviewAction *> *)previewActionsForPackage:(ZBPackage *)package inViewController:(UIViewController *)vc parent:(UIViewController *)parent;
+ (NSArray <UIAction *> *)menuElementsForPackage:(ZBPackage *)package atIndexPath:(NSIndexPath *)indexPath viewController:(UIViewController *)vc parent:(UIViewController *)parent API_AVAILABLE(ios(13.0));

+ (UIColor *)colorForAction:(ZBPackageActionType)action;
+ (NSString *)titleForAction:(ZBPackageActionType)action useIcon:(BOOL)icon;
+ (NSString *)buttonTitleForPackage:(ZBPackage *)package;
@end
