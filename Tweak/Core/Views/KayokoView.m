//
//  KayokoView.m
//  Kayoko
//
//  Created by Alexandra Aurora Göttlicher
//

#import "KayokoView.h"
#import <rootless.h>
#import "KayokoHistoryTableView.h"
#import "KayokoFavoritesTableView.h"
#import "KayokoPreviewView.h"
#import "../../../Manager/PasteboardManager.h"
#import "../../../Manager/PasteboardItem.h"

@implementation KayokoView
/**
 * Initializes the main view.
 *
 * @param frame
 */
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        [self hide];

        [[self layer] setShadowColor:[[UIColor blackColor] CGColor]];
        [[self layer] setShadowOffset:CGSizeZero];
        [[self layer] setShadowRadius:10];
        [[self layer] setShadowOpacity:0.5];

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

        [self setHeaderView:[[UIView alloc] init]];
        [self addSubview:[self headerView]];

        [[self headerView] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self headerView] heightAnchor] constraintEqualToConstant:60],
            [[[self headerView] topAnchor] constraintEqualToAnchor:[self topAnchor]],
            [[[self headerView] leadingAnchor] constraintEqualToAnchor:[self leadingAnchor]],
            [[[self headerView] trailingAnchor] constraintEqualToAnchor:[self trailingAnchor]]
        ]];

        [self setPanGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)]];
        [[self headerView] addGestureRecognizer:[self panGestureRecognizer]];

        [self setTapGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePreview)]];
        [[self headerView] addGestureRecognizer:[self tapGestureRecognizer]];

        [self setGrabber:[[_UIGrabber alloc] init]];
        [[self headerView] addSubview:[self grabber]];

        [[self grabber] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self grabber] topAnchor] constraintEqualToAnchor:[[self headerView] topAnchor] constant:12],
            [[[self grabber] centerXAnchor] constraintEqualToAnchor:[[self headerView] centerXAnchor]]
        ]];

        [self setFavoritesButton:[[UIButton alloc] init]];
        [[self favoritesButton] addTarget:self action:@selector(handleFavoritesButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self updateStyleForHeaderButton:[self favoritesButton] withImageName:@"heart" andImageSize:kFavoritesButtonImageSize andTintColor:[UIColor labelColor]];
        [[self headerView] addSubview:[self favoritesButton]];

        [[self favoritesButton] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self favoritesButton] bottomAnchor] constraintEqualToAnchor:[[self headerView] bottomAnchor] constant:-2],
            [[[self favoritesButton] leadingAnchor] constraintEqualToAnchor:[[self headerView] leadingAnchor] constant:24]
        ]];

        [self setTitleLabel:[[UILabel alloc] init]];
        [[self titleLabel] setText:@"History"];
        [[self titleLabel] setFont:[UIFont systemFontOfSize:26 weight:UIFontWeightSemibold]];
        [[self titleLabel] setTextColor:[UIColor labelColor]];
        [[self headerView] addSubview:[self titleLabel]];

        [[self titleLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self titleLabel] centerYAnchor] constraintEqualToAnchor:[[self favoritesButton] centerYAnchor]],
            [[[self titleLabel] leadingAnchor] constraintEqualToAnchor:[[self favoritesButton] trailingAnchor] constant:12]
        ]];

        [self setClearButton:[[UIButton alloc] init]];
        [[self clearButton] addTarget:self action:@selector(handleClearButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self updateStyleForHeaderButton:[self clearButton] withImageName:@"trash" andImageSize:kClearButtonImageSize andTintColor:[UIColor labelColor]];
        [[self headerView] addSubview:[self clearButton]];

        [[self clearButton] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self clearButton] centerYAnchor] constraintEqualToAnchor:[[self favoritesButton] centerYAnchor]],
            [[[self clearButton] trailingAnchor] constraintEqualToAnchor:[[self headerView] trailingAnchor] constant:-24]
        ]];

        [self setHistoryTableView:[[KayokoHistoryTableView alloc] initWithName:@"History"]];
        [self addSubview:[self historyTableView]];

        [[self historyTableView] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self historyTableView] topAnchor] constraintEqualToAnchor:[[self headerView] bottomAnchor] constant:8],
            [[[self historyTableView] leadingAnchor] constraintEqualToAnchor:[self leadingAnchor]],
            [[[self historyTableView] trailingAnchor] constraintEqualToAnchor:[self trailingAnchor]],
            [[[self historyTableView] bottomAnchor] constraintEqualToAnchor:[self bottomAnchor]]
        ]];

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

        [self setPreviewView:[[KayokoPreviewView alloc] initWithName:@"Preview"]];
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

