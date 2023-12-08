//
//  PasteboardItem.m
//  Kayoko
//
//  Created by Alexandra Aurora Göttlicher
//

#import "PasteboardItem.h"

@implementation PasteboardItem
/**
 * Initializes an item based on the given content.
 */
- (instancetype)initWithBundleIdentifier:(NSString *)bundleIdentifier andContent:(NSString *)content withImageNamed:(NSString *)imageName {
    self = [super init];

    if (self) {
        [self setBundleIdentifier:bundleIdentifier];
        [self setContent:content];
        [self setImageName:imageName];
        [self setHasLink:[content hasPrefix:@"http://"] || [content hasPrefix:@"https://"]];
    }

    return self;
}

/**
 * Creates an item from a dictionary.
 *
 * @param dictionary The dictionary to create the item from.
 *
 * @return The created item.
 */
+ (PasteboardItem *)itemFromDictionary:(NSDictionary *)dictionary {
    NSString* bundleIdentifier = dictionary[kItemKeyBundleIdentifier];
    NSString* content = dictionary[kItemKeyContent];
    NSString* imageName = dictionary[kItemKeyImageName];
    return [[PasteboardItem alloc] initWithBundleIdentifier:bundleIdentifier andContent:content withImageNamed:imageName];
}
@end
