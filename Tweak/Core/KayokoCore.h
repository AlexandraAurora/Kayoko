//
//  KayokoCore.h
//  Kayoko
//
//  Created by Alexandra (@Traurige)
//

#import "substrate.h"
#import "../../Manager/PasteboardManager.h"
#import "Views/KayokoView.h"
#import <Cephei/HBPreferences.h>

static CGFloat const kHeight = 480;

KayokoView* kayokoView;

HBPreferences* preferences;
BOOL pfEnabled;

NSUInteger pfMaximumHistoryAmount;
BOOL pfSaveText;
BOOL pfSaveImages;
BOOL pfAutomaticallyPaste;
BOOL pfAddTranslateOption;
BOOL pfAddSongDotLinkOption;

@interface UIStatusBarWindow  : UIWindow
@end
