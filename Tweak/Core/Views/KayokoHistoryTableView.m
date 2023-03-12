//
//  KayokoHistoryTableView.m
//  Kayoko
//
//  Created by Alexandra (@Traurige)
//

#import "KayokoHistoryTableView.h"

@implementation KayokoHistoryTableView
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIColor *baseColorSeries = nil;
    NSMutableArray* actions = [[NSMutableArray alloc] init];
    PasteboardItem* item = [PasteboardItem itemFromDictionary:[self items][[indexPath row]]];

    UIContextualAction* favoriteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"" handler:^(UIContextualAction* _Nonnull action, __kindof UIView* _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [self performBatchUpdates:^{
            [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            NSMutableArray *items = [[self items] mutableCopy];
            [items removeObjectAtIndex:[indexPath row]];
            [self setItems:items];
        } completion:^(BOOL finished) {
            [[PasteboardManager sharedInstance] addPasteboardItem:item toHistoryWithKey:kHistoryKeyFavorites];
            [[PasteboardManager sharedInstance] removePasteboardItem:item fromHistoryWithKey:kHistoryKeyHistory shouldRemoveImage:NO];
            completionHandler(finished);
        }];
    }];
    [favoriteAction setImage:[UIImage systemImageNamed:@"heart.fill"]];
    baseColorSeries = [UIColor systemPinkColor];
    [actions addObject:favoriteAction];

    if ([item hasLink]) {
        UIContextualAction* linkAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"" handler:^(UIContextualAction* _Nonnull action, __kindof UIView* _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[item content]] options:@{} completionHandler:nil];
            completionHandler(YES);
        }];
        [linkAction setImage:[UIImage systemImageNamed:@"arrow.up"]];
        baseColorSeries = [UIColor colorWithRed:(CGFloat)39 / 255 green:(CGFloat)174 / 255 blue:(CGFloat)96 / 255 alpha:1];
        [actions addObject:linkAction];
    }

    if ([self addSongDotLinkOption] && [item hasMusicLink]) {
        UIContextualAction* songDotLinkAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"" handler:^(UIContextualAction* _Nonnull action, __kindof UIView* _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            [[PasteboardManager sharedInstance] addSongDotLinkItemFromItem:item];
            completionHandler(YES);
        }];
        [songDotLinkAction setImage:[UIImage systemImageNamed:@"music.note"]];
        baseColorSeries = [UIColor colorWithRed:(CGFloat)142 / 255 green:(CGFloat)68 / 255 blue:(CGFloat)173 / 255 alpha:1];
        [actions addObject:songDotLinkAction];
    }

    if ([self addTranslateOption] && [item hasPlainText]) {
        UIContextualAction* translateAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"" handler:^(UIContextualAction* _Nonnull action, __kindof UIView* _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            [[PasteboardManager sharedInstance] addTranslateItemFromItem:item];
            completionHandler(YES);
        }];
        [translateAction setImage:[UIImage systemImageNamed:@"globe"]];
        baseColorSeries = [UIColor colorWithRed:(CGFloat)52 / 255 green:(CGFloat)152 / 255 blue:(CGFloat)219 / 255 alpha:1];
        [actions addObject:translateAction];
    }

    if (baseColorSeries) {
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
            [[PasteboardManager sharedInstance] removePasteboardItem:item fromHistoryWithKey:kHistoryKeyHistory shouldRemoveImage:YES];
            completionHandler(finished);
        }];
    }];
    [deleteAction setImage:[UIImage systemImageNamed:@"trash.fill"]];
    [deleteAction setBackgroundColor:[UIColor colorWithRed:(CGFloat)231 / 255 green:(CGFloat)76 / 255 blue:(CGFloat)60 / 255 alpha:1]];
    [actions addObject:deleteAction];

    return [UISwipeActionsConfiguration configurationWithActions:actions];
}
@end
