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

OBJC_EXTERN BOOL shouldShowCustomSuggestions;

OBJC_EXTERN HBPreferences* preferences;
OBJC_EXTERN BOOL pfEnabled;
OBJC_EXTERN NSUInteger pfActivationMethod;
OBJC_EXTERN BOOL pfAutomaticallyPaste;
OBJC_EXTERN BOOL pfDisablePasteTips;

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
