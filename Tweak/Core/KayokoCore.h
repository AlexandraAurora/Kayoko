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

KayokoView* kayokoView;

HBPreferences* preferences;
BOOL pfEnabled;

NSUInteger pfMaximumHistoryAmount;
BOOL pfSaveText;
BOOL pfSaveImages;
BOOL pfAutomaticallyPaste;
BOOL pfAddTranslateOption;
BOOL pfAddSongDotLinkOption;
BOOL pfPlaySoundEffects;
BOOL pfPlayHapticFeedback;
CGFloat pfHeightInPoints;

@interface UIStatusBarWindow  : UIWindow
@end
