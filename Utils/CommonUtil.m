#import "CommonUtil.h"

@implementation CommonUtil
+ (NSString *)randomStringWithLength:(NSUInteger)length {
    NSString* characters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString* string = [NSMutableString stringWithCapacity:length];

    for (NSUInteger i = 0; i < length; i++) {
        [string appendFormat: @"%c", [characters characterAtIndex: arc4random_uniform([characters length])]];
    }

    return string;
}

+ (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message withDismissButtonTitle:(NSString *)dismissButtonTitle {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:title forKey:(__bridge NSString *)kCFUserNotificationAlertHeaderKey];
        [dictionary setObject:message forKey:(__bridge NSString *)kCFUserNotificationAlertMessageKey];
        [dictionary setObject:dismissButtonTitle forKey:(__bridge NSString *)kCFUserNotificationDefaultButtonTitleKey];

        CFUserNotificationRef alert = CFUserNotificationCreate(NULL, 0, kCFUserNotificationPlainAlertLevel, nil, (__bridge CFDictionaryRef)dictionary);
        CFRelease(alert);
    });
}
@end
