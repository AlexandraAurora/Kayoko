#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface KayokoPreviewView : UIView <WKNavigationDelegate>
@property (nonatomic, strong) UITextView* textView;
@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) WKWebView* webView;
- (void)reset;
@end
