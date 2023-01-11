//
//  CallaLinkCell.h
//  Calla Utils
//
//  Created by Alexandra (@Traurige)
//

#import <UIKit/UIKit.h>
#import <Preferences/PSSpecifier.h>

@interface CallaLinkCell : PSTableCell
@property (nonatomic, strong) UILabel* label;
@property (nonatomic, strong) UILabel* subtitleLabel;
@property (nonatomic, strong) UIView* tapRecognizerView;
@property (nonatomic, strong) UITapGestureRecognizer* tap;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* subtitle;
@property (nonatomic, copy) NSString* url;
@end
