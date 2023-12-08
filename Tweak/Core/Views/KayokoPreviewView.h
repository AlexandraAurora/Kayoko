//
//  KayokoPreviewView.h
//  Kayoko
//
//  Created by Alexandra Aurora Göttlicher
//

#import <WebKit/WebKit.h>

@interface KayokoPreviewView : UIView <WKNavigationDelegate>
@property(nonatomic)UITextView* textView;
@property(nonatomic)UIImageView* imageView;
@property(nonatomic)WKWebView* webView;
@property(nonatomic)NSString* name;
- (instancetype)initWithName:(NSString *)name;
- (void)reset;
@end
