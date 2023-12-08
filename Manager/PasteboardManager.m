//
//  PasteboardManager.m
//  Kayoko
//
//  Created by Alexandra Aurora Göttlicher
//

#import "PasteboardManager.h"
#import "PasteboardItem.h"
#import "../Utils/StringUtil.h"
#import "../Utils/ImageUtil.h"
#import "../Utils/AlertUtil.h"
#import "../Preferences/NotificationKeys.h"
#import "../Preferences/PreferenceKeys.h"

@implementation PasteboardManager
/**
 * Creates the shared instance.
 */
+ (instancetype)sharedInstance {
    static PasteboardManager* sharedInstance;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [PasteboardManager alloc];
        sharedInstance->_pasteboard = [UIPasteboard generalPasteboard];
        sharedInstance->_lastChangeCount = [sharedInstance->_pasteboard changeCount];
        sharedInstance->_fileManager = [NSFileManager defaultManager];
    });

    return sharedInstance;
}

/**
 * Creates the manager using the shared instance.
 */
- (instancetype)init {
    return [PasteboardManager sharedInstance];
}

/**
 * Pulls new changes from the pasteboard.
 */
- (void)pullPasteboardChanges {
    // Return if the pasteboard is empty.
    if ([_pasteboard changeCount] == _lastChangeCount || (![_pasteboard hasStrings] && ![_pasteboard hasImages])) {
        return;
    }

    [self ensureResourcesExist];

    if ([self saveText]) {
        // Don't pull strings if the pasteboard contains images.
        // For example: When copying an image from the web we only want the image, without the string.
        if (!([_pasteboard hasStrings] && [_pasteboard hasImages])) {
            for (NSString* string in [_pasteboard strings]) {
                @autoreleasepool {
                    // The core only runs on the SpringBoard process, thus we can't use mainbundle to get the process' bundle identifier.
                    // However, we can get it by using UIApplication/SpringBoard front-most-application.
                    SBApplication* frontMostApplication = [[UIApplication sharedApplication] _accessibilityFrontMostApplication];
                    PasteboardItem* item = [[PasteboardItem alloc] initWithBundleIdentifier:[frontMostApplication bundleIdentifier] andContent:string withImageNamed:nil];
                    [self addPasteboardItem:item toHistoryWithKey:kHistoryKeyHistory];
                }
            }
        }
    }

    if ([self saveImages]) {
        for (UIImage* image in [_pasteboard images]) {
            @autoreleasepool {
                NSString* imageName = [StringUtil getRandomStringWithLength:32];

                // Only save as PNG if the image has an alpha channel to save storage space.
                if ([ImageUtil imageHasAlpha:image]) {
                    imageName = [imageName stringByAppendingString:@".png"];
                    NSString* filePath = [NSString stringWithFormat:@"%@/%@", kHistoryImagesPath, imageName];
                    [UIImagePNGRepresentation([ImageUtil getRotatedImageFromImage:image]) writeToFile:filePath atomically:YES];
                } else {
                    imageName = [imageName stringByAppendingString:@".jpg"];
                    NSString* filePath = [NSString stringWithFormat:@"%@/%@", kHistoryImagesPath, imageName];
                    [UIImageJPEGRepresentation(image, 1) writeToFile:filePath atomically:YES];
                }

                // See the above loop.
                SBApplication* frontMostApplication = [[UIApplication sharedApplication] _accessibilityFrontMostApplication];
                PasteboardItem* item = [[PasteboardItem alloc] initWithBundleIdentifier:[frontMostApplication bundleIdentifier] andContent:imageName withImageNamed:imageName];
                [self addPasteboardItem:item toHistoryWithKey:kHistoryKeyHistory];
            }
        }
    }

    _lastChangeCount = [_pasteboard changeCount];
}

/**
 * Adds an item to a specified history.
 *
 * @param item The item to save.
 * @param historyKey The key for the history which to save to.
 */
- (void)addPasteboardItem:(PasteboardItem *)item toHistoryWithKey:(NSString *)historyKey {
    if ([[item content] isEqualToString:@""]) {
        return;
    }

    // Remove duplicates.
    [self removePasteboardItem:item fromHistoryWithKey:historyKey shouldRemoveImage:NO];

    NSMutableDictionary* json = [self getJson];
    NSMutableArray* history = [self getItemsFromHistoryWithKey:historyKey];

    [history insertObject:@{
        kItemKeyBundleIdentifier: [item bundleIdentifier] ?: @"com.apple.springboard",
        kItemKeyContent: [item content] ?: @"",
        kItemKeyImageName: [item imageName] ?: @"",
        kItemKeyHasLink: @([item hasLink])
    } atIndex:0];

    // Truncate the history corresponding the set limit.
    while ([history count] > [self maximumHistoryAmount]) {
        [history removeLastObject];
    }

    json[historyKey] = history;

    [self setJsonFromDictionary:json];
}

