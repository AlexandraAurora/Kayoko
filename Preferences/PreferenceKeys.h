//
//  PreferenceKeys.h
//  Kayoko
//
//  Created by Alexandra Aurora Göttlicher
//

static NSString* const kPreferencesIdentifier = @"codes.aurora.kayoko.preferences";

static NSString* const kPreferenceKeyEnabled = @"Enabled";
static NSString* const kPreferenceKeyMaximumHistoryAmount = @"MaximumHistoryAmount";
static NSString* const kPreferenceKeySaveText = @"SaveText";
static NSString* const kPreferenceKeySaveImages = @"SaveImages";
static NSString* const kPreferenceKeyActivationMethod = @"ActivationMethod";
static NSString* const kPreferenceKeyAutomaticallyPaste = @"AutomaticallyPaste";

static NSUInteger const kActivationMethodPredictionBar = 0;
static NSUInteger const kActivationMethodDictationKey = 1;

static BOOL const kPreferenceKeyEnabledDefaultValue = YES;
static NSUInteger const kPreferenceKeyMaximumHistoryAmountDefaultValue = 200;
static BOOL const kPreferenceKeySaveTextDefaultValue = YES;
static BOOL const kPreferenceKeySaveImagesDefaultValue = YES;
static NSUInteger const kPreferenceKeyActivationMethodDefaultValue = kActivationMethodPredictionBar;
static BOOL const kPreferenceKeyAutomaticallyPasteDefaultValue = YES;
