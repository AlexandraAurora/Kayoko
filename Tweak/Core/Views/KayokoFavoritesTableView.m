//
//  KayokoFavoritesTableView.m
//  Kayoko
//
//  Created by Alexandra (@Traurige)
//

#import "KayokoFavoritesTableView.h"

@implementation KayokoFavoritesTableView
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIColor *baseColorSeries = nil;
    NSMutableArray* actions = [[NSMutableArray alloc] init];
    PasteboardItem* item = [PasteboardItem itemFromDictionary:[self items][[indexPath row]]];

    UIContextualAction* unfavorite = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"" handler:^(UIContextualAction* _Nonnull action, __kindof UIView* _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [self performBatchUpdates:^{
            [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            NSMutableArray *items = [[self items] mutableCopy];
            [items removeObjectAtIndex:[indexPath row]];
            [self setItems:items];
        } completion:^(BOOL finished) {
            [[PasteboardManager sharedInstance] addPasteboardItem:item toHistoryWithKey:kHistoryKeyHistory];
            [[PasteboardManager sharedInstance] removePasteboardItem:item fromHistoryWithKey:kHistoryKeyFavorites shouldRemoveImage:NO];
            completionHandler(finished);
        }];
    }];
    [unfavorite setImage:[UIImage systemImageNamed:@"heart.slash.fill"]];
    baseColorSeries = [UIColor systemPinkColor];
    [actions addObject:unfavorite];

    if ([item hasLink]) {
        UIContextualAction* linkAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"" handler:^(UIContextualAction* _Nonnull action, __kindof UIView* _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[item content]] options:@{} completionHandler:nil];
            completionHandler(YES);
        }];
        [linkAction setImage:[UIImage systemImageNamed:@"arrow.up"]];
        // rgba(39, 174, 96, 1.0)
        baseColorSeries = [UIColor colorWithRed:39.0/255.0 green:174.0/255.0 blue:96.0/255.0 alpha:1.0];
        [actions addObject:linkAction];
    }

    if ([self addSongDotLinkOption] && [item hasMusicLink]) {
        UIContextualAction* songDotLinkAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"" handler:^(UIContextualAction* _Nonnull action, __kindof UIView* _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            [[PasteboardManager sharedInstance] addSongDotLinkItemFromItem:item];
            completionHandler(YES);
        }];
        [songDotLinkAction setImage:[UIImage systemImageNamed:@"music.note"]];
        // rgba(142, 68, 173, 1.0)
        baseColorSeries = [UIColor colorWithRed:142.0/255.0 green:68.0/255.0 blue:173.0/255.0 alpha:1.0];
        [actions addObject:songDotLinkAction];
    }

    if ([self addTranslateOption] && [item hasPlainText]) {
        UIContextualAction* translateAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"" handler:^(UIContextualAction* _Nonnull action, __kindof UIView* _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            [[PasteboardManager sharedInstance] addTranslateItemFromItem:item];
            completionHandler(YES);
        }];
        [translateAction setImage:[UIImage systemImageNamed:@"globe"]];
        // rgba(52, 152, 219, 1.0)
        baseColorSeries = [UIColor colorWithRed:52.0/255.0 green:152.0/255.0 blue:219.0/255.0 alpha:1.0];
        [actions addObject:translateAction];
    }

    if (baseColorSeries)
    {
        // Make color a bit different and set them to each action
        for (NSUInteger i = 0; i < [actions count]; i++)
        {
            UIContextualAction *action = [actions objectAtIndex:i];
            CGFloat hue, saturation, brightness, alpha;
            [baseColorSeries getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
            [action setBackgroundColor:[UIColor colorWithHue:hue saturation:saturation brightness:brightness - (i * 0.1) alpha:alpha]];
        }
    }

    return [UISwipeActionsConfiguration configurationWithActions:actions];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray* actions = [[NSMutableArray alloc] init];
    PasteboardItem* item = [PasteboardItem itemFromDictionary:[self items][[indexPath row]]];

    UIContextualAction* deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"" handler:^(UIContextualAction* _Nonnull action, __kindof UIView* _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [self performBatchUpdates:^{
            [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            NSMutableArray *items = [[self items] mutableCopy];
            [items removeObjectAtIndex:[indexPath row]];
            [self setItems:items];
        } completion:^(BOOL finished) {
            [[PasteboardManager sharedInstance] removePasteboardItem:item fromHistoryWithKey:kHistoryKeyFavorites shouldRemoveImage:YES];
            completionHandler(finished);
        }];
    }];
    [deleteAction setImage:[UIImage systemImageNamed:@"trash.fill"]];
    // rgba(231, 76, 60, 1.0)
    [deleteAction setBackgroundColor:[UIColor colorWithRed:231/255.0 green:76/255.0 blue:60/255.0 alpha:1.0]];
    [actions addObject:deleteAction];

    return [UISwipeActionsConfiguration configurationWithActions:actions];
}
@end
