//
//  PasteboardItem.h
//  Kayoko
//
//  Created by Alexandra Aurora Göttlicher
//

#import <Foundation/Foundation.h>

static NSString* const kItemKeyBundleIdentifier = @"bundle_identifier";
static NSString* const kItemKeyContent = @"content";
static NSString* const kItemKeyImageName = @"image_name";
static NSString* const kItemKeyHasLink = @"has_link";

@interface PasteboardItem : NSObject
@property(nonatomic)NSString* bundleIdentifier;
@property(nonatomic)NSString* displayName;
@property(nonatomic)NSString* content;
@property(nonatomic)NSString* imageName;
@property(nonatomic, assign)BOOL hasLink;
- (instancetype)initWithBundleIdentifier:(NSString *)bundleIdentifier andContent:(NSString *)content withImageNamed:(NSString *)imageName;
+ (PasteboardItem *)itemFromDictionary:(NSDictionary *)dictionary;
@end
