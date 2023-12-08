//
//  KayokoTableViewCell.h
//  Kayoko
//
//  Created by Alexandra Aurora Göttlicher
//

#import <UIKit/UIKit.h>

@class PasteboardItem;

@interface KayokoTableViewCell : UITableViewCell
@property(nonatomic)UIImageView* iconImageView;
@property(nonatomic)UILabel* headerLabel;
@property(nonatomic)UILabel* contentLabel;
@property(nonatomic)UIImageView* contentImageView;
- (instancetype)initWithStyle:(UITableViewCellStyle)style andItem:(PasteboardItem *)item reuseIdentifier:(NSString *)reuseIdentifier;
@end

@interface UIImage (Private)
+ (instancetype)_applicationIconImageForBundleIdentifier:(NSString *)bundleIdentifier format:(int)format scale:(CGFloat)scale;
@end

@interface SBApplicationController : NSObject
+ (id)sharedInstance;
- (id)applicationWithBundleIdentifier:(id)arg1;
@end
