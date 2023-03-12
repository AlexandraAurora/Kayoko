//
//  KayokoHelper.m
//  Kayoko
//
//  Created by Alexandra (@Traurige)
//

#import "KayokoHelper.h"

#pragma mark - Class hooks

static void (* orig_UIKeyboardAutocorrectionController_setTextSuggestionList)(UIKeyboardAutocorrectionController* self, SEL _cmd, TIAutocorrectionList* textSuggestionList);
static void override_UIKeyboardAutocorrectionController_setTextSuggestionList(UIKeyboardAutocorrectionController* self, SEL _cmd, TIAutocorrectionList* textSuggestionList) {
    if (shouldShowCustomSuggestions) {
        TIZephyrCandidate* historyCandidate = [[objc_getClass("TIZephyrCandidate") alloc] init];
        [historyCandidate setLabel:@"History"];
        [historyCandidate setFromBundleId:@"dev.traurige.kayoko"];

        TIZephyrCandidate* copyCandidate = [[objc_getClass("TIZephyrCandidate") alloc] init];
        [copyCandidate setLabel:@"Copy"];
        [copyCandidate setFromBundleId:@"dev.traurige.kayoko"];

        TIZephyrCandidate* pasteCandidate = [[objc_getClass("TIZephyrCandidate") alloc] init];
        [pasteCandidate setLabel:@"Paste"];
        [pasteCandidate setFromBundleId:@"dev.traurige.kayoko"];

        NSArray* predictions = @[historyCandidate, copyCandidate, pasteCandidate];
        TIAutocorrectionList* list = [objc_getClass("TIAutocorrectionList") listWithAutocorrection:nil predictions:predictions emojiList:nil];
        orig_UIKeyboardAutocorrectionController_setTextSuggestionList(self, _cmd, list);
    } else {
        orig_UIKeyboardAutocorrectionController_setTextSuggestionList(self, _cmd, textSuggestionList);
    }
}

static void (* orig_UIKeyboardAutocorrectionController_setAutocorrectionList)(UIKeyboardAutocorrectionController* self, SEL _cmd, TIAutocorrectionList* textSuggestionList);
static void override_UIKeyboardAutocorrectionController_setAutocorrectionList(UIKeyboardAutocorrectionController* self, SEL _cmd, TIAutocorrectionList* textSuggestionList) {
    if (shouldShowCustomSuggestions) {
        TIZephyrCandidate* historyCandidate = [[objc_getClass("TIZephyrCandidate") alloc] init];
        [historyCandidate setLabel:@"History"];
        [historyCandidate setFromBundleId:@"dev.traurige.kayoko"];

        TIZephyrCandidate* copyCandidate = [[objc_getClass("TIZephyrCandidate") alloc] init];
        [copyCandidate setLabel:@"Copy"];
        [copyCandidate setFromBundleId:@"dev.traurige.kayoko"];

        TIZephyrCandidate* pasteCandidate = [[objc_getClass("TIZephyrCandidate") alloc] init];
        [pasteCandidate setLabel:@"Paste"];
        [pasteCandidate setFromBundleId:@"dev.traurige.kayoko"];

        NSArray* predictions = @[historyCandidate, copyCandidate, pasteCandidate];
        TIAutocorrectionList* list = [objc_getClass("TIAutocorrectionList") listWithAutocorrection:nil predictions:predictions emojiList:nil];
        orig_UIKeyboardAutocorrectionController_setAutocorrectionList(self, _cmd, list);
    } else {
        orig_UIKeyboardAutocorrectionController_setAutocorrectionList(self, _cmd, textSuggestionList);
    }
}

