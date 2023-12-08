//
//  KayokoTableView.m
//  Kayoko
//
//  Created by Alexandra Aurora Göttlicher
//

#import "KayokoTableView.h"
#import "KayokoTableViewCell.h"
#import "../../../Manager/PasteboardManager.h"
#import "../../../Manager/PasteboardItem.h"

@implementation KayokoTableView
/**
 * Initializes the table view.
 *
 * @param name The associated name with the table view that's displayed on the main view.
 */
- (instancetype)initWithName:(NSString *)name {
    self = [super init];

    if (self) {
        [self setName:name];
        [self setDelegate:self];
        [self setDataSource:self];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setRowHeight:65];
    }

    return self;
}

/**
 * Defines how many rows are in the table view.
 *
 * @param tableView
 * @param section
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self items] count] ?: 0;
}

/**
 * Styles the table view cells.
 *
 * @param tableView
 * @param indexPath
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* dictionary = [self items][[indexPath row]];
    PasteboardItem* item = [PasteboardItem itemFromDictionary:dictionary];

    KayokoTableViewCell* cell = [[KayokoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault andItem:item reuseIdentifier:@"KayokoTableViewCell"];

    // Add long press gesture recognizer to preview the cell's content.
    UILongPressGestureRecognizer* gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestureRecognizer:)];
    [cell addGestureRecognizer:gesture];

    return cell;
}

/**
 * Handles table view cell selection.
 *
 * it creates a dictionary from the cell's row index.
 * Then it creates a pasteboard item from the dictionary and updates the pasteboard with it.
 *
 * @param tableView
 * @param indexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];

    NSDictionary* dictionary = [self items][[indexPath row]];
    PasteboardItem* item = [PasteboardItem itemFromDictionary:dictionary];
    [[PasteboardManager sharedInstance] updatePasteboardWithItem:item fromHistoryWithKey:kHistoryKeyHistory shouldAutoPaste:YES];

    [[self superview] performSelector:@selector(hide)];
}

/**
 * Sets up the swipe actions on the left.
 *
 * @param tableView
 * @param indexPath
 */
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray* actions = [[NSMutableArray alloc] init];
    PasteboardItem* item = [PasteboardItem itemFromDictionary:[self items][[indexPath row]]];

    // If automatic paste is enabled and the item has text, add an option to only copy the contents without pasting.
    // If the item has an image we want to instead add an option to save the image to the photo library.
    if ([self automaticallyPaste] || ![[item imageName] isEqualToString:@""]) {
        UIContextualAction* saveAction;

        if ([[item imageName] isEqualToString:@""]) {
            saveAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"" handler:^(UIContextualAction* _Nonnull action, __kindof UIView* _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
                [[UIPasteboard generalPasteboard] setString:[item content]];
                completionHandler(YES);
            }];
            [saveAction setImage:[UIImage systemImageNamed:@"doc.on.doc.fill"]];
        } else {
            saveAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"" handler:^(UIContextualAction* _Nonnull action, __kindof UIView* _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
                UIImageWriteToSavedPhotosAlbum([[PasteboardManager sharedInstance] getImageForItem:item], nil, nil, nil);
                completionHandler(YES);
            }];
            [saveAction setImage:[UIImage systemImageNamed:@"square.and.arrow.down.fill"]];
        }

        [saveAction setBackgroundColor:[UIColor systemOrangeColor]];
        [actions addObject:saveAction];
    }

    if ([item hasLink]) {
        UIContextualAction* linkAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"" handler:^(UIContextualAction* _Nonnull action, __kindof UIView* _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[item content]] options:@{} completionHandler:nil];
            completionHandler(YES);
        }];
        [linkAction setImage:[UIImage systemImageNamed:@"arrow.up"]];
        [linkAction setBackgroundColor:[UIColor systemGreenColor]];
        [actions addObject:linkAction];
    }

    return [UISwipeActionsConfiguration configurationWithActions:actions];
}

/**
 * Handles the long press gesture for the preview.
 *
 * It creates a dictionary from the cell's content and sends it to the main view to preview it.
 *
 * @param recognizer The long press gesture recognizer.
 */
- (void)handleLongPressGestureRecognizer:(UILongPressGestureRecognizer *)recognizer {
    if ([recognizer state] == UIGestureRecognizerStateBegan) {
        KayokoTableViewCell* cell = (KayokoTableViewCell *)[recognizer view];
        NSIndexPath* indexPath = [self indexPathForCell:cell];

        NSDictionary* dictionary = [self items][[indexPath row]];
        PasteboardItem* item = [PasteboardItem itemFromDictionary:dictionary];

        [[self superview] performSelector:@selector(showPreviewWithItem:) withObject:item];
    }
}

/**
 * Reloads the table view with new items.
 *
 * @param items The new items to laod.
 */
- (void)reloadDataWithItems:(NSArray *)items {
    [self setItems:items];
    [self reloadData];
}
@end
