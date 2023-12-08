//
//  KayokoDaemon.m
//  Kayoko
//
//  Created by Alexandra Aurora Göttlicher
//

#import "KayokoDaemon.h"
#import "../Preferences/NotificationKeys.h"
#import <notify.h>

@implementation KayokoDaemon
/**
 * Notifies the core about pasteboard changes.
 */
- (instancetype)init {
	self = [super init];

	if (self) {
		notify_register_dispatch("com.apple.pasteboard.notify.changed", &(_token), dispatch_get_main_queue(), ^(int _) {
			CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)kNotificationKeyObserverPasteboardChanged, nil, nil, YES);
		});
	}

	return self;
}

/**
 * Deallocates the daemon.
 */
- (void)dealloc {
	notify_cancel(_token);
	[super dealloc];
}
@end

/**
 * Starts the daemon.
 */
int main(int argc, char** argv, char** envp) {
	[[KayokoDaemon alloc] init];
	[[NSRunLoop currentRunLoop] run];

	return 0;
}
