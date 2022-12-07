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


        // favorites button
        [self setFavoritesButton:[[UIButton alloc] init]];
        [[self favoritesButton] addTarget:self action:@selector(showFavorites) forControlEvents:UIControlEventTouchUpInside];

        UIImageSymbolConfiguration* configuration = [UIImageSymbolConfiguration configurationWithPointSize:21 weight:UIImageSymbolWeightMedium];
        [[self favoritesButton] setImage:[[UIImage systemImageNamed:@"heart"] imageWithConfiguration:configuration] forState:UIControlStateNormal];

        [[self favoritesButton] setTintColor:[UIColor labelColor]];
        [[self headerView] addSubview:[self favoritesButton]];

        [[self favoritesButton] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self favoritesButton] centerYAnchor] constraintEqualToAnchor:[[self titleLabel] centerYAnchor]],
            [[[self favoritesButton] trailingAnchor] constraintEqualToAnchor:[[self headerView] trailingAnchor] constant:-24],
        ]];


        // pan gesture
        [self setPanGesture:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)]];
        [[self headerView] addGestureRecognizer:[self panGesture]];


        // history table view
        [self setHistoryTableView:[[KayokoHistoryTableView alloc] init]];
        [self addSubview:[self historyTableView]];

        [[self historyTableView] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self historyTableView] topAnchor] constraintEqualToAnchor:[[self headerView] bottomAnchor] constant:8],
            [[[self historyTableView] leadingAnchor] constraintEqualToAnchor:[self leadingAnchor]],
            [[[self historyTableView] trailingAnchor] constraintEqualToAnchor:[self trailingAnchor]],
            [[[self historyTableView] bottomAnchor] constraintEqualToAnchor:[self bottomAnchor]]
        ]];


        // favorites table view
        [self setFavoritesTableView:[[KayokoFavoritesTableView alloc] init]];
        [self addSubview:[self favoritesTableView]];

        [[self favoritesTableView] setHidden:YES];
        [[self favoritesTableView] reloadDataWithItems:nil];

        [[self favoritesTableView] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self favoritesTableView] topAnchor] constraintEqualToAnchor:[[self headerView] bottomAnchor] constant:8],
            [[[self favoritesTableView] leadingAnchor] constraintEqualToAnchor:[self leadingAnchor]],
            [[[self favoritesTableView] trailingAnchor] constraintEqualToAnchor:[self trailingAnchor]],
            [[[self favoritesTableView] bottomAnchor] constraintEqualToAnchor:[self bottomAnchor]]
        ]];
    }

    return self;
}

- (void)showFavorites {
    if (![[self historyTableView] isHidden]) {
        UIImageSymbolConfiguration* configuration = [UIImageSymbolConfiguration configurationWithPointSize:21 weight:UIImageSymbolWeightMedium];
        [[self favoritesButton] setImage:[[UIImage systemImageNamed:@"heart.fill"] imageWithConfiguration:configuration] forState:UIControlStateNormal];

        NSArray* items = [[PasteboardManager sharedInstance] itemsFromHistoryWithKey:kHistoryKeyFavorites];
        [[self favoritesTableView] reloadDataWithItems:items];
        [[self favoritesTableView] setHidden:NO];

        [self updateSubtitleWithHistoryLabel:@"Favorites" andItemCount:[items count]];

        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [[self historyTableView] setTransform:CGAffineTransformMakeScale(0.95, 0.95)];
            [[self historyTableView] setAlpha:0];

            [[self favoritesTableView] setTransform:CGAffineTransformIdentity];
            [[self favoritesTableView] setAlpha:1];

            [[self favoritesButton] setTintColor:[UIColor systemPinkColor]];
        } completion:^(BOOL finished) {
            [[self historyTableView] reloadDataWithItems:nil];
            [[self historyTableView] setHidden:YES];
        }];
    } else {
        UIImageSymbolConfiguration* configuration = [UIImageSymbolConfiguration configurationWithPointSize:21 weight:UIImageSymbolWeightMedium];
        [[self favoritesButton] setImage:[[UIImage systemImageNamed:@"heart"] imageWithConfiguration:configuration] forState:UIControlStateNormal];

        NSArray* items = [[PasteboardManager sharedInstance] itemsFromHistoryWithKey:kHistoryKeyHistory];
        [[self historyTableView] reloadDataWithItems:items];
        [[self historyTableView] setHidden:NO];

        [self updateSubtitleWithHistoryLabel:@"History" andItemCount:[items count]];

        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [[self historyTableView] setTransform:CGAffineTransformIdentity];
            [[self historyTableView] setAlpha:1];

            [[self favoritesTableView] setTransform:CGAffineTransformMakeScale(1.05, 1.05)];
            [[self favoritesTableView] setAlpha:0];

            [[self favoritesButton] setTintColor:[UIColor labelColor]];
        } completion:^(BOOL finished) {
            [[self favoritesTableView] reloadDataWithItems:nil];
            [[self favoritesTableView] setHidden:YES];
        }];
    }
}

- (void)updateSubtitleWithHistoryLabel:(NSString *)label andItemCount:(NSUInteger)count {
    if (count == 1) {
        [[self subtitleLabel] setText:[NSString stringWithFormat:@"%@ – 1 Item", label]];
    } else {
        [[self subtitleLabel] setText:[NSString stringWithFormat:@"%@ – %lu Items", label, count]];
    }
}

- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = CGPointMake(0, 0);
    const NSUInteger kMaxTranslation = 150;

    if ([recognizer state] == UIGestureRecognizerStateChanged) {
        translation = [recognizer translationInView:self];

        if (translation.y < 0) {
            return;
        }

        double alpha = fabs(translation.y / kMaxTranslation);
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

- (void)show {
    if ([self isAnimating]) {
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

    [self setIsAnimating:YES];
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self setTransform:CGAffineTransformIdentity];
        [self setAlpha:1];
    } completion:^(BOOL finished) {
        [self setIsAnimating:NO];
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self setAlpha:0];
    } completion:^(BOOL finished) {
        [self setHidden:YES];
        [[self historyTableView] reloadDataWithItems:nil];
        [[self favoritesTableView] reloadDataWithItems:nil];
    }];
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
@end
