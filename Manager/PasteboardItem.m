#import "PasteboardItem.h"

@implementation PasteboardItem
- (instancetype)initWithBundleIdentifier:(NSString *)bundleIdentifier andContent:(NSString *)content withImageNamed:(NSString *)imageName {
    self = [super init];

    if (self) {
        [self setBundleIdentifier:bundleIdentifier];
        [self setContent:content];
        [self setImageName:imageName];
        [self setHasLink:[content hasPrefix:@"http://"] || [content hasPrefix:@"https://"]];
        [self setHasMusicLink:[self contentHasMusicLink:content]];
        [self setHasColor:![self hasLink] && ![self hasMusicLink] && [self contentHasColor:content]];
        [self setHasImage:imageName && ![imageName isEqualToString:@""]];
        [self setHasPlainText:![self hasLink] && ![self hasMusicLink] && ![self hasColor] && ![self hasImage]];
    }

    return self;
}

+ (PasteboardItem *)itemFromDictionary:(NSDictionary *)dictionary {
    return [[PasteboardItem alloc] initWithBundleIdentifier:dictionary[@"bundleIdentifier"] andContent:dictionary[@"content"] withImageNamed:dictionary[@"imageName"]];
}

- (BOOL)contentHasMusicLink:(NSString *)content {
    NSArray* linkPrefixes = @[
        @"https://music.apple.com/",
        @"https://open.spotify.com/",
        @"https://music.youtube.com/",
        @"https://soundcloud.com/",
        @"https://music.amazon.com/",
        @"https://www.pandora.com/",
        @"https://www.deezer.com/",
        @"https://napster.com/",
        @"https://listen.tidal.com/",
        @"https://music.yandex.ru/"
    ];

    for (NSString* prefix in linkPrefixes) {
        if ([content hasPrefix:prefix]) {
            return YES;
        }
    }

    return NO;
}

- (BOOL)contentHasColor:(NSString *)content {
    NSString* hexRegex = @"^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$";
    NSString* rgbRegex = @"^rgb\\(\\s*([0-9]{1,3})\\s*,\\s*([0-9]{1,3})\\s*,\\s*([0-9]{1,3})\\s*\\)$";
    NSString* rgbaRegex = @"^rgba\\(\\s*([0-9]{1,3})\\s*,\\s*([0-9]{1,3})\\s*,\\s*([0-9]{1,3})\\s*,\\s*([0-9]{1,3}|[0-9]{1,3}\\.[0-9]{1,3})\\s*\\)$";
    NSArray* regexes = @[hexRegex, rgbRegex, rgbaRegex];

    for (NSString* regex in regexes) {
        NSRegularExpression* expression = [NSRegularExpression regularExpressionWithPattern:regex options:0 error:nil];
        if ([expression firstMatchInString:content options:0 range:NSMakeRange(0, [content length])]) {
            return YES;
        }
    }

    return NO;
}
@end
