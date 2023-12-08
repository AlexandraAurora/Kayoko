//
//  KayokoRootListController.m
//  Kayoko
//
//  Created by Alexandra Aurora Göttlicher
//

#include "KayokoRootListController.h"
#import <rootless.h>
#import <Preferences/PSSpecifier.h>
#import "../../Manager/PasteboardManager.h"
#import "../PreferenceKeys.h"
#import "../NotificationKeys.h"

@implementation KayokoRootListController
/**
 * Loads the root specifiers.
 *
 * @return The specifiers.
 */
- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

/**
 * Handles preference changes.
 *
 * @param value The new value for the changed option.
 * @param specifier The specifier that was interacted with.
 */
- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    [super setPreferenceValue:value specifier:specifier];

    // Prompt to respring for options that require one to apply changes.
    if ([[specifier propertyForKey:@"key"] isEqualToString:kPreferenceKeyEnabled] ||
		[[specifier propertyForKey:@"key"] isEqualToString:kPreferenceKeyActivationMethod] ||
		[[specifier propertyForKey:@"key"] isEqualToString:kPreferenceKeyAutomaticallyPaste]
	) {
		[self promptToRespring];
    }
}

/**
 * Hides the keyboard when the "Return" key is pressed on focused text fields.
 *
 * @param notification The event notification.
 */
- (void)_returnKeyPressed:(NSConcreteNotification *)notification {
    [[self view] endEditing:YES];
    [super _returnKeyPressed:notification];
}

/**
 * Prompts the user to respring to apply changes.
 */
- (void)promptToRespring {
    UIAlertController* resetAlert = [UIAlertController alertControllerWithTitle:@"Kayoko" message:@"This option requires a respring to apply. Do you want to respring now?" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        [self respring];
	}];

	UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];

	[resetAlert addAction:yesAction];
	[resetAlert addAction:noAction];

	[self presentViewController:resetAlert animated:YES completion:nil];
}

/**
 * Resprings the device.
 */
- (void)respring {
	NSTask* task = [[NSTask alloc] init];
	[task setLaunchPath:ROOT_PATH_NS(@"/usr/bin/killall")];
	[task setArguments:@[@"backboardd"]];
	[task launch];
}

/**
 * Prompts the user to reset their preferences.
 */
- (void)resetPrompt {
    UIAlertController* resetAlert = [UIAlertController alertControllerWithTitle:@"Kayoko" message:@"Are you sure you want to reset your preferences?" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        [self resetPreferences];
	}];

	UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];

	[resetAlert addAction:yesAction];
	[resetAlert addAction:noAction];

	[self presentViewController:resetAlert animated:YES completion:nil];
}

/**
 * Resets the preferences.
 */
- (void)resetPreferences {
	NSUserDefaults* userDefaults = [[NSUserDefaults alloc] initWithSuiteName:kPreferencesIdentifier];
	for (NSString* key in [userDefaults dictionaryRepresentation]) {
		[userDefaults removeObjectForKey:key];
	}

	[self reloadSpecifiers];
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)kNotificationKeyPreferencesReload, nil, nil, YES);
}
@end
