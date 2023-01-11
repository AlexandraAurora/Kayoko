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

OBJC_EXTERN KayokoView* kayokoView;

OBJC_EXTERN HBPreferences* preferences;
OBJC_EXTERN BOOL pfEnabled;

OBJC_EXTERN NSUInteger pfMaximumHistoryAmount;
OBJC_EXTERN BOOL pfSaveText;
OBJC_EXTERN BOOL pfSaveImages;
OBJC_EXTERN BOOL pfAutomaticallyPaste;
OBJC_EXTERN BOOL pfAddTranslateOption;
OBJC_EXTERN BOOL pfAddSongDotLinkOption;

OBJC_EXTERN CGFloat pfHeightInPoints;

@interface UIStatusBarWindow  : UIWindow
@end
