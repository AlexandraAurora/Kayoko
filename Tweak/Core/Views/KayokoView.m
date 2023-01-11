//
//  KayokoView.m
//  Kayoko
//
//  Created by Alexandra (@Traurige)
//

#import "KayokoView.h"

@implementation KayokoView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        [self hide];

        [[self layer] setShadowColor:[[UIColor blackColor] CGColor]];
        [[self layer] setShadowOffset:CGSizeZero];
        [[self layer] setShadowRadius:10];
        [[self layer] setShadowOpacity:0.5];


        // background blur
        [self setBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular]];
        [self setBlurEffectView:[[UIVisualEffectView alloc] initWithEffect:[self blurEffect]]];
        [self addSubview:[self blurEffectView]];

        [[self blurEffectView] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self blurEffectView] topAnchor] constraintEqualToAnchor:[self topAnchor]],
            [[[self blurEffectView] leadingAnchor] constraintEqualToAnchor:[self leadingAnchor]],
            [[[self blurEffectView] trailingAnchor] constraintEqualToAnchor:[self trailingAnchor]],
            [[[self blurEffectView] bottomAnchor] constraintEqualToAnchor:[self bottomAnchor]]
        ]];


        // header view
        [self setHeaderView:[[UIView alloc] init]];
        [self addSubview:[self headerView]];

        [[self headerView] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self headerView] heightAnchor] constraintEqualToConstant:90],
            [[[self headerView] topAnchor] constraintEqualToAnchor:[self topAnchor]],
            [[[self headerView] leadingAnchor] constraintEqualToAnchor:[self leadingAnchor]],
            [[[self headerView] trailingAnchor] constraintEqualToAnchor:[self trailingAnchor]]
        ]];


        // tap gesture recognizer
        [self setTapGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePreview)]];
        [[self headerView] addGestureRecognizer:[self tapGestureRecognizer]];


        // grabber
        [self setGrabber:[[_UIGrabber alloc] init]];
        [[self headerView] addSubview:[self grabber]];

        [[self grabber] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self grabber] topAnchor] constraintEqualToAnchor:[[self headerView] topAnchor] constant:12],
            [[[self grabber] centerXAnchor] constraintEqualToAnchor:[[self headerView] centerXAnchor]],
        ]];


        // title label
        [self setTitleLabel:[[UILabel alloc] init]];
        [[self titleLabel] setText:@"Kayoko"];
        [[self titleLabel] setFont:[UIFont systemFontOfSize:32 weight:UIFontWeightMedium]];
        [[self titleLabel] setTextColor:[UIColor labelColor]];
        [[self headerView] addSubview:[self titleLabel]];

        [[self titleLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self titleLabel] topAnchor] constraintEqualToAnchor:[[self grabber] bottomAnchor] constant:12],
            [[[self titleLabel] leadingAnchor] constraintEqualToAnchor:[[self headerView] leadingAnchor] constant:24],
        ]];


        // subtitle label
        [self setSubtitleLabel:[[UILabel alloc] init]];
        [[self subtitleLabel] setFont:[UIFont systemFontOfSize:17 weight:UIFontWeightMedium]];
        [[self subtitleLabel] setTextColor:[[UIColor labelColor] colorWithAlphaComponent:0.8]];
        [[self headerView] addSubview:[self subtitleLabel]];

        [[self subtitleLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self subtitleLabel] topAnchor] constraintEqualToAnchor:[[self titleLabel] bottomAnchor] constant:2],
            [[[self subtitleLabel] leadingAnchor] constraintEqualToAnchor:[[self titleLabel] leadingAnchor]],
        ]];


        // header button
        [self setHeaderButton:[[UIButton alloc] init]];
        [[self headerButton] addTarget:self action:@selector(handleHeaderButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self updateHeaderButtonImageWithName:@"heart" andColor:[UIColor labelColor]];
        [[self headerButton] setTintColor:[UIColor labelColor]];
        [[self headerView] addSubview:[self headerButton]];

        [[self headerButton] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self headerButton] centerYAnchor] constraintEqualToAnchor:[[self titleLabel] centerYAnchor]],
            [[[self headerButton] trailingAnchor] constraintEqualToAnchor:[[self headerView] trailingAnchor] constant:-24],
        ]];


        // pan gesture recognizer
        [self setPanGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)]];
        [[self headerView] addGestureRecognizer:[self panGestureRecognizer]];


        // history table view
        [self setHistoryTableView:[[KayokoHistoryTableView alloc] initWithName:@"History"]];
        [self addSubview:[self historyTableView]];

        [[self historyTableView] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self historyTableView] topAnchor] constraintEqualToAnchor:[[self headerView] bottomAnchor] constant:8],
            [[[self historyTableView] leadingAnchor] constraintEqualToAnchor:[self leadingAnchor]],
            [[[self historyTableView] trailingAnchor] constraintEqualToAnchor:[self trailingAnchor]],
            [[[self historyTableView] bottomAnchor] constraintEqualToAnchor:[self bottomAnchor]]
        ]];


        // favorites table view
        [self setFavoritesTableView:[[KayokoFavoritesTableView alloc] initWithName:@"Favorites"]];
        [[self favoritesTableView] setHidden:YES];
        [self addSubview:[self favoritesTableView]];

        [[self favoritesTableView] reloadDataWithItems:nil];

        [[self favoritesTableView] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self favoritesTableView] topAnchor] constraintEqualToAnchor:[[self headerView] bottomAnchor] constant:8],
            [[[self favoritesTableView] leadingAnchor] constraintEqualToAnchor:[self leadingAnchor]],
            [[[self favoritesTableView] trailingAnchor] constraintEqualToAnchor:[self trailingAnchor]],
            [[[self favoritesTableView] bottomAnchor] constraintEqualToAnchor:[self bottomAnchor]]
        ]];


        // preview view
        [self setPreviewView:[[KayokoPreviewView alloc] init]];
        [[self previewView] setHidden:YES];
        [self addSubview:[self previewView]];

        [[self previewView] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self previewView] topAnchor] constraintEqualToAnchor:[[self headerView] bottomAnchor] constant:8],
            [[[self previewView] leadingAnchor] constraintEqualToAnchor:[self leadingAnchor]],
            [[[self previewView] trailingAnchor] constraintEqualToAnchor:[self trailingAnchor]],
            [[[self previewView] bottomAnchor] constraintEqualToAnchor:[self bottomAnchor]]
        ]];
    }

    return self;
}

- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = CGPointMake(0, 0);
    NSUInteger const kMaxTranslation = 150;

    if ([recognizer state] == UIGestureRecognizerStateChanged) {
        translation = [recognizer translationInView:self];

        if (translation.y < 0) {
            return;
        }

        CGFloat alpha = fabs(translation.y / kMaxTranslation);
        [UIView animateWithDuration:0.1 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self setTransform:CGAffineTransformMakeTranslation(0, translation.y)];
            [self setAlpha:1 - alpha];
        } completion:nil];

        if (translation.y >= kMaxTranslation) {
            [self hide];
            return;
        }
    } else if ([recognizer state] == UIGestureRecognizerStateEnded) {
        if (translation.y < kMaxTranslation) {
            [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self setTransform:CGAffineTransformIdentity];
                [self setAlpha:1];
            } completion:nil];
        }
    }
}

- (void)handleHeaderButtonPressed {
    if (_isAnimating) {
        return;
    }

    if (![[self previewView] isHidden]) {
        [self hidePreview];
    }

    if ([[self historyTableView] isHidden]) {
        NSArray* items = [[PasteboardManager sharedInstance] itemsFromHistoryWithKey:kHistoryKeyHistory];
        [[self historyTableView] reloadDataWithItems:items];

        [self showContentView:[self historyTableView] andHideContentView:[self favoritesTableView] reverse:YES];

        [self updateSubtitleWithHistoryLabel:[[self historyTableView] name] andItemCount:[items count]];
        [self updateHeaderButtonImageWithName:@"heart" andColor:[UIColor labelColor]];
    } else {
        NSArray* items = [[PasteboardManager sharedInstance] itemsFromHistoryWithKey:kHistoryKeyFavorites];
        [[self favoritesTableView] reloadDataWithItems:items];

        [self showContentView:[self favoritesTableView] andHideContentView:[self historyTableView] reverse:NO];

        [self updateSubtitleWithHistoryLabel:[[self favoritesTableView] name] andItemCount:[items count]];
        [self updateHeaderButtonImageWithName:@"heart.fill" andColor:[UIColor systemPinkColor]];
    }

    [self triggerHapticFeedbackWithStyle:UIImpactFeedbackStyleSoft];
}

- (void)showPreviewWithItem:(PasteboardItem *)item {
    if ([item hasLink] || [item hasMusicLink]) {
        [[[self previewView] webView] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[item content]]]];
        [[[self previewView] webView] setHidden:NO];
    } else if ([item hasImage]) {
        NSData* imageData = [[NSFileManager defaultManager] contentsAtPath:[NSString stringWithFormat:@"%@%@", kHistoryImagesPath, [item imageName]]];
        [[[self previewView] imageView] setImage:[UIImage imageWithData:imageData]];
        [[[self previewView] imageView] setHidden:NO];
    } else {
        [[[self previewView] textView] setText:[item content]];
        [[[self previewView] textView] setHidden:NO];
    }

    _previewSourceTableView = [[self historyTableView] isHidden] ? [self favoritesTableView] : [self historyTableView];
    [self showContentView:[self previewView] andHideContentView:_previewSourceTableView reverse:NO];

    [[self subtitleLabel] setText:@"Preview"];
    [self triggerHapticFeedbackWithStyle:UIImpactFeedbackStyleMedium];
}

