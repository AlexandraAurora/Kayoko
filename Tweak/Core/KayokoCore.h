//
//  KayokoCore.h
//  Kayoko
//
//  Created by Alexandra Aurora Göttlicher
//

#import <UIKit/UIKit.h>

@class KayokoView;

static CGFloat const kHeight = 420;

KayokoView* kayokoView;

NSUserDefaults* preferences;
BOOL pfEnabled;

NSUInteger pfMaximumHistoryAmount;
BOOL pfSaveText;
BOOL pfSaveImages;
BOOL pfAutomaticallyPaste;

@interface UIStatusBarWindow  : UIWindow
@end
