//
//  PasteboardManager.m
//  Kayoko
//
//  Created by Alexandra (@Traurige)
//

#import "PasteboardManager.h"

@implementation PasteboardManager
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

- (instancetype)init {
    return [PasteboardManager sharedInstance];
}

- (void)pullPasteboardChanges {
    if ([_pasteboard changeCount] == _lastChangeCount || (![_pasteboard hasStrings] && ![_pasteboard hasImages])) {
        return;
    }

    [self ensureResourcesExist];

    if ([self saveText]) {
        // don't store the strings if the pasteboard contains images as well (e.g. an image from the web)
        if (!([_pasteboard hasStrings] && [_pasteboard hasImages])) {
            for (NSString* string in [_pasteboard strings]) {
                @autoreleasepool {
                    // the core only runs on the springboard process, thus mainbundle can't provide the bundle identifier
                    // uiapplication/springboard can provide the front most application to get the bundle identifier
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
                NSString* imageName = [CommonUtil randomStringWithLength:32];

                // jpg uses less space
                // save as png if an alpha channel is present though
                if ([ImageUtil imageHasAlpha:image]) {
                    imageName = [imageName stringByAppendingString:@".png"];
                    NSString* filePath = [kHistoryImagesPath stringByAppendingString:imageName];
                    [UIImagePNGRepresentation([ImageUtil rotatedImageFromImage:image]) writeToFile:filePath atomically:YES];
                } else {
                    imageName = [imageName stringByAppendingString:@".jpg"];
                    NSString* filePath = [kHistoryImagesPath stringByAppendingString:imageName];
                    [UIImageJPEGRepresentation(image, 1) writeToFile:filePath atomically:YES];
                }

                // see the loop above
                SBApplication* frontMostApplication = [[UIApplication sharedApplication] _accessibilityFrontMostApplication];
                PasteboardItem* item = [[PasteboardItem alloc] initWithBundleIdentifier:[frontMostApplication bundleIdentifier] andContent:imageName withImageNamed:imageName];
                [self addPasteboardItem:item toHistoryWithKey:kHistoryKeyHistory];
            }
        }
    }

    _lastChangeCount = [_pasteboard changeCount];
}

- (void)addPasteboardItem:(PasteboardItem *)item toHistoryWithKey:(NSString *)historyKey {
    if ([[item content] isEqualToString:@""]) {
        return;
    }

    NSMutableDictionary* json = [self getJson];
    NSMutableArray* history = json[historyKey] ?: [[NSMutableArray alloc] init];

    // remove duplicates
    [self removePasteboardItem:item fromHistoryWithKey:historyKey shouldRemoveImage:NO];

    [history insertObject:@{
        @"bundleIdentifier": [item bundleIdentifier] ?: @"com.apple.springboard",
        @"content": [item content] ?: @"",
        @"imageName": [item imageName] ?: @"",
        @"hasPlainText": @([item hasPlainText]),
        @"hasLink": @([item hasLink]),
        @"hasMusicLink": @([item hasMusicLink]),
        @"hasColor": @([item hasColor]),
        @"hasImage": @([item hasImage])
    } atIndex:0];

    // remove the oldest items if the history contains more items than the set maximum amount
    while ([history count] > [self maximumHistoryAmount]) {
        [history removeLastObject];
    }

    json[historyKey] = history;

    [self setJsonFromDictionary:json];
}

- (void)addSongDotLinkItemFromItem:(PasteboardItem *)item {
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.song.link/v1-alpha.1/links?url=%@", [item content]]];
    NSURLSessionDataTask* task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData* _Nullable data, NSURLResponse* _Nullable response, NSError* _Nullable error) {
        @try {
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSString* link = json[@"pageUrl"];
            if (link) {
                PasteboardItem* songDotLinkItem = [[PasteboardItem alloc] initWithBundleIdentifier:[item bundleIdentifier] andContent:link withImageNamed:nil];
                [self addPasteboardItem:songDotLinkItem toHistoryWithKey:kHistoryKeyHistory];
                [self updatePasteboardWithItem:songDotLinkItem fromHistoryWithKey:kHistoryKeyHistory shouldAutoPaste:NO];
            } else {
                [CommonUtil showAlertWithTitle:@"Kayoko" andMessage:[NSString stringWithFormat:@"The server didn't return the expected result.\n\nReason: \"%@\"", json[@"code"]] withDismissButtonTitle:@"Dismiss"];
            }
        } @catch (NSException* exception) {
            [CommonUtil showAlertWithTitle:@"Kayoko" andMessage:[NSString stringWithFormat:@"An error occurred while trying to get the song.link link.\n\n%@", exception] withDismissButtonTitle:@"Dismiss"];
        }
    }];
    [task resume];
}