static void (* orig_UIPredictionViewController_predictionView_didSelectCandidate)(UIPredictionViewController* self, SEL _cmd, TUIPredictionView* predictionView, TIZephyrCandidate* candidate);
static void override_UIPredictionViewController_predictionView_didSelectCandidate(UIPredictionViewController* self, SEL _cmd, TUIPredictionView* predictionView, TIZephyrCandidate* candidate) {
    if ([candidate respondsToSelector:@selector(fromBundleId)] && [[candidate fromBundleId] isEqualToString:@"dev.traurige.kayoko"]) {
        if ([[candidate label] isEqualToString:@"History"]) {
            CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)kNotificationKeyCoreShow, nil, nil, YES);
        } else if ([[candidate label] isEqualToString:@"Copy"]) {
            if (@available(iOS 15.0, *)) {
                UIKBInputDelegateManager* delegateManager = [[objc_getClass("UIKeyboardImpl") activeInstance] inputDelegateManager];
                UITextRange* range = [delegateManager selectedTextRange];
                NSString* text = [delegateManager textInRange:range];

                if (![text isEqualToString:@""]) {
                    [[UIPasteboard generalPasteboard] setString:text];
                }
            } else {
                id delegate = [[objc_getClass("UIKeyboardImpl") activeInstance] inputDelegate];
                UITextRange* range = [delegate selectedTextRange];
                NSString* text = [delegate textInRange:range];

                if (![text isEqualToString:@""]) {
                    [[UIPasteboard generalPasteboard] setString:text];
                }
            }
        } else if ([[candidate label] isEqualToString:@"Paste"]) {
            paste();
        }
    } else {
        orig_UIPredictionViewController_predictionView_didSelectCandidate(self, _cmd, predictionView, candidate);
    }
}

static BOOL override_UIPredictionViewController_isVisibleForInputDelegate_inputViews(UIPredictionViewController* self, SEL _cmd, id delegate, id inputViews) {
    return YES;
}

static void (* orig_UIKeyboardLayoutStar_setKeyplaneName)(UIKeyboardLayoutStar* self, SEL _cmd, NSString* name);
static void override_UIKeyboardLayoutStar_setKeyplaneName(UIKeyboardLayoutStar* self, SEL _cmd, NSString* name) {
    orig_UIKeyboardLayoutStar_setKeyplaneName(self, _cmd, name);

    // the custom candidates should only be shown on the more (123) and more-alternate (#+=) keyplane
    shouldShowCustomSuggestions = [name isEqualToString:@"numbers-and-punctuation"] || [name isEqualToString:@"numbers-and-punctuation-alternate"];

    if (@available(iOS 15.0, *)) {
        [[[objc_getClass("UIKeyboardImpl") activeInstance] autocorrectionController] setAutocorrectionList:nil];
    } else {
        [[[objc_getClass("UIKeyboardImpl") activeInstance] autocorrectionController] setTextSuggestionList:nil];
    }
}

static BOOL override_UIKeyboardImpl_shouldShowDictationKey(UIKeyboardImpl* self, SEL _cmd) {
    return YES;
}

// notch devices
static void override_UISystemKeyboardDockController_dictationItemButtonWasPressed_withEvent(UISystemKeyboardDockController* self, SEL _cmd, UIEvent* event) {
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)kNotificationKeyCoreShow, nil, nil, YES);
}

// home button devices
static UIKBTree* (* orig_UIKeyboardLayoutStar_keyHitTest)(UIKeyboardLayoutStar* self, SEL _cmd, CGPoint point);
static UIKBTree* override_UIKeyboardLayoutStar_keyHitTest(UIKeyboardLayoutStar* self, SEL _cmd, CGPoint point) {
    UIKBTree* orig = orig_UIKeyboardLayoutStar_keyHitTest(self, _cmd, point);

    if ([[orig name] isEqualToString:@"Dictation-Key"]) {
        [[orig properties] setValue:@(0) forKey:@"KBinteractionType"];
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)kNotificationKeyCoreShow, nil, nil, YES);
    }

    return orig;
}

static void (* orig_UIKeyboardLayoutStar_didMoveToWindow)(UIKeyboardLayoutStar* self, SEL _cmd);
static void override_UIKeyboardLayoutStar_didMoveToWindow(UIKeyboardLayoutStar* self, SEL _cmd) {
    orig_UIKeyboardLayoutStar_didMoveToWindow(self, _cmd);
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)kNotificationKeyCoreHide, nil, nil, YES);
}

