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
@property (nonatomic, strong) UIBlurEffect* blurEffect;
@property (nonatomic, strong) UIVisualEffectView* blurEffectView;
@property (nonatomic, strong) UIView* headerView;
@property (nonatomic, strong) UITapGestureRecognizer* tapGestureRecognizer;
@property (nonatomic, strong) _UIGrabber* grabber;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* subtitleLabel;
@property (nonatomic, strong) UIButton* headerButton;
@property (nonatomic, strong) UIPanGestureRecognizer* panGestureRecognizer;
@property (nonatomic, strong) KayokoHistoryTableView* historyTableView;
@property (nonatomic, strong) KayokoFavoritesTableView* favoritesTableView;
@property (nonatomic, strong) KayokoPreviewView* previewView;
@property (nonatomic, strong) UIImpactFeedbackGenerator* feedbackGenerator;
@property (nonatomic, assign) BOOL addTranslateOption;
@property (nonatomic, assign) BOOL addSongDotLinkOption;
- (void)showPreviewWithItem:(PasteboardItem *)item;
- (void)show;
- (void)hide;
- (void)reload;
@end
