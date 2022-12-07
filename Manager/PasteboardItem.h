#import <UIKit/UIKit.h>

@interface PasteboardItem : NSObject
@property(atomic, assign)NSString* bundleIdentifier;
@property(atomic, assign)NSString* displayName;
@property(atomic, assign)NSString* content;
@property(atomic, assign)NSString* imageName;
@property(atomic, assign)BOOL hasPlainText;
@property(atomic, assign)BOOL hasLink;
@property(atomic, assign)BOOL hasMusicLink;
@property(atomic, assign)BOOL hasColor;
@property(atomic, assign)BOOL hasImage;
- (instancetype)initWithBundleIdentifier:(NSString *)bundleIdentifier andContent:(NSString *)content withImageNamed:(NSString *)imageName;
+ (PasteboardItem *)itemFromDictionary:(NSDictionary *)dictionary;
@end
