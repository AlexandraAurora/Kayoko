//
//  KayokoCore.m
//  Kayoko
//
//  Created by Alexandra (@Traurige)
//

#import "KayokoCore.h"

#pragma mark - Class hooks

// UIStatusBarWindow is sick because it's present everywhere and doesn't need uikit injection
// it also prevents sandbox issues as the core runs on springboard (which has fs r/w)
void (* orig_UIStatusBarWindow_initWithFrame)(UIStatusBarWindow* self, SEL _cmd, CGRect frame);
void override_UIStatusBarWindow_initWithFrame(UIStatusBarWindow* self, SEL _cmd, CGRect frame) {
    orig_UIStatusBarWindow_initWithFrame(self, _cmd, frame);

    if (!kayokoView) {
        CGRect bounds = [[UIScreen mainScreen] bounds];
        kayokoView = [[KayokoView alloc] initWithFrame:CGRectMake(0, bounds.size.height - kHeight, bounds.size.width, kHeight)];
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

static void load_preferences() {
    preferences = [[HBPreferences alloc] initWithIdentifier:@"dev.traurige.kayoko.preferences"];
    [preferences registerBool:&pfEnabled default:kPreferenceKeyEnabledDefaultValue forKey:kPreferenceKeyEnabled];
    [preferences registerUnsignedInteger:&pfMaximumHistoryAmount default:kPreferenceKeyMaximumHistoryAmountDefaultValue forKey:kPreferenceKeyMaximumHistoryAmount];
    [preferences registerBool:&pfSaveText default:kPreferenceKeySaveTextDefaultValue forKey:kPreferenceKeySaveText];
    [preferences registerBool:&pfSaveImages default:kPreferenceKeySaveImagesDefaultValue forKey:kPreferenceKeySaveImages];
    [preferences registerBool:&pfAutomaticallyPaste default:kPreferenceKeyAutomaticallyPaste forKey:kPreferenceKeyAutomaticallyPaste];
    [preferences registerBool:&pfAddSongDotLinkOption default:kPreferenceKeyAddSongDotLinkOptionDefaultValue forKey:kPreferenceKeyAddSongDotLinkOption];
    [preferences registerBool:&pfAddTranslateOption default:kPreferenceKeyAddTranslateOptionDefaultValue forKey:kPreferenceKeyAddTranslateOption];

    [[PasteboardManager sharedInstance] setMaximumHistoryAmount:pfMaximumHistoryAmount];
    [[PasteboardManager sharedInstance] setSaveText:pfSaveText];
    [[PasteboardManager sharedInstance] setSaveImages:pfSaveImages];
    [[PasteboardManager sharedInstance] setAutomaticallyPaste:pfAutomaticallyPaste];

    [kayokoView setAddTranslateOption:pfAddTranslateOption];
    [kayokoView setAddSongDotLinkOption:pfAddSongDotLinkOption];
}

#pragma mark - Constructor

__attribute((constructor)) static void initialize() {
    load_preferences();

    if (!pfEnabled) {
        return;
    }

    MSHookMessageEx(NSClassFromString(@"UIStatusBarWindow"), @selector(initWithFrame:), (IMP)&override_UIStatusBarWindow_initWithFrame, (IMP *)&orig_UIStatusBarWindow_initWithFrame);

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)kayokod_pasteboard_changed_notification, (CFStringRef)@"dev.traurige.kayoko.daemon.pasteboard.changed", NULL, (CFNotificationSuspensionBehavior)kNilOptions);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)show, (CFStringRef)@"dev.traurige.kayoko.core.show", NULL, (CFNotificationSuspensionBehavior)kNilOptions);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)hide, (CFStringRef)@"dev.traurige.kayoko.core.hide", NULL, (CFNotificationSuspensionBehavior)kNilOptions);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reload, (CFStringRef)@"dev.traurige.kayoko.core.reload", NULL, (CFNotificationSuspensionBehavior)kNilOptions);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)load_preferences, (CFStringRef)@"dev.traurige.kayoko.preferences.reload", NULL, (CFNotificationSuspensionBehavior)kNilOptions);
}
