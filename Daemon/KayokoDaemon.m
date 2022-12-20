//
//  KayokoDaemon.m
//  Kayoko
//
//  Created by Alexandra (@Traurige)
//

#import "KayokoDaemon.h"

@implementation KayokoDaemon
- (instancetype)init {
	self = [super init];

	if (self) {
		notify_register_dispatch("com.apple.pasteboard.notify.changed", &(_token), dispatch_get_main_queue(), ^(int _) {
			CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)kNotificationKeyObserverPasteboardChanged, nil, nil, YES);
		});
	}

	return self;
}

- (void)dealloc {
	notify_cancel(_token);
	[super dealloc];
}
@end

int main(int argc, char** argv, char** envp) {
	[[KayokoDaemon alloc] init];
	[[NSRunLoop currentRunLoop] run];

	return 0;
}
