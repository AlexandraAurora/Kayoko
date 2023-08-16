//
//  PasteboardManager.h
//  Kayoko
//
//  Created by Alexandra (@Traurige)
//

#import <rootless.h>
#import <UIKit/UIKit.h>
#import "PasteboardItem.h"
#import "../Utils/CommonUtil.h"
#import "../Utils/ImageUtil.h"
#import "../Preferences/NotificationKeys.h"
#import "../Preferences/PreferenceKeys.h"

static NSString* const kHistoryPath = @"/var/mobile/Documents/dev.traurige/Kayoko/history.json";
static NSString* const kHistoryImagesPath = @"/var/mobile/Documents/dev.traurige/Kayoko/images/";
static NSString* const kHistoryKeyHistory = @"history";
static NSString* const kHistoryKeyFavorites = @"favorites";

@interface PasteboardManager : NSObject {
    UIPasteboard* _pasteboard;
    NSUInteger _lastChangeCount;
    NSFileManager* _fileManager;
}
@property(atomic, assign)NSUInteger maximumHistoryAmount;
@property(atomic, assign)BOOL saveText;
@property(atomic, assign)BOOL saveImages;
@property(atomic, assign)BOOL automaticallyPaste;
+ (instancetype)sharedInstance;
- (void)pullPasteboardChanges;
- (void)addPasteboardItem:(PasteboardItem *)item toHistoryWithKey:(NSString *)historyKey;
- (void)addSongDotLinkItemFromItem:(PasteboardItem *)item;
- (void)addTranslateItemFromItem:(PasteboardItem *)item;
- (void)updatePasteboardWithItem:(PasteboardItem *)item fromHistoryWithKey:(NSString *)historyKey shouldAutoPaste:(BOOL)shouldAutoPaste;
- (void)removePasteboardItem:(PasteboardItem *)item fromHistoryWithKey:(NSString *)historyKey shouldRemoveImage:(BOOL)shouldRemoveImage;
- (NSMutableArray *)itemsFromHistoryWithKey:(NSString *)historyKey;
- (PasteboardItem *)latestHistoryItem;
- (UIImage *)imageForItem:(PasteboardItem *)item;
@end

@interface SBApplication : NSObject
@property(nonatomic, readonly)NSString* bundleIdentifier;
@end

@interface UIApplication (Private)
- (SBApplication *)_accessibilityFrontMostApplication;
@end
