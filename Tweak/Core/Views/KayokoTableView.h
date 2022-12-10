//
//  KayokoTableView.h
//  Kayoko
//
//  Created by Alexandra (@Traurige)
//

#import <UIKit/UIKit.h>
#import "KayokoTableViewCell.h"
#import "../../../Manager/PasteboardManager.h"

@interface KayokoTableView : UITableView <UITableViewDelegate, UITableViewDataSource>
@property(atomic, assign)NSString* name;
@property(nonatomic, retain)NSArray* items;
@property(atomic, assign)BOOL addTranslateOption;
@property(atomic, assign)BOOL addSongDotLinkOption;
- (instancetype)initWithName:(NSString *)name;
- (void)reloadDataWithItems:(NSArray *)items;
@end
