//
//  KayokoTableViewCell.m
//  Kayoko
//
//  Created by Alexandra (@Traurige)
//

#import "KayokoTableViewCell.h"

@implementation KayokoTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style andItem:(PasteboardItem *)item reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];

        // icon image view
        [self setIconImageView:[[UIImageView alloc] init]];

        UIImage* icon = [UIImage _applicationIconImageForBundleIdentifier:[item bundleIdentifier] format:2 scale:[[UIScreen mainScreen] scale]];
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
            [[[self iconImageView] widthAnchor] constraintEqualToConstant:50],
            [[[self iconImageView] heightAnchor] constraintEqualToConstant:50],
            [[[self iconImageView] centerYAnchor] constraintEqualToAnchor:[self centerYAnchor]],
            [[[self iconImageView] leadingAnchor] constraintEqualToAnchor:[self leadingAnchor] constant:24]
        ]];
        
        // content image view
        if ([item hasImage] || [item hasColor]) {
            [self setContentImageView:[[UIImageView alloc] init]];

            if (![item hasColor]) {
                NSData* imageData = [[NSFileManager defaultManager] contentsAtPath:[NSString stringWithFormat:@"%@%@", kHistoryImagesPath, [item imageName]]];
                UIImage* originalImage = [UIImage imageWithData:imageData];
                // there's no need to display the image in full resolution in the table view
                UIImage* scaledImage = [ImageUtil imageWithImage:originalImage scaledToSize:CGSizeMake(originalImage.size.width / 4, originalImage.size.height / 4)];
                [[self contentImageView] setImage:scaledImage];
            } else {
                if ([[item content] hasPrefix:@"#"]) {
                    [[self contentImageView] setBackgroundColor:[ColorUtil colorFromHex:[item content]]];
                } else if ([[item content] hasPrefix:@"rgb("]) {
                    [[self contentImageView] setBackgroundColor:[ColorUtil colorFromRgb:[item content]]];
                } else if ([[item content] hasPrefix:@"rgba("]) {
                    [[self contentImageView] setBackgroundColor:[ColorUtil colorFromRgba:[item content]]];
                }
            }

            [[self contentImageView] setContentMode:UIViewContentModeScaleAspectFill];
            [[self contentImageView] setClipsToBounds:YES];
            [[[self contentImageView] layer] setCornerRadius:4];
            [self addSubview:[self contentImageView]];

            [[self contentImageView] setTranslatesAutoresizingMaskIntoConstraints:NO];
            [NSLayoutConstraint activateConstraints:@[
                [[[self contentImageView] widthAnchor] constraintEqualToConstant:80],
                [[[self contentImageView] heightAnchor] constraintEqualToConstant:45],
                [[[self contentImageView] centerYAnchor] constraintEqualToAnchor:[self centerYAnchor]],
                [[[self contentImageView] trailingAnchor] constraintEqualToAnchor:[self trailingAnchor] constant:-24]
            ]];
        }


        // header label
        [self setHeaderLabel:[[UILabel alloc] init]];
        [[self headerLabel] setText:[[[objc_getClass("SBApplicationController") sharedInstance] applicationWithBundleIdentifier:[item bundleIdentifier]] displayName] ?: @"SpringBoard"];
        [[self headerLabel] setFont:[UIFont systemFontOfSize:17 weight:UIFontWeightMedium]];
        [[self headerLabel] setTextColor:[UIColor labelColor]];
        [self addSubview:[self headerLabel]];

        [[self headerLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        if (![item hasImage] && ![item hasColor]) {
            [NSLayoutConstraint activateConstraints:@[
                [[[self headerLabel] topAnchor] constraintEqualToAnchor:[[self iconImageView] topAnchor] constant:-4],
                [[[self headerLabel] leadingAnchor] constraintEqualToAnchor:[[self iconImageView] trailingAnchor] constant:16],
                [[[self headerLabel] trailingAnchor] constraintEqualToAnchor:[self trailingAnchor] constant:-24]
            ]];
        } else {
            [NSLayoutConstraint activateConstraints:@[
                [[[self headerLabel] topAnchor] constraintEqualToAnchor:[[self iconImageView] topAnchor] constant:-4],
                [[[self headerLabel] leadingAnchor] constraintEqualToAnchor:[[self iconImageView] trailingAnchor] constant:16],
                [[[self headerLabel] trailingAnchor] constraintEqualToAnchor:[[self contentImageView] leadingAnchor] constant:-16]
            ]];
        }


        // content label
        [self setContentLabel:[[UILabel alloc] init]];
        [[self contentLabel] setText:[item content]];
        [[self contentLabel] setFont:[UIFont systemFontOfSize:14]];
        [[self contentLabel] setTextColor:[[UIColor labelColor] colorWithAlphaComponent:0.9]];
        [[self contentLabel] setNumberOfLines:2];
        [[self contentLabel] setLineBreakMode:NSLineBreakByTruncatingTail];
        [self addSubview:[self contentLabel]];

        [[self contentLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self contentLabel] topAnchor] constraintEqualToAnchor:[[self headerLabel] bottomAnchor] constant:2],
            [[[self contentLabel] leadingAnchor] constraintEqualToAnchor:[[self headerLabel] leadingAnchor]],
            [[[self contentLabel] trailingAnchor] constraintEqualToAnchor:[[self headerLabel] trailingAnchor]]
        ]];
    }

    return self;
}
@end
