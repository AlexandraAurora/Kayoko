//
//  KayokoCore.m
//  Kayoko
//
//  Created by Alexandra (@Traurige)
//

#import "KayokoCore.h"

KayokoView* kayokoView = nil;

HBPreferences* preferences = nil;
BOOL pfEnabled = kPreferenceKeyEnabledDefaultValue;

NSUInteger pfMaximumHistoryAmount = kPreferenceKeyMaximumHistoryAmountDefaultValue;
BOOL pfSaveText = kPreferenceKeySaveTextDefaultValue;
BOOL pfSaveImages = kPreferenceKeySaveImagesDefaultValue;
BOOL pfAutomaticallyPaste = kPreferenceKeyAutomaticallyPasteDefaultValue;
BOOL pfAddTranslateOption = kPreferenceKeyAddTranslateOptionDefaultValue;
BOOL pfAddSongDotLinkOption = kPreferenceKeyAddSongDotLinkOptionDefaultValue;

CGFloat pfHeightInPoints = kPreferenceKeyHeightInPointsDefaultValue;

#pragma mark - Class hooks

// UIStatusBarWindow is sick because it's present everywhere and doesn't need uikit injection
// it also prevents sandbox issues as the core runs on springboard (which has fs r/w)
static void (* orig_UIStatusBarWindow_initWithFrame)(UIStatusBarWindow* self, SEL _cmd, CGRect frame);
static void override_UIStatusBarWindow_initWithFrame(UIStatusBarWindow* self, SEL _cmd, CGRect frame) {
    orig_UIStatusBarWindow_initWithFrame(self, _cmd, frame);

    if (!kayokoView) {
        CGRect bounds = [[UIScreen mainScreen] bounds];
        CGRect kayokoViewFrame = CGRectMake(0, bounds.size.height - pfHeightInPoints, bounds.size.width, pfHeightInPoints);
        kayokoView = [[KayokoView alloc] initWithFrame:kayokoViewFrame];
        [kayokoView setAddTranslateOption:pfAddTranslateOption];
        [kayokoView setAddSongDotLinkOption:pfAddSongDotLinkOption];
        [self addSubview:kayokoView];
    }
}

#pragma mark - Notification callbacks

static void kayokod_pasteboard_changed_notification() {
    [[PasteboardManager sharedInstance] pullPasteboardChanges];
}

static void show() {
    if ([kayokoView isHidden]) {
        [kayokoView show];
    }
}

static void hide() {
    if (![kayokoView isHidden]) {
        [kayokoView hide];
    }
}

static void reload() {
    if (![kayokoView isHidden]) {
        [kayokoView reload];
    }
}

#pragma mark - Preferences

static void load_preferences(CFNotificationCenterRef center, void *observer, CFNotificationName name, const void *object, CFDictionaryRef userInfo) {
    preferences = [[HBPreferences alloc] initWithIdentifier:kPreferencesIdentifier];
    [preferences registerBool:&pfEnabled default:kPreferenceKeyEnabledDefaultValue forKey:kPreferenceKeyEnabled];
    [preferences registerUnsignedInteger:&pfMaximumHistoryAmount default:kPreferenceKeyMaximumHistoryAmountDefaultValue forKey:kPreferenceKeyMaximumHistoryAmount];
    [preferences registerBool:&pfSaveText default:kPreferenceKeySaveTextDefaultValue forKey:kPreferenceKeySaveText];
    [preferences registerBool:&pfSaveImages default:kPreferenceKeySaveImagesDefaultValue forKey:kPreferenceKeySaveImages];
    [preferences registerBool:&pfAutomaticallyPaste default:kPreferenceKeyAutomaticallyPaste forKey:kPreferenceKeyAutomaticallyPaste];
    [preferences registerBool:&pfAddSongDotLinkOption default:kPreferenceKeyAddSongDotLinkOptionDefaultValue forKey:kPreferenceKeyAddSongDotLinkOption];
    [preferences registerBool:&pfAddTranslateOption default:kPreferenceKeyAddTranslateOptionDefaultValue forKey:kPreferenceKeyAddTranslateOption];
    [preferences registerDouble:&pfHeightInPoints default:kPreferenceKeyHeightInPointsDefaultValue forKey:kPreferenceKeyHeightInPoints];

    [[PasteboardManager sharedInstance] setMaximumHistoryAmount:pfMaximumHistoryAmount];
    [[PasteboardManager sharedInstance] setSaveText:pfSaveText];
    [[PasteboardManager sharedInstance] setSaveImages:pfSaveImages];
    [[PasteboardManager sharedInstance] setAutomaticallyPaste:pfAutomaticallyPaste];

    [kayokoView setAddTranslateOption:pfAddTranslateOption];
    [kayokoView setAddSongDotLinkOption:pfAddSongDotLinkOption];

    if (name)
    {
        CGRect bounds = [[UIScreen mainScreen] bounds];
        CGRect kayokoViewFrame = CGRectMake(0, bounds.size.height - pfHeightInPoints, bounds.size.width, pfHeightInPoints);
        [kayokoView setFrame:kayokoViewFrame];
    }
}

#pragma mark - Constructor

__attribute((constructor)) static void init() {
    load_preferences(NULL, NULL, NULL, NULL, NULL);

    if (!pfEnabled) {
        return;
    }

    MSHookMessageEx(objc_getClass("UIStatusBarWindow"), @selector(initWithFrame:), (IMP)&override_UIStatusBarWindow_initWithFrame, (IMP *)&orig_UIStatusBarWindow_initWithFrame);

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)kayokod_pasteboard_changed_notification, (CFStringRef)kNotificationKeyObserverPasteboardChanged, NULL, (CFNotificationSuspensionBehavior)kNilOptions);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)show, (CFStringRef)kNotificationKeyCoreShow, NULL, (CFNotificationSuspensionBehavior)kNilOptions);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)hide, (CFStringRef)kNotificationKeyCoreHide, NULL, (CFNotificationSuspensionBehavior)kNilOptions);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reload, (CFStringRef)kNotificationKeyCoreReload, NULL, (CFNotificationSuspensionBehavior)kNilOptions);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)load_preferences, (CFStringRef)kNotificationKeyPreferencesReload, NULL, (CFNotificationSuspensionBehavior)kNilOptions);
}