- (void)hidePreview {
    if ([[self previewView] isHidden] || _isAnimating) {
        return;
    }

    [self showContentView:_previewSourceTableView andHideContentView:[self previewView] reverse:YES];
    [[self previewView] reset];

    [self updateSubtitleWithHistoryLabel:[_previewSourceTableView name] andItemCount:[[_previewSourceTableView items] count]];
}

- (void)showContentView:(UIView *)viewToShow andHideContentView:(UIView *)viewToHide reverse:(BOOL)reverse {
    CGFloat viewToShowTransform = reverse ? 0.95 : 1.05;
    [viewToShow setTransform:CGAffineTransformMakeScale(viewToShowTransform, viewToShowTransform)];
    [viewToShow setAlpha:0];
    [viewToShow setHidden:NO];

    _isAnimating = YES;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [viewToShow setTransform:CGAffineTransformIdentity];
        [viewToShow setAlpha:1];

        CGFloat viewToHideTransform = reverse ? 1.05 : 0.95;
        [viewToHide setTransform:CGAffineTransformMakeScale(viewToHideTransform, viewToHideTransform)];
        [viewToHide setAlpha:0];
    } completion:^(BOOL finished) {
        [viewToHide setHidden:YES];
        _isAnimating = NO;
    }];
}

- (void)updateSubtitleWithHistoryLabel:(NSString *)label andItemCount:(NSUInteger)count {
    if (count == 1) {
        [[self subtitleLabel] setText:[NSString stringWithFormat:@"%@ – 1 Item", label]];
    } else {
        [[self subtitleLabel] setText:[NSString stringWithFormat:@"%@ – %lu Items", label, count]];
    }
}

- (void)updateHeaderButtonImageWithName:(NSString *)imageName andColor:(UIColor *)color {
    UIImageSymbolConfiguration* configuration = [UIImageSymbolConfiguration configurationWithPointSize:21 weight:UIImageSymbolWeightMedium];
    [[self headerButton] setImage:[[UIImage systemImageNamed:imageName] imageWithConfiguration:configuration] forState:UIControlStateNormal];
    [[self headerButton] setTintColor:color];
}

- (void)triggerHapticFeedbackWithStyle:(UIImpactFeedbackStyle)style {
    [self setFeedbackGenerator:[[UIImpactFeedbackGenerator alloc] initWithStyle:style]];
    [[self feedbackGenerator] prepare];
    [[self feedbackGenerator] impactOccurred];
    [self setFeedbackGenerator:nil];
}

- (void)reload {
    if (![[self historyTableView] isHidden]) {
        NSArray* items = [[PasteboardManager sharedInstance] itemsFromHistoryWithKey:kHistoryKeyHistory];
        [[self historyTableView] reloadDataWithItems:items];
        [self updateSubtitleWithHistoryLabel:@"History" andItemCount:[items count]];
    } else {
        NSArray* items = [[PasteboardManager sharedInstance] itemsFromHistoryWithKey:kHistoryKeyFavorites];
        [[self favoritesTableView] reloadDataWithItems:items];
        [self updateSubtitleWithHistoryLabel:@"Favorites" andItemCount:[items count]];
    }
}

- (void)show {
    if (_isAnimating) {
        return;
    }

    [[self historyTableView] setAddSongDotLinkOption:[self addSongDotLinkOption]];
    [[self historyTableView] setAddTranslateOption:[self addTranslateOption]];
    [[self favoritesTableView] setAddSongDotLinkOption:[self addSongDotLinkOption]];
    [[self favoritesTableView] setAddTranslateOption:[self addTranslateOption]];

    [self reload];

    [self setTransform:CGAffineTransformMakeTranslation(0, [self bounds].size.height / 3)];
    [self setAlpha:0];
    [self setHidden:NO];

    _isAnimating = YES;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self setTransform:CGAffineTransformIdentity];
        [self setAlpha:1];
    } completion:^(BOOL finished) {
        _isAnimating = NO;
    }];
}

- (void)hide {
    if (_isAnimating) {
        return;
    }

    _isAnimating = YES;
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self setAlpha:0];
    } completion:^(BOOL finished) {
        [self setHidden:YES];
        _isAnimating = NO;
    }];
}
@end
