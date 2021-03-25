//
//  ZBSourceViewController.m
//  Zebra
//
//  Created by Wilson Styres on 3/24/19.
//  Copyright © 2019 Wilson Styres. All rights reserved.
//

#import "ZBSourceViewController.h"

#import <Plains/Plains.h>

@interface ZBSourceViewController () {
    NSArray <NSString *> *sections;
    NSArray <NSNumber *> *counts;
}
@property PLSource *source;
@end

@implementation ZBSourceViewController

- (instancetype)initWithSource:(PLSource *)source {
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        _source = source;
        
        self.title = source.origin;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    [self fetchSections];
}

- (void)fetchSections {
    NSDictionary *unsortedSections = _source.sections;
    sections = [unsortedSections.allKeys sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES]]];
    counts = [unsortedSections objectsForKeys:sections notFoundMarker:@""];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return sections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"sectionCell"];
    
    cell.textLabel.text = sections[indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", counts[indexPath.row].intValue];
    
    return cell;
}

@end
