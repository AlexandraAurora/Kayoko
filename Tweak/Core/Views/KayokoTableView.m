//
//  KayokoTableView.m
//  Kayoko
//
//  Created by Alexandra (@Traurige)
//

#import "KayokoTableView.h"

@implementation KayokoTableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
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

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];

    NSDictionary* dictionary = [self items][[indexPath row]];
    PasteboardItem* item = [PasteboardItem itemFromDictionary:dictionary];
    [[PasteboardManager sharedInstance] updatePasteboardWithItem:item fromHistoryWithKey:kHistoryKeyHistory shouldAutoPaste:YES];

    [[self superview] performSelector:@selector(hide)];
}

- (void)reloadDataWithItems:(NSArray *)items {
    [self setItems:items];
    [self reloadData];
}
@end