- (void)addTranslateItemFromItem:(PasteboardItem *)item {
    NSString* encodedString = [[item content] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString* targetLanguageCode = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.traurige.dev/v1/deepl/translate?text=%@&target_lang=%@", encodedString, targetLanguageCode]];
    NSURLSessionDataTask* task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData* _Nullable data, NSURLResponse* _Nullable response, NSError* _Nullable error) {
        @try {
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSString* translation = json[@"text"];
            if (translation) {
                PasteboardItem* translationItem = [[PasteboardItem alloc] initWithBundleIdentifier:[item bundleIdentifier] andContent:translation withImageNamed:nil];
                [self addPasteboardItem:translationItem toHistoryWithKey:kHistoryKeyHistory];
                [self updatePasteboardWithItem:translationItem fromHistoryWithKey:kHistoryKeyHistory shouldAutoPaste:NO];
            } else {
                [CommonUtil showAlertWithTitle:@"Kayoko" andMessage:[NSString stringWithFormat:@"The server didn't return the expected result.\n\nReason: \"%@\"", json[@"message"]] withDismissButtonTitle:@"Dismiss"];
            }
        } @catch (NSException* exception) {
            [CommonUtil showAlertWithTitle:@"Kayoko" andMessage:[NSString stringWithFormat:@"An error occurred while trying to translate the text.\n\n%@", exception] withDismissButtonTitle:@"Dismiss"];
        }
    }];
    [task resume];
}

- (void)removePasteboardItem:(PasteboardItem *)item fromHistoryWithKey:(NSString *)historyKey shouldRemoveImage:(BOOL)shouldRemoveImage {
    NSMutableDictionary* json = [self getJson];
    NSMutableArray* history = json[historyKey];

    for (NSDictionary* dictionary in history) {
        @autoreleasepool {
            PasteboardItem* historyItem = [PasteboardItem itemFromDictionary:dictionary];
            if ([[historyItem content] isEqualToString:[item content]]) {
                [history removeObject:dictionary];
                if ([item hasImage] && shouldRemoveImage) {
                    NSString* filePath = [kHistoryImagesPath stringByAppendingString:[item imageName]];
                    [_fileManager removeItemAtPath:filePath error:nil];
                }
                break;
            }
        }
    }

    json[historyKey] = history;

    [self setJsonFromDictionary:json];
}

- (void)updatePasteboardWithItem:(PasteboardItem *)item fromHistoryWithKey:(NSString *)historyKey shouldAutoPaste:(BOOL)shouldAutoPaste {
    if ([item hasImage] && ![item hasPlainText] && ![item hasLink] && ![item hasMusicLink] && ![item hasColor]) {
        NSString* filePath = [kHistoryImagesPath stringByAppendingString:[item imageName]];
        UIImage* image = [UIImage imageWithContentsOfFile:filePath];
        [_pasteboard setImage:image];
    } else {
        [_pasteboard setString:[item content]];
    }

    // the given item gets removed, as the pasteboard is updated with the same item
    [self removePasteboardItem:item fromHistoryWithKey:historyKey shouldRemoveImage:YES];

    // automatic paste should not occur for asynchronous operations
    if ([self automaticallyPaste] && shouldAutoPaste) {
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"dev.traurige.kayoko.helper.paste", nil, nil, YES);
    }
}

- (NSArray *)itemsFromHistoryWithKey:(NSString *)historyKey {
    NSDictionary* json = [self getJson];
    return json[historyKey] ?: [[NSArray alloc] init];
}

- (NSMutableDictionary *)getJson {
    [self ensureResourcesExist];

    NSData* jsonData = [NSData dataWithContentsOfFile:kHistoryPath];
    NSMutableDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];

    return json;
}

- (void)setJsonFromDictionary:(NSMutableDictionary *)dictionary {
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    [jsonData writeToFile:kHistoryPath atomically:YES];

    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"dev.traurige.kayoko.core.reload", nil, nil, YES);
}

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