static id (* orig_UIKeyboardDockItem_initWithImageName_identifier)(id self, SEL _cmd, NSString* imageName, NSString* identifier);
static id override_UIKeyboardDockItem_initWithImageName_identifier(id self, SEL _cmd, NSString* imageName, NSString* identifier) {
    if ([imageName isEqualToString:@"mic"])
        return orig_UIKeyboardDockItem_initWithImageName_identifier(self, _cmd, @"doc.on.clipboard", identifier);
    else if ([imageName isEqualToString:@"mic.fill"])
        return orig_UIKeyboardDockItem_initWithImageName_identifier(self, _cmd, @"doc.on.clipboard.fill", identifier);
    return orig_UIKeyboardDockItem_initWithImageName_identifier(self, _cmd, imageName, identifier);
}

static void (* orig_UIKeyboardDockItem_setImageName)(id self, SEL _cmd, NSString* imageName);
static void override_UIKeyboardDockItem_setImageName(id self, SEL _cmd, NSString* imageName) {
    if ([imageName isEqualToString:@"mic"])
        return orig_UIKeyboardDockItem_setImageName(self, _cmd, @"doc.on.clipboard");
    else if ([imageName isEqualToString:@"mic.fill"])
        return orig_UIKeyboardDockItem_setImageName(self, _cmd, @"doc.on.clipboard.fill");
    return orig_UIKeyboardDockItem_setImageName(self, _cmd, imageName);
}

static CGRect (* orig_UIKeyboardDockItemButton_imageRectForContentRect)(id self, SEL _cmd, CGRect contentRect);
static CGRect override_UIKeyboardDockItemButton_imageRectForContentRect(id self, SEL _cmd, CGRect contentRect) {
    CGRect origRect = orig_UIKeyboardDockItemButton_imageRectForContentRect(self, _cmd, contentRect);
    if (ABS(origRect.size.width - origRect.size.height) > 1.0) {
        // adjust image to its 83% but keep its center
        CGSize newSize = CGSizeMake(origRect.size.width * 0.833, origRect.size.height * 0.833);
        CGPoint newOrigin = CGPointMake(origRect.origin.x + (origRect.size.width - newSize.width) / 2, origRect.origin.y + (origRect.size.height - newSize.height) / 2);
        return CGRectMake(newOrigin.x, newOrigin.y, newSize.width, newSize.height);
    }
    return origRect;
}

#pragma mark - Notification callbacks

static void (* orig_UIKeyboardImpl_applicationDidBecomeActive)(id self, SEL _cmd, id arg1);
static void override_UIKeyboardImpl_applicationDidBecomeActive(id self, SEL _cmd, id arg1) {
    applicationIsInForeground = YES;
    orig_UIKeyboardImpl_applicationDidBecomeActive(self, _cmd, arg1);
}

static void (* orig_UIKeyboardImpl_applicationWillResignActive)(id self, SEL _cmd, id arg1);
static void override_UIKeyboardImpl_applicationWillResignActive(id self, SEL _cmd, id arg1) {
    applicationIsInForeground = NO;
    orig_UIKeyboardImpl_applicationWillResignActive(self, _cmd, arg1);
}

static void paste() {
    if (!applicationIsInForeground) return;
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    if ([pasteboard hasStrings]) {
        NSString *pbs = [pasteboard string];
        UIKeyboardImpl *kb = [objc_getClass("UIKeyboardImpl") activeInstance];
        if (@available(iOS 15.0, *)) {
            UIKBInputDelegateManager* delegateManager = [kb inputDelegateManager];
            [delegateManager insertText:pbs];
            if ([delegateManager respondsToSelector:@selector(clearForwardingInputDelegateAndResign:)])
                [delegateManager clearForwardingInputDelegateAndResign:YES];
            [kb updateReturnKey];
        } else {
            [kb insertText:pbs];
            if ([kb respondsToSelector:@selector(clearForwardingInputDelegateAndResign:)])
                [kb clearForwardingInputDelegateAndResign:YES];
            [kb updateReturnKey];
        }
    }
}

#pragma mark - Druid UI

