//
//  CallaSingleContactCell.m
//  Calla Utils
//
//  Created by Alexandra (@Traurige)
//

#import "CallaSingleContactCell.h"

@implementation CallaSingleContactCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

    if (self) {
        [self setDisplayName:[specifier properties][@"DisplayName"]];
        [self setUsername:[specifier properties][@"Username"]];
        [self setUrl:[specifier properties][@"Url"]];

        // avatar image view
        [self setAvatarImageView:[[UIImageView alloc] init]];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
            UIImage* avatar = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.traurige.dev/v1/avatar?username=%@", [self username]]]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView transitionWithView:[self avatarImageView] duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    [[self avatarImageView] setImage:avatar];
                } completion:nil];
            });
        });

        [[self avatarImageView] setContentMode:UIViewContentModeScaleAspectFill];
        [[self avatarImageView] setClipsToBounds:YES];
        [[[self avatarImageView] layer] setCornerRadius:21.5];
        [[[self avatarImageView] layer] setBorderWidth:2];
        [[[self avatarImageView] layer] setBorderColor:[[[UIColor labelColor] colorWithAlphaComponent:0.1] CGColor]];
        [self addSubview:[self avatarImageView]];

        [[self avatarImageView] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self avatarImageView] centerYAnchor] constraintEqualToAnchor:[self centerYAnchor]],
            [[[self avatarImageView] leadingAnchor] constraintEqualToAnchor:[self leadingAnchor] constant:16],
            [[[self avatarImageView] widthAnchor] constraintEqualToConstant:43],
            [[[self avatarImageView] heightAnchor] constraintEqualToConstant:43]
        ]];


        // display name label
        [self setDisplayNameLabel:[[UILabel alloc] init]];
        [[self displayNameLabel] setText:[self displayName]];
        [[self displayNameLabel] setFont:[UIFont systemFontOfSize:17 weight:UIFontWeightSemibold]];
        [[self displayNameLabel] setTextColor:[UIColor labelColor]];
        [self addSubview:[self displayNameLabel]];

        [[self displayNameLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self displayNameLabel] topAnchor] constraintEqualToAnchor:[[self avatarImageView] topAnchor] constant:4],
            [[[self displayNameLabel] leadingAnchor] constraintEqualToAnchor:[[self avatarImageView] trailingAnchor] constant:8],
            [[[self displayNameLabel] trailingAnchor] constraintEqualToAnchor:[self trailingAnchor] constant:-16]
        ]];


        // username label
        [self setUsernameLabel:[[UILabel alloc] init]];
        [[self usernameLabel] setText:[NSString stringWithFormat:@"@%@", [self username]]];
        [[self usernameLabel] setFont:[UIFont systemFontOfSize:11 weight:UIFontWeightRegular]];
        [[self usernameLabel] setTextColor:[[UIColor labelColor] colorWithAlphaComponent:0.6]];
        [self addSubview:[self usernameLabel]];

        [[self usernameLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self usernameLabel] leadingAnchor] constraintEqualToAnchor:[[self avatarImageView] trailingAnchor] constant:8],
            [[[self usernameLabel] trailingAnchor] constraintEqualToAnchor:[[self displayNameLabel] trailingAnchor]],
            [[[self usernameLabel] bottomAnchor] constraintEqualToAnchor:[[self avatarImageView] bottomAnchor] constant:-4]
        ]];


        // tap view
        [self setTapRecognizerView:[[UIView alloc] init]];
        [self addSubview:[self tapRecognizerView]];

        [[self tapRecognizerView] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self tapRecognizerView] topAnchor] constraintEqualToAnchor:[self topAnchor]],
            [[[self tapRecognizerView] leadingAnchor] constraintEqualToAnchor:[self leadingAnchor]],
            [[[self tapRecognizerView] trailingAnchor] constraintEqualToAnchor:[self trailingAnchor]],
            [[[self tapRecognizerView] bottomAnchor] constraintEqualToAnchor:[self bottomAnchor]]
        ]];


        // tap
        [self setTap:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openUserProfile)]];
        [[self tapRecognizerView] addGestureRecognizer:[self tap]];
    }

	return self;
}

- (void)openUserProfile {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self url]] options:@{} completionHandler:nil];
}
@end
