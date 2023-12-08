//
//  SingleContactCell.h
//  Akarii Utils
//
//  Created by Alexandra Aurora Göttlicher
//

#import <UIKit/UIKit.h>
#import <Preferences/PSSpecifier.h>

@interface SingleContactCell : PSTableCell
@property(nonatomic)UIImageView* avatarImageView;
@property(nonatomic)UILabel* displayNameLabel;
@property(nonatomic)UILabel* usernameLabel;
@property(nonatomic)UIView* tapRecognizerView;
@property(nonatomic)UITapGestureRecognizer* tap;
@property(nonatomic)NSString* displayName;
@property(nonatomic)NSString* username;
@end
