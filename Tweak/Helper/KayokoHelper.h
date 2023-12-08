//
//  KayokoHelper.h
//  Kayoko
//
//  Created by Alexandra Aurora Göttlicher
//

#import <UIKit/UIKit.h>

BOOL shouldShowCustomSuggestions = NO;
BOOL applicationIsInForeground = YES;

NSUserDefaults* preferences;
BOOL pfEnabled;
NSUInteger pfActivationMethod;
BOOL pfAutomaticallyPaste;

@interface TIKeyboardCandidate : NSObject
@end

@interface TIAutocorrectionList : NSObject
+ (TIAutocorrectionList *)listWithAutocorrection:(TIKeyboardCandidate *)arg1 predictions:(NSArray *)predictions emojiList:(NSArray *)emojiList;
@end

static TIAutocorrectionList* createAutocorrectionList();
static void paste();

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
@property(nonatomic)UIKBInputDelegateManager* inputDelegateManager;
@property(nonatomic, readonly)UIResponder <UITextInput>* inputDelegate;
+ (instancetype)activeInstance;
- (void)insertText:(NSString *)text;
@end

@interface UIKBTree : NSObject
@property(nonatomic)NSString* name;
@property(nonatomic)NSMutableDictionary* properties;
@end
