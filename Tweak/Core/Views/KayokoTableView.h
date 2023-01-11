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
@property (nonatomic, copy) NSString* name;
@property (nonatomic, strong) NSArray* items;
@property (nonatomic, assign) BOOL addTranslateOption;
@property (nonatomic, assign) BOOL addSongDotLinkOption;
- (instancetype)initWithName:(NSString *)name;
- (void)reloadDataWithItems:(NSArray *)items;
@end
