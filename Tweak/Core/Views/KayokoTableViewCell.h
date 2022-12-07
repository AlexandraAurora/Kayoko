//
//  KayokoTableViewCell.h
//  Kayoko
//
//  Created by Alexandra (@Traurige)
//

#import <substrate.h>
#import <UIKit/UIKit.h>
#import "../../../Manager/PasteboardManager.h"
#import "../../../Utils/ImageUtil.h"
#import "../../../Utils/ColorUtil.h"

@interface KayokoTableViewCell : UITableViewCell
@property(nonatomic, retain)UIImageView* iconImageView;
@property(nonatomic, retain)UILabel* headerLabel;
@property(nonatomic, retain)UILabel* contentLabel;
@property(nonatomic, retain)UIImageView* contentImageView;
- (instancetype)initWithStyle:(UITableViewCellStyle)style andItem:(PasteboardItem *)item reuseIdentifier:(NSString *)reuseIdentifier;
@end

@interface UIImage (Private)
+ (instancetype)_applicationIconImageForBundleIdentifier:(NSString *)bundleIdentifier format:(int)format scale:(CGFloat)scale;
@end

@interface SBApplicationController : NSObject
+ (id)sharedInstance;
- (id)applicationWithBundleIdentifier:(id)arg1;
@end
