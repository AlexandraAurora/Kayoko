//
//  LinkCell.h
//  Akarii Utils
//
//  Created by Alexandra Aurora Göttlicher
//

#import <UIKit/UIKit.h>
#import <Preferences/PSSpecifier.h>

@interface LinkCell : PSTableCell
@property(nonatomic)UILabel* label;
@property(nonatomic)UILabel* subtitleLabel;
@property(nonatomic)UIImageView* indicatorImageView;
@property(nonatomic)UIView* tapRecognizerView;
@property(nonatomic)UITapGestureRecognizer* tap;
@property(nonatomic)NSString* title;
@property(nonatomic)NSString* subtitle;
@property(nonatomic)NSString* url;
@end