static void (* orig_DRPasteAnnouncer_announceDeniedPaste)(id self, SEL _cmd);
static void override_DRPasteAnnouncer_announceDeniedPaste(id self, SEL _cmd) {
    if (pfDisablePasteTips) return;
    orig_DRPasteAnnouncer_announceDeniedPaste(self, _cmd);
}

static void (* orig_DRPasteAnnouncer_announcePaste)(id self, SEL _cmd, id arg1);
static void override_DRPasteAnnouncer_announcePaste(id self, SEL _cmd, id arg1) {
    if (pfDisablePasteTips) return;
    orig_DRPasteAnnouncer_announcePaste(self, _cmd, arg1);
}

#pragma mark - Preferences

static void load_preferences() {
    preferences = [[HBPreferences alloc] initWithIdentifier:kPreferencesIdentifier];
    [preferences registerBool:&pfEnabled default:kPreferenceKeyEnabledDefaultValue forKey:kPreferenceKeyEnabled];
    [preferences registerUnsignedInteger:&pfActivationMethod default:kPreferenceKeyActivationMethodDefaultValue forKey:kPreferenceKeyActivationMethod];
    [preferences registerBool:&pfAutomaticallyPaste default:kPreferenceKeyAutomaticallyPasteDefaultValue forKey:kPreferenceKeyAutomaticallyPaste];
    [preferences registerBool:&pfDisablePasteTips default:kPreferenceKeyDisablePasteTipsDefaultValue forKey:kPreferenceKeyDisablePasteTips];
}

#pragma mark - Constructor

