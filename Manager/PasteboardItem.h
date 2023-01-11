#import <UIKit/UIKit.h>

@interface PasteboardItem : NSObject
@property (nonatomic, copy) NSString* bundleIdentifier;
@property (nonatomic, copy) NSString* displayName;
@property (nonatomic, copy) NSString* content;
@property (nonatomic, copy) NSString* imageName;
@property (nonatomic, assign) BOOL hasPlainText;
@property (nonatomic, assign) BOOL hasLink;
@property (nonatomic, assign) BOOL hasMusicLink;
@property (nonatomic, assign) BOOL hasColor;
@property (nonatomic, assign) BOOL hasImage;
- (instancetype)initWithBundleIdentifier:(NSString *)bundleIdentifier andContent:(NSString *)content withImageNamed:(NSString *)imageName;
+ (PasteboardItem *)itemFromDictionary:(NSDictionary *)dictionary;
@end
