//
//  KayokoCore.h
//  Kayoko
//
//  Created by Alexandra (@Traurige)
//

#import "substrate.h"
#import "../../Manager/PasteboardManager.h"
#import "Views/KayokoView.h"

static CGFloat const kHeight = 480;

KayokoView* kayokoView;

NSUserDefaults* preferences;
BOOL pfEnabled;

NSUInteger pfMaximumHistoryAmount;
BOOL pfSaveText;
BOOL pfSaveImages;
BOOL pfAutomaticallyPaste;
BOOL pfAddTranslateOption;
BOOL pfAddSongDotLinkOption;

@interface UIStatusBarWindow  : UIWindow
@end
