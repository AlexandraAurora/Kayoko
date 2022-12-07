//
//  KayokoHelper.m
//  Kayoko
//
//  Created by Alexandra (@Traurige)
//

#import "KayokoHelper.h"

#pragma mark - Class hooks

void (* orig_UIKeyboardAutocorrectionController_setTextSuggestionList)(UIKeyboardAutocorrectionController* self, SEL _cmd, TIAutocorrectionList* textSuggestionList);
void override_UIKeyboardAutocorrectionController_setTextSuggestionList(UIKeyboardAutocorrectionController* self, SEL _cmd, TIAutocorrectionList* textSuggestionList) {
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

void (* orig_UIKeyboardAutocorrectionController_setAutocorrectionList)(UIKeyboardAutocorrectionController* self, SEL _cmd, TIAutocorrectionList* textSuggestionList);
void override_UIKeyboardAutocorrectionController_setAutocorrectionList(UIKeyboardAutocorrectionController* self, SEL _cmd, TIAutocorrectionList* textSuggestionList) {
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

void (* orig_UIPredictionViewController_predictionView_didSelectCandidate)(UIPredictionViewController* self, SEL _cmd, TUIPredictionView* predictionView, TIZephyrCandidate* candidate);
void override_UIPredictionViewController_predictionView_didSelectCandidate(UIPredictionViewController* self, SEL _cmd, TUIPredictionView* predictionView, TIZephyrCandidate* candidate) {
    if ([candidate respondsToSelector:@selector(fromBundleId)] && [[candidate fromBundleId] isEqualToString:@"dev.traurige.kayoko"]) {
        if ([[candidate label] isEqualToString:@"History"]) {
            CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"dev.traurige.kayoko.core.show", nil, nil, YES);
        } else if ([[candidate label] isEqualToString:@"Copy"]) {
            if (iOS15) {
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

BOOL override_UIPredictionViewController_isVisibleForInputDelegate_inputViews(UIPredictionViewController* self, SEL _cmd, id delegate, id inputViews) {
    return YES;
}

void (* orig_UIKeyboardLayoutStar_setKeyplaneName)(UIKeyboardLayoutStar* self, SEL _cmd, NSString* name);
void override_UIKeyboardLayoutStar_setKeyplaneName(UIKeyboardLayoutStar* self, SEL _cmd, NSString* name) {
    orig_UIKeyboardLayoutStar_setKeyplaneName(self, _cmd, name);

    // the custom candidates should only be shown on the more (123) and more-alternate (#+=) keyplane
    shouldShowCustomSuggestions = [name isEqualToString:@"numbers-and-punctuation"] || [name isEqualToString:@"numbers-and-punctuation-alternate"];

    if (iOS15) {
        [[[objc_getClass("UIKeyboardImpl") activeInstance] autocorrectionController] setAutocorrectionList:nil];
    } else {
        [[[objc_getClass("UIKeyboardImpl") activeInstance] autocorrectionController] setTextSuggestionList:nil];
    }
}

BOOL override_UIKeyboardImpl_shouldShowDictationKey(UIKeyboardImpl* self, SEL _cmd) {
    return YES;
}

// notch devices
void override_UISystemKeyboardDockController_dictationItemButtonWasPressed_withEvent(UISystemKeyboardDockController* self, SEL _cmd, UIEvent* event) {
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"dev.traurige.kayoko.core.show", nil, nil, YES);
}

// home button devices
UIKBTree* (* orig_UIKeyboardLayoutStar_keyHitTest)(UIKeyboardLayoutStar* self, SEL _cmd, CGPoint point);
UIKBTree* override_UIKeyboardLayoutStar_keyHitTest(UIKeyboardLayoutStar* self, SEL _cmd, CGPoint point) {
    UIKBTree* orig = orig_UIKeyboardLayoutStar_keyHitTest(self, _cmd, point);

    if ([[orig name] isEqualToString:@"Dictation-Key"]) {
        [[orig properties] setValue:@(0) forKey:@"KBinteractionType"];
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"dev.traurige.kayoko.core.show", nil, nil, YES);
    }

    return orig;
}

void (* orig_UIKeyboardLayoutStar_didMoveToWindow)(UIKeyboardLayoutStar* self, SEL _cmd);
void override_UIKeyboardLayoutStar_didMoveToWindow(UIKeyboardLayoutStar* self, SEL _cmd) {
    orig_UIKeyboardLayoutStar_didMoveToWindow(self, _cmd);
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"dev.traurige.kayoko.core.hide", nil, nil, YES);
}

#pragma mark - Notification callbacks

static void paste() {
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    if ([pasteboard hasStrings]) {
        if (iOS15) {
            UIKBInputDelegateManager* delegateManager = [[objc_getClass("UIKeyboardImpl") activeInstance] inputDelegateManager];
            [delegateManager insertText:[pasteboard string]];
        } else {
            [[objc_getClass("UIKeyboardImpl") activeInstance] insertText:[pasteboard string]];
        }
    }
}

#pragma mark - Preferences

static void load_preferences() {
    preferences = [[HBPreferences alloc] initWithIdentifier:@"dev.traurige.kayoko.preferences"];
    [preferences registerBool:&pfEnabled default:kPreferenceKeyEnabledDefaultValue forKey:kPreferenceKeyEnabled];
    [preferences registerUnsignedInteger:&pfActivationMethod default:kPreferenceKeyActivationMethodDefaultValue forKey:kPreferenceKeyActivationMethod];
    [preferences registerBool:&pfAutomaticallyPaste default:kPreferenceKeyAutomaticallyPasteDefaultValue forKey:kPreferenceKeyAutomaticallyPaste];
}

#pragma mark - Constructor

__attribute((constructor)) static void initialize() {
    load_preferences();

    if (!pfEnabled) {
        return;
    }

    if (![NSProcessInfo processInfo]) {
        return;
    }

    NSString* processName = [[NSProcessInfo processInfo] processName];
    BOOL isSpringBoard = [@"SpringBoard" isEqualToString:processName];

    BOOL shouldLoad = NO;
    NSArray* args = [[NSClassFromString(@"NSProcessInfo") processInfo] arguments];
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
        if (iOS15) {
            MSHookMessageEx(NSClassFromString(@"UIKeyboardAutocorrectionController"), @selector(setAutocorrectionList:), (IMP)&override_UIKeyboardAutocorrectionController_setAutocorrectionList, (IMP *)&orig_UIKeyboardAutocorrectionController_setAutocorrectionList);
        } else {
            MSHookMessageEx(NSClassFromString(@"UIKeyboardAutocorrectionController"), @selector(setTextSuggestionList:), (IMP)&override_UIKeyboardAutocorrectionController_setTextSuggestionList, (IMP *)&orig_UIKeyboardAutocorrectionController_setTextSuggestionList);
        }
        MSHookMessageEx(NSClassFromString(@"UIPredictionViewController"), @selector(isVisibleForInputDelegate:inputViews:), (IMP)&override_UIPredictionViewController_isVisibleForInputDelegate_inputViews, (IMP *)nil);
        MSHookMessageEx(NSClassFromString(@"UIKeyboardLayoutStar"), @selector(setKeyplaneName:), (IMP)&override_UIKeyboardLayoutStar_setKeyplaneName, (IMP *)&orig_UIKeyboardLayoutStar_setKeyplaneName);
        MSHookMessageEx(NSClassFromString(@"UIPredictionViewController"), @selector(predictionView:didSelectCandidate:), (IMP)&override_UIPredictionViewController_predictionView_didSelectCandidate, (IMP *)&orig_UIPredictionViewController_predictionView_didSelectCandidate);
    } else if (pfActivationMethod == kActivationMethodDictationKey) {
        MSHookMessageEx(NSClassFromString(@"UISystemKeyboardDockController"), @selector(dictationItemButtonWasPressed:withEvent:), (IMP)&override_UISystemKeyboardDockController_dictationItemButtonWasPressed_withEvent, nil);
        MSHookMessageEx(NSClassFromString(@"UIKeyboardImpl"), @selector(shouldShowDictationKey), (IMP)&override_UIKeyboardImpl_shouldShowDictationKey, nil);
        MSHookMessageEx(NSClassFromString(@"UIKeyboardLayoutStar"), @selector(keyHitTest:), (IMP)&override_UIKeyboardLayoutStar_keyHitTest, (IMP *)&orig_UIKeyboardLayoutStar_keyHitTest);
    }
    MSHookMessageEx(NSClassFromString(@"UIKeyboardLayoutStar"), @selector(didMoveToWindow), (IMP)&override_UIKeyboardLayoutStar_didMoveToWindow, (IMP *)&orig_UIKeyboardLayoutStar_didMoveToWindow);

    if (pfAutomaticallyPaste) {
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)paste, (CFStringRef)@"dev.traurige.kayoko.helper.paste", NULL, (CFNotificationSuspensionBehavior)kNilOptions);
    }
}
