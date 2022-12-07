//
//  KayokoHistoryTableView.m
//  Kayoko
//
//  Created by Alexandra (@Traurige)
//

#import "KayokoHistoryTableView.h"

@implementation KayokoHistoryTableView
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray* actions = [[NSMutableArray alloc] init];
    PasteboardItem* item = [PasteboardItem itemFromDictionary:[self items][[indexPath row]]];

    UIContextualAction* favoriteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"" handler:^(UIContextualAction* _Nonnull action, __kindof UIView* _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [[PasteboardManager sharedInstance] addPasteboardItem:item toHistoryWithKey:kHistoryKeyFavorites];
        [[PasteboardManager sharedInstance] removePasteboardItem:item fromHistoryWithKey:kHistoryKeyHistory shouldRemoveImage:NO];
        completionHandler(YES);
    }];
    [favoriteAction setImage:[UIImage systemImageNamed:@"heart.fill"]];
    [favoriteAction setBackgroundColor:[UIColor systemPinkColor]];
    [actions addObject:favoriteAction];

    if ([item hasLink]) {
        UIContextualAction* linkAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"" handler:^(UIContextualAction* _Nonnull action, __kindof UIView* _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[item content]] options:@{} completionHandler:nil];
            completionHandler(YES);
        }];
        [linkAction setImage:[UIImage systemImageNamed:@"arrow.up"]];
        [linkAction setBackgroundColor:[UIColor systemGreenColor]];
        [actions addObject:linkAction];
    }

    if ([self addSongDotLinkOption] && [item hasMusicLink]) {
        UIContextualAction* songDotLinkAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"" handler:^(UIContextualAction* _Nonnull action, __kindof UIView* _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            [[PasteboardManager sharedInstance] addSongDotLinkItemFromItem:item];
            completionHandler(YES);
        }];
        [songDotLinkAction setImage:[UIImage systemImageNamed:@"music.note"]];
        [songDotLinkAction setBackgroundColor:[UIColor systemPurpleColor]];
        [actions addObject:songDotLinkAction];
    }

    if ([self addTranslateOption] && [item hasPlainText]) {
        UIContextualAction* translateAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"" handler:^(UIContextualAction* _Nonnull action, __kindof UIView* _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            [[PasteboardManager sharedInstance] addTranslateItemFromItem:item];
            completionHandler(YES);
        }];
        [translateAction setImage:[UIImage systemImageNamed:@"globe"]];
        [translateAction setBackgroundColor:[UIColor systemBlueColor]];
        [actions addObject:translateAction];
    }

    return [UISwipeActionsConfiguration configurationWithActions:actions];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray* actions = [[NSMutableArray alloc] init];
    PasteboardItem* item = [PasteboardItem itemFromDictionary:[self items][[indexPath row]]];

    UIContextualAction* deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"" handler:^(UIContextualAction* _Nonnull action, __kindof UIView* _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [[PasteboardManager sharedInstance] removePasteboardItem:item fromHistoryWithKey:kHistoryKeyHistory shouldRemoveImage:YES];
        completionHandler(YES);
    }];
    [deleteAction setImage:[UIImage systemImageNamed:@"trash.fill"]];
    [deleteAction setBackgroundColor:[UIColor systemRedColor]];
    [actions addObject:deleteAction];

    return [UISwipeActionsConfiguration configurationWithActions:actions];
}
@end
