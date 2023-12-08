//
//  KayokoRootListController.h
//  Kayoko
//
//  Created by Alexandra Aurora Göttlicher
//

#import <Preferences/PSListController.h>

@interface NSConcreteNotification : NSNotification
@end

@interface PSListController (Private)
- (void)_returnKeyPressed:(NSConcreteNotification *)notification;
@end

@interface KayokoRootListController : PSListController
@end

@interface NSTask : NSObject
@property(copy)NSArray* arguments;
@property(copy)NSString* launchPath;
- (void)launch;
@end
