//
//  KayokoCore.m
//  Kayoko
//
//  Created by Alexandra Aurora Göttlicher
//

#import "KayokoCore.h"
#import <substrate.h>
#import "../../Manager/PasteboardManager.h"
#import "Views/KayokoView.h"
#import "../../Preferences/PreferenceKeys.h"
#import "../../Preferences/NotificationKeys.h"

#pragma mark - UIStatusBarWindow class hooks

/**
 * Sets up the history view.
 *
 * Using the status bar's window is hacky, yet it's present on SpringBoard and in apps.
 * It's important to note that it runs on the SpringBoard process too, which gives us file system read/write.
 *
 * @param frame
 */
static void (* orig_UIStatusBarWindow_initWithFrame)(UIStatusBarWindow* self, SEL _cmd, CGRect frame);
static void override_UIStatusBarWindow_initWithFrame(UIStatusBarWindow* self, SEL _cmd, CGRect frame) {
    orig_UIStatusBarWindow_initWithFrame(self, _cmd, frame);

    if (!kayokoView) {
        CGRect bounds = [[UIScreen mainScreen] bounds];
        kayokoView = [[KayokoView alloc] initWithFrame:CGRectMake(0, bounds.size.height - kHeight, bounds.size.width, kHeight)];
        [kayokoView setAutomaticallyPaste:pfAutomaticallyPaste];
        [self addSubview:kayokoView];
    }
}

#pragma mark - Notification callbacks

/**
 * Receives the notification that the pasteboard changed from the daemon and pulls the new changes.
 */
static void pasteboard_changed() {
    [[PasteboardManager sharedInstance] pullPasteboardChanges];
}

/**
 * Shows the history.
 */
static void show() {
    if ([kayokoView isHidden]) {
        [kayokoView show];
    }
}

/**
 * Hides the history.
 */
static void hide() {
    if (![kayokoView isHidden]) {
        [kayokoView hide];
    }
}

/**
 * Reloads the history.
 */
static void reload() {
    if (![kayokoView isHidden]) {
        [kayokoView reload];
    }
}

#pragma mark - Preferences

/**
 * Loads the user's preferences.
 */
static void load_preferences() {
    preferences = [[NSUserDefaults alloc] initWithSuiteName:kPreferencesIdentifier];

    [preferences registerDefaults:@{
        kPreferenceKeyEnabled: @(kPreferenceKeyEnabledDefaultValue),
        kPreferenceKeyMaximumHistoryAmount: @(kPreferenceKeyMaximumHistoryAmountDefaultValue),
        kPreferenceKeySaveText: @(kPreferenceKeySaveTextDefaultValue),
        kPreferenceKeySaveImages: @(kPreferenceKeySaveImagesDefaultValue),
        kPreferenceKeyAutomaticallyPaste: @(kPreferenceKeyAutomaticallyPasteDefaultValue)
    }];

    pfEnabled = [[preferences objectForKey:kPreferenceKeyEnabled] boolValue];
    pfMaximumHistoryAmount = [[preferences objectForKey:kPreferenceKeyMaximumHistoryAmount] unsignedIntegerValue];
    pfSaveText = [[preferences objectForKey:kPreferenceKeySaveText] boolValue];
    pfSaveImages = [[preferences objectForKey:kPreferenceKeySaveImages] boolValue];
    pfAutomaticallyPaste = [[preferences objectForKey:kPreferenceKeyAutomaticallyPaste] boolValue];

    [[PasteboardManager sharedInstance] setMaximumHistoryAmount:pfMaximumHistoryAmount];
    [[PasteboardManager sharedInstance] setSaveText:pfSaveText];
    [[PasteboardManager sharedInstance] setSaveImages:pfSaveImages];
    [[PasteboardManager sharedInstance] setAutomaticallyPaste:pfAutomaticallyPaste];

    [kayokoView setAutomaticallyPaste:pfAutomaticallyPaste];
}

#pragma mark - Constructor

/**
 * Initializes the core.
 *
 * First it loads the preferences and continues if Kayoko is enabled.
 * Secondly it sets up the hooks.
 * Finally it registers the notification callbacks.
 */
__attribute((constructor)) static void initialize() {
    load_preferences();

    if (!pfEnabled) {
        return;
    }

    MSHookMessageEx(objc_getClass("UIStatusBarWindow"), @selector(initWithFrame:), (IMP)&override_UIStatusBarWindow_initWithFrame, (IMP *)&orig_UIStatusBarWindow_initWithFrame);

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)pasteboard_changed, (CFStringRef)kNotificationKeyObserverPasteboardChanged, NULL, (CFNotificationSuspensionBehavior)kNilOptions);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)show, (CFStringRef)kNotificationKeyCoreShow, NULL, (CFNotificationSuspensionBehavior)kNilOptions);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)hide, (CFStringRef)kNotificationKeyCoreHide, NULL, (CFNotificationSuspensionBehavior)kNilOptions);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reload, (CFStringRef)kNotificationKeyCoreReload, NULL, (CFNotificationSuspensionBehavior)kNilOptions);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)load_preferences, (CFStringRef)kNotificationKeyPreferencesReload, NULL, (CFNotificationSuspensionBehavior)kNilOptions);
}
