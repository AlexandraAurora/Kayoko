//
//  CallaSingleContactCell.h
//  Calla Utils
//
//  Created by Alexandra (@Traurige)
//

#import <UIKit/UIKit.h>
#import <Preferences/PSSpecifier.h>

@interface CallaSingleContactCell : PSTableCell
@property (nonatomic, strong) UIImageView* avatarImageView;
@property (nonatomic, strong) UILabel* displayNameLabel;
@property (nonatomic, strong) UILabel* usernameLabel;
@property (nonatomic, strong) UIView* tapRecognizerView;
@property (nonatomic, strong) UITapGestureRecognizer* tap;
@property (nonatomic, copy) NSString* displayName;
@property (nonatomic, copy) NSString* username;
@property (nonatomic, copy) NSString* url;
- (void)openUserProfile;
@end
