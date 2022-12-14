#import "KayokoPreviewView.h"

@implementation KayokoPreviewView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        // text view
        [self setTextView:[[UITextView alloc] init]];
        [[self textView] setBackgroundColor:[UIColor clearColor]];
        [[self textView] setFont:[UIFont systemFontOfSize:14]];
        [[self textView] setEditable:NO];
        [[self textView] setSelectable:NO];
        [[self textView] setHidden:YES];
        [self addSubview:[self textView]];

        [[self textView] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self textView] topAnchor] constraintEqualToAnchor:[self topAnchor]],
            [[[self textView] leadingAnchor] constraintEqualToAnchor:[self leadingAnchor] constant:16],
            [[[self textView] trailingAnchor] constraintEqualToAnchor:[self trailingAnchor] constant:-16],
            [[[self textView] bottomAnchor] constraintEqualToAnchor:[self bottomAnchor]]
        ]];


        // image view
        [self setImageView:[[UIImageView alloc] init]];
        [[self imageView] setContentMode:UIViewContentModeScaleAspectFit];
        [[self imageView] setHidden:YES];
        [self addSubview:[self imageView]];

        [[self imageView] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self imageView] topAnchor] constraintEqualToAnchor:[self topAnchor]],
            [[[self imageView] leadingAnchor] constraintEqualToAnchor:[self leadingAnchor]],
            [[[self imageView] trailingAnchor] constraintEqualToAnchor:[self trailingAnchor]],
            [[[self imageView] bottomAnchor] constraintEqualToAnchor:[self bottomAnchor]]
        ]];


        // web view
        [self setWebView:[[WKWebView alloc] init]];
        [[self webView] setNavigationDelegate:self];
        [[self webView] setAllowsBackForwardNavigationGestures:YES];
        [[self webView] setHidden:YES];
        [self addSubview:[self webView]];

        [[self webView] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self webView] topAnchor] constraintEqualToAnchor:[self topAnchor]],
            [[[self webView] leadingAnchor] constraintEqualToAnchor:[self leadingAnchor]],
            [[[self webView] trailingAnchor] constraintEqualToAnchor:[self trailingAnchor]],
            [[[self webView] bottomAnchor] constraintEqualToAnchor:[self bottomAnchor]]
        ]];
    }

    return self;
}

- (void)reset {
    [[self textView] setHidden:YES];
    [[self textView] setText:@""];
    [[self imageView] setHidden:YES];
    [[self imageView] setImage:nil];
    [[self webView] setHidden:YES];
    [[self webView] loadHTMLString:@"" baseURL:nil];
}
@end
