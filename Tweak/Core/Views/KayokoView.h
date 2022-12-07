//
//  KayokoView.h
//  Kayoko
//
//  Created by Alexandra (@Traurige)
//

#import <UIKit/UIKit.h>
#import "KayokoHistoryTableView.h"
#import "KayokoFavoritesTableView.h"

@interface _UIGrabber : UIControl
@end

@interface KayokoView : UIView
@property(nonatomic, retain)UIBlurEffect* blurEffect;
@property(nonatomic, retain)UIVisualEffectView* blurEffectView;
@property(nonatomic, retain)UIView* headerView;
@property(nonatomic, retain)_UIGrabber* grabber;
@property(nonatomic, retain)UILabel* titleLabel;
@property(nonatomic, retain)UILabel* subtitleLabel;
@property(nonatomic, retain)UIButton* favoritesButton;
@property(nonatomic, retain)UIPanGestureRecognizer* panGesture;
@property(nonatomic, retain)KayokoHistoryTableView* historyTableView;
@property(nonatomic, retain)KayokoFavoritesTableView* favoritesTableView;
@property(atomic, assign)BOOL isAnimating;
@property(atomic, assign)BOOL addTranslateOption;
@property(atomic, assign)BOOL addSongDotLinkOption;
- (void)show;
- (void)hide;
- (void)reload;
@end
