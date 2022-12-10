//
//  KayokoView.h
//  Kayoko
//
//  Created by Alexandra (@Traurige)
//

#import <UIKit/UIKit.h>
#import "KayokoHistoryTableView.h"
#import "KayokoFavoritesTableView.h"
#import "KayokoPreviewView.h"

@interface _UIGrabber : UIControl
@end

@interface KayokoView : UIView {
    KayokoTableView* _previewSourceTableView;
    BOOL _isAnimating;
}
@property(nonatomic, retain)UIBlurEffect* blurEffect;
@property(nonatomic, retain)UIVisualEffectView* blurEffectView;
@property(nonatomic, retain)UIView* headerView;
@property(nonatomic, retain)UITapGestureRecognizer* tapGestureRecognizer;
@property(nonatomic, retain)_UIGrabber* grabber;
@property(nonatomic, retain)UILabel* titleLabel;
@property(nonatomic, retain)UILabel* subtitleLabel;
@property(nonatomic, retain)UIButton* headerButton;
@property(nonatomic, retain)UIPanGestureRecognizer* panGestureRecognizer;
@property(nonatomic, retain)KayokoHistoryTableView* historyTableView;
@property(nonatomic, retain)KayokoFavoritesTableView* favoritesTableView;
@property(nonatomic, retain)KayokoPreviewView* previewView;
@property(nonatomic, retain)UIImpactFeedbackGenerator* feedbackGenerator;
@property(atomic, assign)BOOL addTranslateOption;
@property(atomic, assign)BOOL addSongDotLinkOption;
- (void)showPreviewWithItem:(PasteboardItem *)item;
- (void)show;
- (void)hide;
- (void)reload;
@end
