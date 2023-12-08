//
//  KayokoFavoritesTableView.m
//  Kayoko
//
//  Created by Alexandra Aurora Göttlicher
//

#import "KayokoFavoritesTableView.h"

@implementation KayokoFavoritesTableView
/**
 * Sets up the swipe actions on the left.
 *
 * @param tableView
 * @param indexPath
 */
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray* actions = [[[super tableView:tableView leadingSwipeActionsConfigurationForRowAtIndexPath:indexPath] actions] mutableCopy];
    PasteboardItem* item = [PasteboardItem itemFromDictionary:[self items][[indexPath row]]];

    UIContextualAction* unfavoriteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"" handler:^(UIContextualAction* _Nonnull action, __kindof UIView* _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [[PasteboardManager sharedInstance] addPasteboardItem:item toHistoryWithKey:kHistoryKeyHistory];
        [[PasteboardManager sharedInstance] removePasteboardItem:item fromHistoryWithKey:kHistoryKeyFavorites shouldRemoveImage:NO];
        completionHandler(YES);
    }];
    [unfavoriteAction setImage:[UIImage systemImageNamed:@"heart.slash.fill"]];
    [unfavoriteAction setBackgroundColor:[UIColor systemPinkColor]];
    [actions insertObject:unfavoriteAction atIndex:0];

    return [UISwipeActionsConfiguration configurationWithActions:actions];
}

/**
 * Sets up the swipe actions on the right.
 *
 * @param tableView
 * @param indexPath
 */
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray* actions = [[NSMutableArray alloc] init];
    PasteboardItem* item = [PasteboardItem itemFromDictionary:[self items][[indexPath row]]];

    UIContextualAction* deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"" handler:^(UIContextualAction* _Nonnull action, __kindof UIView* _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [[PasteboardManager sharedInstance] removePasteboardItem:item fromHistoryWithKey:kHistoryKeyFavorites shouldRemoveImage:YES];
        completionHandler(YES);
    }];
    [deleteAction setImage:[UIImage systemImageNamed:@"trash.fill"]];
    [deleteAction setBackgroundColor:[UIColor systemRedColor]];
    [actions addObject:deleteAction];

    return [UISwipeActionsConfiguration configurationWithActions:actions];
}
@end
