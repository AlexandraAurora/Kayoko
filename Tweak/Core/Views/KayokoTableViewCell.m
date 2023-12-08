//
//  KayokoTableViewCell.m
//  Kayoko
//
//  Created by Alexandra Aurora Göttlicher
//

#import "KayokoTableViewCell.h"
#import <substrate.h>
#import "../../../Manager/PasteboardManager.h"
#import "../../../Manager/PasteboardItem.h"
#import "../../../Utils/ImageUtil.h"

@implementation KayokoTableViewCell
/**
 * Initializes the table view cell.
 *
 * @param style
 * @param item
 * @param reuseIdentifier
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style andItem:(PasteboardItem *)item reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];

        [self setIconImageView:[[UIImageView alloc] init]];

        UIImage* icon = [UIImage _applicationIconImageForBundleIdentifier:[item bundleIdentifier] format:2 scale:[[UIScreen mainScreen] scale]];
        // Use the default app icon if no icon exists for the item's bundle identifier.
        if (!icon) {
            icon = [UIImage _applicationIconImageForBundleIdentifier:@"com.apple.WebSheet" format:2 scale:[[UIScreen mainScreen] scale]];
        }
        [[self iconImageView] setImage:icon];

        [[self iconImageView] setContentMode:UIViewContentModeScaleAspectFit];
        [[self iconImageView] setClipsToBounds:YES];
        [[[self iconImageView] layer] setCornerRadius:10];
        [self addSubview:[self iconImageView]];

        [[self iconImageView] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self iconImageView] widthAnchor] constraintEqualToConstant:40],
            [[[self iconImageView] heightAnchor] constraintEqualToConstant:40],
            [[[self iconImageView] centerYAnchor] constraintEqualToAnchor:[self centerYAnchor]],
            [[[self iconImageView] leadingAnchor] constraintEqualToAnchor:[self leadingAnchor] constant:24]
        ]];

        if (![[item imageName] isEqualToString:@""]) {
            [self setContentImageView:[[UIImageView alloc] init]];

            UIImage* originalImage = [[PasteboardManager sharedInstance] getImageForItem:item];
            // Save memory by scaling the image down in the history view.
            UIImage* scaledImage = [ImageUtil getImageWithImage:originalImage scaledToSize:CGSizeMake(originalImage.size.width / 4, originalImage.size.height / 4)];
            [[self contentImageView] setImage:scaledImage];

            [[self contentImageView] setContentMode:UIViewContentModeScaleAspectFill];
            [[self contentImageView] setClipsToBounds:YES];
            [[[self contentImageView] layer] setCornerRadius:4];
            [self addSubview:[self contentImageView]];

            [[self contentImageView] setTranslatesAutoresizingMaskIntoConstraints:NO];
            [NSLayoutConstraint activateConstraints:@[
                [[[self contentImageView] widthAnchor] constraintEqualToConstant:70],
                [[[self contentImageView] heightAnchor] constraintEqualToConstant:40],
                [[[self contentImageView] centerYAnchor] constraintEqualToAnchor:[self centerYAnchor]],
                [[[self contentImageView] trailingAnchor] constraintEqualToAnchor:[self trailingAnchor] constant:-24]
            ]];
        }

        [self setHeaderLabel:[[UILabel alloc] init]];
        NSString* displayName = [[[objc_getClass("SBApplicationController") sharedInstance] applicationWithBundleIdentifier:[item bundleIdentifier]] displayName] ?: @"SpringBoard";
        [[self headerLabel] setText:displayName];
        [[self headerLabel] setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightMedium]];
        [[self headerLabel] setTextColor:[UIColor labelColor]];
        [self addSubview:[self headerLabel]];

        [[self headerLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self headerLabel] topAnchor] constraintEqualToAnchor:[[self iconImageView] topAnchor] constant:1],
            [[[self headerLabel] leadingAnchor] constraintEqualToAnchor:[[self iconImageView] trailingAnchor] constant:16]
        ]];

        if ([self contentImageView]) {
            [NSLayoutConstraint activateConstraints:@[
                [[[self headerLabel] trailingAnchor] constraintEqualToAnchor:[[self contentImageView] leadingAnchor] constant:-16]
            ]];
        } else {
            [NSLayoutConstraint activateConstraints:@[
                [[[self headerLabel] trailingAnchor] constraintEqualToAnchor:[self trailingAnchor] constant:-24]
            ]];
        }

        [self setContentLabel:[[UILabel alloc] init]];
        [[self contentLabel] setText:[item content]];
        [[self contentLabel] setFont:[UIFont systemFontOfSize:14]];
        [[self contentLabel] setTextColor:[[UIColor labelColor] colorWithAlphaComponent:0.8]];
        [[self contentLabel] setLineBreakMode:NSLineBreakByTruncatingTail];
        [self addSubview:[self contentLabel]];

        [[self contentLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self contentLabel] bottomAnchor] constraintEqualToAnchor:[[self iconImageView] bottomAnchor] constant:-1],
            [[[self contentLabel] leadingAnchor] constraintEqualToAnchor:[[self headerLabel] leadingAnchor]],
            [[[self contentLabel] trailingAnchor] constraintEqualToAnchor:[[self headerLabel] trailingAnchor]]
        ]];
    }

    return self;
}
@end
