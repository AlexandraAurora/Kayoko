//
//  KayokoTableView.m
//  Kayoko
//
//  Created by Alexandra (@Traurige)
//

#import "KayokoTableView.h"

@implementation KayokoTableView
- (instancetype)initWithName:(NSString *)name {
    self = [super init];

    if (self) {
        [self setName:name];
        [self setDelegate:self];
        [self setDataSource:self];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setRowHeight:80];
    }

    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self items] count] ?: 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* dictionary = [self items][[indexPath row]];
    PasteboardItem* item = [PasteboardItem itemFromDictionary:dictionary];

    KayokoTableViewCell* cell = [[KayokoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault andItem:item reuseIdentifier:@"KayokoTableViewCell"];

    UILongPressGestureRecognizer* gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestureRecognizer:)];
    [cell addGestureRecognizer:gesture];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];

    NSDictionary* dictionary = [self items][[indexPath row]];
    PasteboardItem* item = [PasteboardItem itemFromDictionary:dictionary];
    [[PasteboardManager sharedInstance] updatePasteboardWithItem:item fromHistoryWithKey:kHistoryKeyHistory shouldAutoPaste:YES];

    [[self superview] performSelector:@selector(hide)];
}

- (void)handleLongPressGestureRecognizer:(UILongPressGestureRecognizer *)recognizer {
    if ([recognizer state] == UIGestureRecognizerStateBegan) {
        KayokoTableViewCell* cell = (KayokoTableViewCell *)[recognizer view];
        NSIndexPath* indexPath = [self indexPathForCell:cell];

        NSDictionary* dictionary = [self items][[indexPath row]];
        PasteboardItem* item = [PasteboardItem itemFromDictionary:dictionary];

        [[self superview] performSelector:@selector(showPreviewWithItem:) withObject:item];
    }
}

- (void)reloadDataWithItems:(NSArray *)items {
    [self setItems:items];
    [self reloadData];
}

- (void)clearHistoryWithKey:(NSString *)key {
    [[self superview] performSelector:@selector(hide)];

    UIAlertController* clearAlert = [UIAlertController alertControllerWithTitle:@"Kayoko" message:[NSString stringWithFormat:@"This will clear your %@.", key] preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction* action) {
        [[self superview] performSelector:@selector(show)];

        for (NSDictionary* dictionary in [self items]) {
            PasteboardItem* item = [PasteboardItem itemFromDictionary:dictionary];
            [[PasteboardManager sharedInstance] removePasteboardItem:item fromHistoryWithKey:key shouldRemoveImage:YES];
        }
	}];

	UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction* action) {
        [[self superview] performSelector:@selector(show)];
    }];

	[clearAlert addAction:yesAction];
	[clearAlert addAction:noAction];

	[[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:clearAlert animated:YES completion:nil];
}
@end
