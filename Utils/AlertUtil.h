//
//  AlertUtil.h
//  Kayoko
//
//  Created by Alexandra Aurora Göttlicher
//

#import <Foundation/Foundation.h>

@interface AlertUtil : NSObject
+ (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message withDismissButtonTitle:(NSString *)dismissButtonTitle;
@end