/**
 * Handles the drag on the top of the main view to close it.
 *
 * @param recognizer The pan gesture recognizer.
 */
- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = CGPointMake(0, 0);
    NSUInteger const kMaxTranslation = 100;

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

/**
 * Updates the style of the a header button.
 *
 * @param button The button to update.
 * @param imageName The name of the system image to use on the button.
 * @param color The color to use for the image.
 */
- (void)updateStyleForHeaderButton:(UIButton *)button withImageName:(NSString *)imageName andImageSize:(NSUInteger)imageSize andTintColor:(UIColor *)color {
    UIImageSymbolConfiguration* configuration = [UIImageSymbolConfiguration configurationWithPointSize:imageSize weight:UIImageSymbolWeightMedium];
    [button setImage:[[UIImage systemImageNamed:imageName] imageWithConfiguration:configuration] forState:UIControlStateNormal];
    [button setTintColor:color];
}

/**
 * Handles the press of the favorites button.
 *
 * It either shows the history or favorites view or hides the preview view again.
 */
- (void)handleFavoritesButtonPressed {
    if (_isAnimating) {
        return;
    }

    if (![[self previewView] isHidden]) {
        [self hidePreview];
    }

    if ([[self historyTableView] isHidden]) {
        NSArray* items = [[PasteboardManager sharedInstance] getItemsFromHistoryWithKey:kHistoryKeyHistory];
        [[self historyTableView] reloadDataWithItems:items];

        [self showContentView:[self historyTableView] andHideContentView:[self favoritesTableView] reverse:YES];

        [self updateStyleForHeaderButton:[self favoritesButton] withImageName:@"heart" andImageSize:kFavoritesButtonImageSize andTintColor:[UIColor labelColor]];
    } else {
        NSArray* items = [[PasteboardManager sharedInstance] getItemsFromHistoryWithKey:kHistoryKeyFavorites];
        [[self favoritesTableView] reloadDataWithItems:items];

        [self showContentView:[self favoritesTableView] andHideContentView:[self historyTableView] reverse:NO];

        [self updateStyleForHeaderButton:[self favoritesButton] withImageName:@"heart.fill" andImageSize:kFavoritesButtonImageSize andTintColor:[UIColor systemPinkColor]];
    }

    [self triggerHapticFeedbackWithStyle:UIImpactFeedbackStyleSoft];
}

- (void)handleClearButtonPressed {
    [self hide];

    NSString* key = [[self historyTableView] isHidden] ? kHistoryKeyFavorites : kHistoryKeyHistory;
    UIAlertController* clearAlert = [UIAlertController alertControllerWithTitle:@"Kayoko" message:[NSString stringWithFormat:@"This will clear your %@.", key] preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction* action) {
        NSArray* items = [[PasteboardManager sharedInstance] getItemsFromHistoryWithKey:key];
        for (NSDictionary* dictionary in items) {
            PasteboardItem* item = [PasteboardItem itemFromDictionary:dictionary];
            [[PasteboardManager sharedInstance] removePasteboardItem:item fromHistoryWithKey:key shouldRemoveImage:YES];
        }

        [self show];
	}];

	UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction* action) {
        [self show];
    }];

	[clearAlert addAction:yesAction];
	[clearAlert addAction:noAction];

	[[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:clearAlert animated:YES completion:nil];

    [self triggerHapticFeedbackWithStyle:UIImpactFeedbackStyleHeavy];
}

