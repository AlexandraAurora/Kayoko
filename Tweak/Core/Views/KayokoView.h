//
//  KayokoView.h
//  Kayoko
//
//  Created by Alexandra Aurora Göttlicher
//

#import <UIKit/UIKit.h>

@class KayokoTableView;
@class KayokoHistoryTableView;
@class KayokoFavoritesTableView;
@class KayokoPreviewView;
@class PasteboardItem;

static NSUInteger const kFavoritesButtonImageSize = 24;
static NSUInteger const kClearButtonImageSize = 20;

@interface _UIGrabber : UIControl
@end

@interface KayokoView : UIView {
    KayokoTableView* _previewSourceTableView;
    BOOL _isAnimating;
}
@property(nonatomic)UIBlurEffect* blurEffect;
@property(nonatomic)UIVisualEffectView* blurEffectView;
@property(nonatomic)UIView* headerView;
@property(nonatomic)UITapGestureRecognizer* tapGestureRecognizer;
@property(nonatomic)_UIGrabber* grabber;
@property(nonatomic)UILabel* titleLabel;
@property(nonatomic)UIButton* clearButton;
@property(nonatomic)UIButton* favoritesButton;
@property(nonatomic)UIPanGestureRecognizer* panGestureRecognizer;
@property(nonatomic)KayokoHistoryTableView* historyTableView;
@property(nonatomic)KayokoFavoritesTableView* favoritesTableView;
@property(nonatomic)KayokoPreviewView* previewView;
@property(nonatomic)UIImpactFeedbackGenerator* feedbackGenerator;
@property(nonatomic, assign)BOOL automaticallyPaste;
- (void)showPreviewWithItem:(PasteboardItem *)item;
- (void)show;
- (void)hide;
- (void)reload;
@end
