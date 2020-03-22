//
//  ZBSettingsSelectionTableViewController.h
//  Zebra
//
//  Created by Louis on 02/11/2019.
//  Copyright © 2019 Wilson Styres. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ZBSettingsSelectionTypeNormal,
    ZBSettingsSelectionTypeInverse,
} ZBSettingsSelectionType;

NS_ASSUME_NONNULL_BEGIN

@interface ZBSettingsSelectionTableViewController : UITableViewController
@property void (^selectionChanged)(NSArray *options, NSArray *selections);
@property ZBSettingsSelectionType selectionType;
@property int limit;

@property NSString *settingsKey;
@property NSArray <NSString *> *footerText;
@property NSArray <NSString *> *options;

- (id)initWithSettingsKey:(NSString *)key selectionType:(ZBSettingsSelectionType)type limit:(int)optionLimit options:(NSArray *)selectionOptions;
@end

NS_ASSUME_NONNULL_END