/**
 * Shows the preview view with a given item's contents.
 *
 * @param item The item to preview.
 */
- (void)showPreviewWithItem:(PasteboardItem *)item {
    if ([item hasLink]) {
        [[[self previewView] webView] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[item content]]]];
        [[[self previewView] webView] setHidden:NO];
    } else if (![[item imageName] isEqualToString:@""]) {
        NSData* imageData = [[NSFileManager defaultManager] contentsAtPath:[NSString stringWithFormat:@"%@/%@", kHistoryImagesPath, [item imageName]]];
        [[[self previewView] imageView] setImage:[UIImage imageWithData:imageData]];
        [[[self previewView] imageView] setHidden:NO];
    } else {
        [[[self previewView] textView] setText:[item content]];
        [[[self previewView] textView] setHidden:NO];
    }

    _previewSourceTableView = [[self historyTableView] isHidden] ? [self favoritesTableView] : [self historyTableView];
    [self showContentView:[self previewView] andHideContentView:_previewSourceTableView reverse:NO];

    [self triggerHapticFeedbackWithStyle:UIImpactFeedbackStyleMedium];
}

/**
 * Hides the preview view.
 */
- (void)hidePreview {
    if ([[self previewView] isHidden] || _isAnimating) {
        return;
    }

    [self showContentView:_previewSourceTableView andHideContentView:[self previewView] reverse:YES];
    [[self previewView] reset];
}

/**
 * Animates a view in and out.
 *
 * For example when switching between the history and favorites view.
 *
 * @param viewToShow The view that's to be shown.
 * @param viewToHide The view that's to be hidden.
 * @param reverse Whether the animation should play reversed for a mirrored effect.
 */
- (void)showContentView:(UIView *)viewToShow andHideContentView:(UIView *)viewToHide reverse:(BOOL)reverse {
    [UIView transitionWithView:[self titleLabel] duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [[self titleLabel] setText:[viewToShow valueForKey:@"_name"]];
    } completion:nil];

    CGFloat viewToShowTransform = reverse ? 10 : -10;
    [viewToShow setTransform:CGAffineTransformTranslate(viewToShow.transform, 0, viewToShowTransform)];
    [viewToShow setAlpha:0];
    [viewToShow setHidden:NO];

    _isAnimating = YES;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [viewToShow setTransform:CGAffineTransformIdentity];
        [viewToShow setAlpha:1];

        CGFloat viewToHideTransform = reverse ? -10 : 10;
        [viewToHide setTransform:CGAffineTransformTranslate(viewToShow.transform, 0, viewToHideTransform)];
        [viewToHide setAlpha:0];
    } completion:^(BOOL finished) {
        [viewToHide setHidden:YES];
        _isAnimating = NO;
    }];
}

/**
 * Triggers haptic feedback.
 *
 * @param style The feedback type/strength to use.
 */
- (void)triggerHapticFeedbackWithStyle:(UIImpactFeedbackStyle)style {
    [self setFeedbackGenerator:[[UIImpactFeedbackGenerator alloc] initWithStyle:style]];
    [[self feedbackGenerator] prepare];
    [[self feedbackGenerator] impactOccurred];
    [self setFeedbackGenerator:nil];
}

/**
 * Reloads the active history view.
 */
- (void)reload {
    if (![[self historyTableView] isHidden]) {
        NSArray* items = [[PasteboardManager sharedInstance] getItemsFromHistoryWithKey:kHistoryKeyHistory];
        [[self historyTableView] reloadDataWithItems:items];
    } else {
        NSArray* items = [[PasteboardManager sharedInstance] getItemsFromHistoryWithKey:kHistoryKeyFavorites];
        [[self favoritesTableView] reloadDataWithItems:items];
    }
}

/**
 * Shows the main view.
 */
- (void)show {
    if (_isAnimating) {
        return;
    }

    [[self historyTableView] setAutomaticallyPaste:[self automaticallyPaste]];
    [[self favoritesTableView] setAutomaticallyPaste:[self automaticallyPaste]];

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

/**
 * Hides the main view.
 */
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
