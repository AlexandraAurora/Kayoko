//
//  KayokoHelper.h
//  Kayoko
//
//  Created by Alexandra (@Traurige)
//

#import "substrate.h"
#import <UIKit/UIKit.h>
#import "../../Preferences/NotificationKeys.h"
#import "../../Preferences/PreferenceKeys.h"
#import <Cephei/HBPreferences.h>

BOOL shouldShowCustomSuggestions = NO;
BOOL applicationIsInForeground = YES;

HBPreferences* preferences;
BOOL pfEnabled;
NSUInteger pfActivationMethod;
BOOL pfAutomaticallyPaste;
BOOL pfDisablePasteTips;

static void paste();

@interface TIKeyboardCandidate : NSObject
@end

@interface TIAutocorrectionList : NSObject
+ (TIAutocorrectionList *)listWithAutocorrection:(TIKeyboardCandidate *)arg1 predictions:(NSArray *)predictions emojiList:(NSArray *)emojiList;
@end

@interface UIKeyboardAutocorrectionController : NSObject
- (void)setTextSuggestionList:(TIAutocorrectionList *)textSuggestionList;
- (void)setAutocorrectionList:(TIAutocorrectionList *)textSuggestionList;
@end

@interface TUIPredictionView : UIView
@end

@interface TIKeyboardCandidateSingle : TIKeyboardCandidate
@end

@interface TIZephyrCandidate : TIKeyboardCandidateSingle
@property(nonatomic, copy)NSString* label;
@property(nonatomic, copy)NSString* fromBundleId;
@end

@interface UIPredictionViewController : UIViewController
@end

@interface UIKeyboardLayout : UIView
@end

@interface UIKeyboardLayoutStar : UIKeyboardLayout
@end

@interface UISystemKeyboardDockController : NSObject
@end

@interface UIKBInputDelegateManager : NSObject
- (UITextRange *)selectedTextRange;
- (NSString *)textInRange:(UITextRange *)range;
- (void)insertText:(NSString *)text;
@end

@interface UIKeyboardImpl : UIView
@property(nonatomic, readonly)UIKeyboardAutocorrectionController* autocorrectionController;
@property(nonatomic, retain)UIKBInputDelegateManager* inputDelegateManager;
@property(nonatomic, readonly)UIResponder <UITextInput>* inputDelegate;
+ (instancetype)activeInstance;
- (void)insertText:(NSString *)text;
@end

@interface UIKBTree : NSObject
@property(nonatomic, retain)NSString* name;
@property(nonatomic, retain)NSMutableDictionary* properties;
@end

@interface UIKeyboardTaskQueue : NSObject
- (void)addTask:(id)arg1;
- (void)performSingleTask:(id)arg1;
@end

@interface UIKBInputDelegateManager (Private)  // iOS 15
- (void)insertText:(id)arg1 updateInputSource:(BOOL)arg2;
- (void)clearForwardingInputDelegateAndResign:(BOOL)arg1;
@end

@interface UIKeyboardImpl (Private)
- (void)addInputString:(NSString *)arg1 withFlags:(unsigned long long)arg2 executionContext:(id)arg3;
- (void)completeAddInputString:(NSString *)arg1;
- (void)completeAddInputString:(NSString *)arg1 generateCandidates:(BOOL)arg2;
- (void)clearForwardingInputDelegateAndResign:(BOOL)arg1;
- (void)updateReturnKey;
- (UIKBInputDelegateManager *)inputDelegateManager;
- (UIKeyboardTaskQueue *)taskQueue;
@end