__attribute((constructor)) static void init() {
    load_preferences();

    if (!pfEnabled) {
        return;
    }

    if (![NSProcessInfo processInfo]) {
        return;
    }

    NSArray* args = [[NSProcessInfo processInfo] arguments];
    NSString* processName = [[NSProcessInfo processInfo] processName];
    NSString* executablePath = [args firstObject];

    BOOL isDruid = [executablePath hasPrefix:@"/System/Library/"] && [processName isEqualToString:@"druid"];
    if (isDruid) {
        MSHookMessageEx(objc_getClass("DRPasteAnnouncer"), @selector(announceDeniedPaste), (IMP)&override_DRPasteAnnouncer_announceDeniedPaste, (IMP*)&orig_DRPasteAnnouncer_announceDeniedPaste);
        MSHookMessageEx(objc_getClass("DRPasteAnnouncer"), @selector(announcePaste:), (IMP)&override_DRPasteAnnouncer_announcePaste, (IMP*)&orig_DRPasteAnnouncer_announcePaste);
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)load_preferences, (CFStringRef)kNotificationKeyPreferencesReload, NULL, (CFNotificationSuspensionBehavior)kNilOptions);
        return;
    }

    BOOL isSpringBoard = [executablePath hasPrefix:@"/System/Library/"] && [@"SpringBoard" isEqualToString:processName];

    BOOL shouldLoad = NO;
    NSUInteger count = [args count];
    if (count != 0) {
        NSString* executablePath = args[0];
        if (executablePath) {
            NSString* processName = [executablePath lastPathComponent];
            BOOL isApplication = [executablePath rangeOfString:@"/Application/"].location != NSNotFound || [executablePath rangeOfString:@"/Applications/"].location != NSNotFound;
            BOOL isFileProvider = [[processName lowercaseString] rangeOfString:@"fileprovider"].location != NSNotFound;
            BOOL skip = [processName isEqualToString:@"AdSheet"] ||
                        [processName isEqualToString:@"CoreAuthUI"] ||
                        [processName isEqualToString:@"InCallService"] ||
                        [processName isEqualToString:@"MessagesNotificationViewService"] ||
                        [executablePath rangeOfString:@".appex/"].location != NSNotFound;
            if ((!isFileProvider && isApplication && !skip) || isSpringBoard) {
                shouldLoad = YES;
            }
        }
    }

	if (!shouldLoad) {
        return;
    }

    if (pfActivationMethod == kActivationMethodPredictionBar) {
        if (@available(iOS 15.0, *)) {
            MSHookMessageEx(objc_getClass("UIKeyboardAutocorrectionController"), @selector(setAutocorrectionList:), (IMP)&override_UIKeyboardAutocorrectionController_setAutocorrectionList, (IMP *)&orig_UIKeyboardAutocorrectionController_setAutocorrectionList);
        } else {
            MSHookMessageEx(objc_getClass("UIKeyboardAutocorrectionController"), @selector(setTextSuggestionList:), (IMP)&override_UIKeyboardAutocorrectionController_setTextSuggestionList, (IMP *)&orig_UIKeyboardAutocorrectionController_setTextSuggestionList);
        }
        MSHookMessageEx(objc_getClass("UIPredictionViewController"), @selector(isVisibleForInputDelegate:inputViews:), (IMP)&override_UIPredictionViewController_isVisibleForInputDelegate_inputViews, (IMP *)nil);
        MSHookMessageEx(objc_getClass("UIKeyboardLayoutStar"), @selector(setKeyplaneName:), (IMP)&override_UIKeyboardLayoutStar_setKeyplaneName, (IMP *)&orig_UIKeyboardLayoutStar_setKeyplaneName);
        MSHookMessageEx(objc_getClass("UIPredictionViewController"), @selector(predictionView:didSelectCandidate:), (IMP)&override_UIPredictionViewController_predictionView_didSelectCandidate, (IMP *)&orig_UIPredictionViewController_predictionView_didSelectCandidate);
    } else if (pfActivationMethod == kActivationMethodDictationKey) {
        MSHookMessageEx(objc_getClass("UISystemKeyboardDockController"), @selector(dictationItemButtonWasPressed:withEvent:), (IMP)&override_UISystemKeyboardDockController_dictationItemButtonWasPressed_withEvent, nil);
        MSHookMessageEx(objc_getClass("UIKeyboardImpl"), @selector(shouldShowDictationKey), (IMP)&override_UIKeyboardImpl_shouldShowDictationKey, nil);
        MSHookMessageEx(objc_getClass("UIKeyboardLayoutStar"), @selector(keyHitTest:), (IMP)&override_UIKeyboardLayoutStar_keyHitTest, (IMP *)&orig_UIKeyboardLayoutStar_keyHitTest);
        if (@available(iOS 15.0, *)) {
            MSHookMessageEx(objc_getClass("UIKeyboardDockItem"), @selector(initWithImageName:identifier:), (IMP)&override_UIKeyboardDockItem_initWithImageName_identifier, (IMP *)&orig_UIKeyboardDockItem_initWithImageName_identifier);
            MSHookMessageEx(objc_getClass("UIKeyboardDockItem"), @selector(setImageName:), (IMP)&override_UIKeyboardDockItem_setImageName, (IMP *)&orig_UIKeyboardDockItem_setImageName);
            MSHookMessageEx(objc_getClass("UIKeyboardDockItemButton"), @selector(imageRectForContentRect:), (IMP)&override_UIKeyboardDockItemButton_imageRectForContentRect, (IMP *)&orig_UIKeyboardDockItemButton_imageRectForContentRect);
        }
    }
    MSHookMessageEx(objc_getClass("UIKeyboardLayoutStar"), @selector(didMoveToWindow), (IMP)&override_UIKeyboardLayoutStar_didMoveToWindow, (IMP *)&orig_UIKeyboardLayoutStar_didMoveToWindow);
    MSHookMessageEx(objc_getClass("UIKeyboardImpl"), @selector(applicationDidBecomeActive:), (IMP)&override_UIKeyboardImpl_applicationDidBecomeActive, (IMP *)&orig_UIKeyboardImpl_applicationDidBecomeActive);
    MSHookMessageEx(objc_getClass("UIKeyboardImpl"), @selector(applicationWillResignActive:), (IMP)&override_UIKeyboardImpl_applicationWillResignActive, (IMP *)&orig_UIKeyboardImpl_applicationWillResignActive);

    if (pfAutomaticallyPaste) {
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)paste, (CFStringRef)kNotificationKeyHelperPaste, NULL, (CFNotificationSuspensionBehavior)CFNotificationSuspensionBehaviorDrop);
    }
}
