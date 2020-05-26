//
//  ZBPackageDepictionViewController.m
//  Zebra
//
//  Created by Andrew Abosh on 2020-05-16.
//  Copyright © 2020 Wilson Styres. All rights reserved.
//

#import "ZBPackageDepictionViewController.h"
#import <Packages/Helpers/ZBPackage.h>
#import <ZBDevice.h>
#import "NSAttributedString+Markdown.h"
#import <Packages/Controllers/ZBPackageChangelogTableViewController.h>
#import "ZBScreenshotCollectionViewCell.h"
#import "UIColor+GlobalColors.h"
@import SDWebImage;

@interface WKWebView ()
@property (setter=_setApplicationNameForUserAgent:,copy) NSString * _applicationNameForUserAgent;
@end

@interface ZBPackageDepictionViewController () {
    BOOL shouldBeNative;
}

// Web Outlets
@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeightConstraint;

// Native Outlets
@property (weak, nonatomic) IBOutlet UIView *nativeView;
@property (weak, nonatomic) IBOutlet UIStackView *changelogContainerStackView;
@property (weak, nonatomic) IBOutlet UILabel *changelogNotesLabel;
@property (weak, nonatomic) IBOutlet UILabel *changelogVersionTitleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *previewCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *previewCollectionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *previewHeaderLabel;

@property (strong, nonatomic) ZBPackage *package;

@end

@implementation ZBPackageDepictionViewController

#pragma mark - Initializers

- (id)initWithPackage:(ZBPackage *)package {
    self = [super init];
    
    if (self) {
        self.package = package;
        self->shouldBeNative = self.package.preferNative || self.package.depictionURL == nil;
    }
    
    return self;
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDelegates];
    [self applyCustomizations];
    [self setData];
    
    [self.previewCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ZBScreenshotCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"ScreenshotCollectionViewCell"];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self updatePreviewCollectionViewHeightBasedOnContent];
}

#pragma mark - View Setup

- (void)setDelegates {
    if (shouldBeNative) {
        self.previewCollectionView.delegate = self;
        self.previewCollectionView.dataSource = self;
    } else {
        self.webView.navigationDelegate = self;
        self.webView.scrollView.delegate = self;
    }
}

- (void)applyCustomizations {
    self.nativeView.hidden = YES;
    self.webView.hidden = YES;
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.backgroundColor = [UIColor tableViewBackgroundColor];
}

- (void)setData {
    if (shouldBeNative) {
        self.nativeView.hidden = NO;

        if (self.package.previewImageURLs != nil) {
            self.previewHeaderLabel.text = NSLocalizedString(@"Preview", @"");
        } else {
            self.previewCollectionView.hidden = YES;
            self.previewHeaderLabel.text = NSLocalizedString(@"Description", @"");
        };
        
        if ([self.package hasChangelog]) {
            NSAttributedString *changelogNotesAttributedString = [[NSAttributedString alloc] initWithMarkdownString:self.package.changelogNotes fontSize:self.changelogNotesLabel.font.pointSize];
            [self.changelogNotesLabel setAttributedText:changelogNotesAttributedString];
            
            [self.changelogVersionTitleLabel setText:self.package.changelogTitle];
        } else {
            self.changelogContainerStackView.hidden = YES;
        }
        
        NSAttributedString *descriptionAttributedString = [[NSAttributedString alloc] initWithMarkdownString:self.package.packageDescription fontSize:self.descriptionLabel.font.pointSize];
        [self.descriptionLabel setAttributedText:descriptionAttributedString];
        
    } else {
        [self loadWebDepiction];
    }
}

#pragma mark - Helper Methods

- (void)loadWebDepiction {
    if (self.package.depictionURL == nil) return;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:self.package.depictionURL];
    [request setAllHTTPHeaderFields:[ZBDevice depictionHeaders]];
    self.webView._applicationNameForUserAgent = [ZBDevice depictionUserAgent];
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView loadRequest:request];
}

- (IBAction)versionHistoryButtonTapped:(id)sender {
    ZBPackageChangelogTableViewController *changelog = [[ZBPackageChangelogTableViewController alloc] initWithPackage:self.package];
    [[self navigationController] pushViewController:changelog animated:YES];
}

    self.previewCollectionViewHeightConstraint.constant = 400;
- (void)updatePreviewCollectionViewHeightBasedOnContent {
//    self.previewCollectionViewHeightConstraint.constant = self.previewCollectionView.collectionViewLayout.collectionViewContentSize.height;
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
        webView.hidden = NO;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // This is a pretty simple implementation now, it might cause problems later for depictions with ads but not sure at the moment.
    NSURL *url = navigationAction.request.URL;
    WKNavigationType type = navigationAction.navigationType;
    
    if ([url isEqual:self.webView.URL] || type == WKNavigationTypeOther) {
        decisionHandler(WKNavigationActionPolicyAllow);
    } else {
        decisionHandler(WKNavigationActionPolicyCancel);
        
        if (![[url absoluteString] isEqualToString:@"about:blank"] && ([[url scheme] isEqualToString:@"https"] || [[url scheme] isEqualToString:@"http"])) {
            [ZBDevice openURL:url sender:self];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    [scrollView.pinchGestureRecognizer setEnabled:NO];
}

#pragma mark - WKWebView contentSize Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView.scrollView && [keyPath isEqual:@"contentSize"] && self.webViewHeightConstraint.constant != self.webView.scrollView.contentSize.height) {
        self.webViewHeightConstraint.constant = self.webView.scrollView.contentSize.height;
        [[self view] layoutIfNeeded];
    }
}

- (void)dealloc {
    if (!shouldBeNative) [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
}

#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.package.previewImageURLs.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ZBScreenshotCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ScreenshotCollectionViewCell" forIndexPath:indexPath];
    [cell.screenshotImageView sd_setImageWithURL:self.package.previewImageURLs[indexPath.item]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(200, 400);

}
@end
