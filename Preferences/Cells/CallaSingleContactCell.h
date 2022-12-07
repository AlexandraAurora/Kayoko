//
//  CallaSingleContactCell.h
//  Calla Utils
//
//  Created by Alexandra (@Traurige)
//

#import <UIKit/UIKit.h>
#import <Preferences/PSSpecifier.h>

@interface CallaSingleContactCell : PSTableCell
@property(nonatomic, retain)UIImageView* avatarImageView;
@property(nonatomic, retain)UILabel* displayNameLabel;
@property(nonatomic, retain)UILabel* usernameLabel;
@property(nonatomic, retain)UIView* tapRecognizerView;
@property(nonatomic, retain)UITapGestureRecognizer* tap;
@property(nonatomic, retain)NSString* displayName;
@property(nonatomic, retain)NSString* username;
@property(nonatomic, retain)NSString* url;
- (void)openUserProfile;
@end