/**
 * Removes an item from a specified history.
 *
 * @param item The item to remove.
 * @param historyKey The key for the history from which to remove from.
 * @param shouldRemoveImage Whether to remove the item's corresponding image or not.
 */
- (void)removePasteboardItem:(PasteboardItem *)item fromHistoryWithKey:(NSString *)historyKey shouldRemoveImage:(BOOL)shouldRemoveImage {
    NSMutableDictionary* json = [self getJson];
    NSMutableArray* history = json[historyKey];

    for (NSDictionary* dictionary in history) {
        @autoreleasepool {
            PasteboardItem* historyItem = [PasteboardItem itemFromDictionary:dictionary];

            if ([[historyItem content] isEqualToString:[item content]]) {
                [history removeObject:dictionary];

                if (![[item imageName] isEqualToString:@""] && shouldRemoveImage) {
                    NSString* filePath = [NSString stringWithFormat:@"%@/%@", kHistoryImagesPath, [item imageName]];
                    [_fileManager removeItemAtPath:filePath error:nil];
                }

                break;
            }
        }
    }

    json[historyKey] = history;

    [self setJsonFromDictionary:json];
}

/**
 * Updates the pasteboard with an item's content.
 *
 * @param item The item from which to set the content from.
 * @param historyKey The key for the history which the item is from.
 * @param shouldAutoPaste Whether the helper should automatically paste the new content.
 */
- (void)updatePasteboardWithItem:(PasteboardItem *)item fromHistoryWithKey:(NSString *)historyKey shouldAutoPaste:(BOOL)shouldAutoPaste {
    [_pasteboard setString:@""];

    if (![[item imageName] isEqualToString:@""]) {
        NSString* filePath = [NSString stringWithFormat:@"%@/%@", kHistoryImagesPath, [item imageName]];
        UIImage* image = [UIImage imageWithContentsOfFile:filePath];
        [_pasteboard setImage:image];
    } else {
        [_pasteboard setString:[item content]];
    }

    // The pasteboard updates with the given item, which triggers an update event.
    // Therefore we remove the given item to prevent duplicates.
    [self removePasteboardItem:item fromHistoryWithKey:historyKey shouldRemoveImage:YES];

    // Automatic paste should not occur for asynchronous operations.
    if ([self automaticallyPaste] && shouldAutoPaste) {
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)kNotificationKeyHelperPaste, nil, nil, YES);
    }
}

/**
 * Returns all items from a specified history.
 *
 * @param historyKey The key for the history from which to get the items from.
 *
 * @return The history's items.
 */
- (NSMutableArray *)getItemsFromHistoryWithKey:(NSString *)historyKey {
    NSDictionary* json = [self getJson];
    return json[historyKey] ?: [[NSMutableArray alloc] init];
}

/**
 * Returns the latest item from the default history.
 *
 * @return The item.
 */
- (PasteboardItem *)getLatestHistoryItem {
    NSArray* history = [self getItemsFromHistoryWithKey:kHistoryKeyHistory];
    return [PasteboardItem itemFromDictionary:[history firstObject] ?: nil];
}

/**
 * Returns the image for an item.
 *
 * @param item The item from which to get the image from.
 *
 * @return The image.
 */
- (UIImage *)getImageForItem:(PasteboardItem *)item {
    NSData* imageData = [_fileManager contentsAtPath:[NSString stringWithFormat:@"%@/%@", kHistoryImagesPath, [item imageName]]];
    return [UIImage imageWithData:imageData];
}

/**
 * Creates and returns a dictionary from the json containing the histories.
 *
 * @return The dictionary.
 */
- (NSMutableDictionary *)getJson {
    [self ensureResourcesExist];

    NSData* jsonData = [NSData dataWithContentsOfFile:kHistoryPath];
    NSMutableDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];

    return json;
}

/**
 * Stores the contents from a dictionary to a json file.
 *
 * @param dictionary The dictionary from which to save the contents from.
 */
- (void)setJsonFromDictionary:(NSMutableDictionary *)dictionary {
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    [jsonData writeToFile:kHistoryPath atomically:YES];

    // Tell the core to reload the history view.
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)kNotificationKeyCoreReload, nil, nil, YES);
}

/**
 * Creates the json for the histories and path for the images.
 */
- (void)ensureResourcesExist {
    BOOL isDirectory;
    if (![_fileManager fileExistsAtPath:kHistoryImagesPath isDirectory:&isDirectory]) {
        [_fileManager createDirectoryAtPath:kHistoryImagesPath withIntermediateDirectories:YES attributes:nil error:nil];
    }

    if (![_fileManager fileExistsAtPath:kHistoryPath]) {
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:[[NSMutableDictionary alloc] init] options:NSJSONWritingPrettyPrinted error:nil];
        [jsonData writeToFile:kHistoryPath options:NSDataWritingAtomic error:nil];
    }
}
@end
